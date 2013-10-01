class Guide < Article
  include TankerArticleDefaults

  has_many :guide_steps

  tankit do
    indexes :category, :category => true
    indexes :tags
    indexes :preview
    indexes :content do
      guide_steps.map { |gs| gs.content }
    end
    indexes :title do
      [title] << guide_steps.map { |gs| gs.title }
    end
  end

  def guide_steps
    GuideStep.where("article_id = #{self.id}").order("step")
  end
end
