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

class User < ActiveRecord::Base
  extend FriendlyId
  include Linkedinable
  include Searchable
  include Users::Specificities

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, password_length: 8..128

  USERS_COUNT_FEATURED = 8

  belongs_to :branch

  has_many :relationships, dependent: :destroy
  has_many :relations, through: :relationships, source: :target, dependent: :destroy

  has_many :users_skills, dependent: :destroy
  has_many :skills, -> { distinct }, through: :users_skills
  accepts_nested_attributes_for :skills, :allow_destroy => true

  has_many :users_languages, dependent: :destroy
  has_many :languages, -> { distinct }, through: :users_languages
  accepts_nested_attributes_for :languages, :allow_destroy => true

  has_many :jobs, dependent: :destroy
  accepts_nested_attributes_for :jobs, :allow_destroy => true

  has_many :degrees, dependent: :destroy

  has_many :projects, -> { distinct }, through: :project_participations
  has_many :project_participations, dependent: :destroy
  accepts_nested_attributes_for :projects, :allow_destroy => true
  accepts_nested_attributes_for :project_participations, :allow_destroy => true

  has_attached_file :profile_picture, :styles => { :medium => "180x180#", :thumb => "90x90#" }, default_url: "http://placehold.it/180x180"
  validates_attachment :profile_picture, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png"] }

  friendly_id :slug_candidates, use: [:slugged, :finders]

  paginates_per 12

  validates :profile_picture, picture: true
  validates :first_name, :last_name, :email, presence: true
  validates :linkedin, url: true
  validates :phone, phone_number: true
  validates :internal_id, internal_id: true
  validates :twitter, twitter: true

  before_save :downcase_email, if: 'email.present? && email_changed?'
  before_save :strip_twitter_username, if: 'twitter.present? && twitter_changed?'

  scope :by_branch, ->(branch_name) { joins(:branch).where(branches: { name: branch_name }) }
  scope :people, -> { where(role: [:admin, :basic]) }
  scope :featured, ->(users_count) { where.not(profile_picture_file_name: nil).order("RANDOM()").limit(users_count) }


  ROLES = {
      admin:     'admin',
      basic:     'basic',
      test_only: 'test_only'
  }
  enum role: ROLES

  LANGUAGES = {
      fr: 'fr',
      en: 'en'
  }
  enum language: LANGUAGES

  def people?
    [ROLES[:admin], ROLES[:basic]].include? role
  end

  def scope
    case role
      when ROLES[:admin]
        'people'
      when ROLES[:basic]
        'people'
      when ROLES[:test]
        'test'
      else
        nil
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def name_with_position
    "#{self.full_name} - #{self.job_title}"
  end

  def has_relation_with?(user)
    relationship_with(user).present?
  end

  def relationship_with(user)
    relationships.find_by(target_id: user.id)
  end

  def phone_number
    Phonelib.parse(phone)
  end

  # Use default slug, but no dashes
  def normalize_friendly_id(slug_str)
    super.gsub("-", "")
  end

  protected

  def password_required?
    return false unless confirmed?
    super
  end

  private

  def set_branch
    unless branch
      domain_name = self.email.split('@').last
      self.branch = Domain.find_by(name: domain_name).try(:branch)
    end
  end

  def downcase_email
    self.email = email.downcase
  end

  def strip_twitter_username
    self.twitter = TwitterValidator::Format.new(self.twitter).username
  end

  def slug_candidates
    [
        full_name,
        [full_name, send(:id)]
    ]
  end

end
