# == Schema Information
#
# Table name: domains
#
#  id        :integer          not null, primary key
#  name      :string
#  branch_id :integer
#

FactoryGirl.define do
  factory :domain do
    sequence(:name) { |n| "#{Faker::Internet.domain_word}_#{n}" }
    branch
  end
end
