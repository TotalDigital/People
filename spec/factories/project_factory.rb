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

FactoryGirl.define do
  factory :project do
    sequence(:name) { |n| "#{Faker::Lorem.word}_#{n}" }
    location { Faker::Address.city }
    user
  end
end
