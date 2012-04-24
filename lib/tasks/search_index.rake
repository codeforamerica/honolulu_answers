require 'indextank'
include ActionView::Helpers::SanitizeHelper

namespace :admin  do
  desc "index all the documents."
  task :indexdocs => :environment do

    client = IndexTank::Client.new(ENV['SEARCHIFY_API_URL'])
    index = client.indexes("hnlanswers-"+ENV['RAILS_ENV'])

    @articles = Article.all
    for @a in @articles do
      index.document(@a.id.to_s).add({ :text => strip_tags(@a.content), :title => @a.title })
    end
    print "#{@articles.length} articles indexed.\n"
  end

  task :createindex => :environment do

    client = IndexTank::Client.new(ENV['SEARCHIFY_API_URL'])
    index = client.indexes("hnlanswers-"+ENV['RAILS_ENV'])
    index.add()

    print "Waiting for index to be ready"
    while not index.running?
      print "."
      STDOUT.flush
      sleep 0.5
    end
    print "\\n"
    STDOUT.flush
  end

  task :deleteindex => :environment do
    client = IndexTank::Client.new(ENV['SEARCHIFY_API_URL'])
    index = client.indexes("hnlanswers-"+ENV['RAILS_ENV'])
    index.delete()
  end
  
end
