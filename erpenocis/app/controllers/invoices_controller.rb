class InvoicesController < ApplicationController
  before_action :set_invoice, only: %i[ show edit update destroy ]
  before_action :set_dates_params
  # GET /invoices or /invoices.json
  def index
    @invoices = Invoice.between_dates(set_start_date(@start_month, @start_year),set_end_date(@end_month, @end_year))
    @users = User.all
  end

  # GET /invoices/1 or /invoices/1.json
  def show
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new(invoice_date: Date.today())
  end

  # GET /invoices/1/edit
  def edit
  end

  # POST /invoices or /invoices.json
  def create
    @invoice = Invoice.new(invoice_params)
    @invoice.code = generate_code(3)
    while Invoice.find_by(code: @invoice.code) do
      @invoice.code = generate_code(3) 
    end 
    respond_to do |format|
      if  @invoice.save
        format.html { redirect_to invoices_path(sm: @start_month, sy: @start_year, em: @end_month, ey: @end_year), notice: "Invoice was successfully created." }
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
        format.html { redirect_to invoices_path(sm: @start_month, sy: @start_year, em: @end_month, ey: @end_year), notice: "Invoice was successfully updated." }
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
      format.html { redirect_to invoices_path(sm: @start_month, sy: @start_year, em: @end_month, ey: @end_year), notice: "Invoice was successfully destroyed." }
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
      x = @invoice.project.name.gsub(/\W+/, '')[0,4]
      charset = Array('A'..'Z') 
      x + "_"+ Array.new(number) { charset.sample }.join
      
    end
    # def check_sum(invoice)
    #   invoice.invoice_value_without_vat - Invoice.where(invoice_number: invoice.invoice_number, invoice_date: invoice.invoice_date, invoice_value_without_vat: invoice.invoice_value_without_vat).sum(:invoice_value_for_project_without_vat) - invoice.invoice_value_for_project_without_vat > 0
    # end
end
