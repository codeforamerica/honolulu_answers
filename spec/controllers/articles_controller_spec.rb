require 'spec_helper'

describe ArticlesController do
  render_views

  describe "GET show" do
    let(:article) { FactoryGirl.create :quick_answer }

    it "assigns Article.find(article) to @article" do
      get :show, :id => article.id
      assigns(:article).should eq(article)
    end
  end


end
