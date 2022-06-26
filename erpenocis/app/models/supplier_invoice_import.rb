class SupplierInvoiceImport
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  attr_accessor :file
  attr_accessor :current_user
  require 'roo'
  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def save
    if imported_supplier_invoices.compact.map(&:valid?).all?
      imported_supplier_invoices.compact.each do |supplier_invoice|
        if supplier_invoice.save
          Record.create(record_type: "Adaugare prin import", location: "Situatie furnizori - facturi", model_id: supplier_invoice.supplier_id, initial_data: "", modified_data: "Furnizor: #{supplier_invoice.supplier.name} | Numar factura: #{supplier_invoice.number} | Suma: #{supplier_invoice.value} | Data emiterii: #{supplier_invoice.date} | Data scadenta: #{supplier_invoice.due_date}", user_id: current_user.id)
        end
      end
      true
    else
      imported_supplier_invoices.each_with_index do |supplier_invoice, index|
        supplier_invoice.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+3}: #{message}"
        end
      end
      false
    end
  end

  def imported_supplier_invoices
    @imported_supplier_invoices ||= load_imported_supplier_invoices
  end

  def load_imported_supplier_invoices
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(2)
    header.each_with_index do |x,i|
      case x.downcase
        when "id furnizor"
          header[i]="id_supplier"
        when "numar factura"
          header[i]="number"
        when "suma factura"
          header[i]="value"
        when "data emiterii"
          header[i]="date"
        when "data scadenta"
          header[i]="due_date"
        else      
      end
    end
    if (header.include? "id_supplier") &&(header.include? "number") && (header.include? "value") && (header.include? "date") && (header.include? "due_date")
      @new = true
      (3..spreadsheet.last_row).map do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
          if Supplier.find_by_id(row["id_supplier"])
            supplier_invoice = SupplierInvoice.new
            supplier_invoice.supplier_id = row["id_supplier"]
            supplier_invoice.attributes = row.to_hash.slice(*SupplierInvoice.accessible_attributes) 
            if supplier_invoice.value==""
              supplier_invoice.value = 0
            else
              supplier_invoice.value = supplier_invoice.value.to_f
            end
            if supplier_invoice.date.to_s==""
              errors.add :base, "Randul #{i} - date emiterii necompletata"
              raise "No date"
            else
              if supplier_invoice.date < Date.parse('2020-01-01')
                errors.add :base, "Randul #{i} - data emiterii este inainte de 01.01.2020"
                raise "Wrong date"
              end
            end
            if supplier_invoice.due_date.to_s==""
              errors.add :base, "Randul #{i} - date scadenta necompletata"
              raise "No date"
            else
              if supplier_invoice.due_date < Date.parse('2020-01-01')
                errors.add :base, "Randul #{i} - data scadenta este inainte de 01.01.2020"
                raise "Wrong date"
              end
            end
            if supplier_invoice.value==""
              supplier_invoice.value=0
            else
              supplier_invoice.value=supplier_invoice.value.to_f
            end
              supplier_invoice 
          else
            if row["id_supplier"].to_s==""
              errors.add :base, "Randul #{i} - id furnizor necompletat" 
            else
              errors.add :base, "Randul #{i} - id furnizor inexistent in baza de date"
            end
          end
      end
    else
      errors.add :base, "Fisieru nu contine coloanele corespunzatoare. Acestea ar trebui sa fie: Id furnizor | Numar factura | Suma factura | Data emiterii | Data scadenta"
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
   
end