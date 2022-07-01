class EmployeeSalaryImport
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
    if imported_employee_salaries.flatten.compact.map(&:valid?).all?
      imported_employee_salaries.flatten.compact.each do |employee_salary|
        if EmployeeSalary.find_by_id(employee_salary.id)
          old_info_employee_salary = EmployeeSalary.find_by_id(employee_salary.id).dup
        
          if employee_salary.save
            old_s = ""
            s = ""
            if old_info_employee_salary.net_salary != employee_salary.net_salary
              old_s += "Salariu net: #{old_info_employee_salary.net_salary} | "
              s += "Salariu net: #{employee_salary.net_salary} | "
            end
            if old_info_employee_salary.salary_tax != employee_salary.salary_tax
              old_s += "Taxe de achitat: #{old_info_employee_salary.salary_tax} | "
              s += "Taxe de achitat: #{employee_salary.salary_tax} | "
            end
            if old_info_employee_salary.salary_tax_due_date != employee_salary.salary_tax_due_date
              old_s += "Data scadenta taxe: #{old_info_employee_salary.salary_tax_due_date} | "
              s += "Data scadenta taxe: #{employee_salary.salary_tax_due_date} | "
            end
            if old_info_employee_salary.meal_vouchers != employee_salary.meal_vouchers
              old_s += "Bonuri de masa: #{old_info_employee_salary.meal_vouchers} | "
              s += "Bonuri de masa: #{employee_salary.meal_vouchers} | "
            end
            if old_info_employee_salary.gift_vouchers != employee_salary.gift_vouchers
              old_s += "Bonuri cadou: #{old_info_employee_salary.gift_vouchers} | "
              s += "Bonuri cadou: #{employee_salary.gift_vouchers} | "
            end
            if old_info_employee_salary.overtime != employee_salary.overtime
              old_s += "Ore suplimentare: #{old_info_employee_salary.overtime} | "
              s += "Ore suplimentare: #{employee_salary.overtime} | "
            end
            if old_info_employee_salary.extra_salary != employee_salary.extra_salary
              old_s += "Salariu extra: #{old_info_employee_salary.extra_salary} | "
              s += "Salariu extra: #{employee_salary.extra_salary} | "
            end
            if old_info_employee_salary.date != employee_salary.date
              old_s += "Data: #{old_info_employee_salary.date} | "
              s += "Data: #{employee_salary.date} | "
            end
            if s!="" || old_s != ""
              Record.create(record_type: "Modificare prin import", location: "Cheltuieli salariale", model_id: employee_salary.employee_id, initial_data: old_s[0..-3], modified_data: s[0..-3], user_id: current_user.id)
            end
          end
        else
          if employee_salary.save
            Record.create(record_type: "Adaugare prin import", location: "Cheltuieli salariale", model_id: employee_salary.employee_id, initial_data: "", modified_data: "Salariu net: #{employee_salary.net_salary} | Taxe de achitat: #{employee_salary.salary_tax} | Data scadenta taxe: #{employee_salary.salary_tax_due_date} | Bonuri de masa: #{employee_salary.meal_vouchers} | Bonuri cadou: #{employee_salary.gift_vouchers} | Ore suplimentare: #{employee_salary.overtime} | Salariu extra: #{employee_salary.extra_salary} | Data: #{employee_salary.date}", user_id: current_user.id)
          end
        end
      end
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