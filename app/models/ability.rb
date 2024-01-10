
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new 

    if user.admin? 
      can :manage, :all
    elsif user.expert?
      can :manage, Course
      can :manage, Expert
    elsif user.user?
      can :manage, User
      can :read, Course
      can :read, Expert
    end
  end
end

