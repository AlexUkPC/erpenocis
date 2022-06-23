class CarsController < ApplicationController
  before_action :set_car, only: %i[ show edit update destroy ]
  before_action :set_dates_params

  # GET /cars or /cars.json
  def index
    @cars = Car.between_dates(set_start_date(@start_month.to_s, @start_year.to_s),set_end_date(@end_month, @end_year))
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
        Record.create(record_type: "Adaugare", location: "Flota auto", model_id: @car.id, initial_data: "", modified_data: "Nr inmatriculare: #{@car.number_plate} | Data expirare Rca: #{@car.rca_expiry_date} | Data expirare Rovinieta: #{@car.rov_expiry_date} | Data expirare Itp: #{@car.itp_expiry_date}", user_id: current_user.id)
        format.html { redirect_to cars_path(sm: @start_month, sy: @start_year, em: @end_month, ey: @end_year), notice: "Auto a fost adaugat." }
        format.json { render :show, status: :created, location: @car }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cars/1 or /cars/1.json
  def update
    @cars = Car.between_dates(set_start_date(@start_month, @start_year),set_end_date(@end_month, @end_year))
    @old_info_car = @car.dup
    respond_to do |format|
      if @car.update(car_params)
        old_s = ""
        s = ""
        if @old_info_car.number_plate != @car.number_plate
          old_s += "Nr inmatriculare: #{@old_info_car.number_plate} | "
          s += "Nr inmatriculare: #{@car.number_plate} | "
        end
        if @old_info_car.rca_expiry_date != @car.rca_expiry_date
          old_s += "Data expirare Rca: #{@old_info_car.rca_expiry_date} | "
          s += "Data expirare Rca: #{@car.rca_expiry_date} | "
        end
        if @old_info_car.rov_expiry_date != @car.rov_expiry_date
          old_s += "Data expirare Rovinieta: #{@old_info_car.rov_expiry_date} | "
          s += "Data expirare Rovinieta: #{@car.rov_expiry_date} | "
        end
        if @old_info_car.itp_expiry_date != @car.itp_expiry_date
          old_s += "Data expirare Itp: #{@old_info_car.itp_expiry_date} | "
          s += "Data expirare Itp: #{@car.itp_expiry_date} | "
        end
        Record.create(record_type: "Modificare", location: "Flota auto", model_id: @car.id, initial_data: old_s[0..-3], modified_data: s[0..-3], user_id: current_user.id)
        format.html { redirect_to cars_path(sm: @start_month, sy: @start_year, em: @end_month, ey: @end_year), notice: "Auto a fost modificat." }
        format.json { render :show, status: :ok, location: @car }
      else
        format.html { render 'index', cars: @cars, status: :unprocessable_entity}
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cars/1 or /cars/1.json
  def destroy
    @car.destroy
    Record.create(record_type: "Stergere", location: "Flota auto", model_id: @car.id, initial_data: "Nr inmatriculare: #{@car.number_plate} | Data expirare Rca: #{@car.rca_expiry_date} | Data expirare Rovinieta: #{@car.rov_expiry_date} | Data expirare Itp: #{@car.itp_expiry_date}", modified_data: "", user_id: current_user.id)
    respond_to do |format|
      format.html { redirect_to cars_path(sm: @start_month, sy: @start_year, em: @end_month, ey: @end_year), notice: "Auto a fost sters." }
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
