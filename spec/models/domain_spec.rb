# == Schema Information
#
# Table name: domains
#
#  id        :integer          not null, primary key
#  name      :string
#  branch_id :integer
#

require 'rails_helper'

RSpec.describe Domain, type: :model do

  describe 'all_names' do
    let!(:domains) { create_list(:domain, 5) }

    it 'returns an array of all domain names' do
      result = Domain.all_names
      expect(result).to be_a Array
      expect(result.sample).to be_a String
      expect(result.count).to eq 5
    end
  end

  describe 'authorized?(email)' do
    let!(:domain) { create(:domain, name: 'google.com') }

    it 'returns true if email match domain name' do
      expect(Domain.authorized?('user.name@google.com')).to eq true
    end

    it 'returns false if email does not match domain name' do
      expect(Domain.authorized?('google.com@unauthorized.com')).to eq false
    end
  end
end
