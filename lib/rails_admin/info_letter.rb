module RailsAdmin
  module Config
    module Actions
      class InfoLetter < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :http_methods do
          [:get]
        end

        register_instance_option :controller do
          proc do
            @objects = list_entries(@model_config, :destroy)
            booking_ids = @objects.map(&:booking_id)

            InfoLettersWorker.perform_async(booking_ids)
            redirect_to back_or_index
          end
        end

        register_instance_option :bulkable? do
          true
        end

        register_instance_option :link_icon do
          'icon-envelope'
        end
      end
    end
  end
end
