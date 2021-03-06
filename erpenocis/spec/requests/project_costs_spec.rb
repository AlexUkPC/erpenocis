require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/project_costs", type: :request do
  
  # This should return the minimal set of attributes required to create a valid
  # ProjectCost. As you add validations to ProjectCost, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      ProjectCost.create! valid_attributes
      get project_costs_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      project_cost = ProjectCost.create! valid_attributes
      get project_cost_url(project_cost)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_project_cost_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      project_cost = ProjectCost.create! valid_attributes
      get edit_project_cost_url(project_cost)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new ProjectCost" do
        expect {
          post project_costs_url, params: { project_cost: valid_attributes }
        }.to change(ProjectCost, :count).by(1)
      end

      it "redirects to the created project_cost" do
        post project_costs_url, params: { project_cost: valid_attributes }
        expect(response).to redirect_to(project_cost_url(ProjectCost.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new ProjectCost" do
        expect {
          post project_costs_url, params: { project_cost: invalid_attributes }
        }.to change(ProjectCost, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post project_costs_url, params: { project_cost: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested project_cost" do
        project_cost = ProjectCost.create! valid_attributes
        patch project_cost_url(project_cost), params: { project_cost: new_attributes }
        project_cost.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the project_cost" do
        project_cost = ProjectCost.create! valid_attributes
        patch project_cost_url(project_cost), params: { project_cost: new_attributes }
        project_cost.reload
        expect(response).to redirect_to(project_cost_url(project_cost))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        project_cost = ProjectCost.create! valid_attributes
        patch project_cost_url(project_cost), params: { project_cost: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested project_cost" do
      project_cost = ProjectCost.create! valid_attributes
      expect {
        delete project_cost_url(project_cost)
      }.to change(ProjectCost, :count).by(-1)
    end

    it "redirects to the project_costs list" do
      project_cost = ProjectCost.create! valid_attributes
      delete project_cost_url(project_cost)
      expect(response).to redirect_to(project_costs_url)
    end
  end
end
