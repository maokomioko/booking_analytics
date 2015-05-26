module Overbooking
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
      can [:index, :update], Overbooking::Hotel, id: user.hotels.pluck(:id)
    end

    attr_reader :user
  end
end
