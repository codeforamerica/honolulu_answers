class Question < ActiveRecord::Base
  attr_accessible :answer, :context, :email, :location, :name, :question, :status, :urgency, :title

end
