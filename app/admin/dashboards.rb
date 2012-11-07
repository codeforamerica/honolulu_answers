ActiveAdmin::Dashboards.build do
  
  section("Recent Articles", :if => proc {current_user.is_admin? || current_user.is_editor? }) do
    table_for Article.order("created_at DESC").limit(5) do
      column "Article Title", :title do |article|
        link_to article.title, [:admin, article]
      end
      column "Author", :author_name
      column "Date Created", :created_at
      column "Date Updated", :updated_at
    end
    strong { link_to "View All Articles", admin_articles_path }
    strong {'|'}
    strong { link_to "New Article", new_admin_article_path }
  end
  
  section("Users", :if => proc{ current_user.is_admin? }) do
    table_for User.order("created_at DESC").limit(5) do
      column "User", :email do |user|
        link_to user.email, [:admin, user]
      end
      column "Department", :department
      column "Editor", :is_editor
    end
    strong { link_to "View All Users", admin_users_path }
    strong {'|'}
    strong { link_to "New User", new_admin_user_path }
  end
  

  # Define your dashboard sections here. Each block will be
  # rendered on the dashboard in the context of the view. So just
  # return the content which you would like to display.
  
  # == Simple Dashboard Section
  # Here is an example of a simple dashboard section
  #
  #   section "Recent Posts" do
  #     ul do
  #       Post.recent(5).collect do |post|
  #         li link_to(post.title, admin_post_path(post))
  #       end
  #     end
  #   end
  
  # == Render Partial Section
  # The block is rendered within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
  #   section "Recent Posts" do
  #     div do
  #       render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
  #     end
  #   end
  
  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section "Recent Posts", :priority => 10
  #   section "Recent User", :priority => 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.
  
  # == Conditionally Display
  # Provide a method name or Proc object to conditionally render a section at run time.
  #
  # section "Membership Summary", :if => :memberships_enabled?
  # section "Membership Summary", :if => Proc.new { current_admin_user.account.memberships.any? }

end
