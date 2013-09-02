class Administrator < ActiveRecord::Base
  devise :database_authenticatable, :lockable, :timeoutable, :recoverable, :trackable
  attr_accessible :email, :password, :password_confirmation
end
