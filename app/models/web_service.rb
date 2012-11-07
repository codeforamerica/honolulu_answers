class WebService < Article
	include TankerArticleDefaults

	attr_accessible :service_url
	
	before_save :set_is_published
		
	private
	
  def set_is_published
    if status == 'Published'
      self.is_published = true
    else
      self.is_published = false
    end
  end
end