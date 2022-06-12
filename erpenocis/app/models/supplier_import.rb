class SupplierImport
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  attr_accessor :file
  require 'roo'
  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def save
    if imported_suppliers.compact.map(&:valid?).all?
      imported_suppliers.compact.each(&:save!)
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
      errors.add :base, "Fisieru nu contine coloanele corespunzatoare. Acestea ar trebui sa fie: ID | Nume furnizor "
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