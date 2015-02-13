require 'rails_helper'

RSpec.describe TextsController, type: :controller do
  describe "GET #index" do
    let(:work) { Work.create(work_name: "Hamlet", language: "en", venue: Venue.thomas_theatre) }

    it "returns http success" do
      get :index, work_id: work.id
      expect(response).to have_http_status(:success)
      expect(assigns(:work)).to eq work
    end
  end
end
