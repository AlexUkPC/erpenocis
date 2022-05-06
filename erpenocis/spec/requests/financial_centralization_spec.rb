require 'rails_helper'

RSpec.describe "FinancialCentralizations", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/financial_centralization/index"
      expect(response).to have_http_status(:success)
    end
  end

end
