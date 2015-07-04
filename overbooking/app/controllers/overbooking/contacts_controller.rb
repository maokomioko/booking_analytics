module Overbooking
  class ContactsController < ApplicationController
    before_filter :find_hotel
    before_filter :find_contact, only: [:edit, :update, :destroy]

    layout 'modal'

    def index
      @contacts = @hotel.contacts
    end

    def new
      @contact = @hotel.contacts.build
    end

    def create
      @contact = @hotel.contacts.build(contact_params)

      unless @contact.save
        flash[:error] = @contact.errors.full_messages.to_sentence
      end
    end

    def edit
    end

    def update
      # STI fix
      @contact = @contact.becomes!(contact_params[:type].constantize)

      unless @contact.update_attributes(contact_params)
        flash[:error] = @contact.errors.full_messages.to_sentence
      end
    end

    def destroy
      unless @contact.destroy
        flash[:error] = @contact.errors.full_messages.to_sentence
      end
    end

    protected

    def find_hotel
      @hotel = Overbooking::Hotel.find_by_booking_id(params[:hotel_id])
    end

    def find_contact
      @contact = @hotel.contacts.find(params[:id])
    end

    def contact_params
      attrs = %i(value description contact_type custom_type optional preferred)
      params.require(:contact).permit(*attrs).tap do |whitelisted|
        whitelisted[:type] = Overbooking::Contact.define_type(params[:contact][:contact_type])
      end
    end
  end
end