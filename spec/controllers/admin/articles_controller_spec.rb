require 'spec_helper'
include Devise::TestHelpers

describe Admin::ArticlesController do

  describe "Create" do
    let(:create) { post :create, :article => FactoryGirl.attributes_for(:article) }

    before(:each) { sign_in FactoryGirl.create(:writer) }

    it "creates an article" do
      expect{ create }.to change(Article, :count).by(1)
    end

    it "is unpublished by default" do
      create
      Article.last.should_not be_published
    end

    it "is not pending review by default" do
      create
      Article.last.should_not be_pending_review
    end
  end

  describe "Update" do
    let(:article) do
      FactoryGirl.create(:article, :unpublished, :not_pending_review)
    end

    let(:update) do
      put :update, :id => article.id, :article => { :title => 'new title' }
    end

    let(:update_with_publish) do
      put :update, :id => article.id, :article => { :title => 'new title' },
        :publish => ''
    end

    let(:update_with_unpublish) do
      put :update, :id => article.id, :article => { :title => 'new title' },
        :unpublish => ''
    end

    let(:update_with_ask_review) do
      put :update, :id => article.id, :article => { :title => 'new title' },
        :ask_review => ''
    end

    let(:update_with_ask_revise) do
      put :update, :id => article.id, :article => { :title => 'new title' },
        :ask_revise => ''
    end

    it "updates the title" do
      sign_in FactoryGirl.create(:writer)
      update
      article.reload.title.should eq('new title')
    end

    context "as a writer" do
      before(:each) do
        sign_in FactoryGirl.create(:writer)
      end

      context "draft articles" do
        let(:article) { FactoryGirl.create(:article, :draft) }

        it "can be updated with Ready to Review" do
          update_with_ask_review
          article.reload.should be_pending_review
        end

        it "cannot be published" do
          update_with_publish
          article.reload.should_not be_published
        end
      end

      context "published articles" do
        let(:article) { FactoryGirl.create(:article, :published) }

        it "cannot be updated" do
          update
          article.reload.title.should_not eq('new title')
        end

        it "cannot be unpublished" do
          update_with_unpublish
          article.reload.should be_published
        end
      end

      context "pending review articles" do
        let(:article) { FactoryGirl.create(:article, :pending_review) }

        it "cannot be updated" do
          update
          article.reload.title.should_not eq('new title')
        end
      end
    end


    context "as an editor" do
      before(:each) do
        sign_in FactoryGirl.create(:editor)
      end

      context "unpublished articles" do
        let(:article) { FactoryGirl.create(:article, :unpublished) }

        it "can be published" do
          update_with_publish
          article.reload.should be_published
        end
      end

      context "when pending review" do
        it "can ask writer to revise" do
          update_with_ask_revise
          article.reload.should be_draft
        end
      end

      context "published articles" do
        let(:article) { FactoryGirl.create(:article, :published) }

        it "can be unpublished" do
          update_with_unpublish
          article.reload.should_not be_published
        end
      end
    end

    context "as an admin" do
      let(:admin) { FactoryGirl.create(:admin) }
      before(:each) { sign_in admin }

      it "writers can be assigned" do
        put :update, :id => article.id, :article => { :title => 'new title',
                                                      :user_id => admin.id }
        article.reload.user.should eq(admin)
      end
    end
  end
end

