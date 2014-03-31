namespace :rails_nlp do  
  desc 'populate the keywords and wordcounts tables with data from the models'

  task :analyse_articles => :environment do
    pbar = ProgressBar.new("Please wait...", Article.count)
    Keyword.destroy_all
    Wordcount.destroy_all
    Article.all.each do |article|
      RailsNlp::TextAnalyser.new(article, Article::TEXT_ANALYSE_FIELDS).create_analysis
      pbar.inc
    end
  end
end
