class Category < ActiveRecord::Base
  attr_accessible :access_count, :name
  has_many :articles

  before_validation :set_access_count_if_nil

  private

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
#

