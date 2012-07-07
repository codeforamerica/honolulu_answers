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

  let(:article) { FactoryGirl.create(:article) }
  subject { article }
  it { should be_valid }
  its(:access_count) { should_not be_nil }

  describe "search" do
    context "query matches articles in the database" do
      subject { Article.search( article.title ) }
      it { should include( article ) }
    end
    context "query does not match anything in the database" do
      subject { Article.search( "jjzwg36n75ii42pv1uo4" ) }
      it { should == [] }
    end
    context "query is the empty string" do
      subject { Article.search ''}
      it { should == Article.all }
    end

    context "query is a single space" do
      subject { Article.search ' ' }
      it { should == Article.all }
    end

    describe "search titles" do
      context "query is present in an article but not the title" do
        subject { Article.search_titles article.preview }
        it { should == [] }
      end
      context "query is present in the title" do
        subject { Article.search_titles article.title }
        it { should == [article] }
      end
    end
  end

  describe "access_count_increment" do
    it "increases access_count by 1" do
      lambda {
        article.access_count_increment
      }.should change(article, :access_count).by(1)
    end
  end

end

# == Schema Information
#
# Table name: articles
#
#  id           :integer         not null, primary key
#  updated      :datetime
#  title        :string(255)
#  content      :text
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  content_type :integer
#  preview      :text
#  contact_id   :integer
#  tags         :text
#  service_url  :string(255)
#  is_published :boolean         default(FALSE)
#  slug         :string(255)
#  category_id  :integer
#  access_count :integer
#

