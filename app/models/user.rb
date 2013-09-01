class User < ActiveRecord::Base
  belongs_to :department
  has_many :articles
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :is_admin, :is_editor, :is_writer, :department_id

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
