class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user

    if user
      case user.role
      when 'admin'
        can :manage, :all
      when 'manager'
        manager_abilities
      when 'client'
        client_abilities
      end
    end
  end

  private

  def client_abilities
  end

  def manager_abilities
    can :manage, Company, owner_id: user.id
    can :manage, ChannelManager, company_id: user.company_id
    can :index, Hotel, id: user.hotels.pluck(:id)
    can :update, Room, hotel_id: user.hotels.pluck(:id)
    can :manage, Setting do |setting|
      user.hotels.pluck(:id).include?(setting.hotel_id) &&
        user.company.owner_id == user.id
    end
    can :invite, User
    can [:index, :destroy], User, User.related_to(user) do |other|
      other.id != user.id && (other.company_id == user.company_id ||
        other.invited_by_id == user.id)
    end
  end

  attr_reader :user
end
