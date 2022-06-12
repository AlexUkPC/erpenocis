class EmployeeSalaryImport
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
    if imported_employee_salaries.flatten.compact.map(&:valid?).all?
      imported_employee_salaries.flatten.compact.each(&:save!)
      true
    else
      imported_employee_salaries.each_with_index do |employee_salary, index|
        employee_salary.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+3}: #{message}"
        end
      end
      false
    end
  end

  def imported_employee_salaries
    @imported_employee_salaries ||= load_imported_employee_salaries
  end

  def load_imported_employee_salaries
    spreadsheet = open_spreadsheet
    year = spreadsheet.sheet("Salariu net").cell(1,1)[-4..-1]
    header = spreadsheet.sheet("Salariu net").row(2)
    header.each_with_index do |x,i|
      case x.downcase
        when "id"
          header[i]="id"
        when "nume angajat"
          header[i]="name"
        when "ian"
          header[i]="ian"
        when "feb"
          header[i]="feb"
        when "mar"
          header[i]="mar"
        when "apr"
          header[i]="apr"
        when "mai"
          header[i]="mai"
        when "iun"
          header[i]="iun"
        when "iul"
          header[i]="iul"
        when "aug"
          header[i]="aug"
        when "sep"
          header[i]="sep"
        when "oct"
          header[i]="oct"
        when "nov"
          header[i]="nov"
        when "dec"
          header[i]="dec"
        else      
      end
    end
    if (header.include? "id") && (header.include? "name") && (header.include? "ian") && (header.include? "feb") && (header.include? "mar") && (header.include? "apr") && (header.include? "mai") && (header.include? "iun") && (header.include? "iul") && (header.include? "aug") && (header.include? "sep") && (header.include? "oct") && (header.include? "nov") && (header.include? "dec")
      (3..spreadsheet.sheet("Salariu net").last_row).map do |i|
        if spreadsheet.sheet("Salariu net").cell(i,2) != "Total"
        row = Hash[[header, spreadsheet.row(i)].transpose]
          (3..spreadsheet.sheet("Salariu net").last_column-1).map do |j|
            if spreadsheet.sheet("Salariu net").cell(i,j) || spreadsheet.sheet("Taxe salariu").cell(i,j) || spreadsheet.sheet("Bonuri de masa").cell(i,j) || spreadsheet.sheet("Bonuri cadou").cell(i,j) || spreadsheet.sheet("Ore suplimentare").cell(i,j) || spreadsheet.sheet("Salariu extra").cell(i,j)
              if spreadsheet.sheet("Salariu net").cell(i,j).to_f!=0 || spreadsheet.sheet("Taxe salariu").cell(i,j).to_f!=0 || spreadsheet.sheet("Bonuri de masa").cell(i,j).to_f!=0 || spreadsheet.sheet("Bonuri cadou").cell(i,j).to_f!=0 || spreadsheet.sheet("Ore suplimentare").cell(i,j).to_f!=0 || spreadsheet.sheet("Salariu extra").cell(i,j).to_f!=0
                if Employee.find_by_id(row["id"])
                  employee_salary = EmployeeSalary.created_between(set_start_date(j-2,year),set_end_date(j-2,year)).find_by(employee_id: row["id"]) || EmployeeSalary.new
                  employee_salary.net_salary = spreadsheet.sheet("Salariu net").cell(i,j).to_f
                  employee_salary.salary_tax = spreadsheet.sheet("Taxe salariu").cell(i,j).to_f
                  employee_salary.meal_vouchers = spreadsheet.sheet("Bonuri de masa").cell(i,j).to_f
                  employee_salary.gift_vouchers = spreadsheet.sheet("Bonuri cadou").cell(i,j).to_f
                  employee_salary.overtime = spreadsheet.sheet("Ore suplimentare").cell(i,j).to_f
                  employee_salary.extra_salary = spreadsheet.sheet("Salariu extra").cell(i,j).to_f
                  unless employee_salary.date?
                    employee_salary.date = Date.parse(year.to_s+'-'+(j-2).to_s+'-01')
                    employee_salary.employee_id = row["id"]
                  end
                  employee_salary
                else
                  if row["id"].to_s==""
                    errors.add :base, "Randul #{i} - id angajat necompletat" 
                  else
                    errors.add :base, "Randul #{i} - id angajat inexistent in baza de date"
                  end
                end
              end
            end
          end
        end
      end
    else
      errors.add :base, "Fisieru nu contine coloanele corespunzatoare. Acestea ar trebui sa fie: Id | Denumire cheltuiala | Ian | Feb | Mar | Apr | Mai | Iun | Iul | Aug | Sep | Oct | Nov | Dec "
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
  def set_start_date(start_month ,start_year)
    Date.parse(start_year.to_s+'-'+start_month.to_s+'-01')
  end
  def set_end_date(end_month, end_year)
    Date.parse(end_year.to_s+'-'+end_month.to_s+'-01').next_month-1.day
  end
end