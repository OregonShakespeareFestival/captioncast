require 'rails_helper'

RSpec.describe WorksController, type: :controller do
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "assigns the @works variable" do
      get :index
      expect(assigns(:works)).not_to be_nil
    end
  end
end
