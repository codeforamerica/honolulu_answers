#
#
# NOTE: As a last minute hack, the following fields are being reused instead of recreated.
#
# subname => emailaddress
# department => address2
#
# The field labels have been changed in app/admin/contacts.rb
#
# -Andy
#
class Contact < ActiveRecord::Base
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

