# == Schema Information
#
# Table name: project_participations
#
#  id               :integer          not null, primary key
#  start_date       :date
#  end_date         :date
#  user_id          :integer
#  project_id       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  role_description :text
#

class ProjectParticipationSerializer < BaseSerializer
  attributes :id, :start_date, :end_date, :role_description, :user_id, :user_first_name, :user_last_name, :user_picture_url,
             :user_job_title, :project_owner
  attribute :project, if: :with_project?
  attributes :links

  def project
    ProjectSerializer.new(object.project, scope: scope, root: false, with_project_participations: false)
  end

  def with_project?
    instance_options[:with_project].nil? ? true : instance_options[:with_project]
  end

  def user_first_name
    object.user.first_name
  end

  def user_last_name
    object.user.last_name
  end

  def user_picture_url
    object.user.profile_picture.url(:medium)
  end

  def user_job_title
    object.user.job_title
  end

  def project_owner
    object.user_id == object.project.user_id
  end
end
