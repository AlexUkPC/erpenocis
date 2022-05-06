class SupplierInvoicesController < ApplicationController
  before_action :set_supplier_invoice, only: %i[ show edit update destroy ]

  # GET /supplier_invoices or /supplier_invoices.json
  def index
    @supplier_invoices = SupplierInvoice.all
  end

  # GET /supplier_invoices/1 or /supplier_invoices/1.json
  def show
  end

  # GET /supplier_invoices/new
  def new
    @supplier_invoice = SupplierInvoice.new
  end

  # GET /supplier_invoices/1/edit
  def edit
  end

  # POST /supplier_invoices or /supplier_invoices.json
  def create
    @supplier_invoice = SupplierInvoice.new(supplier_invoice_params)

    respond_to do |format|
      if @supplier_invoice.save
        format.html { redirect_to supplier_invoice_url(@supplier_invoice), notice: "Supplier invoice was successfully created." }
        format.json { render :show, status: :created, location: @supplier_invoice }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @supplier_invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /supplier_invoices/1 or /supplier_invoices/1.json
  def update
    respond_to do |format|
      if @supplier_invoice.update(supplier_invoice_params)
        format.html { redirect_to supplier_invoice_url(@supplier_invoice), notice: "Supplier invoice was successfully updated." }
        format.json { render :show, status: :ok, location: @supplier_invoice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @supplier_invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /supplier_invoices/1 or /supplier_invoices/1.json
  def destroy
    @supplier_invoice.destroy

    respond_to do |format|
      format.html { redirect_to supplier_invoices_url, notice: "Supplier invoice was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supplier_invoice
      @supplier_invoice = SupplierInvoice.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def supplier_invoice_params
      params.require(:supplier_invoice).permit(:number, :value, :paid_amount, :date, :due_date, :supplier_id)
    end
end
