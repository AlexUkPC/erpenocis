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

RSpec.describe "/employee_salaries", type: :request do
  
  # This should return the minimal set of attributes required to create a valid
  # EmployeeSalary. As you add validations to EmployeeSalary, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      EmployeeSalary.create! valid_attributes
      get employee_salaries_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      employee_salary = EmployeeSalary.create! valid_attributes
      get employee_salary_url(employee_salary)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_employee_salary_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      employee_salary = EmployeeSalary.create! valid_attributes
      get edit_employee_salary_url(employee_salary)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new EmployeeSalary" do
        expect {
          post employee_salaries_url, params: { employee_salary: valid_attributes }
        }.to change(EmployeeSalary, :count).by(1)
      end

      it "redirects to the created employee_salary" do
        post employee_salaries_url, params: { employee_salary: valid_attributes }
        expect(response).to redirect_to(employee_salary_url(EmployeeSalary.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new EmployeeSalary" do
        expect {
          post employee_salaries_url, params: { employee_salary: invalid_attributes }
        }.to change(EmployeeSalary, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post employee_salaries_url, params: { employee_salary: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested employee_salary" do
        employee_salary = EmployeeSalary.create! valid_attributes
        patch employee_salary_url(employee_salary), params: { employee_salary: new_attributes }
        employee_salary.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the employee_salary" do
        employee_salary = EmployeeSalary.create! valid_attributes
        patch employee_salary_url(employee_salary), params: { employee_salary: new_attributes }
        employee_salary.reload
        expect(response).to redirect_to(employee_salary_url(employee_salary))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        employee_salary = EmployeeSalary.create! valid_attributes
        patch employee_salary_url(employee_salary), params: { employee_salary: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested employee_salary" do
      employee_salary = EmployeeSalary.create! valid_attributes
      expect {
        delete employee_salary_url(employee_salary)
      }.to change(EmployeeSalary, :count).by(-1)
    end

    it "redirects to the employee_salaries list" do
      employee_salary = EmployeeSalary.create! valid_attributes
      delete employee_salary_url(employee_salary)
      expect(response).to redirect_to(employee_salaries_url)
    end
  end
end
