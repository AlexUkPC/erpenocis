class ProjectCostsController < ApplicationController
  before_action :set_project_cost, only: %i[ show edit update destroy ]

  # GET /project_costs or /project_costs.json
  def index
    @project_costs = ProjectCost.all
  end

  # GET /project_costs/1 or /project_costs/1.json
  def show
  end

  # GET /project_costs/new
  def new
    @project_cost = ProjectCost.new
  end

  # GET /project_costs/1/edit
  def edit
  end

  # POST /project_costs or /project_costs.json
  def create
    @project_cost = ProjectCost.new(project_cost_params)

    respond_to do |format|
      if @project_cost.save
        format.html { redirect_to project_cost_url(@project_cost), notice: "Project cost was successfully created." }
        format.json { render :show, status: :created, location: @project_cost }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project_cost.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /project_costs/1 or /project_costs/1.json
  def update
    respond_to do |format|
      if @project_cost.update(project_cost_params)
        format.html { redirect_to project_cost_url(@project_cost), notice: "Project cost was successfully updated." }
        format.json { render :show, status: :ok, location: @project_cost }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project_cost.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_costs/1 or /project_costs/1.json
  def destroy
    @project_cost.destroy

    respond_to do |format|
      format.html { redirect_to project_costs_url, notice: "Project cost was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_cost
      @project_cost = ProjectCost.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def project_cost_params
      params.require(:project_cost).permit(:amount, :month, :year, :project_id)
    end
end
