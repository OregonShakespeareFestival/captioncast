require 'rails_helper'

RSpec.describe TextsController, type: :controller do
  describe "GET #index" do
    let(:work) { Work.create(work_name: "Hamlet", language: "en", venue: Venue.thomas_theatre) }

    it "returns http success" do
      get :index, work_id: work.id
      expect(response).to have_http_status(:success)
    end

    it "assigns variables for the view" do
      get :index, work_id: work.id
      expect(assigns(:work)).to eq work
      expect(assigns(:texts)).not_to be_nil
    end
  end
end
