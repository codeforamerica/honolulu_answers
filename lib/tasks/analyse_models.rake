namespace :admin do  
  desc 'populate the keywords and wordcounts tables with data from the models'

  task :analysemodels => :environment do
    RailsNlp::TextAnalyser.analyse!
  end
end