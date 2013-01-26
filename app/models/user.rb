class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable, :registerable,
  belongs_to :department
  has_many :articles
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :is_admin, :is_editor, :is_writer, :department_id #:admin

  after_validation :make_roles_exclusive

  def to_s
    email
  end

  private

  def make_roles_exclusive
    if is_admin
      self.is_editor = false
      self.is_writer = false
    elsif is_editor
      self.is_writer = false
    end
  end

end
# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  is_moderator           :boolean
#  is_admin               :boolean         default(FALSE)
#  is_editor              :boolean         default(FALSE)
#  department_id

