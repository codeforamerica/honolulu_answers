class Ability
  include CanCan::Ability

  def initialize(user)
    articles = [QuickAnswer, WebService, Guide, Article]
    if !user # guest
      can :read, :all, :published => true
    else
      can :read, :all

      if user.is_admin
        can :manage, :all
      end

      if user.is_editor
        can :manage, articles + [Category, Contact, GuideStep]
      end

      if user.is_writer
        can :create, articles + [Category, Contact, GuideStep]
        can [:update, :destroy], articles, :published => false, :pending_review => false
        can [:update, :destroy], GuideStep,
          :guide =>  { :published => false, :pending_review => false }
      end
    end
  end
end
