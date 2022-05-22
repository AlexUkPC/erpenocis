class JanuarySoldsController < ApplicationController
  before_action :set_january_sold, only: %i[ show edit update destroy ]
  before_action :set_date_params, only: %i[ create update destroy ]

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
        format.html { redirect_to financial_centralization_path(jsid: "", year: Date.today().strftime("%Y"), start_month: @start_month, start_year: @start_year, end_month: @end_month, end_year: @end_year), notice: "January sold was successfully created." }
        format.json { render :show, status: :created, location: @january_sold }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @january_sold.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /january_solds/1 or /january_solds/1.json
  def update
    respond_to do |format|
      if @january_sold.update(january_sold_params)
        format.html { redirect_to financial_centralization_path(jsid: "", year: Date.today().strftime("%Y"), start_month: @start_month, start_year: @start_year, end_month: @end_month, end_year: @end_year), notice: "January sold was successfully updated." }
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

    respond_to do |format|
      format.html { redirect_to financial_centralization_path(jsid: "", year: Date.today().strftime("%Y"), start_month: @start_month, start_year: @start_year, end_month: @end_month, end_year: @end_year), notice: "January sold was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_january_sold
      @january_sold = JanuarySold.find(params[:id])
    end
    def set_date_params
      @start_month = params[:start_month].to_i
      @start_year = params[:start_year].to_i
      @end_month = params[:end_month].to_i
      @end_year = params[:end_year].to_i
    end

    # Only allow a list of trusted parameters through.
    def january_sold_params
      params.require(:january_sold).permit(:value, :year)
    end
end
