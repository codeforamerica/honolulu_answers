ActiveAdmin::Dashboards.build do
  section("Recent Articles", :if => proc {current_user.is_admin? || current_user.is_editor? }, :priority => 1) do
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
  end

  section("Your Articles", :if => proc {current_user.is_writer? }, :priority => 2) do
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
  end

  section("Users", :if => proc{ current_user.is_admin? }) do
    table_for User.order("created_at DESC").limit(5) do
      column "User", :email do |user|
        link_to user.email, [:admin, user]
      end
    end
    strong { link_to "View All Users", admin_users_path }
  end
end
