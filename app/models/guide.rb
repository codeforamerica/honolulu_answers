class Guide < Article
	include TankerArticleDefaults

	has_many :guide_steps
	before_save :set_is_published

	tankit do    
	    indexes :guide_steps_content do
	      guide_steps.map { |gs| gs.content }
	    end
	    indexes :guide_steps_title do
	      guide_steps.map { |gs| gs.title }
	    end
    end


	def guide_steps
		GuideStep.where("article_id = #{self.id}").order("step")
	end
		
	private
	
  def set_is_published
    if status == 'Published'
      self.is_published = true
    else
      self.is_published = false
    end
  end
end