# == Schema Information
#
# Table name: languages
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Language, type: :model do

  describe 'dependencies on destroy' do
    let(:language) { create(:language) }
    let!(:users_language) { create(:users_language, language: language) }

    it 'deletes its users_languages' do
      expect { language.destroy }.to change(UsersLanguage, :count).by(-1)
    end
  end

  describe 'adds languages' do
    let(:english) { build(:language, name: 'english') }
    let(:english_with_spaces) { build(:language, name: ' english ') }

    it 'adds only one language' do
      expect do
        english.save && english_with_spaces.save
      end.to change(Language, :count).by(1)
    end
  end
end

