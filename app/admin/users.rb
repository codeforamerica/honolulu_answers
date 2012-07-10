ActiveAdmin.register User do
    index do # Display only specific article db columns
      column :id
      column :email
      column :is_moderator
      column :is_admin
      column :is_editor
      default_actions # View/Edit/Delete column
    end

    # form do |f|
    #       f.input "Create User" do
    #         f.input :email
    #         f.input :admin, :as => :radio
    #       end
    #       f.buttons
    #     end
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