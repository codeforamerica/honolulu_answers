include ActionView::Helpers::SanitizeHelper

class Article < ActiveRecord::Base  
  include Tanker
  include RailsNlp
  require_dependency 'keyword'

  extend FriendlyId

  # Permalinks. :slugged option means it uses the 'slug' column for the url
  #             :history option means when you change the article title, old slugs still work
  friendly_id :title, use: [:slugged, :history]

  belongs_to :contact
  belongs_to :category
  has_many :wordcounts
  has_many :keywords, :through => :wordcounts

  validates_presence_of :access_count

  after_save :update_tank_indexes # Comment this line out when running analysemodels to save time
  after_destroy :delete_tank_indexes
  before_validation :set_access_count_if_nil

  # query-magic callbacks
  after_create  :qm_after_create
  after_update  :qm_after_update
  after_destroy :qm_after_destroy

  def self.search( query )
    return Article.all if query == '' or query == ' '
    self.search_tank query
  end

  def self.search_titles( query )
    return Article.all if query == '' or query == ' '
    self.search_tank( '__type:Article', :conditions => {:title => query })
  end

  def allContent()
    [self.title, self.content].join(" ")
  end

  def to_s
    if self.category
      "#{self.title} (#{self.id}) [#{self.category}]"
    else
      self.title + '(' + self.id + ')'
    end
  end

  def self.remove_stop_words string
    eng_stop_list = Rails.cache.fetch('stop_words') do
      CSV.read( "#{Rails.root.to_s}/lib/assets/eng_stop.csv" )
    end
    string = (string.downcase.split - eng_stop_list.flatten).join " "    
  end

  def self.spell_check string
    @is_corrected = false
    dict = Hunspell.new( "#{Rails.root.to_s}/lib/assets/dict/blank", 'blank' )
    keywords = Rails.cache.fetch('keyword_names') { Keyword.all(:select => 'name') }
    keywords.each{ |kw| dict.add( kw.name ) }

    string_corrected = []
    string.split.each do |term|
      if dict.check?( term )
        string_corrected << term
      else 
        suggestion = dict.suggest( term ).first
        if suggestion.nil? # if no suggestion, stick with the existing term
          string_corrected << term
        else
          @is_corrected = true
          string_corrected << suggestion
        end
      end
    end
    return string_corrected.join ' '
  end

  def self.expand_query( query )
    stems,metaphones,synonyms = [[],[],[]]
    query.split.each do |term|
      # try and hit the database first, only compute stuff if we have to
      kw = Keyword.find_by_name(term)
      if kw 
        stems << kw.stem
        metaphones << kw.metaphone.compact
        # synonyms << kw.synonyms.first(3)
      else
        stems << Text::PorterStemming.stem(term)
        metaphones << Text::Metaphone.double_metaphone(term)
        # synonyms << RailsNlp::BigHugeThesaurus.synonyms(term)
      end
    end

    ## Construct the OR query
    query_final =      "title:(#{query.split.join(' OR ')})^10"
    query_final << " OR content:(#{query.split.join(' OR ')})^5"
    query_final << " OR tags:(#{query.split.join(' OR ')})^8"
    query_final << " OR stems:(#{stems.flatten.join(' OR ')})^3"
    query_final << " OR metaphones:(#{metaphones.flatten.compact.join(' OR ')})^2"
    # query_final << " OR #{'synonyms:"'  + synonyms.flatten.first(3).join( '" OR synonyms:"') + '"'}"
    query_final << " OR synonyms:(#{query.split.join(' OR ')})"

    return query_final
  end


  index = 'hnlanswers-development'
  index = 'hnlanswers-production' if Rails.env === 'production'
  
  tankit index do
    indexes :title
    indexes :content
    indexes :category, :category => true
    indexes :tags
    indexes :preview

    # NLP
    indexes :metaphones do
      keywords.map { |kw| kw.metaphone }
    end
    indexes :synonyms do
      keywords.map { |kw| kw.synonyms }
    end
    indexes :keywords do
      keywords.map { |kw| kw.name }
    end
    indexes :stems do
      keywords.map { |kw| kw.stem }
    end
  end

  def indexable?
    self.is_published
  end

  def hits
    self.access_count
  end

  def analyse
    qm_after_create
  end

  def self.analyse_all
    Article.all.each { |a| a.analyse }
  end


  private

  def set_access_count_if_nil
    self.access_count = 0 if self.access_count.nil?
  end

  ## Query Magic methods (soon to be refactored into a gem)

  require 'facets/enumerable'

  @@STOP_WORDS = ['a','able','about','across','after','all','almost','also','am','among','an','and','any','are','as','at','be','because','been','but','by','can','cannot','could','dear','did','do','does','either','else','ever','every','for','from','get','got','had','has','have','he','her','hers','him','his','how','however','i','if','in','into','is','it','its','just','least','let','like','likely','may','me','might','most','must','my','neither','no','nor','not','of','off','often','on','only','or','other','our','own','rather','said','say','says','she','should','since','so','some','than','that','the','their','them','then','there','these','they','this','tis','to','too','twas','us','wants','was','we','were','what','when','where','which','while','who','whom','why','will','with','would','yet','you','your']

  def collect_text( options )
    model = options[:model]
    text = ''
    options[:fields].each do |field|
      begin
        text << model.instance_eval(field) + ' '
      rescue NoMethodError
      end
    end
    text
  end

  def clean str
    # strip html tags
    # "This currently assumes valid XHTML, which means no free < or > characters."
    # https://github.com/rails/rails/blob/master/actionpack/lib/action_controller/vendor/html-scanner/html/tokenizer.rb
    str = ActionView::Helpers::SanitizeHelper.strip_tags str

    # # replace control characters like \n and \t with a space
    str.gsub!(/[[:cntrl:]]+/, ' ')

    # remove plurals and posessives
    str.gsub!(/'(\S+)/, '')

    # remove anything that isn't a letter or a space
    str.gsub!(/[^\p{Word} ]/, '')

    # remove single characters
    str.gsub!(/(\s|\A)\S(\s|\z)/, ' ')

    # remove numbers
    str.gsub!(/\s\d+\s/, ' ')

    # downcase
    str.downcase!

    str
  end

  def count_words words
    words = words.split
    words = words - @@STOP_WORDS
    
    # Ruby Facets - http://www.webcitation.org/69k1oBjmR    
    return words.frequency
  end

  def delete_orphaned_keywords
    orphan_kw_ids = Keyword.all( :select => 'id' ).map{ |kw| kw.id } - 
                    Wordcount.all( :select => 'keyword_id' ).map{ |wc| wc.keyword_id }
    Keyword.destroy( orphan_kw_ids )
  end

  ### query-magic activerecord callbacks

  # When an article is created
  #   1) Analyse all the text fields and parse them into a frequency map of words. { <word_i> => <freq_i>, [...], <word_n> => <freq_n> }
  #   2) For each word in text, kw = Keyword.find_or_create_by_name(word).(i)
  #   3) Create a new Wordcount row with :keyword_id => kw.id, :article_id => article.id and count as the frequency of the keyword in the article.
  def qm_after_create
    text = collect_text(:model => self, :fields => ['title',
                                                    'content',
                                                    'preview',
                                                    'tags',
                                                    'category.name'])
    text = clean( text )
    wordcounts = count_words( text )
    wordcounts.each do |word, frequency|
      kw = Keyword.find_or_create_by_name( word )
      Wordcount.create!(:keyword_id => kw.id, :article_id => self.id, :count => frequency)
    end
  end

  # 1) remove all wordcount rows for this article
  # 2) treat the article as a new article
  # 3) remove keywords where keyword.id isn't present in column Wordcount#keyword_id
  def qm_after_update
    self.wordcounts.destroy_all
    qm_after_create
    delete_orphaned_keywords
  end

  # 1) remove all wordcount rows for this article
  # 2) remove keywords where keyword.id isn't present in column Wordcount#keyword_id
  def qm_after_destroy
    self.wordcounts.destroy_all
    delete_orphaned_keywords
  end


end

# == Schema Information
#
# Table name: articles
#
#  id           :integer         not null, primary key
#  updated      :datetime
#  title        :string(255)
#  content      :text
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  content_type :integer
#  preview      :text
#  contact_id   :integer
#  tags         :text
#  service_url  :string(255)
#  is_published :boolean         default(FALSE)
#  slug         :string(255)
#  category_id  :integer
#  access_count :integer
#

