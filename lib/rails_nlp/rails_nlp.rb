# encoding: UTF-8
module RailsNlp

  STOP_WORDS = ['a','able','about','across','after','all','almost','also','am','among','an','and','any','are','as','at','be','because','been','but','by','can','cannot','could','dear','did','do','does','either','else','ever','every','for','from','get','got','had','has','have','he','her','hers','him','his','how','however','i','if','in','into','is','it','its','just','least','let','like','likely','may','me','might','most','must','my','neither','no','nor','not','of','off','often','on','only','or','other','our','own','rather','said','say','says','she','should','since','so','some','than','that','the','their','them','then','there','these','they','this','tis','to','too','twas','us','wants','was','we','were','what','when','where','which','while','who','whom','why','will','with','would','yet','you','your']

  module ActiveRecordIncluded
    def text_analyser
      @text_analyser ||= TextAnalyser.new(self, self.class::TEXT_ANALYSE_FIELDS)
    end

    def create_analysis
      text_analyser.delay(:priority => 1).create_analysis
    end

    def update_analysis
      needs_analysis = !!(changes.keys & self.class::TEXT_ANALYSE_FIELDS).any?
      yield
      text_analyser.delay(:priority => 1).update_analysis if needs_analysis
    end

    def destroy_analysis
      text_analyser.delay(:priority => 1).destroy_analysis
    end

    def self.included(base)
      base.has_many :wordcounts
      base.has_many :keywords, :through => :wordcounts

      base.after_create :create_analysis
      base.around_update :update_analysis
      base.after_destroy :destroy_analysis
    end
  end

  class TextAnalyser
    require 'facets/enumerable'
    require 'action_view'

    include ActionView::Helpers::SanitizeHelper

    attr_accessor :model, :fields

    def initialize(model, fields)
      @model = model
      @fields = fields
    end

    def collect_text
      [].tap do |text|
        fields.each do |field|
          begin
            field_contents = model.send(field)
            text << field_contents if field_contents
          rescue NoMethodError => e
            ErrorService.report(e)
          end
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

    # Ruby Facets - http://www.webcitation.org/69k1oBjmR
    def count_words words
      QueryExpansion.remove_stop_words(words.split).frequency
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
      text = collect_text
      text = clean(text)
      wordcounts = count_words(text)
      wordcounts.each do |word, frequency|
        kw = Keyword.find_or_create_by_name( word )
        Wordcount.create!(:keyword_id => kw.id, :article_id => model.id,
                          :count => frequency)
      end
    end

    # 1) remove all wordcount rows for this article
    # 2) treat the article as a new article
    # 3) remove keywords where keyword.id isn't present in column Wordcount#keyword_id
    def update_analysis
      model.wordcounts.destroy_all
      create_analysis
      delete_orphaned_keywords
    end

    # 1) remove all wordcount rows for this article
    # 2) remove keywords where keyword.id isn't present in column Wordcount#keyword_id
    def destroy_analysis
      model.wordcounts.destroy_all
      delete_orphaned_keywords
    end
  end

  class QueryExpansion

    def self.remove_stop_words(string_list)
      string_list.map(&:downcase) - STOP_WORDS
    end

    def self.expand(query)
      stems,metaphones = [[],[]]

      remove_stop_words(query.split).each do |term|
        if kw = Keyword.find_by_name(term)
          stems << kw.stem
          metaphones << kw.metaphone.compact
        else
          stems << Text::PorterStemming.stem(term)
          metaphones << Text::Metaphone.double_metaphone(term)
        end
      end

      query_final =      "title:(#{query.split.join(' OR ')})^10"
      query_final << " OR content:(#{query.split.join(' OR ')})^5"
      query_final << " OR tags:(#{query.split.join(' OR ')})^8"
      query_final << " OR stems:(#{stems.flatten.join(' OR ')})^3"
      query_final << " OR metaphones:(#{metaphones.flatten.compact.join(' OR ')})^2"
      query_final << " OR synonyms:(#{query.split.join(' OR ')})"

      return query_final
    end

    def self.spell_check(string)
      dict = Hunspell.new( "#{Rails.root.to_s}/lib/assets/dict/en_US", 'en_US' )

      dict_custom = Hunspell.new( "#{Rails.root.to_s}/lib/assets/dict/blank", 'blank' )
      Keyword.pluck(:name).each do |keyword|
        dict_custom.add keyword
      end

      STOP_WORDS.each{ |sw| dict_custom.add sw }

      string_corrected = string.split.map do |word|
        if dict.spell(word) or dict_custom.spell(word) # word is correct
          word
        else
          suggestion = dict_custom.suggest( word ).first
          suggestion.nil? ? word : suggestion
        end
      end

      string_corrected.join ' '
    end

    def self.remove_punctuation_and_plurals(query)
      query.downcase.gsub(/[^\w]/, ' ').gsub(/ . /, ' ')
    end

  end
end
