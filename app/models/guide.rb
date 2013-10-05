class Guide < Article
  include TankerArticleDefaults

  has_many :guide_steps

  tankit do
    indexes :category, :category => true
    indexes :tags
    indexes :preview
    indexes :content do
      guide_steps.map(&:content).join(' ')
    end
    indexes :title do
      title + " " + guide_steps.map(&:title).join(" ")
    end
  end

  def guide_steps
    GuideStep.where("article_id = #{self.id}").order("step")
  end
end
