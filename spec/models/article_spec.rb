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

  describe "#remove_stop_words(string)" do
    it "removes common english words from the string" do
      Article.remove_stop_words('why am I a banana').should eq('banana')
    end
  end

  describe "#spell_check(string)" do
    it "corrects misspelt words in the string" do
      Keyword.create_all( ['renew', 'driver', 'license'] )
      Article.spell_check('renw droivr lisence').should eq('renew driver license')
    end
  end

end

#  describe "spell checking" do
    #context "well formed clean strings" do
      #it "corrects simple spelling mistakes like typos" do
      #end

      #it "only suggests words which occur in the database" do
      #end
    #end

    #context "problem strings" do
      #xit "leaves a correctly spelled string with punctuation in tact" do
      #end
    #end
  #end

# == Schema Information
#
# Table name: articles
#
#  id                      :integer         not null, primary key
#  updated                 :datetime
#  title                   :string(255)
#  content                 :text
#  created_at              :datetime        not null
#  updated_at              :datetime        not null
#  content_type            :string(255)
#  preview                 :text
#  contact_id              :integer
#  tags                    :text
#  service_url             :string(255)
#  is_published            :boolean         default(FALSE)
#  slug                    :string(255)
#  category_id             :integer
#  access_count            :integer         default(0)
#  author_pic_file_name    :string(255)
#  author_pic_content_type :string(255)
#  author_pic_file_size    :integer
#  author_pic_updated_at   :datetime
#  author_name             :string(255)
#  author_link             :string(255)
#

