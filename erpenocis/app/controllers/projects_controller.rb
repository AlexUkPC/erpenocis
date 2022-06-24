class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show edit update destroy add_project_costs update_project_costs]
  before_action :set_dates_params

  # GET /projects or /projects.json
  def index
    @projects = Project.where(stoc: false).between_dates(set_start_date(@start_month, @start_year),set_end_date(@end_month, @end_year)).order("id DESC")
    @users = User.all
  end

  # GET /projects/1 or /projects/1.json
  def show
    @invoices = Invoice.where(:project_id => @project.id).between_dates(set_start_date(@start_month, @start_year),set_end_date(@end_month, @end_year))
    @orders = Order.where(:project_id => @project.id).between_dates(set_start_date(@start_month, @start_year),set_end_date(@end_month, @end_year)).order("id DESC")
    @users = User.all
    @suppliers = Supplier.all
  end

  # GET /projects/new
  def new
    @project = Project.new(start_date: Date.today())
    if params[:st]
      @st = params[:st]
      @project.stoc = true
    end
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects or /projects.json
  def create
    @project = Project.new(project_params)
    respond_to do |format|
      if @project.save
        if params[:st]
          Record.create(record_type: "Adaugare", location: "Stocuri", model_id: @project.id, initial_data: "", modified_data: "Nume: #{@project.name} | Observatii: #{@project.obs}", user_id: current_user.id)
          format.html { redirect_to stock_url(sm: @start_month, sy: @start_year, em: @end_month, ey: @end_year), notice: "Stocul a fost creeat." }
          format.json { render :show, status: :created, location: @project }
        else
          Record.create(record_type: "Adaugare", location: "Proiecte", model_id: @project.id, initial_data: "", modified_data: "Nume proiect: #{@project.name} | Data inceput: #{@project.start_date} | Data finalizare: #{@project.end_date} | Valoare: #{@project.value} | Observatii: #{@project.obs}", user_id: current_user.id)
          format.html { redirect_to projects_url(sm: @start_month, sy: @start_year, em: @end_month, ey: @end_year), notice: "Proiectul a fost creeat." }
          format.json { render :show, status: :created, location: @project }
        end
        project_situation = ProjectSituation.new(project_id: @project.id)
        project_situation.save
        project_cost = ProjectCost.new(project_id: @project.id)
        project_cost.save
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
    
  end
  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    @old_info_project = @project.dup
    respond_to do |format|
      if @project.update(project_params)
        if params[:st]
          old_s = ""
          s = ""
          if @old_info_project.name != @project.name
            old_s += "Nume proiect: #{@old_info_project.name} | "
            s += "Nume proiect: #{@project.name} | "
          end
          if @old_info_project.obs != @project.obs
            old_s += "Observatii: #{@old_info_project.obs} | "
            s += "Observatii: #{@project.obs} | "
          end
          if s!="" || old_s != ""
            Record.create(record_type: "Modificare", location: "Stocuri", model_id: @project.id, initial_data: old_s[0..-3], modified_data: s[0..-3], user_id: current_user.id)
          end
          format.html { redirect_to stock_url(sm: @start_month, sy: @start_year, em: @end_month, ey: @end_year), notice: "Stocul a fost modificat." }
          format.json { render :show, status: :ok, location: @project }
        else
          old_s = ""
          s = ""
          if @old_info_project.name != @project.name
            old_s += "Nume proiect: #{@old_info_project.name} | "
            s += "Nume proiect: #{@project.name} | "
          end
          if @old_info_project.start_date != @project.start_date
            old_s += "Data inceput: #{@old_info_project.start_date} | "
            s += "Data inceput: #{@project.start_date} | "
          end
          if @old_info_project.end_date != @project.end_date
            old_s += "Data finalizare: #{@old_info_project.end_date} | "
            s += "Data finalizare: #{@project.end_date} | "
          end
          if @old_info_project.value != @project.value
            old_s += "Valoare: #{@old_info_project.value} | "
            s += "Valoare: #{@project.value} | "
          end
          if @old_info_project.obs != @project.obs
            old_s += "Observatii: #{@old_info_project.obs} | "
            s += "Observatii: #{@project.obs} | "
          end
          if s!="" || old_s != ""
            Record.create(record_type: "Modificare", location: "Proiecte", model_id: @project.id, initial_data: old_s[0..-3], modified_data: s[0..-3], user_id: current_user.id)
          end
          format.html { redirect_to projects_url(sm: @start_month, sy: @start_year, em: @end_month, ey: @end_year), notice: "Proiectul a fost modificat." }
          format.json { render :show, status: :ok, location: @project }
        end
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
      if params[:st]
        Record.create(record_type: "Stergere", location: "Stocuri", model_id: @project.id, initial_data: "Nume: #{@project.name} | Observatii: #{@project.obs}", modified_data: "", user_id: current_user.id)
        format.html { redirect_to stock_url(sm: @start_month, sy: @start_year, em: @end_month, ey: @end_year), notice: "Stocul a fost sters." }
        format.json { head :no_content }
      else
        Record.create(record_type: "Stergere", location: "Proiecte", model_id: @project.id, initial_data: "Nume proiect: #{@project.name} | Data inceput: #{@project.start_date} | Data finalizare: #{@project.end_date} | Valoare: #{@project.value} | Observatii: #{@project.obs}", modified_data: "", user_id: current_user.id)
        format.html { redirect_to projects_url(sm: @start_month, sy: @start_year, em: @end_month, ey: @end_year), notice: "Proiectul a fost sters." }
        format.json { head :no_content }
      end
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
