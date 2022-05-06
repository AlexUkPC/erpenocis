require "rails_helper"

RSpec.describe ExpenseValuesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/expense_values").to route_to("expense_values#index")
    end

    it "routes to #new" do
      expect(get: "/expense_values/new").to route_to("expense_values#new")
    end

    it "routes to #show" do
      expect(get: "/expense_values/1").to route_to("expense_values#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/expense_values/1/edit").to route_to("expense_values#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/expense_values").to route_to("expense_values#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/expense_values/1").to route_to("expense_values#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/expense_values/1").to route_to("expense_values#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/expense_values/1").to route_to("expense_values#destroy", id: "1")
    end
  end
end
