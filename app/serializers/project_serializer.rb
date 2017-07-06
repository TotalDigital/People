# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string
#  location   :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ProjectSerializer < BaseSerializer
  attributes :id, :name, :location, :user_id
  attribute :project_participations, if: :with_project_participations?
  attributes :links

  def project_participations
    object.project_participations.map do |pp|
      ProjectParticipationSerializer.new(pp, scope: scope, root: false, with_project: false)
    end
  end

  def with_project_participations?
    instance_options[:with_project_participations].nil? ? true : instance_options[:with_project_participations]
  end

  class SearchResults < BaseSerializer
    attributes :id, :name, :location
  end
end
