# == Schema Information
#
# Table name: jobs
#
#  id          :integer          not null, primary key
#  title       :string
#  start_date  :date
#  end_date    :date
#  description :text
#  location    :string
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :job do
    title       { Faker::Name.title }
    start_date  { Faker::Date.birthday(3, 4) }
    end_date    { Faker::Date.birthday(1, 2) }
    description { Faker::Lorem.sentence(3) }
    location    { Faker::Address.city }
    user
  end
end
