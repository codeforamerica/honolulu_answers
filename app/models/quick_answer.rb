class QuickAnswer < Article
	include TankerArticleDefaults
	
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