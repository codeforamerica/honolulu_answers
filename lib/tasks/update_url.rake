task :update_url => :environment do
  Article.find_each(&:save)
end