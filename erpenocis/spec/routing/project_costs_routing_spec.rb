require "rails_helper"

RSpec.describe ProjectCostsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/project_costs").to route_to("project_costs#index")
    end

    it "routes to #new" do
      expect(get: "/project_costs/new").to route_to("project_costs#new")
    end

    it "routes to #show" do
      expect(get: "/project_costs/1").to route_to("project_costs#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/project_costs/1/edit").to route_to("project_costs#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/project_costs").to route_to("project_costs#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/project_costs/1").to route_to("project_costs#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/project_costs/1").to route_to("project_costs#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/project_costs/1").to route_to("project_costs#destroy", id: "1")
    end
  end
end
