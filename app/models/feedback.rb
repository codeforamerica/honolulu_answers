class Feedback < ActiveRecord::Base
  after_initialize :init

  attr_accessible :no_count, :yes_count
  
  belongs_to :article

  def yes_feedback
    self.yes_count += 1
  end

  def no_feedback
    self.no_count += 1
  end

  def to_s
    self.yes_count.to_s + "/" + (self.no_count + self.yes_count).to_s
  end

  private
    def init
      self.yes_count ||= 0
      self.no_count ||= 0
    end
end
