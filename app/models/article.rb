include ActionView::Helpers::SanitizeHelper

class Article < ActiveRecord::Base
  # has_and_belongs_to_many :locations
  belongs_to :contact
  after_commit :index_article

  def self.search(search)
    if search
      where('title ILIKE ? OR content ILIKE ?', "%#{search}%", "%#{search}%")
    else
      ""
    end
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

  private
    def index_article
      client = IndexTank::Client.new(ENV['SEARCHIFY_API_URL'])
      index = client.indexes("hnlanswers-"+ENV['RAILS_ENV'])

      index.document(self.id.to_s).add({ :text => strip_tags(self.content), :title => self.title, :tags => self.tags.to_s, :preview => self.preview.to_s })
      print "index updated"
    end

end
