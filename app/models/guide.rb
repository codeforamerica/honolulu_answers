class Guide < Article
  include TankerArticleDefaults

  has_many :guide_steps

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
end
