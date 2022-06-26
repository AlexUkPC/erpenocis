class ProjectSituationsController < ApplicationController
  before_action :set_project_situation, only: %i[ show edit update destroy ]
  before_action :set_dates_params
  before_action :set_which_date
  
  # GET /project_situations or /project_situations.json
  def index
    if @which_date=="advance"
      @project_situations = ProjectSituation.between_advance_dates(@start_month, @end_month, @start_year, @end_year)
    elsif @which_date=="closure"
      @project_situations = ProjectSituation.between_closure_dates(@start_month, @end_month, @start_year, @end_year)
    end
    @projects = Project.where(stoc: false).where(project_situation: @project_situations)
    
    total_closure_payment = @project_situations.sum(:closure_payment)
    @total_advance_payment = @project_situations.sum(:advance_payment)
    @total_to_be_collected = Project.all.sum(:value) - @total_advance_payment - total_closure_payment
  end

  # GET /project_situations/1 or /project_situations/1.json
  def show
  end

  # GET /project_situations/new
  def new
    @project_situation = ProjectSituation.new
  end

  # GET /project_situations/1/edit
  def edit
  end

  # POST /project_situations or /project_situations.json
  def create
    @project_situation = ProjectSituation.new(project_situation_params)

    respond_to do |format|
      if @project_situation.save
        format.html { redirect_to project_situation_url(@project_situation), notice: "Project situation was successfully created." }
        format.json { render :show, status: :created, location: @project_situation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project_situation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /project_situations/1 or /project_situations/1.json
  def update
    @old_info_project_situation = ProjectSituation.find_by_id(@project_situation.id).dup
    respond_to do |format|
      if @project_situation.update(project_situation_params)
        old_s = ""
        s = ""
        if @old_info_project_situation.advance_invoice_date != @project_situation.advance_invoice_date
          old_s += "Data ff avans: #{@old_info_project_situation.advance_invoice_date} | "
          s += "Data ff avans: #{@project_situation.advance_invoice_date} | "
        end
        if @old_info_project_situation.advance_invoice_number != @project_situation.advance_invoice_number
          old_s += "FF avans: #{@old_info_project_situation.advance_invoice_number} | "
          s += "FF avans: #{@project_situation.advance_invoice_number} | "
        end
        if @old_info_project_situation.advance_payment_date != @project_situation.advance_payment_date
          old_s += "Data avans: #{@old_info_project_situation.advance_payment_date} | "
          s += "Data avans: #{@project_situation.advance_payment_date} | "
        end
        if @old_info_project_situation.advance_payment != @project_situation.advance_payment
          old_s += "Avans: #{@old_info_project_situation.advance_payment} | "
          s += "Avans: #{@project_situation.advance_payment} | "
        end
        if @old_info_project_situation.advance_month != @project_situation.advance_month
          old_s += "Luna comanda/avans: #{@old_info_project_situation.advance_month} | "
          s += "Luna comanda/avans: #{@project_situation.advance_month} | "
        end
        if @old_info_project_situation.advance_year != @project_situation.advance_year
          old_s += "An comanda/avans: #{@old_info_project_situation.advance_year} | "
          s += "An comanda/avans: #{@project_situation.advance_year} | "
        end
        if @old_info_project_situation.closure_invoice_date != @project_situation.closure_invoice_date
          old_s += "Data ff finala: #{@old_info_project_situation.closure_invoice_date} | "
          s += "Data ff finala: #{@project_situation.closure_invoice_date} | "
        end
        if @old_info_project_situation.closure_invoice_number != @project_situation.closure_invoice_number
          old_s += "FF finala: #{@old_info_project_situation.closure_invoice_number} | "
          s += "FF finala: #{@project_situation.closure_invoice_number} | "
        end
        if @old_info_project_situation.closure_payment_date != @project_situation.closure_payment_date
          old_s += "Data inchidere: #{@old_info_project_situation.closure_payment_date} | "
          s += "Data inchidere: #{@project_situation.closure_payment_date} | "
        end
        if @old_info_project_situation.closure_payment != @project_situation.closure_payment
          old_s += "Inchidere: #{@old_info_project_situation.closure_payment} | "
          s += "Inchidere: #{@project_situation.closure_payment} | "
        end
        if @old_info_project_situation.closure_month != @project_situation.closure_month
          old_s += "Luna finalizare/rest de plata: #{@old_info_project_situation.closure_month} | "
          s += "Luna finalizare/rest de plata: #{@project_situation.closure_month} | "
        end
        if @old_info_project_situation.closure_year != @project_situation.closure_year
          old_s += "An finalizare/rest de plata: #{@old_info_project_situation.closure_year} | "
          s += "An finalizare/rest de plata: #{@project_situation.closure_year} | "
        end
        
        if s!="" || old_s != ""
          Record.create(record_type: "Modificare", location: "Situatie proiecte", model_id: @project_situation.project.id, initial_data: old_s[0..-3], modified_data: s[0..-3], user_id: current_user.id)
        end
        format.html { redirect_to project_situations_path(which_date: @which_date, sm: @start_month, sy: @start_year, em: @end_month, ey: @end_year), notice: "Project situation was successfully updated." }
        format.json { render :show, status: :ok, location: @project_situation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project_situation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_situations/1 or /project_situations/1.json
  def destroy
    @project_situation.destroy

    respond_to do |format|
      format.html { redirect_to project_situations_url, notice: "Project situation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_situation
      @project_situation = ProjectSituation.find(params[:id])
    end
    def set_which_date
      if params[:which_date]
        @which_date = params[:which_date]
      else
        @which_date = 'advance'
      end
    end
    
    # Only allow a list of trusted parameters through.
    def project_situation_params
      params.require(:project_situation).permit(:advance_invoice_date, :advance_invoice_number, :advance_payment_date, :advance_payment, :advance_month, :advance_year, :closure_invoice_date, :closure_invoice_number, :closure_payment_date, :closure_payment, :closure_month, :closure_year, :project_id)
    end
end
