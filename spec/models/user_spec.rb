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

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:manager) { create(:user) }
  let(:colleague) { create(:user) }
  let!(:colleague_bound) { create(:relationship, user_id: manager.id, target_id: colleague.id, kind: 'is_colleague_of') }
  let(:member) { create(:user) }
  let!(:manager_bound) { create(:relationship, user_id: manager.id, target_id: member.id, kind: 'is_manager_of') }
  let(:random_user) { create(:user) }

  context 'validations' do
    describe 'twitter username' do
      it 'validates presence of twitter username in twitter input' do
        user = FactoryGirl.build(:user, twitter: 'not a URL')
        expect(user).not_to be_valid
        expect(user.errors.messages[:twitter]).to eq ['must be a valid Twitter username']
      end
    end

    describe 'linkedin url' do
      it 'validates url format for linkedin link' do
        user = FactoryGirl.build(:user, linkedin: 'not a URL')
        expect(user).not_to be_valid
        expect(user.errors.messages[:linkedin]).to eq ['must be a valid URL with format https://www.linkedin.com/in/username']
      end
    end
  end

  describe 'relationship_with(user)' do
    it 'returns relationship of a user with other user' do
      expect(manager.relationship_with(colleague)).to eq colleague_bound
      expect(manager.relationship_with(colleague).kind).to eq 'is_colleague_of'
    end
  end

  describe 'has_relation_with?(user)' do
    it 'returns true is user has any relationships with other user' do
      expect(manager.has_relation_with?(member)).to eq true
      expect(manager.has_relation_with?(random_user)).to eq false
    end
  end

  describe 'tests if the email is being saved in lowcase' do
    it 'saves the user with email in lowcase' do
      email = 'UPCASE@TOTAL.COM'
      user = FactoryGirl.create(:user, email: email)
      expect(user.email).to eq email.downcase
    end
  end

  context 'callbacks' do
    let(:user) { create(:user) }

    describe 'strip_twitter_username' do
      it 'strips username if entered with @' do
        user.update(twitter: '@username')
        user.reload
        expect(user.twitter).to eq 'username'
      end

      it 'strips username if entered with url' do
        user.update(twitter: 'https://www.twitter.com/username')
        user.reload
        expect(user.twitter).to eq 'username'
      end

      it 'strips username if entered with url' do
        user.update(twitter: 'twitter.com/username')
        user.reload
        expect(user.twitter).to eq 'username'
      end

      it 'doesnt strip username if entered correctly' do
        user.update(twitter: 'username')
        user.reload
        expect(user.twitter).to eq 'username'
      end
    end
  end

  describe 'dependencies on destroy' do
    let(:user) { create(:user) }
    let!(:users_language) { create(:users_language, user: user) }
    let!(:users_skill) { create(:users_skill, user: user) }
    let!(:job) { create(:job, user: user) }
    let!(:degree) { create(:degree, user: user) }
    let!(:project_participation) { create(:project_participation, user: user) }
    let!(:project) { create(:project, user: user) }
    let!(:relationship) { create(:relationship, user: user) }

    it 'deletes its users_languages' do
      expect { user.destroy }.to change(UsersLanguage, :count).by(-1)
    end

    it 'deletes its users_skills' do
      expect { user.destroy }.to change(UsersSkill, :count).by(-1)
    end

    it 'deletes its jobs' do
      expect { user.destroy }.to change(Job, :count).by(-1)
    end

    it 'deletes its degrees' do
      expect { user.destroy }.to change(Degree, :count).by(-1)
    end

    it 'deletes its project_participations' do
      expect { user.destroy }.to change(ProjectParticipation, :count).by(-1)
    end

    it 'does not delete projects' do
      expect { user.destroy }.to change(Project, :count).by(0)
    end

    it 'deletes its relationship and the inverse relationship' do
      expect { user.destroy }.to change(Relationship, :count).by(-2)
    end
  end
end
