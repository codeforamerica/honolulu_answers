class Category < ActiveRecord::Base
  attr_accessible :access_count, :name, :description
  has_many :articles

  before_validation :set_access_count_if_nil

  def self.all_by_access_count   
    self.all :order => 'access_count DESC'
  end

  def articles_by_access_count
    self.articles.all(:order => 'access_count DESC')
  end

  private

  def hits
    self.access_count
  end

  def set_access_count_if_nil
    self.access_count = 0 if self.access_count.nil?
  end
  
end
# == Schema Information
#
# Table name: categories
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  access_count :integer
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  article_id   :integer
#  description  :text
#

