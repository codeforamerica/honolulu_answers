class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all
    if user && user.admin
      can :access, :rails_admin   # grant access to rails_admin
      can :dashboard
      can :manage, :all
    end
  end
  
end
