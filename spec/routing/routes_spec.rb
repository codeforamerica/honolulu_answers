require 'spec_helper'

describe "routing to articles" do
  let(:article) { FactoryGirl.create :article }
  before { article.save }

  it "routes /articles/:id to articles#show for the article id" do
    { :get => "/articles/#{article.id}" }.should route_to(
      :controller => "articles",
      :action     => "show",
      :id         => "#{article.id}"
    )
  end

  it "routes /articles to articles#index" do
    { :get => "/articles"}.should route_to(
      :controller => "articles",
      :action     => "index"
    )
  end
end

describe "routing to search" do
  it "routes /search to search#index" do
    { :get => "/search" }.should route_to(
      :controller => "search",
      :action     => "index")
  end
end

