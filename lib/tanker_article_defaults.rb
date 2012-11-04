module TankerArticleDefaults
  def self.included(base)
    base.send(:include, ::Tanker)

    index = 'hnlgovanswers-development'
  	index = 'hnlgovanswers-production' if Rails.env === 'production'
    
    base.tankit index, :as => 'Article' do
      indexes :title
	    indexes :content
      indexes :content_md
      indexes :content_main_extra
      indexes :content_need_to_know
	    indexes :category, :category => true
	    indexes :tags
	    indexes :preview
      indexes :author_name

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