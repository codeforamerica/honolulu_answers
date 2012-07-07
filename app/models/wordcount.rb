class Wordcount < ActiveRecord::Base
  attr_accessible :article_id, :count, :keyword_id
  
  belongs_to :article
  belongs_to :keyword
end
