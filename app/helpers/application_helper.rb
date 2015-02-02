module ApplicationHelper
  def body_data_page
    path = controller.controller_path.split('/')
    namespace = path.first if path.second

    [namespace, controller.controller_name, controller.action_name].compact.join(":")
  end

  def active_class(url)
    request.fullpath.include?(url) ? 'active' : ''
  end

  def header_title
    if controller_name == 'channel_manager'
      if action_name == 'new'
        t('auth.new.connect_via', provider: 'WuBook')
      elsif action_name == 'edit'
        t('auth.edit.edit_connection', provider: 'WuBook')
      end
    else
      if current_user && current_user.wubook_auth.size > 0
        current_user.wubook_auth.first.hotel_name
      end
    end
  end
end
