# == Schema Information
#
# Table name: branches
#
#  id   :integer          not null, primary key
#  name :string
#

require 'rails_helper'

RSpec.describe Branch, type: :model do

  describe 'dependencies on destroy' do

    context 'if branch has users' do
      let(:branch)  { create(:branch) }
      let!(:user)   { create(:user, branch: branch) }
      it 'cannot delete a branch' do
        expect { branch.destroy }.to change(Branch, :count).by(0)
      end
    end

    context 'if has no users' do
      let!(:branch)  { create(:branch) }
      it 'deletes a branch' do
        expect { branch.destroy }.to change(Branch, :count).by(-1)
      end
    end

    context 'if has domains' do
      let(:branch)  { create(:branch) }
      let!(:domain) { create(:domain, branch: branch) }
      it 'deletes its related domains' do
        expect { branch.destroy }.to change(Domain, :count).by(-1)
      end
    end
  end
end
