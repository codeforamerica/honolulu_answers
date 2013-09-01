require 'spec_helper'

describe "Searches" do

  describe "index.html.erb the search results page" do
    let(:article) { FactoryGirl.create :article }
    let(:query) { article.title.downcase.gsub!(/[^\w ]*/, '') }

    context "1 result found" do
      before do
        Article.delete_all
        article = FactoryGirl.create :article
        visit root_path
        fill_in 'query', :with => query
        click_on 'query-btn'
      end
      subject { page }
      it { should have_content "Search results for: \"#{query}\"" }
      it { should have_content " result found" }
      it { should have_content article.title }
      it { should have_content article.preview }
    end

    context "no results found" do
      before do
        visit root_path
        fill_in 'query', :with => query.reverse*3
        click_on 'query-btn'
      end
      subject { page }
      it { should have_content "Search results for: \"#{query}\"" }
      it { should have_content "0 results found" }
      it { should_not have_content article.title }
    end

    context "several results found" do
      let(:article_1) { FactoryGirl.create :article_random }
      let(:article_2) { FactoryGirl.create :article_random }
      let(:results) { [article_1, article_2] }
      let(:query_random) { article.content.split.sample }
      before do
        visit root_path
        fill_in 'query', :with => query_random
        click_on 'query-btn'
      end
      subject { page }

      it { should have_content "Search results for: \"#{query_random}\"" }
      it { should have_content " results found" }
      it { should have_content article_1.title }
      it { should have_content article_1.preview }
      it { should have_content article_2.title }
      it { should have_content article_2.preview }
    end


  end


  describe "example queries" do
    let(:article) { FactoryGirl.create :article }
    before { visit root_path }
    
    describe "Incorrect spelling" do
      it "returns results for commonly misspelled terms" do
        fill_in 'query', :with => 'driving lisence'
        click_on 'query-btn'      
        page.should have_content article.title
      end

      it "returns results when the query has typos" do
        fill_in 'query', :with => 'drivnig livense'
        click_on 'query-btn'
        page.should have_content article.title
      end
    end

    describe "Non-keyword words are synonyms of desired search results" do
      it "returns relevant search results" do
        pending 'integration of synonym search'
        fill_in 'query', :with => 'new automobile license'
        click_on 'query-btn'
        page.should have_content article.title
      end
    end

    describe "Articles without tags" do
      let(:article) { FactoryGirl.create :article_no_tags }
      context "Query contains conjugations of title keywords" do
        it "search results include the article" do
          fill_in 'query', :with => article.title.gsub(/driver/, 'driving')
          click_on 'query-btn'
          page.should have_content article.title
        end
      end

      context "Query matches title exactly" do
        it "search results include the article" do
          fill_in 'query', :with => article.title
          click_on 'query-btn'
          page.should have_content article.title
        end
      end
    end
  end  
end
