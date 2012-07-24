# encoding: UTF-8
require 'spec_helper'

describe RailsNlp::TextAnalyser do
  before(:all) do
    @analyser = RailsNlp::TextAnalyser.new
  end

  describe "Combining all the strings and texts of a model into one long string" do
    it "works with a fantasy example" do
      class AssocModel
        attr_accessor :name
        def name
          @name || "INCEPTION"
        end
      end
      class FakeModel
        attr_accessor :name, :player_class, :level, :description, :private_text

        def assoc_model
          AssocModel.new
        end

        def name
          @name || 'Dan Longstaff'
        end

        def player_class
          @player_class || 'Fighter'
        end

        def level
           @level || '32'
        end

        def description
          @description || "<a href='about:blank'>Dan</a> wields his mighty sword with a <strong>tight fisted grip</strong>.\n\nLunging at his enemies' bodies he yells \"AAAARRRGGH!!\", before flailing wildly all that rests in his path."  
        end

        def private
          @private_text || "you shouldn't be reading this you bottle-ale rascal, you filthy bung, away!"
        end
      end
      model = FakeModel.new
      text = @analyser.collect_text( :model => model, :fields => ['name', 'player_class', 'description', 'assoc_model.name'])
      text.should eq(model.name + ' ' + model.player_class + ' ' + model.description + ' ' + model.assoc_model.name + ' ')
    end
  end

  describe "Clean the text of non-word characters" do

    it "removes html tags" do
      dirty = "<div id='content', class='class'>one two <br /><ul><li>three </li><br /><strong>four</strong></ul></div>"
      @analyser.clean(dirty).should eq "one two three four"
    end

    it "removes non-valid html" do
      pending 'not working since the hml tokenizer in actionpack only supports valid xhtml'
    end

    it "doesn't remove foreign language characters" do
      @analyser.clean("トマノシク").should eq("トマノシク")
    end

    it "removes punctuation" do
      @analyser.clean("s.w.a.t. fever!").should eq("swat fever")
    end

    it "removes single characters and digits" do
      @analyser.clean(" a 2 bird").should eq(" bird")
    end

    it "removes numbers" do
      @analyser.clean("sherman 42 wallaby way sydney").should eq("sherman wallaby way sydney")
    end

    it "removes capitalisation" do
      @analyser.clean("Hello").should eq("hello")
    end

    it "removes control characters" do
      @analyser.clean("new\n\nline").should eq("new line")
    end

    it "works with actual examples" do
      dirty = "<div class=\"quick_bottom\"><h3>what you need to know</h3>\r\n<p>\tTo renew online, you'll need your license plate number, the VIN number for your trailer, and a Visa or Mastercard.</p>\r\n"
      clean = @analyser.clean( dirty )
      clean.should eq("what you need to know to renew online you need your license plate number the vin number for your trailer and visa or mastercard ")
    end
  end

  describe "creating a frequency map of useful words" do
    it "ignores stop words" do
      string = "when is i a the then to but how where"
      @analyser.freq_map(string).should == {}
    end

    it "returns a hash" do
      string = ""
      @analyser.freq_map(string).class.should eq( {}.class )
    end

    it "maps each word to its ocurrence in the string" do
      string = "when nonstopword1 is nonstopword2  i a the then to nonstopword2 nonstopword2 but how where"
      @analyser.freq_map(string).should == { 'nonstopword1' => 1, 'nonstopword2' => 3 }
    end
  end

  describe "Given an array of words, return an array of Keywords" do
    class PretendKeyword 
      attr_accessor :name, :metaphones, :stem, :synonyms
    end

    # before(:all) do
    #   @kw = PretendKeyword.new
    #   @kw.name = "jobs"
    #   @kw.metaphones = ["JPS", "APS"]
    #   @kw.stem = 'job'
    #   @kw.synonyms = ['occupation', 'business', 'line of work']
    # end

    it "uses an existing keyword if one is present" do
      pending 'not sure how to test'
      # we will have access to the Keyword model, i think.
    end

    it "creates a new keyword if one doesn't already exist" do
      pending 'not sure how to test'
    end

    it "works with a nice example" do
      words = %w{one two three four five}
      keywords = @analyser.words_to_keywords( words )
      keywords.map(&:name).should eq( words )
    end

    it "keywords should have computed stem" do
      words = ['driving']
      keywords = @analyser.words_to_keywords( words )
      keywords.first.stem.should eq( 'drive' )
    end

    xit "keywords should have computed metaphones" do
    end

    xit "keywords should have computed synonyms" do
    end
  end
  



end