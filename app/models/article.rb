include ActionView::Helpers::SanitizeHelper

class Article < ActiveRecord::Base  
  include Tanker
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

  def access_count_increment
    self.increment! :access_count
  end
  
  if Rails.env === 'production'
    index = 'hnlanswers-production'
  else
    index = 'hnlanswers-development'
  end
  tankit index do
    indexes :title
    indexes :content
    indexes :category, :category => true
    indexes :tags
    indexes :preview

    # NLP
    indexes :metaphone do
      keywords.map { |kw| kw.metaphone }
    end
    indexes :synonyms do
      keywords.map { |kw| kw.synonyms }
    end
    indexes :keywords do
      keywords.map { |kw| kw.name }
    end
    indexes :stem do
      keywords.map { |kw| kw.stem }
    end
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

