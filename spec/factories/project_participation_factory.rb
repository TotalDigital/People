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

FactoryGirl.define do
  factory :project_participation do
    start_date        { Faker::Date.birthday(3, 4) }
    end_date          { Faker::Date.birthday(1, 2) }
    role_description  { Faker::Lorem.sentence(3) }
    user
    project
  end
end
