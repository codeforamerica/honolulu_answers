class Guide < Article
  include TankerArticleDefaults

  has_many :guide_steps

  TEXT_ANALYSE_FIELDS = ['guide_step_contents', 'guide_step_titles',
    'guide_step_previews', 'title', 'preview']

  tankit do
    indexes :content do
      guide_step_contents
    end

    indexes :title do
      guide_step_titles << title
    end

    indexes :preview do
      guide_step_previews << preview
    end
  end

  def guide_steps
    GuideStep.where("article_id = #{self.id}").order("step")
  end

  def guide_step_contents
    guide_steps.map(&:content).join(" ")
  end

  def guide_step_titles
    guide_steps.map(&:title).join(" ")
  end

  def guide_step_previews
    guide_steps.map(&:preview).join(" ")
  end
end
