namespace :data do
  task :set_published => [:environment] do
    p 'Setting All Articles to be published...'
    Article.all.each{|a| a.update_attributes(:status => 'Published')}
  end
end