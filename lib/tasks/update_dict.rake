include ActionView::Helpers::SanitizeHelper
require 'hunspell-ffi'

namespace :admin  do
  desc "create a custom dictionary file with text from the articles"

  task :createdict => :environment do
    str = ''
    Article.all.each do |a|
      str << a.tags                  + ' ' +
             a.title                 + ' ' +
             strip_tags( a.content ) + ' ' +
             a.preview               + ' ' +
             a.category              + ' '
    end

    # replace control characters like \n and \t with a space
    str = str.gsub!(/[[:cntrl:]]+/, ' ')

    # remove puncutation 
    str = str.gsub!(/[[:punct:]]+/, '')

    # remove numbers
    str = str.gsub!(/[[:digit:]]+/, '')

    # remove single characters
    str = str.gsub!(/\s\S\s/, ' ')

    # downcase
    str = str.downcase

    ## save in hunspell format - OVERWRITES existing file
    custom = File.new( "#{Rails.root.to_s}/lib/assets/dict/custom/custom.dic", 'w')
    words = str.split.uniq!

    # file should begin with the word count to optimize hash bucket size etc.
    custom.puts words.size 
    words.each do |word|
      custom.puts word
    end
    custom.close()

    # ensure the file can be read by hunspell
    dict = Hunspell.new( "#{Rails.root.to_s}/lib/assets/dict/custom", 'custom')
  end

  # TODO: create a rake task to update the dictionary file, 
  #       so that it doesn't have to be recreated each time
  
end
