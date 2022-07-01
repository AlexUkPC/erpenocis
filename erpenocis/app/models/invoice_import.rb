class InvoiceImport
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  attr_accessor :file
  attr_accessor :project_id
  attr_accessor :proj_id
  attr_accessor :show
  attr_accessor :st
  attr_accessor :current_user
  require 'roo'
  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def save
    if imported_invoices.compact.map(&:valid?).all?
      imported_invoices.compact.each do |invoice|
        if Invoice.find_by_id(invoice.id)
          old_info_invoice = Invoice.find_by_id(invoice.id).dup
          if invoice.save
            old_s = ""
            s = ""
            if old_info_invoice.project_id != invoice.project_id
              old_s += "Proiect: #{old_info_invoice.project.name} | "
              s += "Proiect: #{invoice.project.name} | "
            end
            if old_info_invoice.description != invoice.description
              old_s += "Descriere: #{old_info_invoice.description} | "
              s += "Descriere: #{invoice.description} | "
            end
            if old_info_invoice.category != invoice.category
              old_s += "Categorie: #{old_info_invoice.category} | "
              s += "Categorie: #{invoice.category} | "
            end
            if old_info_invoice.supplier != invoice.supplier
              old_s += "Furnizor: #{old_info_invoice.supplier} | "
              s += "Furnizor: #{invoice.supplier} | "
            end
            if old_info_invoice.invoice_number != invoice.invoice_number
              old_s += "Nr. factura: #{old_info_invoice.invoice_number} | "
              s += "Nr. factura: #{invoice.invoice_number} | "
            end
            if old_info_invoice.invoice_date != invoice.invoice_date
              old_s += "Data factura: #{old_info_invoice.invoice_date} | "
              s += "Data factura: #{invoice.invoice_date} | "
            end
            if old_info_invoice.invoice_value_without_vat != invoice.invoice_value_without_vat
              old_s += "Valoare factura fara TVA: #{old_info_invoice.invoice_value_without_vat} | "
              s += "Valoare factura fara TVA: #{invoice.invoice_value_without_vat} | "
            end
            if old_info_invoice.invoice_value_for_project_without_vat != invoice.invoice_value_for_project_without_vat
              old_s += "Valoare factura pt proiect fara TVA: #{old_info_invoice.invoice_value_for_project_without_vat} | "
              s += "Valoare factura pt proiect fara TVA: #{invoice.invoice_value_for_project_without_vat} | "
            end
            if old_info_invoice.obs != invoice.obs
              old_s += "Observatii: #{old_info_invoice.obs} | "
              s += "Observatii: #{invoice.obs} | "
            end
            if s!="" || old_s != ""
              Record.create(record_type: "Modificare prin import", location: "Facturi", model_id: invoice.id, initial_data: old_s[0..-3], modified_data: s[0..-3], user_id: current_user.id)
            end
          end
        else
          if invoice.save
            Record.create(record_type: "Adaugare prin import", location: "Facturi", model_id: invoice.id, initial_data: "", modified_data: "Proiect: #{invoice.project.name} | Descriere: #{invoice.description} | Categorie: #{invoice.category} | Furnizor: #{invoice.supplier} | Nr. factura: #{invoice.invoice_number} | Data factura: #{invoice.invoice_date} | Valoare factura fara TVA: #{invoice.invoice_value_without_vat} | Valoare factura pt proiect fara TVA: #{invoice.invoice_value_for_project_without_vat}| Observatii: #{invoice.obs}", user_id: current_user.id)
          end
        end
      end
      true
    else
      imported_invoices.each_with_index do |invoice, index|
        invoice.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+3}: #{message}"
        end
      end
      false
    end
  end

  def imported_invoices
    @imported_invoices ||= load_imported_invoices
  end

  def load_imported_invoices
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(2)
    header.each_with_index do |x,i|
      case x.downcase
      when "id"
        header[i]="id"
      when "descriere"
        header[i]="description"
      when "categorie"
        header[i]="category"
      when "nume furnizor"
        header[i]="supplier"
      when "nr. factura"
        header[i]="invoice_number"
      when "data factura"
        header[i]="invoice_date"
      when "valoare factura fara tva"
        header[i]="invoice_value_without_vat"
      when "valoare pt proiect fara tva"
        header[i]="invoice_value_for_project_without_vat"
      when "observatii"
        header[i]="obs"
      else      
      end
    end
    if (header.include? "id") && (header.include? "description") && (header.include? "category") && (header.include? "supplier") && (header.include? "invoice_number") && (header.include? "invoice_date") && (header.include? "invoice_value_without_vat") && (header.include? "invoice_value_for_project_without_vat") && (header.include? "obs")
      (3..spreadsheet.last_row).map do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        invoice = Invoice.find_by_id(row["id"]) || Invoice.new
        invoice.attributes = row.to_hash.slice(*Invoice.accessible_attributes)
        invoice.user_id = current_user.id
        invoice.project_id = project_id
        if !Invoice.find_by_id(row["id"])
          invoice.code = generate_code(3)
          while Invoice.find_by(code: invoice.code) do
            invoice.code = generate_code(3) 
          end 
        end
        if invoice.invoice_value_without_vat==""
          invoice.invoice_value_without_vat = 0
        else
          invoice.invoice_value_without_vat = invoice.invoice_value_without_vat.to_f
        end
        if invoice.invoice_value_for_project_without_vat==""
          invoice.invoice_value_for_project_without_vat = 0
        else
          invoice.invoice_value_for_project_without_vat = invoice.invoice_value_for_project_without_vat.to_f
        end
        invoice
      end
    else
      errors.add :base, "Fisieru nu contine coloanele corespunzatoare. Acestea ar trebui sa fie: Id | Descriere | Categorie | Nume furnizor | Nr. factura | Data factura | Valoare factura fara TVA | Valoare pt proiect fara TVA | Observatii"
    end
  end

  def open_spreadsheet
    case File.extname(file.original_filename)
    # when ".csv" then Roo::Csv.new(file.path)
    when ".xls" then Roo::Excel.new(file.path)
    when ".xlsx" then Roo::Excelx.new(file.path)
    else 
      errors.add :base, "Extensie fisier nepermisa. Puteti incarca doar fisiere xls sau xlsx"
      raise "Unknown file type: #{file.original_filename}"
    end
  end
  def generate_code(number)
    x = Project.find_by_id(project_id).name.gsub(/\W+/, '')[0,4]
    charset = Array('A'..'Z') 
    x + "_"+ Array.new(number) { charset.sample }.join
    
  end
end