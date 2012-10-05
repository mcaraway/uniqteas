Spree::Ability.class_eval do
  def initialize(user)
    self.clear_aliased_actions

    # override cancan default aliasing (we don't want to differentiate between read and index)
    alias_action :edit, :to => :update
    alias_action :new, :to => :create
    alias_action :new_action, :to => :create
    alias_action :show, :to => :read

    user ||= Spree.user_class.new
    if user.respond_to?(:has_spree_role?) && user.has_spree_role?('admin')
      can :manage, :all
    else
    #############################
      can :manage, Spree::Image
      #############################
      can :read, Spree::Order do |order, token|
        order.user == user || order.token && token == order.token
      end
      can :update, Spree::Order do |order, token|
        order.user == user || order.token && token == order.token
      end
      can :create, Spree::Order
      #############################
      can :read, Spree::Product
      can :index, Spree::Product
      #############################
      can :read, Spree::Taxon
      can :index, Spree::Taxon
     #############################
      can :read, Spree::User do |resource|
        resource == user
      end
      can :update, Spree::User do |resource|
        resource == user
      end
      can :create, Spree::User
    #############################
    end
  end
end