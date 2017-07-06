# == Schema Information
#
# Table name: skills
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :skill do
    sequence(:name) { |n| "#{Faker::Lorem.word}_#{n}" }
  end
end
