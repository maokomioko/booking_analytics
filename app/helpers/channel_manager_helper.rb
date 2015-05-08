module ChannelManagerHelper
  def options_for_cm_types(default = nil)
    default ||= ChannelManager::TYPES.first
    options = ChannelManager::TYPES.map do |type|
      [I18n.t("enum.channel_manager_type.#{ type }"), type]
    end

    options_for_select(options, default)
  end
end