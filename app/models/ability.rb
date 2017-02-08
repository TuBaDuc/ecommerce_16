class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new
    case user.role
    when :admin
      can :manage, :all
    when :user
      can :read, User
      can :edit, User do |check_user|
        check_user == user
      end
    else
      can :read, User
      can :create, User
    end
  end
end
