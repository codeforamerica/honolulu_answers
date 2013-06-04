ActiveAdmin.register QuickAnswer do
  # as per https://github.com/gregbell/active_admin/wiki/Enforce-CanCan-constraints
  controller do
    load_and_authorize_resource :except => :index
    def scoped_collection
      end_of_association_chain.accessible_by(current_ability)
    end

    def create
      if params[:commit] == "Preview"
        max_id = Article.maximum('id')
        session[:article_preview] = request.parameters[:quick_answer].merge(id: max_id+1)
        redirect_to preview_quick_answers_path
      else
        @quick_answer = QuickAnswer.new(params[:quick_answer])
        super
      end
    end

    def update
      if params[:commit] == "Preview"
        session[:article_preview] = request.parameters[:quick_answer]
        redirect_to preview_quick_answers_path
      else
        @quick_answer = QuickAnswer.find(params[:id])
        super
      end
    end
  end

  # Add to :parent Dropdown menu
  menu :parent => "Articles"
  # menu :priority => 2

  # Filterable attributes
  filter :title
  filter :tags
  filter :contact_id
  filter :status

  # View
  scope :all, :default => true do |articles|
    articles.includes [:category, :feedback]
  end

  index do
    #column :id
    column "Quick Answer Title", :title do |article|
      link_to article.title, [:admin, article]
    end
    column :category, :sortable => 'categories.name'
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
    column "Helpful?", :feedback, :sortable => 'feedbacks.yes_count'
    default_actions # Add show, edit, delete column
  end

  form :partial => "shared/admin/article_form"
end
