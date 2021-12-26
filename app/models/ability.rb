# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
      user ||= User.new # guest user (not logged in)
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

    can :read, [Comment, User, Profile, Follow, Tag]
    can :read, Article, status: 'published'
    can [:trending_articles, :tag_articles], Article, status: 'published'
    if user.roles.pluck(:role).include?("normal_user")
      can :manage, User, email: user.email
      can [:follow, :unfollow], User
      can :manage, Profile, user: user
      can :manage, Article, user: user
      # can [:read, :update], Article, user: user, status: 'published'
      can  :access, :rails_admin
      can :read, :dashboard
    end

    if user.roles.pluck(:role).include?("admin")
      can :manage, :all

      can :manage, :rails_admin

      can  :access, :rails_admin
    end

  end

  

end
