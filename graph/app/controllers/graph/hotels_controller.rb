module Graph
  class HotelsController < Graph.parent_controller.constantize
    def index
    end

    def simple
      @data = generate_dummy
    end

    def competitors
      @data = generate_dummy
    end

    def cherry_pick
      @data = generate_dummy
    end

    private

    def generate_dummy
      range      = params[:range].present? ? params[:range].to_i : 7
      future     = params[:future].present? && params[:future].to_i == 1
      graph_type = action_name

      dates = if future
                Date.today...(Date.today + range.days)
              else
                (Date.today - range.days)...Date.today
              end

      data = []

      dates.each do |day|
        data << { day: day.strftime('%d.%m.%Y'), price: rand(80..120) }
      end

      data
    end
  end
end
