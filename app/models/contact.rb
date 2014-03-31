class Contact < ActiveRecord::Base
  default_scope order('name ASC')

  has_many :articles

end
