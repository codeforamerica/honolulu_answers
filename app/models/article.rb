include ActionView::Helpers::SanitizeHelper

class Article < ActiveRecord::Base
  include Tanker

  # has_and_belongs_to_many :locations
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
    
    # keyword = params[:search]
    # if keyword.empty?
    #   # This will return all Services in IndexTank. Change 'Service' to reference your model name
    #   keyword = "__type:Service"
    # end
    # @services = Service.search_tank(keyword,
    #   :var0 => lat,
    #   :var1 => lon,
    #   # And we'll return all results sorted by distance
    #   :function => 1)
  end

  tankit "hnlanswers-#{Rails.env}" do
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
