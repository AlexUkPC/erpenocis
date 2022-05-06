class ExpenseValuesController < ApplicationController
  before_action :set_expense_value, only: %i[ show edit update destroy ]

  # GET /expense_values or /expense_values.json
  def index
    @expense_values = ExpenseValue.all
  end

  # GET /expense_values/1 or /expense_values/1.json
  def show
  end

  # GET /expense_values/new
  def new
    @expense_value = ExpenseValue.new
  end

  # GET /expense_values/1/edit
  def edit
  end

  # POST /expense_values or /expense_values.json
  def create
    @expense_value = ExpenseValue.new(expense_value_params)

    respond_to do |format|
      if @expense_value.save
        format.html { redirect_to expense_value_url(@expense_value), notice: "Expense value was successfully created." }
        format.json { render :show, status: :created, location: @expense_value }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @expense_value.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expense_values/1 or /expense_values/1.json
  def update
    respond_to do |format|
      if @expense_value.update(expense_value_params)
        format.html { redirect_to expense_value_url(@expense_value), notice: "Expense value was successfully updated." }
        format.json { render :show, status: :ok, location: @expense_value }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @expense_value.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expense_values/1 or /expense_values/1.json
  def destroy
    @expense_value.destroy

    respond_to do |format|
      format.html { redirect_to expense_values_url, notice: "Expense value was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense_value
      @expense_value = ExpenseValue.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def expense_value_params
      params.require(:expense_value).permit(:value, :date, :due_date, :vat_taxes, :expense_id)
    end
end
