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

class RelationshipSerializer < BaseSerializer
  attributes :id, :kind, :source, :target, :links

  def source
    {
        id:          object.user_id,
        first_name:  object.user.first_name,
        last_name:   object.user.last_name,
        picture_url: object.user.profile_picture.url(:medium),
        job_title:   object.user.job_title
    }
  end

  def target
    {
        id:          object.target_id,
        first_name:  object.target.first_name,
        last_name:   object.target.last_name,
        picture_url: object.target.profile_picture.url(:medium),
        job_title:   object.target.job_title
    }
  end
end
