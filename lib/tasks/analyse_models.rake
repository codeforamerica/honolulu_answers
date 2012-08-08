namespace :admin do  
  desc 'populate the keywords and wordcounts tables with data from the models'

  task :analysemodels => :environment do
    pbar = ProgressBar.new("Please wait...", Article.count)
    Article.all.each do |article|
      article.analyse
      pbar.inc
    end
  end
end