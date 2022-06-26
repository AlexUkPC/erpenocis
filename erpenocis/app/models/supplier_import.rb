class SupplierImport
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
    if imported_suppliers.compact.map(&:valid?).all?
      imported_suppliers.compact.each do |supplier|
        if Supplier.find_by_id(supplier.id)
          old_info_supplier = Supplier.find_by_id(supplier.id).dup
          if supplier.save
            old_s = ""
            s = ""
            if old_info_supplier.name != supplier.name
              old_s += "Nume furnizor: #{old_info_supplier.name} | "
              s += "Nume furnizor: #{supplier.name} | "
            end
            if s!="" || old_s != ""
              Record.create(record_type: "Modificare prin import", location: "Situatie furnizori", model_id: supplier.id, initial_data: old_s[0..-3], modified_data: s[0..-3], user_id: current_user.id)
            end
          end
        else
          if supplier.save
            Record.create(record_type: "Adaugare prin import", location: "Situatie furnizori", model_id: supplier.id, initial_data: "", modified_data: "Nume furnizor: #{supplier.name}", user_id: current_user.id)
          end
        end
      end
      true
    else
      imported_suppliers.each_with_index do |supplier, index|
        supplier.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+3}: #{message}"
        end
      end
      false
    end
  end

  def imported_suppliers
    @imported_suppliers ||= load_imported_suppliers
  end

  def load_imported_suppliers
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(2)
    header.each_with_index do |x,i|
      case x.downcase
        when "id"
          header[i]="id"
        when "nume furnizor"
          header[i]="name"
        else      
      end
    end
    if (header.include? "id") && (header.include? "name")
      (3..spreadsheet.last_row).map do |i|
        if spreadsheet.cell(i,2) != "Total" && spreadsheet.cell(i,2).to_s!=""
          row = Hash[[header, spreadsheet.row(i)].transpose]
          supplier = Supplier.find_by_id(row["id"]) || Supplier.new
          supplier.attributes = row.to_hash.slice(*Supplier.accessible_attributes)
          supplier
        end
      end
    else
      errors.add :base, "Fisieru nu contine coloanele corespunzatoare. Acestea ar trebui sa fie: Id | Nume furnizor "
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