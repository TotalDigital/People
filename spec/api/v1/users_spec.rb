require 'rails_helper'

RSpec.describe API::V1::Users do
  let(:user) { FactoryGirl.create(:user,
                                  first_name:     "first_name",
                                  last_name:      "last_name",
                                  internal_id:    "J0123456",
                                  job_title:      "job_title",
                                  phone:          "+33 123456789",
                                  office_address: "office_address",
                                  wat_link:       "wat_link",
                                  entity:         "entity",
                                  linkedin:       "https://www.linkedin.com/in/foo",
                                  twitter:        "https://twitter.com/bar"
  ) }
  let!(:test_users) { FactoryGirl.create_list(:user_test_role, 3) }
  let!(:users) { FactoryGirl.create_list(:user, 3) }

  before(:each) do
    # we're using here an access_token for a user with role set to 'basic'
    create_doorkeeper_app(user: user)
  end

  describe 'GET /users' do

    it 'gets all users' do
      get '/api/v1/users', access_token: @dk_token.token
      json = json(response.body)

      expect(response).to be_success
      expect(json.length).to eq(4) # Note that there's already one user in db
      expect(json.map { |user| user[:id] }).to match_array(users.map(&:id) + [user.id]) # no user ids from test_users
    end
  end

  describe 'GET /featured' do

    let!(:users_with_picture) { FactoryGirl.create_list(:user_with_profile_picture, 3) }

    it 'gets all users' do
      get "/api/v1/users/featured", access_token: @dk_token.token
      json = json(response.body)

      expect(response).to be_success
      expect(json.length).to eq([users_with_picture.length, User::USERS_COUNT_FEATURED].min)
    end
  end

  describe 'GET /users/:user_id' do
    it 'gets one user by id' do
      get "/api/v1/users/#{user.id}", access_token: @dk_token.token
      json = json(response.body)

      expect(response).to be_success
      expect(json).to eq(user_to_json(user))
    end
  end

  describe 'GET /users/profile' do
    it 'gets the authenticated current_user' do
      get "/api/v1/users/profile", access_token: @dk_token.token
      json = json(response.body)

      expect(response).to be_success
      expect(json).to eq(user_to_json(user))
    end
  end

  describe 'PUT /users/:user_id' do

    context 'if successful' do
      it 'updates a user' do
        put "/api/v1/users/#{user.id}",
            user:         {
                first_name:     "New first_name",
                last_name:      "New last_name",
                internal_id:    "L6543210",
                job_title:      "New job_title",
                phone:          "+33 987654321",
                office_address: "New office_address",
                wat_link:       "New wat_link",
                entity:         "New entity",
                linkedin:       "https://www.linkedin.com/in/new",
                twitter:        "https://twitter.com/new"
            },
            access_token: @dk_token.token

        json = json(response.body)

        expect(response).to be_success
        expect(json[:first_name]).to eq "New first_name"
        expect(json[:last_name]).to eq "New last_name"
        expect(json[:internal_id]).to eq "L6543210"
        expect(json[:job_title]).to eq "New job_title"
        expect(json[:phone]).to eq "+33 987654321"
        expect(json[:office_address]).to eq "New office_address"
        expect(json[:wat_link]).to eq "New wat_link"
        expect(json[:entity]).to eq "New entity"
        expect(json[:linkedin]).to eq "https://www.linkedin.com/in/new"
        expect(json[:twitter]).to eq "new"
      end
    end

    context 'if not successful' do
      let(:another_user) { FactoryGirl.create(:user) }

      it 'returns an error status 409 if record not valid' do
        put "/api/v1/users/#{user.id}", user: { first_name: '' }, access_token: @dk_token.token
        expect(response.status).to eq 409
      end

      it 'returns an error status 401 if not authorized' do
        put "/api/v1/users/#{another_user.id}", user: { first_name: 'Some First Name' }, access_token: @dk_token.token
        expect(response.status).to eq 401
      end
    end
  end

  describe 'GET search/:term' do
    let!(:user_a) { create(:user, first_name: 'Jean-Michel') }
    let!(:user_b) { create(:user, first_name: 'Jean-Louis') }

    it 'returns users matching search term' do
      get '/api/v1/users/search/jean-michel', access_token: @dk_token.token
      json     = json(response.body)
      user_ids = json.map { |user| user[:id] }

      expect(response).to be_success
      expect(user_ids).to include user_a.id
      expect(user_ids).to_not include user_b.id
    end
  end

  describe 'POST :user_id/skills' do
    context 'if successful' do
      let!(:skill) { create(:skill) }

      it 'adds users_skill' do
        post "/api/v1/users/#{user.id}/skills", skill_id: skill.id, access_token: @dk_token.token
        expect(response).to be_success
      end
    end

    context 'if not successful' do
      let!(:existing_users_skill) { create(:users_skill, user: user) }

      it 'returns an error status 409 if the skill already exists for the given user' do
        post "/api/v1/users/#{user.id}/skills", skill_id: existing_users_skill.skill_id, access_token: @dk_token.token
        expect(response.status).to eq 409
      end
    end
  end

  describe 'POST :user_id/languages' do
    context 'if successful' do
      let!(:language) { create(:language) }

      it 'adds users_language' do
        post "/api/v1/users/#{user.id}/languages", language_id: language.id, access_token: @dk_token.token
        expect(response).to be_success
      end
    end

    context 'if not successful' do
      let!(:existing_users_language) { create(:users_language, user: user) }

      it 'returns an error status 409 if the language already exists for the given user' do
        post "/api/v1/users/#{user.id}/languages", language_id: existing_users_language.language_id, access_token: @dk_token.token
        expect(response.status).to eq 409
      end
    end
  end

  describe 'DELETE :user_id' do
    let!(:admin) { create(:user, role: 'admin') }
    let!(:some_user) { create(:user) }

    context 'if successful' do
      it 'deletes user' do
        create_doorkeeper_app(user: admin)
        expect do
          delete "/api/v1/users/#{some_user.id}", access_token: @dk_token.token
          expect(response).to be_success
        end.to change(User, :count).by -1
      end
    end

    context 'if not successful' do
      let!(:project_participation_another_user) { create(:project_participation) }

      it 'returns an error status 401 if not authorized' do
        expect do
          delete "/api/v1/users/#{some_user.id}", access_token: @dk_token.token
          expect(response.status).to eq 401
        end.to change(User, :count).by 0
      end
    end
  end

  describe 'DELETE :user_id/skills/:skill_id' do
    let!(:existing_users_skill) { create(:users_skill, user: user) }

    context 'if successful' do
      it 'deletes users_skill' do
        delete "/api/v1/users/#{user.id}/skills/#{existing_users_skill.skill_id}", access_token: @dk_token.token
        expect(response).to be_success
      end
    end

    context 'if not successful' do
      let!(:skill) { create(:skill) }
      let!(:users_skill_another_skill) { create(:users_skill, skill: skill) }

      it 'returns an error status 404 if the skill has not be found in users_skill' do
        delete "/api/v1/users/#{user.id}/skills/#{users_skill_another_skill.skill_id}", access_token: @dk_token.token
        expect(response.status).to eq 404
      end
    end
  end

  describe 'DELETE :user_id/languages/:language_id' do
    let!(:existing_users_language) { create(:users_language, user: user) }

    context 'if successful' do
      it 'deletes users_language' do
        delete "/api/v1/users/#{user.id}/languages/#{existing_users_language.language_id}", access_token: @dk_token.token
        expect(response).to be_success
      end
    end

    context 'if not successful' do
      let!(:language) { create(:language) }
      let!(:users_language_another_language) { create(:users_language, language: language) }

      it 'returns an error status 404 if the language has not be found in users_language' do
        delete "/api/v1/users/#{user.id}/languages/#{users_language_another_language.language_id}", access_token: @dk_token.token
        expect(response.status).to eq 404
      end
    end
  end

  describe 'GET /users/:user_id/graph' do
    it 'gets one user by id' do
      get "/api/v1/users/#{user.id}/graph", access_token: @dk_token.token
      expect(response).to be_success
    end
  end

end
