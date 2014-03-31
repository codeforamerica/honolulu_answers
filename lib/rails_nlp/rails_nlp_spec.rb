# encoding: UTF-8
require_relative 'spec_helper'

module RailsNlp
describe TextAnalyser do

  before(:each) do
    @model = double("ActiveRecord model")
    @model.stub(:name => "Jimmy")
    @model.stub(:description => "He'll fix anything!")
    @model.stub(:fields => ['name', 'description'])
    @analyser = TextAnalyser.new(@model, @model.fields)
  end

  describe "Clean the text of non-word characters" do

    it "removes html tags" do
      dirty = "<div id='content', class='class'>one two <br /><ul><li>three </li><br /><strong>four</strong></ul></div>"
      @analyser.clean(dirty).should eq "one two three four"
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
      @analyser.count_words(string).should == {}
    end

    it "returns a hash" do
      string = ""
      @analyser.count_words(string).class.should eq(Hash)
    end

    it "maps each word to its ocurrence in the string" do
      string = "when nonstopword1 is nonstopword2  i a the then to nonstopword2 nonstopword2 but how where"
      @analyser.count_words(string).should == { 'nonstopword1' => 1, 'nonstopword2' => 3 }
    end
  end

end

  describe QueryExpansion do
    describe "#remove_stop_words(string)" do
      it "removes common english words from a list of words" do
        QueryExpansion.remove_stop_words('why am I a banana'.split).should eq(['banana'])
      end
    end

    describe "#spell_check(string)" do
      it "corrects misspelt words in the string" do
        ['renew', 'driver', 'license'].each { |kw| Keyword.create!(:name => kw) }
        QueryExpansion.spell_check('renw droivr lisence').should eq('renew driver license')
      end
    end
  end
end
