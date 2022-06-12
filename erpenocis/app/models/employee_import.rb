class EmployeeImport
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
    if imported_employees.compact.map(&:valid?).all?
      imported_employees.compact.each(&:save!)
      true
    else
      imported_employees.each_with_index do |employee, index|
        employee.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+3}: #{message}"
        end
      end
      false
    end
  end

  def imported_employees
    @imported_employees ||= load_imported_employees
  end

  def load_imported_employees
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(2)
    header.each_with_index do |x,i|
      case x.downcase
        when "id"
          header[i]="id"
        when "nume angajat"
          header[i]="name"
        when "data angajarii"
          header[i]="hire_date"
        when "data incheierii"
          header[i]="dismiss_date"
        else      
      end
    end
    if (header.include? "id") && (header.include? "name") && (header.include? "hire_date") && (header.include? "dismiss_date")
      (3..spreadsheet.last_row).map do |i|
        if spreadsheet.cell(i,2) != "Total"
          row = Hash[[header, spreadsheet.row(i)].transpose]
          employee = Employee.find_by_id(row["id"]) || Employee.new
          employee.attributes = row.to_hash.slice(*Employee.accessible_attributes)
          employee
        end
      end
    else
      errors.add :base, "Fisieru nu contine coloanele corespunzatoare. Acestea ar trebui sa fie: Id | Nume angajat | Data angajarii | Data incheierii "
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