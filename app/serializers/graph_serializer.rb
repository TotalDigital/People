class GraphSerializer < BaseSerializer

  attributes :id, :first_name, :last_name, :picture_url, :children, :links

  def first_name
    object.first_name
  end

  def last_name
    object.last_name
  end

  def picture_url
    object.profile_picture.url(:medium)
  end

  def children
    object.relationships.send(with_scope).map do |r|
      ChildrenSerializer.new(r, scope: scope, root: false)
    end
  end

  def links
    link(:self, full_url(api_v1_users_graph_path(user_id: object.id))).merge(
        link(:user, full_url(api_v1_users_path(user_id: object.id)))
    )
  end

  def with_scope
    instance_options[:with_scope].nil? ? 'people' : instance_options[:with_scope]
  end

  class ChildrenSerializer < BaseSerializer
    attributes :id, :first_name, :last_name, :kind, :picture_url, :links

    def id
      object.target_id
    end

    def first_name
      object.target.first_name
    end

    def last_name
      object.target.last_name
    end

    def picture_url
      object.target.profile_picture.url(:medium)
    end

    def links
      link(:self, full_url(api_v1_users_graph_path(user_id: object.target_id)))
    end

  end
end