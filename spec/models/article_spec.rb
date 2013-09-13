require 'spec_helper'

describe Article do
  it { should belong_to :contact}
  it { should belong_to :category}
  it { should have_many(:keywords).through :wordcounts }
  it { should have_many :wordcounts }

  it { should respond_to :title }
  it { should respond_to :content }
  it { should respond_to :category }
  it { should respond_to :preview }
  it { should respond_to :tags }
  it { should respond_to :access_count }

  it { should respond_to :content_md }

  it { should respond_to :content_main }
  it { should respond_to :content_main_extra }
  it { should respond_to :content_need_to_know }

  let(:article) { FactoryGirl.create(:quick_answer) }
  subject { article }
  it { should be_valid }
  its(:access_count) { should_not be_nil }

  describe "#remove_stop_words(string)" do
    it "removes common english words from the string" do
      Article.remove_stop_words('why am I a banana').should eq('banana')
    end
  end

  describe "#spell_check(string)" do
    it "corrects misspelt words in the string" do
      ['renew', 'driver', 'license'].each { |kw| Keyword.create!(:name => kw) }
      Article.spell_check('renw droivr lisence').should eq('renew driver license')
    end
  end

end

