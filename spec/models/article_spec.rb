require 'spec_helper'

describe Article do
  it { should belong_to :contact}

  it { should respond_to :title }
  it { should respond_to :content }
  it { should respond_to :category }
  it { should respond_to :preview }
  it { should respond_to :tags }

  let(:article) { FactoryGirl.create(:article) }
  subject { article }
  it { should be_valid }


  





end

# == Schema Information
#
# Table name: articles
#
#  id           :integer         not null, primary key
#  updated      :datetime
#  title        :string(255)
#  content      :text
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  category     :string(255)
#  content_type :integer
#  preview      :text
#  contact_id   :integer
#  tags         :text
#  service_url  :string(255)
#

