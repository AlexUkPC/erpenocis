class JanuarySoldsController < ApplicationController
  before_action :set_january_sold, only: %i[ show edit update destroy ]
  before_action :set_dates_params

  # GET /january_solds or /january_solds.json
  def index
    @january_solds = JanuarySold.all
  end

  # GET /january_solds/1 or /january_solds/1.json
  def show
  end

  # GET /january_solds/new
  def new
    @january_sold = JanuarySold.new
  end

  # GET /january_solds/1/edit
  def edit
  end

  # POST /january_solds or /january_solds.json
  def create
    @january_sold = JanuarySold.new(january_sold_params)
    
    respond_to do |format|
      if @january_sold.save
        Record.create(record_type: "Adaugare", location: "Centralizare financiara", model_id: @january_sold.id, initial_data: "", modified_data: "Sold Ianuarie: #{@january_sold.value} | An: #{@january_sold.year}", user_id: current_user.id)
        format.html { redirect_to financial_centralization_path(jsid: "", year: Date.today().strftime("%Y"), sm: @start_month, sy: @start_year, em: @end_month, ey: @end_year), notice: "January sold was successfully created." }
        format.json { render :show, status: :created, location: @january_sold }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @january_sold.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /january_solds/1 or /january_solds/1.json
  def update
    @old_info_january_sold = @january_sold.dup
    respond_to do |format|
      if @january_sold.update(january_sold_params)
        old_s = ""
        s = ""
        if @old_info_january_sold.value != @january_sold.value
          old_s += "Sold Ianuarie: #{@old_info_january_sold.value} | "
          s += "Sold Ianuarie: #{@january_sold.value} | "
        end
        if @old_info_january_sold.year != @january_sold.year
          old_s += "An: #{@old_info_january_sold.year} | "
          s += "An: #{@january_sold.year} | "
        end
        if s!="" || old_s != ""
          Record.create(record_type: "Modificare", location: "Centralizare financiara", model_id: @january_sold.id, initial_data: old_s[0..-3], modified_data: s[0..-3], user_id: current_user.id)
        end
        format.html { redirect_to financial_centralization_path(jsid: "", year: Date.today().strftime("%Y"), sm: @start_month, sy: @start_year, em: @end_month, ey: @end_year), notice: "January sold was successfully updated." }
        format.json { render :show, status: :ok, location: @january_sold }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @january_sold.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /january_solds/1 or /january_solds/1.json
  def destroy
    @january_sold.destroy
    Record.create(record_type: "Stergere", location: "Centralizare financiara", model_id: @january_sold.id, initial_data: "Sold Ianuarie: #{@january_sold.value} | An: #{@january_sold.year}", modified_data: "", user_id: current_user.id)
    respond_to do |format|
      format.html { redirect_to financial_centralization_path(jsid: "", year: Date.today().strftime("%Y"), sm: @start_month, sy: @start_year, em: @end_month, ey: @end_year), notice: "January sold was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_january_sold
      @january_sold = JanuarySold.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def january_sold_params
      params.require(:january_sold).permit(:value, :year)
    end
end
