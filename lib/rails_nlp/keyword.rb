module RailsNlp
  class Keyword < ActiveRecord::Base
    attr_accessible :metaphone, :name, :stem, :synonyms
    serialize :metaphone, Array
    serialize :synonyms, Array

    has_many :wordcounts
    #  TODO: set this via metaprogramming for whatever the AR model is called that has keywords.
    has_many :articles, :through => :wordcounts

    # returns the total number of ocurrences of this keyword across all articles
    def count
      self.wordcounts.map(&:count).inject(0, :+)
    end

    def analyse
      raise "Cannot analyse keyword with no name" if self.name.blank?
      self.stem = Text::PorterStemming.stem( self.name )
      self.metaphone = Text::Metaphone.double_metaphone( self.name )
      self.synonyms = BigHugeThesaurus.synonyms( self.name )
      self.save
    end


    private

    # def stem string
    # end

    # def metaphone string
    # end

    # def synonyms
    # end

  end
end