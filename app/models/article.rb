class Article < ActiveRecord::Base 
  include ActionView::Helpers::SanitizeHelper
  include RailsNlp::BigHugeThesaurus
  include Tanker
  require_dependency 'keyword'

  extend FriendlyId

  # Permalinks. :slugged option means it uses the 'slug' column for the url
  #             :history option means when you change the article title, old slugs still work
  friendly_id :title, use: [:slugged, :history]

  belongs_to :contact
  belongs_to :category
  has_many :wordcounts
  has_many :keywords, :through => :wordcounts

  has_attached_file :author_pic, 
                    :storage => :s3,
                    :bucket => 'hnlanswers-production',
                    :s3_credentials => {
                      :access_key_id => ENV['S3_KEY'],
                      :secret_access_key => ENV['S3_SECRET']
                    },
                    :path => "/:style/:id/:filename",
                    :styles => { :thumb => "100x100" } 

  validates_attachment_size :author_pic, :less_than => 5.megabytes  
  validates_attachment_content_type :author_pic, :content_type => ['image/jpeg', 'image/png']                      

  validates_presence_of :access_count

  attr_accessible :title, :content, :preview, :contact_id, :tags, :is_published, :slugs, :category_id, :updated_at, :created_at, :author_pic_file_nameauthor_pic_content_type, :author_pic_file_size, :author_pic_updated_at, :author_name, :author_link, :type

  after_save do
    :update_tank_indexes
    Rails.cache.clear
  end

  after_destroy do
   :delete_tank_indexes
  end
  before_validation do
    :set_access_count_if_nil
  end
  def self.search( query )
    return Article.all if query == '' or query == ' '
    self.search_tank query
  end

  def self.search_titles( query )
    return Article.all if query == '' or query == ' '
    self.search_tank( '__type:Article', :conditions => {:title => query })
  end

  def self.find_by_type( content_type )
    return Article.where(:type => content_type).order('category_id').order('access_count DESC')
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
    is_corrected = false
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
          is_corrected = true
          string_corrected << suggestion
        end
      end
    end

    # if the query has not been corrected, return nil.
    return is_corrected ? string_corrected.join(' ') : nil
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
      (Article.search_tank(self.wordcounts.all(:order => 'count DESC').first(10).map(&:keyword).map(&:name).join(" OR ")) - [self]).first(4)
    }
  end


  index = 'hnlanswers-development'
  index = 'hnlanswers-production' if Rails.env === 'production'
  
  tankit 'my_index', :as => 'Article' do
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

