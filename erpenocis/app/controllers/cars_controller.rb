class CarsController < ApplicationController
  before_action :set_car, only: %i[ show edit update destroy ]
  before_action :set_dates_params

  # GET /cars or /cars.json
  def index
    @cars = Car.between_dates(set_start_date(@start_month, @start_year),set_end_date(@end_month, @end_year))
    if params[:id]
      @car = @cars.find(params[:id])
    else
      @car = Car.new(rca_expiry_date: Date.today, rov_expiry_date: Date.today, itp_expiry_date: Date.today)
    end
  end

  # GET /cars/1 or /cars/1.json
  def show
  end

  # GET /cars/new
  def new
    @car = Car.new
  end

  # GET /cars/1/edit
  def edit
  end

  # POST /cars or /cars.json
  def create
    @car = Car.new(car_params)

    respond_to do |format|
      if @car.save
        format.html { redirect_to cars_path(sm: @start_month, sy: @start_year, em: @end_month, ey: @end_year), notice: "Car was successfully created." }
        format.json { render :show, status: :created, location: @car }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cars/1 or /cars/1.json
  def update
    respond_to do |format|
      if @car.update(car_params)
        format.html { redirect_to cars_path(sm: @start_month, sy: @start_year, em: @end_month, ey: @end_year), notice: "Car was successfully updated." }
        format.json { render :show, status: :ok, location: @car }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cars/1 or /cars/1.json
  def destroy
    @car.destroy

    respond_to do |format|
      format.html { redirect_to cars_path(sm: @start_month, sy: @start_year, em: @end_month, ey: @end_year), notice: "Car was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car
      @car = Car.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def car_params
      params.require(:car).permit(:number_plate, :rca_expiry_date, :rov_expiry_date, :itp_expiry_date)
    end
end
