class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show edit update destroy add_project_costs update_project_costs]

  # GET /projects or /projects.json
  def index
    @projects = Project.where(stoc: false)
    @users = User.all
    
  end

  # GET /projects/1 or /projects/1.json
  def show
    @invoices = Invoice.where(:project_id => @project.id)
    @orders = Order.where(:project_id => @project.id)
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects or /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to project_url(@project), notice: "Project was successfully created." }
        format.json { render :show, status: :created, location: @project }
        project_situation = ProjectSituation.new(project_id: @project.id)
        project_situation.save
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
    
  end
  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to project_url(@project), notice: "Project was successfully updated." }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url, notice: "Project was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def index_project_costs
    @projects = Project.where(stoc: false)
  end
  
  def add_project_costs

  end
  def update_project_costs
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to index_project_costs_url, notice: "Costuri proiecte modificate cu success." }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.require(:project).permit(:name, :start_date, :end_date, :value, :obs, :stoc, :user_id, project_costs_attributes: [:id, :amount, :month, :year, :_destroy])
    end
end
