class ExpenseValueImport
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  attr_accessor :file
  attr_accessor :expense_type
  require 'roo'
  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def save
    if imported_expense_values.flatten.compact.map(&:valid?).all?
      imported_expense_values.flatten.compact.each(&:save!)
      true
    else
      imported_expense_values.each_with_index do |expense_value, index|
        expense_value.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+3}: #{message}"
        end
      end
      false
    end
  end

  def imported_expense_values
    @imported_expense_values ||= load_imported_expense_values
  end

  def load_imported_expense_values
    spreadsheet = open_spreadsheet
    year = spreadsheet.cell(1,1)[-4..-1]
    header = spreadsheet.row(2)
    header.each_with_index do |x,i|
      case x.downcase
        when "id"
          header[i]="id"
        when "denumire cheltuiala"
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
      (3..spreadsheet.last_row).map do |i|
        if spreadsheet.cell(i,2) != "Total"
          row = Hash[[header, spreadsheet.row(i)].transpose]
          (3..spreadsheet.last_column-1).map do |j|
            if spreadsheet.cell(i,j)
              if spreadsheet.cell(i,j).to_s[0].ord != 160
                if Expense.find_by_id(row["id"])
                  expense_value = ExpenseValue.created_between(set_start_date(j-2,year),set_end_date(j-2,year)).find_by(expense_id: row["id"]) || ExpenseValue.new
                  expense_value.value = spreadsheet.cell(i,j).to_f
                  unless expense_value.date?
                    expense_value.date = Date.parse(year.to_s+'-'+(j-2).to_s+'-01')
                    expense_value.expense_id = row["id"]
                  end
                  expense_value
                else
                  if row["id"].to_s==""
                    errors.add :base, "Randul #{i} - id cheltuiala necompletat" 
                  else
                    errors.add :base, "Randul #{i} - id cheltuiala inexistent in baza de date"
                  end
                end
              end
            end
          end
        end
      end
    else
      errors.add :base, "Fisieru nu contine coloanele corespunzatoare. Acestea ar trebui sa fie: ID | Denumire cheltuiala | Ian | Feb | Mar | Apr | Mai | Iun | Iul | Aug | Sep | Oct | Nov | Dec "
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