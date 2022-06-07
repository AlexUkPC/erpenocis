class CarImportsController < ApplicationController
  def new
    @car_import = CarImport.new
  end

  def create
    begin
      @car_import = CarImport.new(params[:car_import])
      if @car_import.save
        redirect_to cars_url, notice: "Imported cars successfully."
      else
        render :new
      end
    rescue => exception
      render :action => 'new', status: :unprocessable_entity
    end
    
  end
end