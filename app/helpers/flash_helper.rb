module FlashHelper
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

  def render_flash
    "".tap do |html|
      unless flash.empty?
        flash.each do |type, message|
          html << raw(render(
                          template: 'partials/_flash',
                          locals: { type: type, message: message.html_safe }
                      ))
        end
      end
    end.html_safe
  end
end