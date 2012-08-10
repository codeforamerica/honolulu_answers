ActiveAdmin.register GuideStep do
	controller.authorize_resource  

	show do |step|
      attributes_table do
        row :title
        row :content
        row :preview
      end
      active_admin_comments
    end
end
