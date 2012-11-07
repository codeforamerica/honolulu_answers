ActiveAdmin.register User do

  menu :if => proc{ current_user.is_admin? }, :label => 'Users'

  # This will authorize the Foobar class
  # The authorization is done using the AdminAbility class
  controller.authorize_resource

    index do # Display only specific article db columns
      column :id
      column :email
      column :is_admin
      column :is_editor
      column :is_writer
      default_actions # View/Edit/Delete column
    end

    form do |f|   # create/edit user form
      f.inputs "User Details" do
        f.input :email
        f.input :password
        f.input :password_confirmation
        f.input :department
      end
      f.inputs "Type of User" do
        f.input :is_admin,      :label => "Administrator"
        f.input :is_editor,  :label => "Editor"
        f.input :is_writer,     :label => "Writer"
      end
      f.buttons
    end

    # Create/edit any user
    create_or_edit = Proc.new {
      @user            = User.find_or_create_by_id(params[:id])
      @user.is_admin = params[:user][:is_admin]
      @user.attributes = params[:user].delete_if do |k, v|
        (k == "is_admin") ||
        (["password", "password_confirmation"].include?(k) && v.empty? && !@user.new_record?)
      end
      if @user.save
        redirect_to :action => :show, :id => @user.id
      else
        render active_admin_template((@user.new_record? ? 'new' : 'edit') + '.html.arb')
      end
    }
    member_action :create, :method => :post, &create_or_edit
    member_action :update, :method => :put, &create_or_edit


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
#  admin                  :boolean
#