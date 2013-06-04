module TankerArticleDefaults

  INDEX = Rails.env == 'production' ? ENV['SEARCHIFY_INDEX_PROD'] : ENV['SEARCHIFY_INDEX_DEV']

  def self.included(base)
    base.send(:include, ::Tanker)

    base.tankit INDEX, :as => 'Article' do
      indexes :title
      indexes :content_md
      indexes :category, :category => true
      indexes :tags
      indexes :preview

      # NLP
      indexes :metaphones do
        keywords.map { |kw| kw.metaphone }
      end
      indexes :synonyms do
        keywords.map { |kw| kw.synonyms.first(5) }
      end
      indexes :keywords do
        keywords.map { |kw| kw.name }
      end
      indexes :stems do
        keywords.map { |kw| kw.stem }
      end

    end
  end
end
