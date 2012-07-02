class Ability
  include CanCan::Ability

  def initialize(user)
    #can :read, [Article,Contact]#:all
    
    if user# && user.is_moderator
      can :access, :rails_admin   # grant access to rails_admin
      can :dashboard
      
      if user.is_admin
        can :manage, [User]
      end 

      if user.is_editor
        can :manage, [Article, Contact]
      end
    end
  end
end