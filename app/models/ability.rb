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
    can :manage, Setting do |setting|
      setting.company_id == user.company_id && user.company.owner_id == user.id
    end
  end

  def user
    @user
  end
end
