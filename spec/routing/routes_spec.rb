require 'spec_helper'

describe "routing to search results" do
  it "routes /search/ to search#index for a given query" do
    { :get => "/search/" }.should route_to(
      :controller => 'search',
      :action => 'index'
    )
  end

end