require 'spec_helper'

describe Article do
  it { should belong_to :contact}
  it { should belong_to :category}
  it { should have_many(:keywords).through :wordcounts }
  it { should have_many :wordcounts }

  it { should respond_to :title }
  it { should respond_to :category }
  it { should respond_to :preview }
  it { should respond_to :tags }
  it { should respond_to :access_count }

  it { should respond_to :content_main }
  it { should respond_to :content_main_extra }
  it { should respond_to :content_need_to_know }

  let(:article) { FactoryGirl.create(:quick_answer) }
  subject { article }
  it { should be_valid }
  its(:access_count) { should_not be_nil }

end

