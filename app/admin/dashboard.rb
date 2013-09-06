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
            column "Status", :status
            column "Date Created", :created_at
            column "Date Updated", :updated_at
          end
        end if current_user.is_admin? || current_user.is_editor?

        panel "Your Articles", :priority => 2 do
          table_for current_user.articles.order("created_at DESC") do
            column "Article Title", :title do |article|
              link_to article.title, [:admin, article]
            end
            column "Author", :user do |article|
              article.user.try(:email)
            end
            column "Status", :status
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
            column "Status", :status
            column "Date Created", :created_at
          end
        end if current_user.is_editor?

        panel "Legacy articles" do
          table_for Article.where(:status => Article::PUBLISHED) do
            column "Article Title", :title
            column "Status", :status
            column "" do |article|
              show_on_site_text = article.published? ? "Open on site" : "Preview on site"
              link_to show_on_site_text, article_path(article)
            end
            column "" do |article|
              link_to "edit", [:admin, article]
            end
          end
        end if current_user.is_admin?

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
