class Ability
  include CanCan::Ability

  def initialize(user)

    @articles = [QuickAnswer, WebService, Guide]

    if !user # guest
      can :read, :all, :status => "Published"
    else
      can :read, :all

      if user.is_admin
        can :manage, :all
      end

      if user.is_editor
        can :manage, @articles + [Category, Contact, GuideStep]
      end

      if user.is_writer
        can :create, @articles + [Category, Contact, GuideStep]
        can [:update, :destroy], @articles, status: "Draft", user_id: user.id
        can [:update, :destroy], GuideStep, guide: { user_id: user.id, status: "Draft" }
      end
    end

  end
end
