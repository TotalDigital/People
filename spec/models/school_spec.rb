# == Schema Information
#
# Table name: schools
#
#  id   :integer          not null, primary key
#  name :string
#

require 'rails_helper'

RSpec.describe School, type: :model do

  describe 'dependencies on destroy' do

    context 'if school is related to degrees' do
      let(:school)  { create(:school) }
      let!(:degree) { create(:degree, school: school) }

      it 'cannot delete a school' do
        expect { school.destroy }.to change(School, :count).by(0)
      end
    end

    context 'if school has no related degrees' do
      let!(:school)  { create(:school) }

      it 'deletes a school' do
        expect { school.destroy }.to change(School, :count).by(-1)
      end
    end
  end
end
