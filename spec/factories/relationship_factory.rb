# == Schema Information
#
# Table name: relationships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  target_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  state      :string
#  kind       :string
#

FactoryGirl.define do
  factory :relationship do
    user
    target { create(:user) }
    kind { ["is_manager_of", "is_managed_by", "is_assistant_of", "is_assisted_by", "is_colleague_of"].sample }
    state { "current" }
  end

  factory :relationship_test_users, parent: :relationship do
    user { create(:user_test_role) }
    target { create(:user_test_role) }
  end
end