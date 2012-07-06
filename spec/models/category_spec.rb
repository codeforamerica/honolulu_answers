require 'spec_helper'

describe Category do
  it { should have_many :articles }
  
  it { should respond_to :name }
  it { should respond_to :access_count }


end
# == Schema Information
#
# Table name: categories
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  access_count :integer
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  article_id   :integer
#

