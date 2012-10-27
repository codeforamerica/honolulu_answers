class ApplicationController < ActionController::Base
  protect_from_forgery

  helper :all

  def authenticate_active_admin_user!
    authenticate_user!
    unless current_user
      flash[:alert] = "Unauthorized Access!"
      redirect_to root_path
    end
  end

  def stop_words
    @stop_words ||= Rails.cache.fetch('stop_words') do
      CSV.read( "lib/assets/eng_stop.csv" ).flatten
    end
  end
end
