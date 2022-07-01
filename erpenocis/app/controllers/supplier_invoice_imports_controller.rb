class SupplierInvoiceImportsController < ApplicationController
  def new
    @supplier_invoice_import = SupplierInvoiceImport.new
    @supplier_invoice_import.current_user = current_user
  end

  def create
    begin
      @supplier_invoice_import = SupplierInvoiceImport.new(params[:supplier_invoice_import])
      @supplier_invoice_import.current_user = current_user
      if @supplier_invoice_import.save
        redirect_to suppliers_path(current_tab: "fe"), notice: "Imported project costs successfully."
      else
        render :new
      end
    rescue => exception
      render :action => 'new', status: :unprocessable_entity
    end
    
  end
end