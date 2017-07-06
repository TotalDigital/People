module ApplicationHelper

  def error_message(error_msg, alert_class, detailed_errors = [])
    html = <<-HTML
      <div class="alert alert--fullScreen alert-dismissable #{alert_class}" role="alert">
        <button type="button" class="close" data-dismiss="alert">
          <span aria-hidden="true">&times;</span><span class="sr-only">#{t'helpers.application.close'}</span>
        </button>
        <span class="error-message">#{error_msg}</span>
        #{to_list(detailed_errors)}
      </div>
    HTML

    html.html_safe
  end

  def to_list(errors)
    unless errors.blank?
      html_errors = errors.map { |error| content_tag(:li, error) }.join.html_safe
      content_tag :ul, html_errors
    end
  end

  def full_url(path)
    protocol = ::Rails.application.routes.default_url_options[:protocol]
    host     = ::Rails.application.routes.default_url_options[:host]
    port     = ::Rails.application.routes.default_url_options[:port]
    (protocol.present? ? "#{protocol}://" : '') + host + (port.present? ? ":#{port}" : '') + path
  end

  def app_title
    "#{People.app_name} - #{People.app_owner}"
  end
end
