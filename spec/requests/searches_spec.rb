require 'spec_helper'

# TODO: change this so that instead of hardcoding variations, use regex.  
# THEN: refactor so there's a more logical and DRY structure

describe "Searches",:js => true do
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

  describe "Keyword in query is a different conjugation" do
    it "returns search results for the actual keyword" do
      fill_in 'query', :with => 'driving license'
      click_on 'query-btn'
      page.should have_content article.title
    end      
  end

  describe "Non-keyword words are synonyms of desired search results" do
    it "returns relevant search results" do
      fill_in 'query', :with => 'what to do for a new driver license'
      click_on 'query-btn'
      page.should have_content article.title
    end
  end

  describe "Query contains search keywords where some are in one field and some another" do
    # like if an article's title is 'car' and content is 'register'
    # then the query 'car register' should find the article
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

    context "Query contains synonyms for common words" do
      it "search results include the article" do
        fill_in 'query', :with => article.title.gsub(/can/, 'do').gsub(/get/, 'have').gsub(/for the first time/, '')
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
