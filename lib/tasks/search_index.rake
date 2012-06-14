require 'indextank'
include ActionView::Helpers::SanitizeHelper

namespace :admin  do
  desc "index all the documents."
  task :indexdocs => :environment do

    client = IndexTank::Client.new(ENV['SEARCHIFY_API_URL'])
    index = client.indexes("hnlanswers-"+ Rails.env)

    @articles = Article.all
    @articles.each do |a|
      index.document( a.id.to_s ).add( {
          :text    => strip_tags(a.content), 
          :title   => a.title,
          :tags    => a.tags.to_s,
          :preview => a.preview.to_s
           } )
    end
    print "#{@articles.length} articles indexed.\n"
  end

  task :createindex => :environment do

    client = IndexTank::Client.new(ENV['SEARCHIFY_API_URL'])
    index = client.indexes("hnlanswers-"+ Rails.env)
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
    index = client.indexes("hnlanswers-"+ Rails.env)
    index.delete
  end
  
end
