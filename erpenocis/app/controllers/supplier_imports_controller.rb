class SupplierImportsController < ApplicationController
  def new
    @supplier_import = SupplierImport.new
  end

  def create
    begin
      @supplier_import = SupplierImport.new(params[:supplier_import])
      if @supplier_import.save
        redirect_to suppliers_path(current_tab: "fe"), notice: "Imported suppliers successfully."
      else
        render :new
      end
    rescue => exception
      render :action => 'new', status: :unprocessable_entity
    end
    
  end
end