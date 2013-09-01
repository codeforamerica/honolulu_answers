require 'spec_helper'

describe Category do
  it { should have_many :articles }
  
  it { should respond_to :name }
  it { should respond_to :access_count }

  let(:category) { FactoryGirl.create :category}
  it { should be_valid }
  subject { category }
  its(:access_count) { should_not be_nil }


  describe "all by access count" do
    subject { Category }
    its(:all_by_access_count) { should == Category.all(:order => 'access_count DESC') }
  end

  describe 'articles by access count' do
    subject { category }
    its(:articles_by_access_count) { should == category.articles.all(:order => 'access_count DESC') }
  end



end
