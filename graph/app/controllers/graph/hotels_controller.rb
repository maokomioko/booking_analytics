module Graph
  class HotelsController < Graph.parent_controller.constantize
    helper Graph::FormHelper

    #respond_to :js, except: :index

    def index
      hotel = current_user.hotels.first

      unless hotel.present?
        flash[:alert] = I18n.t('graph.messages.no_hotels')
        redirect_to main_app.root_path
      end

      @form = Graph::Form.new(
        booking_id: hotel.booking_id,
        room_id: hotel.rooms.limit(4).pluck(:id)
      )
    end

    def simple
      room_ids = Graph.room.where(id: graph_params[:room_id])
                  .where(booking_hotel_id: graph_params[:booking_id])
                  .pluck(:id)

      period = graph_params[:date_from].to_date..graph_params[:date_to].to_date
      @data = Data::Room.new(room_ids, period)

      puts "RESULTS - #{@data.merged}"
    end

    def competitors
      @data = generate_dummy
    end

    def cherry_pick
      @data = generate_dummy
    end

    private

    def generate_dummy
      dates = graph_params[:date_from].to_date..graph_params[:date_to].to_date

      dates.map{ |day| { day: day.strftime('%d.%m.%Y'), price: rand(80..120) } }
    end

    def graph_params
      # HACK for select2 empty value
      %i(room_id).each do |field|
        if params[:form][field].present?
          params[:form][field].select!(&:present?)
        end
      end

      params.require(:form).permit(:date_from, :date_to, :booking_id,
                                     room_id: [], related_booking_id: [])
    end
  end
end
