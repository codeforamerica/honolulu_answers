class Question < ActiveRecord::Base
  attr_accessible :context, :email, :location, :name, :question, :question_status, :urgency

  validates_presence_of :question, :email

end
