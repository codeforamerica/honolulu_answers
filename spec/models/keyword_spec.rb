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
    keyword.reload.synonyms.should include('enrollment')
  end
end
