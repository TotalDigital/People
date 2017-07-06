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

class Job < ActiveRecord::Base
  include Datable

	validates :title, :start_date, :location, :description, :user_id, presence: true

	belongs_to :user
end
