namespace :admin do  
	task :update_url => :environment do
	  Article.find_each(&:save)
	end



	task :update_type => :environment do
		Article.update_all("type='WebService'","service_url is not null and service_url <> '' and type <> 'Guide'")
		Article.update_all("type='QuickAnswer'","(service_url is null or service_url = '') and type <> 'Guide'")
end
end