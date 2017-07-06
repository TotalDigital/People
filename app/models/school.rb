# == Schema Information
#
# Table name: schools
#
#  id   :integer          not null, primary key
#  name :string
#

class School < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  has_many :degrees, dependent: :restrict_with_error
  has_many :users, through: :degrees

  def self.search(term)
    where('LOWER(name) LIKE :term', term: "%#{term.downcase}%")
  end
end
