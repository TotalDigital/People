json.array! @user.relationships do |relation|
  json.source do
    json.id relation.user.id
    json.name relation.user.full_name
    json.job relation.user.job_title
    json.picture_url relation.user.profile_picture.url(:medium)
  end
  json.target do
    json.id relation.target.id
    json.name relation.target.full_name
    json.job relation.target.job_title
    json.picture_url relation.target.profile_picture.url(:medium)
  end
  json.relationship relation.kind
end
