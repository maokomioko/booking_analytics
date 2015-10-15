module HotelRailsAdmin
  extend ActiveSupport::Concern
  included do

    rails_admin do
      navigation_label 'Hotels'
      list do
        field :id
        field :booking_id
        field :name
        field :city do
          pretty_value { "#{value} - #{bindings[:object].district}".html_safe }
        end
        field :contacts do
          pretty_value {
            bindings[:object].contacts.fancy_order_by_type
          }
        end
        field :email_newsletters do
          pretty_value {
            newsletters = bindings[:object].email_newsletters.order('created_at DESC')
            if newsletters.count > 0
              "Sent: #{newsletters.count},
              Last at: #{newsletters.first.try(:created_at)}"
            else
              "Nothing has been sent yet"
            end
          }
        end
      end
    end

  end
end
