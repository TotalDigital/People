require 'rails_helper'

describe UserDecorator do
  let(:user) { create(:user, twitter: "username", linkedin: "https://www.linkedin.com/in/username/", internal_id: "J1234567", phone: "+33123456789") }
  subject { UserDecorator.new(user) }

  describe 'twitter_label' do
    it 'returns button with link to twitter url' do
      expect(subject.twitter_label).to eq "<a class=\"btn btn-default btn-sm\" target=\"_blank\" href=\"https://twitter.com/username\"><span class=\"glyphicon glyphicon-link\"></span> Twitter</a>"
    end
  end

  describe 'linkedin_label' do
    it 'returns button with link to linkedin url ' do
      expect(subject.linkedin_label).to eq "<a class=\"btn btn-default btn-sm\" target=\"_blank\" href=\"https://www.linkedin.com/in/username/\"><span class=\"glyphicon glyphicon-link\"></span> Linkedin</a>"
    end
  end

  describe 'phone_label' do
    it 'returns a tel link' do
      expect(subject.phone_label).to eq "<a href=\"tel:+33123456789\">+33 1 23 45 67 89</a>"
    end
  end

  describe 'internal_id_label' do
    it 'returns internal_id label + internal_id' do
      expect(subject.internal_id_label).to eq "IGG : J1234567"
    end
  end

  describe 'twitter_url' do
    it 'returns twitter url' do
      expect(subject.twitter_url).to eq "https://twitter.com/username"
    end
  end
end
