module TankerArticleDefaults
  def self.included(base)
    base.send(:include, ::Tanker)

    index = case Rails.env
            when 'production' then 'hnlgovanswers'
            when 'staging' then 'hnlgovanswers-stage'
            else 'hnlgovanswers-dev'
            end

    base.tankit index, :as => 'Article' do
      indexes :title
      indexes :category, :category => true
      indexes :tags
      indexes :preview
      indexes :content do
        [:content_main, :content_main_extra, :content_need_to_know]
      end

      # NLP
      indexes :metaphones do
        keywords.map(&:metaphone).uniq
      end
      indexes :synonyms do
        keywords.map { |kw| kw.synonyms.first(5) }.uniq
      end
      indexes :stems do
        keywords.map(&:stem).uniq
      end
    end
  end
end
