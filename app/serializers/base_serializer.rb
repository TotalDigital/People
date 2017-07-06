class BaseSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  include GrapeRouteHelpers::NamedRouteMatcher
  include ApplicationHelper

  def links
    resource_name = object.class.name.underscore
    hash_params   = { "#{resource_name}_id": object.id }
    route         = send("api_v1_#{resource_name.pluralize}_path", hash_params)
    link(:self, full_url(route))
  end

  private

  def link(target, href)
    { "#{target}": { href: href } }
  end

end