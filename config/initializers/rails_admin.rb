RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == Cancan ==
  config.authorize_with :cancan
  config.compact_show_view = true

  require Rails.root.join('lib', 'rails_admin', 'info_letter.rb')

  config.main_app_name = ["HotelCommander", "Administration"]

  config.included_models = ["Hotel", "Room", "RoomPrice", "BlockAvailability", "Contact", "User"]

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    bulk_delete do
      except ["Hotel", "Room"]
    end
    show
    edit
    delete do
      except ["Hotel", "Room"]
    end
    info_letter do
      only ["Hotel"]
    end
  end
end
