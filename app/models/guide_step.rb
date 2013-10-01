class GuideStep < ActiveRecord::Base
  belongs_to :guide, :class_name => 'Article', :foreign_key => 'article_id'
  attr_accessible :article_id, :title, :content, :preview, :step

  delegate :category, :tags, :keywords, :to => :guide

  after_save { guide.update_tank_indexes }
  after_destroy { guide.delete_tank_indexes }
end
