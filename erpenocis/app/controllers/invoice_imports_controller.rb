class InvoiceImportsController < ApplicationController
  def new
    @invoice_import = InvoiceImport.new
    @invoice_import.current_user = current_user
  end

  def create
    begin
      @invoice_import = InvoiceImport.new(params[:invoice_import])
      @invoice_import.current_user = current_user
      if @invoice_import.save
        if params[:invoice_import][:proj_id]
          redirect_to project_path(params[:invoice_import][:proj_id],show: params[:invoice_import][:show]), notice: "Imported invoices successfully."
        else
          redirect_to invoices_url, notice: "Imported invoices successfully."
        end
      else
        render :new
      end
    rescue => exception
      render :action => 'new', status: :unprocessable_entity
    end
    
  end
end