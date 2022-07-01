class EmployeeImport
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
    if imported_employees.compact.map(&:valid?).all?
      imported_employees.compact.each do |employee|
        if Employee.find_by_id(employee.id)
          old_info_employee = Employee.find_by_id(employee.id).dup
          if employee.save
            old_s = ""
            s = ""
            if old_info_employee.name != employee.name
              old_s += "Nume angajat: #{old_info_employee.name} | "
              s += "Nume angajat: #{employee.name} | "
            end
            if old_info_employee.hire_date != employee.hire_date
              old_s += "Data angajarii: #{old_info_employee.hire_date} | "
              s += "Data angajarii: #{employee.hire_date} | "
            end
            if old_info_employee.dismiss_date != employee.dismiss_date
              old_s += "Data incheierii: #{old_info_employee.dismiss_date} | "
              s += "Data incheierii: #{employee.dismiss_date} | "
            end
            if s!="" || old_s != ""
              Record.create(record_type: "Modificare prin import", location: "Cheltuieli salariale", model_id: employee.id, initial_data: old_s[0..-3], modified_data: s[0..-3], user_id: current_user.id)
            end
          end
        else
          if employee.save
            Record.create(record_type: "Adaugare prin import", location: "Cheltuieli salariale", model_id: employee.id, initial_data: "", modified_data: "Nume angajat: #{employee.name} | Data angajarii: #{employee.hire_date} | Data incheierii: #{employee.dismiss_date}", user_id: current_user.id)
          end
        end
      end
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