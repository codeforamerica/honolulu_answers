class GuideStep < ActiveRecord::Base
  include TankerArticleDefaults
  belongs_to :guide, :class_name => 'Guide', :foreign_key => 'article_id'
  attr_accessible :article_id, :title, :content, :preview, :step

  delegate :category, :tags, :keywords, :to => :guide

  def content_md
    content
  end
end
