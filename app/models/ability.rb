class Ability
  include CanCan::Ability

  def initialize(user)

    can :read, :all
    
    if user.is_editor || user.is_writer
      can :manage, Article
      can :manage, Contact
      can :manage, Guide
      can :manage, GuideStep
      # can :manage, QuickAnswer
      # can :manage, WebService
    end

    # A manager can do the following:
    if user.is_editor
      can :manage, Category
    end

    if user.is_admin
      can :manage, User
    end
       
  end
end