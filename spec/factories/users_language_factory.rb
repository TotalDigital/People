# == Schema Information
#
# Table name: users_languages
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  language_id :integer
#


FactoryGirl.define do
  factory :users_language do
    user
    language
  end
end
