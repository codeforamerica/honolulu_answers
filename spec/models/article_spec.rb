require 'spec_helper'

describe Article do
  it { should belong_to :contact}
  it { should belong_to :category}

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
      subject { Article.search( SecureRandom.hex(16) ) }
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
        it { should include(article) }
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

  describe "#remove_stop_words(string)" do
    it "removes common english words from the string" do
      Article.remove_stop_words('why am I a banana').should eq('banana')
    end
  end

  describe "#spell_check(string)" do
    it "corrects misspelt words in the string" do
      Article.spell_check('renw droivr lisence').should eq('renew driver license')
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

