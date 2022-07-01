class SuppliersController < ApplicationController
  before_action :set_supplier, only: %i[ show edit update destroy ]
  before_action :set_current_tab
  before_action :set_dates_params, :set_table_head

  # GET /suppliers or /suppliers.json
  def index
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
        Record.create(record_type: "Adaugare", location: "Situatie furnizori", model_id: @supplier.id, initial_data: "", modified_data: "Nume furnizor: #{@supplier.name}", user_id: current_user.id)
        format.html { redirect_to suppliers_path(current_tab: @current_tab,sm: @start_month, sy: @start_year, em: @end_month, ey: @end_year), notice: "Supplier was successfully created." }
        format.json { render :show, status: :created, location: @supplier }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @supplier.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /suppliers/1 or /suppliers/1.json
  def update
    @old_info_supplier = @supplier.dup
    @old_info_supplier_invoices = []
    @old_info_supplier_invoice_payments = []
      @supplier.supplier_invoices.clone.map(&:clone).each do |supplier_invoice|
        @old_info_supplier_invoices.push(supplier_invoice.clone.freeze)
        supplier_invoice.supplier_invoice_payments.clone.map(&:clone).each do |supplier_invoice_payment|
          @old_info_supplier_invoice_payments.push(supplier_invoice_payment.clone.freeze)
        end
      end
    respond_to do |format|
      if @supplier.update(supplier_params)
        old_s = ""
        s = ""
        if @old_info_supplier.name != @supplier.name
          old_s += "Nume furnizor: #{@old_info_supplier.name} | "
          s += "Nume furnizor: #{@supplier.name} | "
        end
        if s!="" || old_s != ""
          Record.create(record_type: "Modificare", location: "Situatie furnizori - facturi", model_id: @supplier.id, initial_data: old_s[0..-3], modified_data: s[0..-3], user_id: current_user.id)
        end

        @supplier.supplier_invoices.each do |supplier_invoice|
          if @old_info_supplier_invoices.include? supplier_invoice
            old_info_supplier_invoice = @old_info_supplier_invoices.select{|h| supplier_invoice.id == h[:id]}
            old_s = ""
            s = ""
            if old_info_supplier_invoice[0].number != supplier_invoice.number
              old_s += "Numar factura: #{old_info_supplier_invoice[0].number} | "
              s += "Numar factura: #{supplier_invoice.number} | "
            end
            if old_info_supplier_invoice[0].value != supplier_invoice.value
              old_s += "Suma: #{old_info_supplier_invoice[0].value} | "
              s += "Suma: #{supplier_invoice.value} | "
            end
            if old_info_supplier_invoice[0].date != supplier_invoice.date
              old_s += "Data emiterii: #{old_info_supplier_invoice[0].date} | "
              s += "Data emiterii: #{supplier_invoice.date} | "
            end
            if old_info_supplier_invoice[0].due_date != supplier_invoice.due_date
              old_s += "Data scadenta: #{old_info_supplier_invoice[0].due_date} | "
              s += "Data scadenta: #{supplier_invoice.due_date} | "
            end
            if s!="" || old_s != ""
              Record.create(record_type: "Modificare", location: "Situatie furnizori - facturi", model_id: @supplier.id, initial_data: old_s[0..-3], modified_data: s[0..-3], user_id: current_user.id)
            end
          else
            Record.create(record_type: "Adaugare", location: "Situatie furnizori - facturi", model_id: @supplier.id, initial_data: "", modified_data: "Nume furnizor: #{@supplier.name} | Numar factura: #{supplier_invoice.number} | Suma: #{supplier_invoice.value} | Data emiterii: #{supplier_invoice.date} | Data scadenta: #{supplier_invoice.due_date}", user_id: current_user.id)
          end
          supplier_invoice.supplier_invoice_payments.each do |supplier_invoice_payment|
            if @old_info_supplier_invoice_payments.include? supplier_invoice_payment
              old_info_supplier_invoice_payment = @old_info_supplier_invoice_payments.select{|h| supplier_invoice_payment.id == h[:id]}
              old_s = ""
              s = ""
              if old_info_supplier_invoice_payment[0].paid_amount != supplier_invoice_payment.paid_amount
                old_s += "Suma platita: #{old_info_supplier_invoice_payment[0].paid_amount} | "
                s += "Suma platita: #{supplier_invoice_payment.paid_amount} | "
              end
              if old_info_supplier_invoice_payment[0].date != supplier_invoice_payment.date
                old_s += "Data platii: #{old_info_supplier_invoice_payment[0].date} | "
                s += "Data platii: #{supplier_invoice_payment.date} | "
              end
              if s!="" || old_s != ""
                Record.create(record_type: "Modificare", location: "Situatie furnizori - plati facturi", model_id: @supplier.id, initial_data: old_s[0..-3], modified_data: s[0..-3], user_id: current_user.id)
              end
            else
              Record.create(record_type: "Adaugare", location: "Situatie furnizori - plati facturi", model_id: @supplier.id, initial_data: "", modified_data: "Nume furnizor: #{@supplier.name} | Numar factura: #{supplier_invoice.number} | Suma platita: #{supplier_invoice_payment.paid_amount} | Data platii: #{supplier_invoice_payment.date}", user_id: current_user.id)
            end
          end
          @old_info_supplier_invoice_payments.each do |old_info_supplier_invoice_payment|
            if (!supplier_invoice.supplier_invoice_payments.include? old_info_supplier_invoice_payment) && old_info_supplier_invoice_payment.supplier_invoice_id == supplier_invoice.id
              Record.create(record_type: "Stergere", location: "Situatie furnizori - plati facturi", model_id: @supplier.id, initial_data: "Nume furnizor: #{@supplier.name} | Numar factura: #{supplier_invoice.number} | Suma platita: #{old_info_supplier_invoice_payment.paid_amount} | Data platii: #{old_info_supplier_invoice_payment.date}", modified_data: "", user_id: current_user.id)
            end
          end
        end
        @old_info_supplier_invoices.each do |old_info_supplier_invoice|
          if !@supplier.supplier_invoices.include? old_info_supplier_invoice
            Record.create(record_type: "Stergere", location: "Situatie furnizori - facturi", model_id: @supplier.id, initial_data: "Nume furnizor: #{@supplier.name} | Numar factura: #{old_info_supplier_invoice.number} | Suma: #{old_info_supplier_invoice.value} | Data emiterii: #{old_info_supplier_invoice.date} | Data scadenta: #{old_info_supplier_invoice.due_date}", modified_data: "", user_id: current_user.id)
          end
        end

        format.html { redirect_to suppliers_path(current_tab: @current_tab, sm: @start_month, sy: @start_year, em: @end_month, ey: @end_year), notice: "Supplier was successfully updated." }
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
    Record.create(record_type: "Stergere", location: "Situatie furnizori", model_id: @supplier.id, initial_data: "Nume furnizor: #{@supplier.name}", modified_data: "", user_id: current_user.id)
    respond_to do |format|
      format.html { redirect_to suppliers_path(current_tab: @current_tab,sm: @start_month, sy: @start_year, em: @end_month, ey: @end_year), notice: "Supplier was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supplier
      @supplier = Supplier.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def supplier_params
      params.require(:supplier).permit(:name,supplier_invoices_attributes:[:id, :number, :value, :date, :due_date, :supplier_id, :_destroy, supplier_invoice_payments_attributes:[:id, :paid_amount, :date, :_destroy]])
    end
end
