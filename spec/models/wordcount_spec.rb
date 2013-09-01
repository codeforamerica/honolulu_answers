require 'spec_helper'

describe Wordcount do
  it { should belong_to :article }
  it { should belong_to :keyword }

  it { should respond_to :count }

  let(:wordcount) { FactoryGirl.create :wordcount }
  subject { wordcount }
  it { should be_valid }


end
