require 'spec_helper'

describe Wordcount do
  it { should belong_to :article }
  it { should belong_to :keyword }

  it { should respond_to :count }

  let(:wordcount) { FactoryGirl.create :wordcount }
  subject { wordcount }
  it { should be_valid }


end
# == Schema Information
#
# Table name: wordcounts
#
#  id         :integer         not null, primary key
#  article_id :integer
#  keyword_id :integer
#  count      :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

