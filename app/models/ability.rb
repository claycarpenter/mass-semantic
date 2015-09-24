class Ability
  include CanCan::Ability

  def initialize(user)
    # Ensure a user instance is always present, even for guest users
    user ||= User.new

    # Users can only update their own profile.
    can :update, User, :id => user.id

    # Only author can edit or delete their own comment.
    can [:edit, :update, :destroy, :delete], Comment, :user_id => user.id

    # Only real user/non-guest can author a new comment.
    can :create, Comment if user.persisted?

    # Allow show, index on comments for everyone.
    can [:show, :index], Comment

    # Allow show, index on snippets for everyone.
    can [:show, :index], Snippet
    # Only real user/non-guest can author a new snippet or update/edit
    # an existing snippet.
    can [:new, :create, :edit, :update], Snippet if user.persisted?

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
