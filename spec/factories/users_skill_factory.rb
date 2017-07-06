# == Schema Information
#
# Table name: users_skills
#
#  id       :integer          not null, primary key
#  user_id  :integer
#  skill_id :integer
#

FactoryGirl.define do
  factory :users_skill do
    user
    skill
  end
end
