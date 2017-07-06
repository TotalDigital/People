# == Schema Information
#
# Table name: users
#
#  id                           :integer          not null, primary key
#  email                        :string           default(""), not null
#  encrypted_password           :string           default(""), not null
#  reset_password_token         :string
#  reset_password_sent_at       :datetime
#  remember_created_at          :datetime
#  sign_in_count                :integer          default(0), not null
#  current_sign_in_at           :datetime
#  last_sign_in_at              :datetime
#  current_sign_in_ip           :string
#  last_sign_in_ip              :string
#  created_at                   :datetime
#  updated_at                   :datetime
#  profile_picture_file_name    :string
#  profile_picture_content_type :string
#  profile_picture_file_size    :integer
#  profile_picture_updated_at   :datetime
#  job_title                    :string
#  phone                        :string
#  office_address               :string
#  wat_link                     :string
#  entity                       :string
#  linkedin                     :string
#  twitter                      :string
#  linkedin_uid                 :string
#  linkedin_token               :string
#  linkedin_token_expires_at    :datetime
#  role                         :string           default("basic")
#  first_name                   :string
#  last_name                    :string
#  external                     :boolean
#  internal_id                  :string
#  confirmation_token           :string
#  confirmed_at                 :datetime
#  confirmation_sent_at         :datetime
#  unconfirmed_email            :string
#  branch_id                    :integer
#  imported                     :boolean          default(FALSE)
#  slug                         :string
#  conditions_of_use            :boolean
#  language                     :string           default("en")
#

class UserSerializer < BaseSerializer
  attributes :id, :email, :internal_id, :slugged_id, :first_name, :last_name, :phone, :job_title, :office_address, :entity, :external,
             :twitter, :linkedin, :wat_link, :picture_url, :links

  has_many :relationships
  has_many :jobs
  has_many :projects
  has_many :skills
  has_many :languages
  has_many :degrees

  def slugged_id
    object.slug
  end

  def picture_url
    object.profile_picture.url(:medium)
  end

end
