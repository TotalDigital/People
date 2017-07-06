# == Schema Information
#
# Table name: skills
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Skill, type: :model do

  describe 'dependencies on destroy' do
    let(:skill) { create(:skill) }
    let!(:users_skill) { create(:users_skill, skill: skill) }

    it 'deletes its users_skills' do
      expect { skill.destroy }.to change(UsersSkill, :count).by(-1)
    end
  end

  describe 'adds skills' do
    let(:digital) { build(:skill, name: 'digital') }
    let(:digital_with_spaces) { build(:skill, name: ' digital ') }

    it 'adds only one skill' do
      expect do
        digital.save && digital_with_spaces.save
      end.to change(Skill, :count).by(1)
    end
  end
end
