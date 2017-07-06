# == Schema Information
#
# Table name: branches
#
#  id   :integer          not null, primary key
#  name :string
#

FactoryGirl.define do
  factory :branch do
    sequence(:name) { |n| "#{Faker::Company.name}_#{n}" }
  end
end
