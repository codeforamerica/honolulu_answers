class Keyword < ActiveRecord::Base
  attr_accessible :metaphone, :name, :stem, :synonyms
  serialize :metaphone, Array
  serialize :synonyms, Array

  has_many :wordcounts
  has_many :articles, :through => :wordcounts

end
