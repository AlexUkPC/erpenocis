require 'rails_helper'

RSpec.describe "ImportData", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/import_data/index"
      expect(response).to have_http_status(:success)
    end
  end

end
