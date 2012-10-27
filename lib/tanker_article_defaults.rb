module TankerArticleDefaults
  def self.included(base)
    base.send(:include, ::Tanker)

    index = 'wmgg_dev'
    index = 'wmgg_prod' if Rails.env === 'production'
    
    base.tankit index, :as => 'Article' do
      indexes :title
      indexes :content
      indexes :category, :category => true
      indexes :tags
      indexes :preview
      
      # NLP
      indexes :metaphones do
        keywords.map { |kw| kw.metaphone }
      end
      indexes :synonyms do
        keywords.map { |kw| kw.synonyms }
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
