class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all
    
    if user# && user.is_moderator
      can :access, :rails_admin   # grant access to rails_admin
      can :dashboard
      can :manage, [Article, Contact] #:all
    end

  end
  
  # def initialize(administrator)
  #   can :read, :all
  #   if administrator
  #     can :access, :rails_admin   # grant access to rails_admin
  #     can :dashboard
  #     can :manage, :all
  #   end
  # end
end
