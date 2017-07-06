# == Schema Information
#
# Table name: schools
#
#  id   :integer          not null, primary key
#  name :string
#

class SchoolSerializer < BaseSerializer
  attributes :id, :name, :links
end
