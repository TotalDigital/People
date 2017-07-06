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

class ProjectParticipation < ActiveRecord::Base
  include Datable

  belongs_to :user
  belongs_to :project
  delegate :name, :location, to: :project

  validates :start_date, :user, :project, presence: true

  scope :people, -> { joins(:user).where(users: { role: [:admin, :basic] }) }
  scope :test_only, -> { joins(:user).where(users: { role: :test_only }) }

  def participants
    project.participants
  end

  attr_reader :project_name, :project_location
end
