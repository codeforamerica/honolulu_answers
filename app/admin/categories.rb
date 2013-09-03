ActiveAdmin.register Category do

  # View
  index do
    column :name, :sortable => :name
    column "Created", :created_at
    column "Updated", :updated_at
    column "Description", :description
    default_actions # Add show, edit, delete column
  end

  show do
    attributes_table do
      row :name
      row :access_count
      row :description
      row :slug
    end

    div do
      panel("Articles with this category") do
        table_for(category.articles) do
          column "" do |article|
            if article.is_a? QuickAnswer
              link_to( "Edit", edit_admin_quick_answer_path(article))
            elsif article.is_a? WebService
              link_to( "Edit", edit_admin_web_service_path(article) )
            elsif article.is_a? Guide
              link_to( "Edit", admin_guide_path(article))
            end
          end

          column "" do |article|
            if article.status == Article::PUBLISHED
              link_to "Open", article
            else
              link_to "Preview", article
            end
          end

          column :title
          column :type
          column :contact
          column :user
          column :status
        end
      end #panel
    end #div
  end #show
end
