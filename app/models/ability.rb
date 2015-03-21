class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user

    if user
      case user.role
      when 'admin'
        can :manage, :all
      when 'client'
        client_abilities
      end
    end
  end

  private

  def client_abilities
  end

  def user
    @user
  end
end
