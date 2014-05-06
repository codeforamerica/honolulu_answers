ActiveAdmin.setup do |config|

  config.site_title = "Rehnuma CMS"

  config.site_title_link = "/admin"

  config.authentication_method  = :authenticate_active_admin_user!
  config.current_user_method    = :current_user
  config.logout_link_path       = :destroy_user_session_path
  config.logout_link_method     = :delete

  config.authorization_adapter = ActiveAdmin::CanCanAdapter

end
