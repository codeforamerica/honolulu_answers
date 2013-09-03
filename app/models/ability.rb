class Ability
  include CanCan::Ability

  def initialize(user)

  articles = [QuickAnswer, WebService, Guide]

    can :read, :all

    if user.is_admin
      can :manage, :all
    end

    if user.is_editor
      can :manage, articles + [Category, Contact, GuideStep]
    end

    if user.is_writer
      can :create, articles + [Category, Contact, GuideStep]
      can [:update, :destroy], articles, :status => "Draft"
      can [:update, :destroy], GuideStep, :guide =>  { status: "Draft" }
    end

  end
end
