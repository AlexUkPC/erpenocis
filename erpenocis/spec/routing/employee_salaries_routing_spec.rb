require "rails_helper"

RSpec.describe EmployeeSalariesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/employee_salaries").to route_to("employee_salaries#index")
    end

    it "routes to #new" do
      expect(get: "/employee_salaries/new").to route_to("employee_salaries#new")
    end

    it "routes to #show" do
      expect(get: "/employee_salaries/1").to route_to("employee_salaries#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/employee_salaries/1/edit").to route_to("employee_salaries#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/employee_salaries").to route_to("employee_salaries#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/employee_salaries/1").to route_to("employee_salaries#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/employee_salaries/1").to route_to("employee_salaries#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/employee_salaries/1").to route_to("employee_salaries#destroy", id: "1")
    end
  end
end
