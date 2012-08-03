# encoding: UTF-8
module RailsNlp
  class TextAnalyser
    include ActionView::Helpers::SanitizeHelper # to strip tags
    # require 'text'
    # require 'big_huge_thesaurus'
    require 'facets/enumerable'

    @@STOP_WORDS = ['a','able','about','across','after','all','almost','also','am','among','an','and','any','are','as','at','be','because','been','but','by','can','cannot','could','dear','did','do','does','either','else','ever','every','for','from','get','got','had','has','have','he','her','hers','him','his','how','however','i','if','in','into','is','it','its','just','least','let','like','likely','may','me','might','most','must','my','neither','no','nor','not','of','off','often','on','only','or','other','our','own','rather','said','say','says','she','should','since','so','some','than','that','the','their','them','then','there','these','they','this','tis','to','too','twas','us','wants','was','we','were','what','when','where','which','while','who','whom','why','will','with','would','yet','you','your']

    def collect_text( options )
      model = options[:model]
      text = ''
      options[:fields].each do |field|
        text << model.instance_eval(field) + ' '
      end
      text
    end

    def clean str
      # strip html tags
      # "This currently assumes valid XHTML, which means no free < or > characters."
      # https://github.com/rails/rails/blob/master/actionpack/lib/action_controller/vendor/html-scanner/html/tokenizer.rb
      str = ActionView::Helpers::SanitizeHelper.strip_tags str

      # # replace control characters like \n and \t with a space
      str.gsub!(/[[:cntrl:]]+/, ' ')

      # remove plurals and posessives
      str.gsub!(/'(\S+)/, '')

      # remove anything that isn't a letter or a space
      str.gsub!(/[^\p{Word} ]/, '')

      # remove single characters
      str.gsub!(/(\s|\A)\S(\s|\z)/, ' ')

      # remove numbers
      str.gsub!(/\s\d+\s/, ' ')

      # downcase
      str.downcase!

      str
    end

    def freq_map words
      words = words.split
      words = words - @@STOP_WORDS
      
      # https://github.com/rubyworks/facets/blob/master/lib/core/facets/enumerable/frequency.rb
      return words.frequency
    end

    def words_to_keywords( words )
      keywords = []
      words.each do |word|
        keywords << Keyword.find_or_create_by_name( word )
      end
    end

        # def self.analyse!
    #   Article.all.each do |article|
    #     self.analyse article
    #   end
    
    #   # def get_text entity, columns
    #   #   # columns should be [:name, :title, :text]
    #   #   # entity should be an active record instance
    #   #   text = ''
    #   #   columns.each do |column|
    #   #     text << ' ' + entity.column + ' '
    #   #   end
    #   # end
    # end

    # def self.analyse article
    #  text = ''        
    #   # grab all the text from the string/text fields, seperated by spaces
    #   text << (   article.tags                  if article.tags )    + ' '
    #           ( + article.title                 if article.title )   + ' '
    #           ( + strip_tags( article.content ) if article.content ) + ' '
    #           ( + article.preview               if article.preview ) + ' '
    #           ( + article.category.name         if article.category )+ ' '
      
    #   # remove non-word content
    #   text = self.clean( text )

    #   # make an array of every word in the text (WITH DUPLICATES)
    #   words = text.split

    #   # remove stop words
    #   words = words - @@STOP_WORDS

    #   # make the words a frequency hashmap
    #   words = words.frequency

    #   pbar = ProgressBar.new("article_id: #{article.id}", words.values.count) unless Rails.env == production
    #   words.each do |word, freq|
    #     # find the Keyword object for this word, or create a new one if this word is new
    #     keyword = Keyword.find_by_name( word )
    #     if keyword.nil?
    #       keyword = Keyword.create!( 
    #         :name      => word,
    #         :metaphone => Text::Metaphone.double_metaphone(word),
    #         :stem      => Text::PorterStemming.stem(word),
    #         :synonyms  => BigHugeThesaurus.synonyms( word )
    #       ) 
    #     end

    #     # Add the keyword to the article's list of words
    #     article.keywords << keyword unless article.keywords.include? keyword
    #     article.save

    #     # set how many times 'word' aappears in 'article'
    #     wordcount = Wordcount.where( :article_id => article.id, :keyword_id => keyword.id)
    #     raise Exception.new "#{wordcount.count} record(s) found for: Wordcount.where( :article_id => #{article.id}, :keyword_id => #{keyword.id})" if wordcount.count != 1
    #     wordcount.first.update_attributes! :count => freq

    #     # Increment the progress bar
    #     pbar.inc unless Rails.env == production
    #   end 
    # end

  end
end