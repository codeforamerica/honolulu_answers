class Contact < ActiveRecord::Base
  default_scope order('name ASC')

  has_many :articles


end
# == Schema Information
#
# Table name: contacts
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  subname     :string(255)
#  number      :string(255)
#  url         :string(255)
#  address     :string(255)
#  department  :string(255)
#  description :text
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

