class Administrator < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable,  and :omniauthable
  devise :database_authenticatable, :lockable, :timeoutable, :recoverable, :trackable #, :registerable, :validatable, :rememberable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation#, :remember_me
  # attr_accessible :title, :body
end
