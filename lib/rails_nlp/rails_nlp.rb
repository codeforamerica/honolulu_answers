# encoding: UTF-8
module RailsNlp
  class TextAnalyser
    require 'facets/enumerable'
    require 'action_view'

    include ActionView::Helpers::SanitizeHelper

    attr_accessor :model, :fields

    def initialize(model, fields)
      @model = model
      @fields = fields
    end

    def stop_words
      @stop_words ||= ['a','able','about','across','after','all','almost','also','am','among','an','and','any','are','as','at','be','because','been','but','by','can','cannot','could','dear','did','do','does','either','else','ever','every','for','from','get','got','had','has','have','he','her','hers','him','his','how','however','i','if','in','into','is','it','its','just','least','let','like','likely','may','me','might','most','must','my','neither','no','nor','not','of','off','often','on','only','or','other','our','own','rather','said','say','says','she','should','since','so','some','than','that','the','their','them','then','there','these','they','this','tis','to','too','twas','us','wants','was','we','were','what','when','where','which','while','who','whom','why','will','with','would','yet','you','your']
    end

    def collect_text
      [].tap do |text|
        fields.each do |field|
          field_contents = model.instance_eval(field)
          text << field_contents if field_contents
        end
      end.join(" ")
    end

    def clean str
      # strip html tags
      # "This currently assumes valid XHTML, which means no free < or > characters."
      # https://github.com/rails/rails/blob/master/actionpack/lib/action_controller/vendor/html-scanner/html/tokenizer.rb
      str = strip_tags str
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

    def count_words words
      words = words.split
      words = words - stop_words

      # Ruby Facets - http://www.webcitation.org/69k1oBjmR
      return words.frequency
    end

    def delete_orphaned_keywords
      orphan_kw_ids = Keyword.all( :select => 'id' ).map{ |kw| kw.id } -
        Wordcount.all( :select => 'keyword_id' ).map{ |wc| wc.keyword_id }
      Keyword.destroy( orphan_kw_ids )
    end

    ### query-magic activerecord callbacks

    #   1) Analyse all the text fields and parse them into a frequency map of words. { <word_i> => <freq_i>, [...], <word_n> => <freq_n> }
    #   2) For each word in text, kw = Keyword.find_or_create_by_name(word).(i)
    #   3) Create a new Wordcount row with :keyword_id => kw.id, :article_id => article.id and count as the frequency of the keyword in the article.
    def create_analysis
      begin
        text = collect_text
        text = clean(text)
        wordcounts = count_words(text)
        wordcounts.each do |word, frequency|
          kw = Keyword.find_or_create_by_name( word )
          Wordcount.create!(:keyword_id => kw.id, :article_id => model.id,
                            :count => frequency)
        end
      rescue => e
        ErrorService.report e
      end
    end

    # 1) remove all wordcount rows for this article
    # 2) treat the article as a new article
    # 3) remove keywords where keyword.id isn't present in column Wordcount#keyword_id
    def update_analysis
      begin
        model.wordcounts.destroy_all
        create_analysis
        delete_orphaned_keywords
      rescue => e
        ErrorService.report(e)
      end
    end

    # 1) remove all wordcount rows for this article
    # 2) remove keywords where keyword.id isn't present in column Wordcount#keyword_id
    def destroy_analysis
      begin
        model.wordcounts.destroy_all
        delete_orphaned_keywords
      rescue => e
        ErrorService.report(e)
      end
    end

  end
end
