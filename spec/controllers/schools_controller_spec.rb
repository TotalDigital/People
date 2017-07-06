require 'rails_helper'

RSpec.describe SchoolsController, type: :controller do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  let!(:school_a) { create(:school, name: "Alqemist Academy") }
  let!(:school_b) { create(:school, name: "Alqemist University") }
  let!(:school_c) { create(:school, name: "Kahn Academy") }

   describe "GET autocomplete_school_name" do
      it "returns schools matching school name" do
        get :autocomplete_school_name, term: "alq", format: :json
        school_names = json(response.body).map{|school| school[:value]}

        expect(school_names).to include school_a.name
        expect(school_names).to include school_b.name
        expect(school_names).to_not include school_c.name
      end
   end
end
