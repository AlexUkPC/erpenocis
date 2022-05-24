class ProjectCostsController < ApplicationController
  before_action :set_project, only: %i[ show edit update destroy ]
  before_action :set_dates_params

  # GET /project_costs or /project_costs.json
  def index
    @project_costs = ProjectCost.between_dates(@start_month, @end_month, @start_year, @end_year)
    @projects = Project.where(stoc: false).where(project_costs: @project_costs)
  end

  # GET /project_costs/1 or /project_costs/1.json
  def show
  end

  # GET /project_costs/new
  def new
    # @project_cost = ProjectCost.new
  end

  # GET /project_costs/1/edit
  def edit
  end

  # POST /project_costs or /project_costs.json
  def create
    # @project_cost = ProjectCost.new(project_cost_params)

    # respond_to do |format|
    #   if @project_cost.save
    #     format.html { redirect_to project_cost_url(@project_cost), notice: "Project cost was successfully created." }
    #     format.json { render :show, status: :created, location: @project_cost }
    #   else
    #     format.html { render :new, status: :unprocessable_entity }
    #     format.json { render json: @project_cost.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /project_costs/1 or /project_costs/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        if @project.project_costs.empty?
          project_cost = ProjectCost.new(project_id: @project.id)
          project_cost.save
        end
        format.html { redirect_to project_costs_url(sm: @start_month, sy: @start_year, em: @end_month, ey: @end_year), notice: "Costuri proiecte modificate cu success." }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_costs/1 or /project_costs/1.json
  def destroy
    # @project_cost.destroy

    # respond_to do |format|
    #   format.html { redirect_to project_costs_url, notice: "Project cost was successfully destroyed." }
    #   format.json { head :no_content }
    # end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.require(:project).permit(:name, :start_date, :end_date, :value, :obs, :stoc, :user_id, project_costs_attributes:[:id, :amount, :month, :year, :_destroy])
    end
end
