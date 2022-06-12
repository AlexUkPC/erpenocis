class ExpenseImportsController < ApplicationController
  def new
    @expense_import = ExpenseImport.new
  end

  def create
    begin
      @expense_import = ExpenseImport.new(params[:expense_import])
      if @expense_import.save
        redirect_to expenses_path(expense_type: params[:expense_import][:expense_type]), notice: "Imported expenses successfully."
      else
        render :new
      end
    rescue => exception
      render :action => 'new', status: :unprocessable_entity
    end
    
  end
end