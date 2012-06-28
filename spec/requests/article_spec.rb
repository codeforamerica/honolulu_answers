require 'spec_helper'

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