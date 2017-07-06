# == Schema Information
#
# Table name: languages
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :language do
    sequence(:name) { |n| "#{Faker::Lorem.word}_#{n}" }
  end
end
