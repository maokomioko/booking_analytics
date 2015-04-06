module ApplicationHelper
  # engine routes helper
  def method_missing(method, *args, &block)
    if method.to_s.end_with?('_path') || method.to_s.end_with?('_url')
      if main_app.respond_to?(method)
        main_app.send(method, *args)
      else
        super
      end
    else
      super
    end
  end

  def respond_to?(method)
    if method.to_s.end_with?('_path') || method.to_s.end_with?('_url')
      if main_app.respond_to?(method)
        true
      else
        super
      end
    else
      super
    end
  end
  # END engine routes helper

  def flash_class(key)
    case key.to_s
      when *%w(alert error) then 'alert-danger'
      when 'notice' then 'alert-info'
      when 'success' then 'alert-success'
      when 'warning' then 'alert-warning'
      else 'alert-info'
    end
  end

  def flash_icon(key)
    case key.to_s
      when *%w(alert error) then icon('times-circle')
      when 'notice' then icon('info-circle')
      when 'success' then icon('check-circle')
      when 'warning' then icon('exclamation-triangle')
      else icon('info-circle')
    end
  end

  def body_data_page
    path = controller.controller_path.split('/')
    namespace = path.first if path.second

    [namespace, controller.controller_name, controller.action_name].compact.join(':')
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

  def humanize(secs)
    [[60, :seconds], [60, :minutes], [24, :hours], [1000, :days]].map do |count, name|
      if secs > 0
        secs, n = secs.divmod(count)
        if n > 0
          "#{n.to_i} #{ I18n.t("datetime.prompts.#{name}", default: name).downcase }"
        end
      end
    end.compact.reverse.join(' ')
  end
end
