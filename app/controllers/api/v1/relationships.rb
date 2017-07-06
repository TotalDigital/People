module API
  module V1
    class Relationships < Grape::API
      include API::V1::Defaults
      include Grape::Kaminari

      namespace :relationships do

        desc "List all relationships"
        oauth2
        paginate per_page: @per_page, max_per_page: @max_per_page, offset: false
        get do
          paginate policy_scope(Relationship)
        end

        desc "Get a relationship"
        oauth2
        params do
          requires :relationship_id, type: String, desc: "ID of the relationship"
        end
        get ":relationship_id" do
          policy_scope(Relationship).find(permitted_params[:relationship_id])
        end

        desc "Create a new relationship"
        oauth2
        params do
          requires :relationship, type: Hash do
            requires :user_id, type: String, desc: "ID of user"
            requires :target_id, type: String, desc: "ID of target user"
            requires :kind, type: String, desc: "Kind of relationship (#{Relationship.kinds.keys.join(", ")})"
          end
        end
        post do
          relationship = Relationship.new(permitted_params[:relationship])
          create_resource(relationship)
        end

        desc "Delete a relationship"
        oauth2
        params do
          requires :relationship_id, type: String, desc: "ID of the relationship"
        end
        delete ":relationship_id" do
          relationship = Relationship.find(permitted_params[:relationship_id])
          delete_resource(relationship)
        end
      end
    end
  end
end
