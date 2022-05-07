class InvoicesController < ApplicationController
  before_action :set_invoice, only: %i[ show edit update destroy ]
  # GET /invoices or /invoices.json
  def index
    @invoices = Invoice.all
    @users = User.all
  end

  # GET /invoices/1 or /invoices/1.json
  def show
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
  end

  # GET /invoices/1/edit
  def edit
  end

  # POST /invoices or /invoices.json
  def create
    @invoice = Invoice.new(invoice_params)
    @invoice.code = generate_code(8)
    while Invoice.find_by(code: @invoice.code) do
      @invoice.code = generate_code(8) 
    end 
    respond_to do |format|
      if  @invoice.save
        format.html { redirect_to invoice_url(@invoice), notice: "Invoice was successfully created." }
        format.json { render :show, status: :created, location: @invoice }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end      
    end
  end

  # PATCH/PUT /invoices/1 or /invoices/1.json
  def update
    respond_to do |format|
      if @invoice.update(invoice_params)
        format.html { redirect_to invoice_url(@invoice), notice: "Invoice was successfully updated." }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1 or /invoices/1.json
  def destroy
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to invoices_url, notice: "Invoice was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def invoice_params
      params.require(:invoice).permit(:description, :category, :supplier, :invoice_number, :invoice_date, :invoice_value_without_vat, :invoice_value_for_project_without_vat, :code, :obs, :project_id, :user_id)
    end
    def generate_code(number)
      charset = Array('A'..'Z') 
      Array.new(number) { charset.sample }.join
    end
    # def check_sum(invoice)
    #   invoice.invoice_value_without_vat - Invoice.where(invoice_number: invoice.invoice_number, invoice_date: invoice.invoice_date, invoice_value_without_vat: invoice.invoice_value_without_vat).sum(:invoice_value_for_project_without_vat) - invoice.invoice_value_for_project_without_vat > 0
    # end
end
