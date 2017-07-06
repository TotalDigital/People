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

class JobSerializer < BaseSerializer
  attributes :id, :title, :start_date, :end_date, :description, :location, :user_id, :links
end
