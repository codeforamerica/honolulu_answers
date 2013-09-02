namespace :admin do  
  desc 'populate the keywords and wordcounts tables with data from the models'

  task :analysemodels => :environment do
    pbar = ProgressBar.new("Please wait...", Article.count)
    Keyword.destroy_all
    Wordcount.destroy_all
    Article.all.each do |article|
      article.analyse_now
      pbar.inc
    end
  end
end
