class Wordcount < ActiveRecord::Base
  attr_accessible :article_id, :count, :keyword_id
  
  belongs_to :article
  #  TODO: set this via metaprogramming for whatever the AR model is called that has keywords.
  belongs_to :keyword

  before_validation :set_count_if_nil

  private

  def set_count_if_nil
    self.count = 0 if self.count.nil?
  end

end
# == Schema Information
#
# Table name: wordcounts
#
#  id         :integer         not null, primary key
#  article_id :integer
#  keyword_id :integer
#  count      :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

