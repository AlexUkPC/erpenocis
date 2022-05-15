class ExpensesController < ApplicationController
  before_action :set_expense, only: %i[ show edit update destroy ]

  # GET /expenses or /expenses.json
  def index
    expense_type = params[:expense_type]
    expense_id = params[:expense_id]
    expense_value_id = params[:expense_value_id]
    expense_value = params[:expense_value]
    @start_month = params[:start_month].to_i
    @start_year = params[:start_year].to_i
    @end_month = params[:end_month].to_i
    @end_year = params[:end_year].to_i
    @months = (@end_year - @start_year) * 12 + @end_month - @start_month + 1
    if expense_value
      @expense_value = ExpenseValue.new(date: "01/"+params[:current_month]+"/"+params[:current_year])
    end
    if !expense_type.nil?
      @expenses = Expense.where(expense_type: expense_type)
      if !expense_id.nil?
        @expense = Expense.find(expense_id)
        if !expense_value_id.nil?
          @expense_value = ExpenseValue.find(expense_value_id)
        end
      else
        @expense = Expense.new(expense_type: expense_type)
      end
      
      @expense.expense_values.build
      @expense_values = ExpenseValue.where(expense_id: @expenses.ids)
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
        format.html { redirect_to expenses_path(expense_type: @expense.expense_type, start_month: params[:start_month], start_year: params[:start_year], end_month: params[:end_month], end_year: params[:end_year]), notice: "Expense was successfully created." }
        format.json { render :show, status: :created, location: @expense }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expenses/1 or /expenses/1.json
  def update
    respond_to do |format|
      if @expense.update(expense_params)
        format.html { redirect_to expenses_path(expense_type: @expense.expense_type, start_month: params[:start_month], start_year: params[:start_year], end_month: params[:end_month], end_year: params[:end_year]), notice: "Expense was successfully updated." }
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

    respond_to do |format|
      format.html { redirect_to expenses_path(expense_type: @expense.expense_type, start_month: params[:start_month], start_year: params[:start_year], end_month: params[:end_month], end_year: params[:end_year]), notice: "Expense was successfully destroyed." }
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
