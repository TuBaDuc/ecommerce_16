class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new
    if user.admin?
      can :manage, :all
    elsif user.user?
      can :read, [User, Category, Product, Order, Suggest]
      can :create, [Order, OrderDetail, Suggest]
      can :edit, User do |check_user|
        check_user == user
      end
    else
      can :read, [User, Category, Product]
      can :read, [User, Category, Product, Order, OrderDetail, Suggest]
      can :create, User
    end
  end
end
