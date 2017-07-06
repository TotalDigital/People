# == Schema Information
#
# Table name: users_languages
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  language_id :integer
#

class UsersLanguage < ActiveRecord::Base
	belongs_to :user
	belongs_to :language
  validates :language, :user, presence: true
  validates_uniqueness_of :language_id, scope: :user_id
end
