class Question < ActiveRecord::Base
  attr_accessible :answer, :context, :email, :location, :name, :question, :status, :urgency, :title

  validates_presence_of :question, :email

  def after_initialize
    if new_record?
      status ||= 'new'
    end
  end

end
