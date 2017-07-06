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

class Relationship < ActiveRecord::Base

  belongs_to :user
  belongs_to :target, class_name: 'User'

  after_create :create_inverse, unless: :has_inverse?
  after_destroy :destroy_inverse, if: :has_inverse?

  validates :user_id, :target_id, :kind, presence: true
  validates :user_id, uniqueness: { scope: :target_id }

  scope :people, -> { joins(:target).where(users: { role: [:admin, :basic] }) }
  scope :test_only, -> { joins(:target).where(users: { role: :test_only }) }

  KINDS = {
      is_manager_of:   'is_manager_of',
      is_managed_by:   'is_managed_by',
      is_assistant_of: 'is_assistant_of',
      is_assisted_by:  'is_assisted_by',
      is_colleague_of: 'is_colleague_of'
  }

  KIND_PERMISSIONS_EXTERNAL = {
      is_manager_of:   false,
      is_managed_by:   false,
      is_assistant_of: false,
      is_assisted_by:  false,
      is_colleague_of: true
  }

  enum kind: KINDS

  def create_inverse
    Relationship.create(inverse_target_options)
  end

  def destroy_inverse
    inverse.destroy
  end

  def has_inverse?
    inverse.present?
  end

  def inverse
    Relationship.find_by(inverse_target_options)
  end

  def inverse_target_options
    {target_id: user_id, user_id: target_id, kind: inverse_of(kind)}
  end

  def inverse_of(kind)
    case kind
      when 'is_manager_of'
        'is_managed_by'
      when 'is_managed_by'
        'is_manager_of'
      when 'is_assistant_of'
        'is_assisted_by'
      when 'is_assisted_by'
        'is_assistant_of'
      else
        'is_colleague_of'
    end
  end

  attr_reader :search
end
