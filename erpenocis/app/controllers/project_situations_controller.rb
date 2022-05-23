class ProjectSituationsController < ApplicationController
  before_action :set_project_situation, only: %i[ show edit update destroy ]

  # GET /project_situations or /project_situations.json
  def index
    @project_situations = ProjectSituation.all
    @projects = Project.where(stoc: false)
    total_closure_payment = ProjectSituation.all.sum(:closure_payment)
    @total_advance_payment = ProjectSituation.all.sum(:advance_payment)
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
    respond_to do |format|
      if @project_situation.update(project_situation_params)
        format.html { redirect_to project_situations_path, notice: "Project situation was successfully updated." }
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

    # Only allow a list of trusted parameters through.
    def project_situation_params
      params.require(:project_situation).permit(:advance_invoice_date, :advance_invoice_number, :advance_payment_date, :advance_payment, :advance_month, :advance_year, :closure_invoice_date, :closure_invoice_number, :closure_payment_date, :closure_payment, :closure_month, :closure_year, :project_id)
    end
end
