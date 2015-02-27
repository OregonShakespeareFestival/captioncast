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
      expect(assigns(:texts)).not_to be_nil
    end
  end

  describe "GET #edit" do
    let(:work) { Work.create(work_name: "Hamlet", language: "en", venue: Venue.thomas_theatre) }
    let(:element) { Element.create(element_type: 'CHARACTER', work: work, color: 'red') }
    let(:text) { work.texts.create(element: element, sequence: 1) }

    it "returns http success" do
      get :edit, work_id: work.id, id: text.id
      expect(response).to have_http_status(:success)
    end

    it "assigns variables for the view" do
      get :edit, work_id: work.id, id: text.id
      expect(assigns(:work)).to eq work
      expect(assigns(:text)).to eq text
    end
  end
end
