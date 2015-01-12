module ApplicationHelper
  def body_data_page
    path = controller.controller_path.split('/')
    namespace = path.first if path.second

    [namespace, controller.controller_name, controller.action_name].compact.join(":")
  end

  def active_class(url)
    request.fullpath.include?(url) ? 'active' : ''
  end
end
