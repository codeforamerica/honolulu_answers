class Keyword < ActiveRecord::Base
  attr_accessible :metaphone, :name, :stem, :synonyms
  serialize :metaphone, Array
  serialize :synonyms, Array

  has_many :wordcounts
  has_many :articles, :through => :wordcounts

  # returns the total number of ocurrences of this keyword across all articles
  def count
    self.wordcounts.map(&:count).inject(0, :+)
  end

end
