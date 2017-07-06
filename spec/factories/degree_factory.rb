# == Schema Information
#
# Table name: degrees
#
#  id              :integer          not null, primary key
#  title           :string
#  graduation_year :integer
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  entry_year      :integer
#  school_id       :integer
#

FactoryGirl.define do
  factory :degree do
    title { Faker::Name.title }
    school
    entry_year { Faker::Number.number(4) }
    graduation_year { Faker::Number.number(4) }
    user
  end
end
