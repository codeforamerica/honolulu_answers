include ActionView::Helpers::SanitizeHelper

class Article < ActiveRecord::Base
  # has_and_belongs_to_many :locations
  belongs_to :contact

  include Tanker

  # after_commit :index_article
  after_save :update_tank_indexes
  after_destroy :delete_tank_indexes

  def self.search(search)
    # if search
    #   where('title ILIKE ? OR content ILIKE ?', "%#{search}%", "%#{search}%")
    # else
    #   ""
    # end
    self.search_tank search
  end

  def self.search_titles(search)
    
    if search      
      where('title ILIKE ?', "%#{search}%")
    else
      ""
    end
  end

  def allContent()
    [self.title, self.content].join(" ")
  end


  tankit "hnlanswers-#{Rails.env}" do
    # For example if you only want to index articles with a proper title, uncomment this and implement 'self.indexable?'
    # conditions do
    #   indexable?
    # end

    indexes :title
    indexes :content
    indexes :category, :category => true
    indexes :tags
    indexes :preview
  end

  def self.per_page
    5
  end

  # private
  #   def index_article
  #     client = IndexTank::Client.new(ENV['SEARCHIFY_API_URL'])
  #     index = client.indexes("hnlanswers-"+ENV['RAILS_ENV'])

  #     index.document(self.id.to_s).add({ :text => strip_tags(self.content), :title => self.title, :tags => self.tags.to_s, :preview => self.preview.to_s })
  #     print "index updated"
  #   end

end
