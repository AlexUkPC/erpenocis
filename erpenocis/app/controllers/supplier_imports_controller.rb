class SupplierImportsController < ApplicationController
  def new
    @supplier_import = SupplierImport.new
    @supplier_import.current_user = current_user
  end

  def create
    begin
      @supplier_import = SupplierImport.new(params[:supplier_import])
      @supplier_import.current_user = current_user
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