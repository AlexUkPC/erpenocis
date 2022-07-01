class ExpensesController < ApplicationController
  before_action :set_expense, only: %i[ show edit update destroy ]
  before_action :set_dates_params, :set_table_head
  # GET /expenses or /expenses.json
  def index
    @expense_type = params[:expense_type]
    expense_id = params[:expense_id]
    expense_value_id = params[:expense_value_id]
    expense_value = params[:expense_value]
    if expense_value
      @expense_value = ExpenseValue.new(date: "01/"+params[:current_month]+"/"+params[:current_year])
    end
    if !@expense_type.nil?
      @total_per_months = []
      @months.times do |month|
        @total_per_months[month]=0
      end
      @grand_total = 0
      
      @expenses = Expense.where(expense_type: @expense_type).eager_load(:expense_values).order("expenses.id ASC, expense_values.date ASC")
      if !expense_id.nil?
        @expense = Expense.find(expense_id)
        if !expense_value_id.nil?
          @expense_value = ExpenseValue.find(expense_value_id)
        end
      else
        @expense = Expense.new(expense_type: @expense_type)
      end
      
      @expense.expense_values.build
      # @expense_values = ExpenseValue.where(expense_id: @expenses.ids)
    else
      @expenses = Expense.all
      @expense = Expense.new()
    end
  end
  
  # GET /expenses/1 or /expenses/1.json
  def show
  end

  # GET /expenses/new
  def new
    @expense = Expense.new
  end

  # GET /expenses/1/edit
  def edit
  end

  # POST /expenses or /expenses.json
  def create
    @expense = Expense.new(expense_params)
    respond_to do |format|
      if @expense.save
        expense_value = expense_params[:expense_values_attributes]["0"]
        Record.create(record_type: "Adaugare", location: @expense.expense_type=="investitii" || @expense.expense_type=="alte_cheltuieli"  ? @expense.expense_type.titleize : "Cheltuieli "+ @expense.expense_type.titleize, model_id: @expense.id, initial_data: "", modified_data: "Denumire cheltuiala: #{@expense.name} | Suma: #{expense_value[:value]} | Data cheltuiala: #{expense_value[:date]} | Data scadenta: #{expense_value[:due_date]} | Taxe stat/TVA?: #{expense_value[:vat_taxes]==1 ? "da" : "nu"}", user_id: current_user.id)
        format.html { redirect_to expenses_path(expense_type: @expense.expense_type, sm: @start_month, sy: @start_year, em: @end_month, ey: @end_year), notice: "Expense was successfully created." }
        format.json { render :show, status: :created, location: @expense }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expenses/1 or /expenses/1.json
  def update
    @old_info_expense = @expense.dup
    @old_info_expense_value = @expense.expense_values.find_by_id(expense_params[:expense_values_attributes]["0"][:id])
    respond_to do |format|
      if @expense.update(expense_params)
        old_s = ""
        s = ""
        if @old_info_expense.name != @expense.name
          old_s += "Denumire cheltuiala: #{@old_info_expense.name} | "
          s += "Denumire cheltuiala: #{@expense.name} | "
        end
        if s!="" || old_s != ""
          Record.create(record_type: "Modificare", location: @expense.expense_type=="investitii" || @expense.expense_type=="alte_cheltuieli"  ? @expense.expense_type.titleize : "Cheltuieli "+ @expense.expense_type.titleize, model_id: @expense.id, initial_data: old_s[0..-3], modified_data: s[0..-3], user_id: current_user.id)
        end
        if expense_params[:expense_values_attributes]["0"][:id]
          @expense_value = @expense.expense_values.find_by_id(expense_params[:expense_values_attributes]["0"][:id])
          old_s = ""
          s = ""
          if @old_info_expense_value.value != @expense_value.value
            old_s += "Suma: #{@old_info_expense_value.value} | "
            s += "Suma: #{@expense_value.value} | "
          end
          if @old_info_expense_value.date != @expense_value.date
            old_s += "Data cheltuiala: #{@old_info_expense_value.date} | "
            s += "Data cheltuiala: #{@expense_value.date} | "
          end
          if @old_info_expense_value.due_date != @expense_value.due_date
            old_s += "Data scadenta: #{@old_info_expense_value.due_date} | "
            s += "Data scadenta: #{@expense_value.due_date} | "
          end
          if @old_info_expense_value.vat_taxes != @expense_value.vat_taxes
            old_s += "Taxe stat/TVA?: #{@old_info_expense_value.vat_taxes==1 ? "da" : "nu"} | "
            s += "Taxe stat/TVA?: #{@expense_value.vat_taxes==1 ? "da" : "nu"} | "
          end
          if s!="" || old_s != ""
            Record.create(record_type: "Modificare", location: @expense.expense_type=="investitii" || @expense.expense_type=="alte_cheltuieli"  ? @expense.expense_type.titleize : "Cheltuieli "+ @expense.expense_type.titleize, model_id: @expense.id, initial_data: old_s[0..-3], modified_data: s[0..-3], user_id: current_user.id)
          end
        else
          expense_value = expense_params[:expense_values_attributes]["0"]
          Record.create(record_type: "Adaugare", location: @expense.expense_type=="investitii" || @expense.expense_type=="alte_cheltuieli"  ? @expense.expense_type.titleize : "Cheltuieli "+ @expense.expense_type.titleize, model_id: @expense.id, initial_data: "", modified_data: "Suma: #{expense_value[:value]} | Data cheltuiala: #{expense_value[:date]} | Data scadenta: #{expense_value[:due_date]} | Taxe stat/TVA?: #{expense_value[:vat_taxes]==1 ? "da" : "nu"}", user_id: current_user.id)
        end
        format.html { redirect_to expenses_path(expense_type: @expense.expense_type, sm: @start_month, sy: @start_year, em: @end_month, ey: @end_year), notice: "Expense was successfully updated." }
        format.json { render :show, status: :ok, location: @expense }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expenses/1 or /expenses/1.json
  def destroy
    @expense.destroy
    Record.create(record_type: "Stergere", location: @expense.expense_type=="investitii" || @expense.expense_type=="alte_cheltuieli"  ? @expense.expense_type.titleize : "Cheltuieli "+ @expense.expense_type.titleize, model_id: @expense.id, initial_data: "Denumire cheltuiala: #{@expense.name}", modified_data: "", user_id: current_user.id)
    respond_to do |format|
      format.html { redirect_to expenses_path(expense_type: @expense.expense_type, sm: @start_month, sy: @start_year, em: @end_month, ey: @end_year), notice: "Expense was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def expense_params
      params.require(:expense).permit(:name, :expense_type, expense_values_attributes: [:id, :value, :date, :due_date, :vat_taxes, :_destroy])
    end
end
