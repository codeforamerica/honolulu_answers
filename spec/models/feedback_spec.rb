require 'spec_helper'

describe Feedback do
  context "#after_init" do
    it "set the yes and no counts to default" do
      feedback = Feedback.new
      feedback.yes_count.should == 0
      feedback.no_count.should == 0
    end
  end

  context "#reaction_to_feedback" do
    let(:feedback) { Feedback.new }

    it "reacts to yes feedback" do
      feedback.yes_feedback
      feedback.yes_count.should == 1
    end

    it "reacts to no feedback" do
      feedback.no_feedback
      feedback.no_count.should == 1
    end
  end
end
