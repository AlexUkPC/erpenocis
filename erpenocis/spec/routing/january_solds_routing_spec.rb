require "rails_helper"

RSpec.describe JanuarySoldsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/january_solds").to route_to("january_solds#index")
    end

    it "routes to #new" do
      expect(get: "/january_solds/new").to route_to("january_solds#new")
    end

    it "routes to #show" do
      expect(get: "/january_solds/1").to route_to("january_solds#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/january_solds/1/edit").to route_to("january_solds#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/january_solds").to route_to("january_solds#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/january_solds/1").to route_to("january_solds#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/january_solds/1").to route_to("january_solds#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/january_solds/1").to route_to("january_solds#destroy", id: "1")
    end
  end
end
