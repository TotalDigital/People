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

class Project < ActiveRecord::Base

  validates :name, :location, :user, presence: true

  belongs_to :user

  has_many :participants, through: :project_participations, source: :user
  has_many :project_participations, dependent: :restrict_with_error

  attr_reader :search

  scope :people, -> { joins(:user).where(users: { role: [:admin, :basic] }) }
  scope :test_only, -> { joins(:user).where(users: { role: :test_only }) }

  def self.search(term)
    where("name ~* ?", term)
  end

  def short_name
    name.truncate(25)
  end

  def transfer_ownership_or_destroy
    if project_participations.present? && next_owner
      self.update(user: next_owner)
    else
      self.project_participations.destroy_all
      self.destroy
    end
  end

  private

  def next_owner
    oldest_participation = project_participations.where.not(user_id: user.id).order(created_at: :asc).first
    oldest_participation.try(:user)
  end
end
