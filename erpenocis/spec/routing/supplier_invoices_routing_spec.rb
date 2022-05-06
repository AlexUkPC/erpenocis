require "rails_helper"

RSpec.describe SupplierInvoicesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/supplier_invoices").to route_to("supplier_invoices#index")
    end

    it "routes to #new" do
      expect(get: "/supplier_invoices/new").to route_to("supplier_invoices#new")
    end

    it "routes to #show" do
      expect(get: "/supplier_invoices/1").to route_to("supplier_invoices#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/supplier_invoices/1/edit").to route_to("supplier_invoices#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/supplier_invoices").to route_to("supplier_invoices#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/supplier_invoices/1").to route_to("supplier_invoices#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/supplier_invoices/1").to route_to("supplier_invoices#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/supplier_invoices/1").to route_to("supplier_invoices#destroy", id: "1")
    end
  end
end
