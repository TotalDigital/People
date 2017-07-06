# == Schema Information
#
# Table name: skills
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Skill < ActiveRecord::Base

	validates :name, presence: true, uniqueness: true

	has_many :users_skills, dependent: :destroy
	has_many :users, -> { distinct }, through: :users_skills

	auto_strip_attributes :name, squish: true

	def self.search(term)
		where('LOWER(name) LIKE :term', term: "%#{term.downcase}%")
	end
end
