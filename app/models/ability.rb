class Ability
  include CanCan::Ability

  def initialize(user)

    can :read, :all
    
    if user.is_moderator || user.is_editor
      can :manage, Article
      can :manage, Contact
      can :manage, Guide
      can :manage, GuideStep
      # can :manage, QuickAnswer
      # can :manage, Resource
    end

    # A manager can do the following:
    if user.is_moderator
      can :manage, Category
    end

    if user.is_admin
      can :manage, User
    end
       
  end
end
