class Guide < Article
	has_many :guide_steps

	def guide_steps
		GuideStep.where("article_id = #{self.id}").order("step")
	end
end