# == Schema Information
#
# Table name: users_skills
#
#  id       :integer          not null, primary key
#  user_id  :integer
#  skill_id :integer
#

class UsersSkill < ActiveRecord::Base
  belongs_to :user
  belongs_to :skill
  validates :skill, :user, presence: true
  validates_uniqueness_of :skill, scope: :user
end
