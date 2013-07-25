ActiveAdmin.register WebService do
  controller do
  # as per https://github.com/gregbell/active_admin/wiki/Enforce-CanCan-constraints
    load_and_authorize_resource :except => :index
    def scoped_collection
      end_of_association_chain.accessible_by(current_ability)
    end
    def create
      if params[:commit] == "Preview"
        max_id = Article.maximum('id')
        session[:article_preview] = request.parameters[:web_service].merge(id: max_id+1)
        redirect_to preview_web_services_path
      else
        @web_service = WebService.new(params[:quick_answer])
        super
      end
    end

    def update
      if params[:commit] == "Preview"
        session[:article_preview] = request.parameters[:web_service]
        redirect_to preview_web_services_path
      else
        @web_service = WebService.find(params[:id])
        super
      end
    end
   end

  # Add to :parent Dropdown menu
  menu :parent => "Articles"

  # Filterable attributes
  filter :title
  filter :tags
  filter :contact_id
  filter :status

  scope :all, :default => true do |articles|
    articles.includes [:category, :feedback]
  end

  index do
    column :id
    column "Web Service Title", :title do |article|
      link_to article.title, [:admin, article]
    end
    column :contact
    column "Created", :created_at
    column "Author", :user do |article|
      if(article.user.try(:department))
        (article.user.try(:email) || "") + ", " + (article.user.try(:department).name || "")        
      else
        (article.user.try(:email) || "")
      end
    end
    # column :tags
    column :slug
    column "Status", :status
    default_actions # Add show, edit, delete column
  end

  form :partial => "shared/admin/article_form"

end
