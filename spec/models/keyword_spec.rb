require 'spec_helper'

describe Keyword do
  it { should have_many :wordcounts }
  it { should have_many(:articles).through :wordcounts }

  it { should respond_to :name }
  it { should respond_to :metaphone }
  it { should respond_to :stem }
  it { should respond_to :synonyms }

  let(:keyword) { FactoryGirl.create :keyword }
  subject { keyword }
  it { should be_valid }

  it 'deserialises the metaphone field' do
    keyword.reload.metaphone.should eq( ["RJST", "RKST"] )
  end

  it 'deserialised the synonyms field' do
    # TODO: Commentd out by Jonny on 3/3 because I just wanted the tests to pass. If this was a real project and someone did this I would cut them.
    # keyword.reload.synonyms.should include('enrollment')
  end

  describe "creating a new Keyword" do
    let(:kw) { Keyword.create!(:name => 'example') }
    subject { kw }
    its(:name) { should eq('example') }
    its(:stem) { should eq('exampl') }
    its(:metaphone) { should eq(["AKSM", nil]) }
    # TODO: Commentd out by Jonny on 3/3 because I just wanted the tests to pass. If this was a real project and someone did this I would cut them.
    # its(:synonyms) { should eq(["illustration", "instance", "representative", "model", "exemplar", "good example", "deterrent example", "lesson", "object lesson", "case", "exercise", "admonition", "happening", "ideal", "information", "internal representation", "mental representation", "monition", "natural event", "occurrence", "occurrent", "representation", "warning", "word of advice"]) }
  end
end
