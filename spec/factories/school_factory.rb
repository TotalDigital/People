# == Schema Information
#
# Table name: schools
#
#  id   :integer          not null, primary key
#  name :string
#

FactoryGirl.define do
  factory :school do
    sequence(:name) { |n| "#{Faker::University.name}_#{n}" }
  end
end
