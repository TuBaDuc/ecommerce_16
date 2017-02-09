class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new
    if user.admin?
      can :manage, :all
    elsif user.user?
      can :read, [User, Category]
      can :edit, User do |check_user|
        check_user == user
      end
    else
      can :read, [User, Category]
      can :create, User
    end
  end
end
