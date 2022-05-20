class SuppliersController < ApplicationController
  before_action :set_supplier, only: %i[ show edit update destroy ]
  before_action :set_date_params, only: %i[index new edit]

  # GET /suppliers or /suppliers.json
  def index
    
    @months = (@end_year - @start_year) * 12 + @end_month - @start_month + 1
    @supplier_invoices = {}
    @suppliers = Supplier.all
  end

  # GET /suppliers/1 or /suppliers/1.json
  def show
  end

  # GET /suppliers/new
  def new
    @supplier = Supplier.new
  end

  # GET /suppliers/1/edit
  def edit
    from_where = params[:from_where]
    current_month = params[:current_month]
    current_year = params[:current_year]
    if from_where=="issued_supplier_invoices"
      @supplier_invoices = SupplierInvoice.where(supplier_id: @supplier.id).created_between(Date.parse(current_year.to_s+'-'+current_month.to_s+'-01'),Date.parse(current_year.to_s+'-'+current_month.to_s+'-01').next_month-1.day).order("date ASC")
    elsif from_where=="to_be_payed_supplier_invoices"
      @supplier_invoices = SupplierInvoice.where(supplier_id: @supplier.id).created_between_due_date(Date.parse(current_year.to_s+'-'+current_month.to_s+'-01'),Date.parse(current_year.to_s+'-'+current_month.to_s+'-01').next_month-1.day).order("date ASC")
    elsif from_where=="payed_supplier_invoices"
      @supplier_invoice_payments = SupplierInvoicePayment.created_between(Date.parse(current_year.to_s+'-'+current_month.to_s+'-01'),Date.parse(current_year.to_s+'-'+current_month.to_s+'-01').next_month-1.day).order("date ASC")
      @supplier_invoices = SupplierInvoice.where(supplier_id: @supplier.id,supplier_invoice_payments: @supplier_invoice_payments)
    elsif from_where=="unpaid_supplier_invoices"
      
      @supplier_invoices = SupplierInvoice.where(supplier_id: @supplier.id).created_between_due_date(Date.parse(current_year.to_s+'-'+current_month.to_s+'-01'),Date.parse(current_year.to_s+'-'+current_month.to_s+'-01').next_month-1.day).order("date ASC")
      # @supplier_invoice_payments = SupplierInvoicePayment.where(supplier_invoice_id: @supplier_invoices.ids)

      # @supplier_invoices = @supplier_invoices.where.not(value: @supplier_invoice_payments.map(&:paid_amount).sum)
     
    end
  end

  # POST /suppliers or /suppliers.json
  def create
    @supplier = Supplier.new(supplier_params)

    respond_to do |format|
      if @supplier.save
        format.html { redirect_to suppliers_path(current_tab: params[:current_tab],start_month: params[:start_month], start_year: params[:start_year], end_month: params[:end_month], end_year: params[:end_year]), notice: "Supplier was successfully created." }
        format.json { render :show, status: :created, location: @supplier }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @supplier.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /suppliers/1 or /suppliers/1.json
  def update
    respond_to do |format|
      if @supplier.update(supplier_params)
        format.html { redirect_to suppliers_path(current_tab: params[:current_tab], start_month: params[:start_month], start_year: params[:start_year], end_month: params[:end_month], end_year: params[:end_year]), notice: "Supplier was successfully updated." }
        format.json { render :show, status: :ok, location: @supplier }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @supplier.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /suppliers/1 or /suppliers/1.json
  def destroy
    @supplier.destroy

    respond_to do |format|
      format.html { redirect_to suppliers_path(current_tab: params[:current_tab],start_month: params[:start_month], start_year: params[:start_year], end_month: params[:end_month], end_year: params[:end_year]), notice: "Supplier was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supplier
      @supplier = Supplier.find(params[:id])
    end

    def set_date_params
      @start_month = params[:start_month].to_i
      @start_year = params[:start_year].to_i
      @end_month = params[:end_month].to_i
      @end_year = params[:end_year].to_i
      @current_tab = params[:current_tab]
    end

    # Only allow a list of trusted parameters through.
    def supplier_params
      params.require(:supplier).permit(:name,supplier_invoices_attributes:[:id, :number, :value, :date, :due_date, :supplier_id, :_destroy, supplier_invoice_payments_attributes:[:id, :paid_amount, :date, :_destroy]])
    end
end
