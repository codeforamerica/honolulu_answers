ActiveAdmin.register Contact do
  # This will authorize the Foobar class
  # The authorization is done using the AdminAbility class
  controller.authorize_resource  


   # View 
  index do
    #column :id
    column "Name", :name
    column :department
    column :url
    column "Created", :created_at
    # column :tags
    default_actions # Add show, edit, delete column
  end

  # FIXME: not working
  show :title => proc { contact.name } do
  end

  show do |contact|

    attributes_table do
      row :name
      row :subname
      row :number
      row :url
      row :address
      row :department
      row :description
    end

    div do
      panel("Articles with this contact") do

        table_for(contact.articles) do
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
            if article.status=="Published"
              link_to "View", article
            else 
              "Draft"
            end
          end

          column :title
          column :type
          column :category
          column :user
          column :status
        end

      end
    end

  end

end
