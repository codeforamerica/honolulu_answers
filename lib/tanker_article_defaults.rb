module TankerArticleDefaults
  def self.included(base)
    base.send(:include, ::Tanker)

    index = ENV['SEARCHIFY_API_INDEX']
  	#index = 'hnlanswers-production' if Rails.env === 'production'
    
    base.tankit index, :as => 'Article' do
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
