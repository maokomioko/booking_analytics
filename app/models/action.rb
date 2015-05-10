# == Schema Information
#
# Table name: impressions
#
#  id                  :integer          not null, primary key
#  impressionable_type :string
#  impressionable_id   :integer
#  user_id             :integer
#  controller_name     :string
#  action_name         :string
#  view_name           :string
#  request_hash        :string
#  ip_address          :string
#  session_hash        :string
#  message             :text
#  referrer            :text
#  created_at          :datetime
#  updated_at          :datetime
#
# Indexes
#
#  controlleraction_ip_index          (controller_name,action_name,ip_address)
#  controlleraction_request_index     (controller_name,action_name,request_hash)
#  controlleraction_session_index     (controller_name,action_name,session_hash)
#  impressionable_type_message_index  (impressionable_type,message,impressionable_id)
#  index_impressions_on_user_id       (user_id)
#  poly_ip_index                      (impressionable_type,impressionable_id,ip_address)
#  poly_request_index                 (impressionable_type,impressionable_id,request_hash)
#  poly_session_index                 (impressionable_type,impressionable_id,session_hash)
#

class Action < Impression
  belongs_to :user

  def render(context, params = {})
    params[:i18n] and return context.render :text => self.text(params)

    partial = partial_path(*params.values_at(:partial, :partial_root))
    layout  = layout_path(*params.values_at(:layout, :layout_root))
    locals  = prepare_locals(params)

    begin
      context.render params.merge(partial: partial, layout: layout, locals: locals)
    rescue ActionView::MissingTemplate => e
      if params[:fallback] == :text
        context.render :text => self.text(params)
      elsif params[:fallback].present?
        partial = partial_path(*params.values_at(:fallback, :partial_root))
        context.render params.merge(partial: partial, layout: layout, locals: locals)
      else
        partial = partial_path('default')
        context.render params.merge(partial: partial, layout: layout, locals: locals)
      end
    end
  end

  def partial_path(path = nil, root = nil)
    root ||= 'impressions'
    path ||= [self.controller_name, self.action_name].join('/')
    select_path path, root
  end

  def layout_path(path = nil, root = nil)
    path.nil? and return
    root ||= 'layouts'
    select_path path, root
  end

  def prepare_locals(params)
    locals = params.delete(:locals) || Hash.new

    prepared_parameters = prepare_parameters(params)
    locals.merge\
        impression:   self,
        parameters:   prepared_parameters
  end

  def prepare_parameters(params)
    @prepared_params ||= (JSON.parse(self.message).with_indifferent_access rescue {}).merge(params)
  end

  private

  def select_path path, root
    [root, path].map(&:to_s).join('/')
  end
end
