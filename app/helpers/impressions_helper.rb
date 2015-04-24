module ImpressionsHelper
  def render_impression impressions, options = {}
    if impressions.is_a? Action
      impressions.render self, options
    elsif impressions.respond_to?(:map)
      return nil if impressions.empty?
      impressions.map {|impression| impression.render self, options.dup }.join.html_safe
    end
  end
  alias_method :render_impressions, :render_impression
end