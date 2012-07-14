include ActionView::Helpers::SanitizeHelper

class Article < ActiveRecord::Base  
  include Tanker
  include RailsNlp::BigHugeThesaurus

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
    eng_stop_list = CSV.read( "#{Rails.root.to_s}/lib/assets/eng_stop.csv" )
    string = (string.downcase.split - eng_stop_list.flatten).join " "    
  end

  def self.spell_check string
    @is_corrected = false
    dict = Hunspell.new( "#{Rails.root.to_s}/lib/assets/dict/blank", 'blank' )
    Keyword.all.each{ |kw| dict.add( kw.name ) }
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
      stems << Text::PorterStemming.stem(term)
      kw = Keyword.find_by_name(term)
      if kw # Hit the database first to prevent uneccesary API calls to BHT
        synonyms << kw.synonyms.first(3)
      else
        synonyms << RailsNlp::BigHugeThesaurus.synonyms(term) 
      end
      metaphones << Text::Metaphone.double_metaphone(term)
    end

    query_final =      "#{'title:'      + query.split.join('^10 title:')  + '^10'}"
    query_final << " OR #{'content:'    + query.split.join('^5 content:') + '^5'}"
    query_final << " OR #{'tags:'       + query.split.join('^8 tags:')    + '^8'}"
    query_final << " OR #{'stems:'      + stems.flatten.join(' OR stems:')}"
    query_final << " OR #{'metaphones:' + metaphones.flatten.compact.join(' OR metaphones:')}"
    query_final << " OR #{'synonyms:"'  + synonyms.flatten.first(3).join( '" OR synonyms:"') + '"'}"

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
      keywords.map { |kw| kw.synonyms.first(3) }
    end
    indexes :keywords do
      keywords.map { |kw| kw.name }
    end
    indexes :stems do
      keywords.map { |kw| kw.stem }
    end
  end

  def hits
    self.access_count
  end



  private

  def set_access_count_if_nil
    self.access_count = 0 if self.access_count.nil?
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

