include ActionView::Helpers::SanitizeHelper

class Article < ActiveRecord::Base  
  include Tanker
  extend FriendlyId

  # Permalinks. :slugged option means it uses the 'slug' column for the url
  #             :history option means when you change the article title, old slugs still work
  friendly_id :title, use: [:slugged, :history]

  belongs_to :contact

  after_save :update_tank_indexes
  after_destroy :delete_tank_indexes

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
#  category     :string(255)
#  content_type :integer
#  preview      :text
#  contact_id   :integer
#  tags         :text
#  service_url  :string(255)
#  slug         :string(255)
#  is_published :boolean         default(FALSE)
#

