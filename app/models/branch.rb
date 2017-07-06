# == Schema Information
#
# Table name: branches
#
#  id   :integer          not null, primary key
#  name :string
#

class Branch < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  has_many :domains, dependent: :destroy
  has_many :users, dependent: :restrict_with_error
end
