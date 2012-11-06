class Department < ActiveRecord::Base
  attr_accessible :acronym, :name
  has_many :users
end
