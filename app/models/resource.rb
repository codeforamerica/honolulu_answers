class Resource < Article
	include TankerArticleDefaults

	attr_accessible :service_url
end
