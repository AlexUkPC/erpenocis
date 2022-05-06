require 'rails_helper'

RSpec.describe "IndirectExpenses", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/indirect_expenses/index"
      expect(response).to have_http_status(:success)
    end
  end

end
