class Category < ActiveRecord::Base
  extend FriendlyId
  attr_accessible :access_count, :name, :description
  has_many :articles

  before_validation :set_access_count_if_nil

  friendly_id :name, use: [:slugged, :history]

  default_scope order('name ASC')
  scope :by_access_count, order('access_count DESC')

  private

  def set_access_count_if_nil
    self.access_count = 0 if self.access_count.nil?
  end

end
