# == Schema Information
#
# Table name: users
#
#  id                           :integer          not null, primary key
#  email                        :string           default(""), not null
#  encrypted_password           :string           default(""), not null
#  reset_password_token         :string
#  reset_password_sent_at       :datetime
#  remember_created_at          :datetime
#  sign_in_count                :integer          default(0), not null
#  current_sign_in_at           :datetime
#  last_sign_in_at              :datetime
#  current_sign_in_ip           :string
#  last_sign_in_ip              :string
#  created_at                   :datetime
#  updated_at                   :datetime
#  profile_picture_file_name    :string
#  profile_picture_content_type :string
#  profile_picture_file_size    :integer
#  profile_picture_updated_at   :datetime
#  job_title                    :string
#  phone                        :string
#  office_address               :string
#  wat_link                     :string
#  entity                       :string
#  linkedin                     :string
#  twitter                      :string
#  linkedin_uid                 :string
#  linkedin_token               :string
#  linkedin_token_expires_at    :datetime
#  role                         :string           default("basic")
#  first_name                   :string
#  last_name                    :string
#  external                     :boolean
#  internal_id                  :string
#  confirmation_token           :string
#  confirmed_at                 :datetime
#  confirmation_sent_at         :datetime
#  unconfirmed_email            :string
#  branch_id                    :integer
#  imported                     :boolean          default(FALSE)
#  slug                         :string
#  conditions_of_use            :boolean
#  language                     :string           default("en")
#

include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :user do
    created_at        Time.current
    sequence(:email)  { |n| "#{n}#{Faker::Internet.email}" }
    password          'password'
    first_name        { Faker::Name.first_name }
    last_name         { Faker::Name.last_name }
    internal_id       { ["L", "J"].sample + rand(1000000..9999999).to_s }
    job_title         { 'Project Manager' }
    branch

    after(:build) do |user|
      user.skip_confirmation!
    end
  end

  factory :user_with_profile_picture, parent: :user do
    profile_picture { fixture_file_upload(Rails.root.join('spec', 'support', 'paperclip', 'avatar.png'), 'image/png') }
  end

  factory :user_test_role, parent: :user do
    role 'test_only'
  end
end
