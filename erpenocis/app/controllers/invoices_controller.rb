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
        Record.create(record_type: "Adaugare", location: "Facturi", model_id: @invoice.id, initial_data: "", modified_data: "Proiect: #{@invoice.project.name} | Descriere: #{@invoice.description} | Categorie: #{@invoice.category} | Furnizor: #{@invoice.supplier} | Nr. factura: #{@invoice.invoice_number} | Data factura: #{@invoice.invoice_date} | Valoare factura fara TVA: #{@invoice.invoice_value_without_vat} | Valoare factura pt proiect fara TVA: #{@invoice.invoice_value_for_project_without_vat}| Observatii: #{@invoice.obs}", user_id: current_user.id)
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
    @old_info_invoice = Invoice.find_by_id(@invoice.id).dup
    respond_to do |format|
      if @invoice.update(invoice_params)
        old_s = ""
        s = ""
        if @old_info_invoice.project_id != @invoice.project_id
          old_s += "Proiect: #{@old_info_invoice.project.name} | "
          s += "Proiect: #{@invoice.project.name} | "
        end
        if @old_info_invoice.description != @invoice.description
          old_s += "Descriere: #{@old_info_invoice.description} | "
          s += "Descriere: #{@invoice.description} | "
        end
        if @old_info_invoice.category != @invoice.category
          old_s += "Categorie: #{@old_info_invoice.category} | "
          s += "Categorie: #{@invoice.category} | "
        end
        if @old_info_invoice.supplier != @invoice.supplier
          old_s += "Furnizor: #{@old_info_invoice.supplier} | "
          s += "Furnizor: #{@invoice.supplier} | "
        end
        if @old_info_invoice.invoice_number != @invoice.invoice_number
          old_s += "Nr. factura: #{@old_info_invoice.invoice_number} | "
          s += "Nr. factura: #{@invoice.invoice_number} | "
        end
        if @old_info_invoice.invoice_date != @invoice.invoice_date
          old_s += "Data factura: #{@old_info_invoice.invoice_date} | "
          s += "Data factura: #{@invoice.invoice_date} | "
        end
        if @old_info_invoice.invoice_value_without_vat != @invoice.invoice_value_without_vat
          old_s += "Valoare factura fara TVA: #{@old_info_invoice.invoice_value_without_vat} | "
          s += "Valoare factura fara TVA: #{@invoice.invoice_value_without_vat} | "
        end
        if @old_info_invoice.invoice_value_for_project_without_vat != @invoice.invoice_value_for_project_without_vat
          old_s += "Valoare factura pt proiect fara TVA: #{@old_info_invoice.invoice_value_for_project_without_vat} | "
          s += "Valoare factura pt proiect fara TVA: #{@invoice.invoice_value_for_project_without_vat} | "
        end
        if @old_info_invoice.obs != @invoice.obs
          old_s += "Observatii: #{@old_info_invoice.obs} | "
          s += "Observatii: #{@invoice.obs} | "
        end
        if s!="" || old_s != ""
          Record.create(record_type: "Modificare", location: "Facturi", model_id: @invoice.id, initial_data: old_s[0..-3], modified_data: s[0..-3], user_id: current_user.id)
        end
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
    Record.create(record_type: "Stergere", location: "Facturi", model_id: @invoice.id, initial_data: "Proiect: #{@invoice.project.name} | Descriere: #{@invoice.description} | Categorie: #{@invoice.category} | Furnizor: #{@invoice.supplier} | Nr. factura: #{@invoice.invoice_number} | Data factura: #{@invoice.invoice_date} | Valoare factura fara TVA: #{@invoice.invoice_value_without_vat} | Valoare factura pt proiect fara TVA: #{@invoice.invoice_value_for_project_without_vat}| Observatii: #{@invoice.obs}", modified_data: "", user_id: current_user.id)
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
