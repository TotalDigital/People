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

class DegreeSerializer < BaseSerializer
  attributes :id, :title, :entry_year, :graduation_year, :user_id, :school, :links

  def school
    SchoolSerializer.new(object.school, scope: scope, root: false)
  end
end
