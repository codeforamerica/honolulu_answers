ActiveAdmin.register_page "Dashboard" do
  menu :priority => 1

  content :title => proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Recent Articles" do
          table_for Article.order("created_at DESC").limit(5) do
            column "Article Title", :title do |article|
              link_to article.title, [:admin, article]
            end
            column "Author", :user do |article|
              article.user.try(:email)
            end
            column :published
            column :pending_review
            column "Date Created", :created_at
            column "Date Updated", :updated_at
          end
        end if current_user.is_admin? || current_user.is_editor?

        panel "Your Draft Articles", :priority => 2 do
          table_for current_user.articles.drafts.order("created_at DESC") do
            column "Article Title", :title do |article|
              link_to article.title, [:admin, article]
            end
            column "Date Created", :created_at
          end
        end if current_user.is_writer?

        panel "Your Pending Review Articles", :priority => 2 do
          table_for current_user.articles.pending_review.order("created_at DESC") do
            column "Article Title", :title do |article|
              link_to article.title, [:admin, article]
            end
            column "Date Created", :created_at
          end
        end if current_user.is_writer?

        panel "Your Published Articles", :priority => 2 do
          table_for current_user.articles.published.order("created_at DESC") do
            column "Article Title", :title do |article|
              link_to article.title, [:admin, article]
            end
            column "Date Created", :created_at
          end
        end if current_user.is_writer?

        panel "Pending review" do
          table_for Article.pending_review.order("created_at ASC") do
            column "Article Title", :title do |article|
              link_to article.title, [:admin, article]
            end
            column "Author", :user do |article|
              article.user.try(:email)
            end
            column :published
            column :pending_review
            column "Date Created", :created_at
          end
        end if current_user.is_editor?

        panel "Users" do
          table_for User.order("created_at DESC").limit(5) do
            column "User", :email do |user|
              link_to user.email, [:admin, user]
            end
          end
          strong { link_to "View All Users", admin_users_path }
        end if current_user.is_admin?
      end
    end
  end
end
