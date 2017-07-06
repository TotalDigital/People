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

require 'rails_helper'

RSpec.describe Relationship, type: :model do

  describe 'create_inverse' do
    let(:relationship) { create(:relationship, kind: 'is_manager_of') }

    it 'creates an opposite relationship as the one just created' do
      inverse_relationship = relationship.create_inverse
      expect(inverse_relationship.user_id).to eq relationship.target_id
      expect(inverse_relationship.target_id).to eq relationship.user_id
      expect(inverse_relationship.kind).to eq 'is_managed_by'
    end
  end

  describe 'destroy_inverse' do
    let!(:relationship) { create(:relationship, kind: 'is_manager_of') }

    it 'destroys inverse relationship' do
      expect { relationship.destroy_inverse }.to change { Relationship.count }.by -2
    end
  end

  describe 'has_inverse?' do
    let!(:relationship_with_inverse) { create(:relationship) }

    it 'returns true if inverse is present' do
      expect(relationship_with_inverse.has_inverse?).to eq true
    end
  end

  describe 'inverse' do
    let!(:relationship) { create(:relationship, kind: 'is_manager_of') }

    it 'inverse relationship' do
      expect(relationship.inverse.kind).to eq 'is_managed_by'
    end
  end
end
