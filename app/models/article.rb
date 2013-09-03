# encoding: utf-8
include ActionView::Helpers::SanitizeHelper

class Article < ActiveRecord::Base
  include TankerArticleDefaults
  include Tanker
  include RailsNlp
  include Markdownifier

  require_dependency 'keyword'

  extend FriendlyId

  # Permalinks. :slugged option means it uses the 'slug' column for the url
  #             :history option means when you change the article title, old slugs still work
  friendly_id :title, use: [:slugged, :history]

  belongs_to :contact
  belongs_to :category
  belongs_to :user
  has_many :wordcounts
  has_many :keywords, :through => :wordcounts

  scope :by_access_count, order('access_count DESC')

  has_attached_file :author_pic,
    :storage => :s3,
    :bucket => ENV['S3_BUCKET'],
    :s3_credentials => {
      :access_key_id => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET']
    },
    :s3_protocol => :https,
    :path => "/:style/:id/:filename",
    :styles => { :thumb => "100x100" }

  validates_attachment_size :author_pic, :less_than => 5.megabytes
  validates_attachment_content_type :author_pic, :content_type => ['image/jpeg', 'image/png']

  validates_presence_of :access_count

  attr_accessible :title, :content, :content_md, :content_main, :content_main_extra,
    :content_need_to_know, :render_markdown, :preview, :contact_id, :tags,
    :is_published, :slugs, :category_id, :updated_at, :created_at, :author_pic,
    :author_pic_file_name, :author_pic_content_type, :author_pic_file_size,
    :author_pic_updated_at, :author_name, :author_link, :type, :service_url, :user_id, :status

  # A note on the content fields:
  # *  Originally the content for the articles was stored as HTML in Article#content.
  # *  We then moved to Markdown for content storage, resulting in Article#content_md.
  # *  Most recently, the QuickAnswers were split into three distinct sections: content_main, content_main_extra and content_need_to_know. All these use Markdown.

  # Tanker callbacks to update the search index
  after_save :update_tank_indexes
  after_destroy :delete_tank_indexes

  handle_asynchronously :update_tank_indexes
  handle_asynchronously :delete_tank_indexes

  # query_magic callbacks to update keywords and wordcounts tables (The gem will be called query_magic --hale)
  after_create :qm_after_create
  after_update :qm_after_update
  after_destroy :qm_after_destroy

  before_validation :set_access_count_if_nil

  def legacy?
    !render_markdown
  end

  def self.search( query )
    begin
      self.search_tank query
    rescue Exception => exception
      ErrorService.report(exception)
      []
    end
  end

  def self.find_by_type( content_type )
    return Article.where(:type => content_type).order('category_id').order('access_count DESC')
  end

  def to_s
    if self.category
      "#{self.title} (#{self.id}) [#{self.category}]"
    else
    end
  end

  def published?
    status == "Published"
  end

  def md_to_html( field )
    return '' if instance_eval(field.to_s).blank?
    Kramdown::Document.new( instance_eval(field.to_s), :auto_ids => false).to_html
  end

  def raw_md_to_html( field )
    return '' if field.to_s.blank?
    Kramdown::Document.new( field.to_s, :auto_ids => false).to_html
  end

  def self.remove_stop_words string
    eng_stop_list = Rails.cache.fetch('stop_words') do
      CSV.read( "#{Rails.root.to_s}/lib/assets/eng_stop.csv" )
    end
    string = (string.downcase.split - eng_stop_list.flatten).join " "
  end

  def self.spell_check string
    dict = Hunspell.new( "#{Rails.root.to_s}/lib/assets/dict/en_US", 'en_US' )

    dict_custom = Hunspell.new( "#{Rails.root.to_s}/lib/assets/dict/blank", 'blank' )
    Keyword.all(:select => ['name', 'synonyms']).each do |kw|
      dict_custom.add kw.name
    end
    stop_words ||= Rails.cache.fetch('stop_words') do
      CSV.read( "lib/assets/eng_stop.csv" ).flatten
    end
    stop_words.each{ |sw| dict_custom.add sw }

    string_corrected = string.split.map do |word|
      if dict.spell(word) or dict_custom.spell(word) # word is correct
        word
      else
        suggestion = dict_custom.suggest( word ).first
        suggestion.nil? ? word : suggestion
      end
    end

    string_corrected.join ' '
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

  def related
    Rails.cache.fetch("#{self.id}-related") {
      return [] if wordcounts.empty?
      (Article.search(self.wordcounts.all(:order => 'count DESC', :limit => 10).map(&:keyword).map(&:name).join(" OR ")) - [self]).first(4)
    }
  end

  def indexable?
    self.status == "Published"
  end

  def analyse
    qm_after_create
  end

  def analyse_now
    qm_after_create_without_delay
  end

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
    begin
      if self.status == "Published"
        text = collect_text(
          :model => self,
          :fields => ['title','content_main','content_main_extra','content_need_to_know','preview','tags','category.name'])
          text = clean( text )
          wordcounts = count_words( text )
          wordcounts.each do |word, frequency|
            kw = Keyword.find_or_create_by_name( word )
            Wordcount.create!(:keyword_id => kw.id, :article_id => self.id, :count => frequency)
          end
      end
    rescue => e
      puts "ERROR: error after article creation; could not update keywords and wordcounts for article with id #{self.try(:id)}"
      puts e.message
      puts e.backtrace
    end
  end
  handle_asynchronously :qm_after_create

  # 1) remove all wordcount rows for this article
  # 2) treat the article as a new article
  # 3) remove keywords where keyword.id isn't present in column Wordcount#keyword_id
  def qm_after_update
    #binding.pry
    begin
      wordcounts.destroy_all
      qm_after_create
      delete_orphaned_keywords
    rescue => e
      puts "ERROR: error after article update; could not update keywords and wordcounts for article with id #{self.id unless self.id.blank?}"
      puts e.message
      puts e.backtrace
    end
  end
  handle_asynchronously :qm_after_update

  # 1) remove all wordcount rows for this article
  # 2) remove keywords where keyword.id isn't present in column Wordcount#keyword_id
  def qm_after_destroy
    begin
      wordcounts.destroy_all
      delete_orphaned_keywords
    rescue => e
      puts "ERROR: error after article destruction; could not update keywords and wordcounts for article with id #{self.id unless self.id.blank?}"
      puts e.message
      puts e.backtrace
    end
  end
  handle_asynchronously :qm_after_destroy

end
