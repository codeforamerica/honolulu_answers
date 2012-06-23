include ActionView::Helpers::SanitizeHelper


class Article < ActiveRecord::Base
  include Tanker

  belongs_to :contact

  after_save :update_tank_indexes
  after_destroy :delete_tank_indexes

  def self.search(search)
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
  
  # # For pagination with will_paginate
  # def self.per_page
  #   5
  # end

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
#

