namespace :admin do  
  desc 'populate the keywords and wordcounts tables with data from the models'

  task :analysemodels => :environment do
    Keyword.destroy_all
    Wordcount.destroy_all
    pbar = ProgressBar.new("Please wait...", Article.count)
    Article.all.each do |article|
      article.qm_after_create_without_delay
      pbar.inc
    end
  end
end
