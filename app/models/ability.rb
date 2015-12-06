class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      if user.has_role? "admin"
        can :manage, :all
      elsif user
        can :write, :posts
        can :manage, Post do |post|
          post.user_id == user.id
        end
      end
    end
    can :read, :posts
  end
end
