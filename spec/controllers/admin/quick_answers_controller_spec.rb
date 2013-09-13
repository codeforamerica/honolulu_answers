require 'spec_helper'
include Devise::TestHelpers

describe Admin::QuickAnswersController do

  context "As a writer" do
    before(:each) do
      sign_in FactoryGirl.create(:writer)
    end

    describe "Create" do
      it "is unpublished by default" do
        post :create, :quick_answer => {}
        QuickAnswer.last.published.should be_false
      end

      it "is not pending review by default" do
        post :create, :quick_answer => {}
        QuickAnswer.last.pending_review.should be_false
      end
    end

    describe "Update" do
      it "updates the title" do
        article = FactoryGirl.create(:quick_answer)
        put :update, :id => article.id, :quick_answer => { :title => 'new title' }
        article.reload.title.should eq('new title')
      end

      describe "with Ready to Review" do
        it "marks it as pending_review: true" do
          article = FactoryGirl.create(:quick_answer, :not_pending_review)
          put :update, :id => article.id, :ask_review => '', :quick_answer => {}
          article.reload.read_attribute(:pending_review).should be_true
        end
      end
    end
  end

  context "As an editor" do
    before(:each) do
      sign_in FactoryGirl.create(:editor)
    end

    describe "with 'Publish'" do
      it "marks it as published: true" do
        article = FactoryGirl.create(:quick_answer, :unpublished)
        put :update, :id => article.id, :publish => '', :quick_answer => {}
        article.reload.read_attribute(:published).should be_true
      end
    end

    describe "with 'Unpublish'" do
      it "marks it as published: false" do
        article = FactoryGirl.create(:quick_answer, :published)
        put :update, :id => article.id, :unpublish => '', :quick_answer => {}
        article.reload.read_attribute(:published).should be_false
      end
    end

    describe "with 'Ask writer to revise'" do
      it "marks it as pending_review: false" do
        article = FactoryGirl.create(:quick_answer, :published)
        put :update, :id => article.id, :ask_revise => '', :quick_answer => {}
        article.reload.read_attribute(:pending_review).should be_false
      end
    end
  end

  context "As an admin" do
    before(:each) do
      @user = FactoryGirl.create(:admin)
      sign_in  @user
    end

    describe "assign a writer" do
      it "changes the user_id" do
        article = FactoryGirl.create(:quick_answer)
        put :update, :id => article.id,
          :quick_answer => { :user_id => @user.id }
        article.reload.user.should eq(@user)
      end
    end
  end
end
