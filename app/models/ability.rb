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
      end
    end
  end

  private

  def manager_abilities
    # can [:index, :show], Action
    can :wizard_setup, Object
    can :manage, Company, owner_id: user.id
    can :manage, ChannelManager, company_id: user.company_id

    cannot :update_booking_id, ChannelManager, company_id: user.company_id

    can [:index, :update], Hotel, id: user.channel_manager.try(:hotel).try(:id)

    can :update, Room, booking_hotel_id: user.company.try(:hotel).try(:booking_id)
    can :update_connector_credentials, Room

    can :manage, RoomSetting, setting_id: user.company.try(:setting).try(:id)
    can :manage, Setting do |setting|
      user.channel_manager.hotel.id == setting.hotel.id &&
        setting.company.owner_id == user.id
    end
    can :update, Hotel, id: user.hotels.pluck(:id)
    can :invite, User
    can [:index, :destroy], User, User.related_to(user) do |other|
      other.id != user.id && (other.company_id == user.company_id ||
        other.invited_by_id == user.id)
    end
  end

  attr_reader :user
end
