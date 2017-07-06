require 'rails_helper'

RSpec.describe SkillsController, type: :controller do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'create #POST' do
    let!(:skill) { create(:skill, name: 'rollerblade') }

    it 'creates a new skill if it does not exist yet' do
      expect{ post :create, user_id: user.id, skill: { name: 'Bowling'} }.to change(Skill, :count).by 1
    end

    it 'does not create a new skill if it exists' do
      expect{ post :create, user_id: user.id, skill: { name: 'Rollerblade'} }.to change(Skill, :count).by 0
    end

    it 'creates a new users_skill' do
      expect{ post :create, user_id: user.id, skill: { name: 'Bowling'}  }.to change(UsersSkill, :count).by 1
    end

    it 'downcases the skill name' do
      post :create, user_id: user.id, skill: { name: 'Hula-OOp'}
      expect(Skill.last.name).to eq 'hula-oop'
    end

    it 'redirects to user profile with flash notice' do
      post :create, user_id: user.id, skill: { name: 'Bowling'}
      expect(response).to redirect_to user_path(user)
    end
  end

  describe 'destroy #DELETE' do
    let(:skill) { create(:skill, name: 'rollerblade') }
    let!(:users_skill) { create(:users_skill, user: user, skill: skill) }

    it "destroys current user's users_skill" do
      expect{ delete :destroy, user_id: user.id, id: skill.id }.to change { user.skills.count }.by -1
    end

    it 'redirects to user profile with flash notice' do
      delete :destroy, user_id: user.id, id: skill.id
      expect(flash[:notice]).to eq "Removed skill rollerblade"
      expect(response).to redirect_to user_path(user)
    end
  end
  
end
