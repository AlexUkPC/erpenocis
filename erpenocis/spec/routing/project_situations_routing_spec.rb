require "rails_helper"

RSpec.describe ProjectSituationsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/project_situations").to route_to("project_situations#index")
    end

    it "routes to #new" do
      expect(get: "/project_situations/new").to route_to("project_situations#new")
    end

    it "routes to #show" do
      expect(get: "/project_situations/1").to route_to("project_situations#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/project_situations/1/edit").to route_to("project_situations#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/project_situations").to route_to("project_situations#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/project_situations/1").to route_to("project_situations#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/project_situations/1").to route_to("project_situations#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/project_situations/1").to route_to("project_situations#destroy", id: "1")
    end
  end
end
