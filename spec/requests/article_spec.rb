require 'spec_helper'

describe "Articles" do
  describe "show.html.erb the show article page do" do
    let(:article) { FactoryGirl.create :article }
    before { visit article_path article }

    describe "the url" do
      it "shows the article title" do
        url = current_url.gsub!(/http:..www.example.com.articles./, '')
        url.should == (article.id.to_s + '-') + article.title.parameterize
      end
    end

  end

  describe "index.html.erb the listing articles page", :js => true do
    let(:article) { FactoryGirl.create :article }
    before do
      visit articles_path
      wait_for_ajax
    end
    
    subject { page }

    it { should have_content "All Articles" }

    it 'saop' do page.driver.render "tmp/screenshot.png"; end

    describe "an article in the list" do
      it { should have_content article.title }
    end

    describe "a category" do
      it { should have_content article.category }
    end
    

  end
end