class ExpenseValueImportsController < ApplicationController
  def new
    @expense_value_import = ExpenseValueImport.new
    @expense_value_import.current_user = current_user
  end

  def create
    begin
      @expense_value_import = ExpenseValueImport.new(params[:expense_value_import])
      @expense_value_import.current_user = current_user
      if @expense_value_import.save
        redirect_to expenses_path(expense_type: params[:expense_value_import][:expense_type]), notice: "Imported expense values successfully."
      else
        render :new
      end
    rescue => exception
      render :action => 'new', status: :unprocessable_entity
    end
    
  end
end