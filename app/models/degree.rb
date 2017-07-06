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

class Degree < ActiveRecord::Base
  belongs_to :user
  belongs_to :school
  validates :user, :title, :school, :entry_year, :graduation_year, presence: true

  attr_reader :school_name
end
