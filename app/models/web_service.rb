class WebService < Article
	include TankerArticleDefaults

	attr_accessible :service_url
end