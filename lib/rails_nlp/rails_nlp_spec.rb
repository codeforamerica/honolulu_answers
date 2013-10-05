# encoding: UTF-8
require_relative 'spec_helper'

describe RailsNlp::TextAnalyser do

  before(:each) do
    @model = double("ActiveRecord model")
    @model.stub(:name => "Jimmy")
    @model.stub(:description => "He'll fix anything!")
    @model.stub(:fields => ['name', 'description'])
    @analyser = RailsNlp::TextAnalyser.new(@model, @model.fields)
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
