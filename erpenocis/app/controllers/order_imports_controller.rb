class OrderImportsController < ApplicationController
  def new
    @order_import = OrderImport.new
    @order_import.current_user = current_user
  end

  def create
    begin
      @order_import = OrderImport.new(params[:order_import])
      @order_import.current_user = current_user
      if @order_import.save
        if params[:order_import][:proj_id]
          redirect_to project_path(params[:order_import][:proj_id],show: params[:order_import][:show]), notice: "Imported orders successfully."
        else
          redirect_to orders_url, notice: "Imported orders successfully."
        end
      else
        render :new
      end
    rescue => exception
      render :action => 'new', status: :unprocessable_entity
    end
    
  end
end