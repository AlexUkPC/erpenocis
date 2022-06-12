class ExpenseImport
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
    if imported_expenses.compact.map(&:valid?).all?
      imported_expenses.compact.each(&:save!)
      true
    else
      imported_expenses.each_with_index do |expense, index|
        expense.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+3}: #{message}"
        end
      end
      false
    end
  end

  def imported_expenses
    @imported_expenses ||= load_imported_expenses
  end

  def load_imported_expenses
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(2)
    header.each_with_index do |x,i|
      case x.downcase
        when "id"
          header[i]="id"
        when "denumire cheltuiala"
          header[i]="name"
        else      
      end
    end
    if (header.include? "id") && (header.include? "name")
      (3..spreadsheet.last_row).map do |i|
        if spreadsheet.cell(i,2) != "Total"
          row = Hash[[header, spreadsheet.row(i)].transpose]
          expense = Expense.find_by_id(row["id"]) || Expense.new
          expense.attributes = row.to_hash.slice(*Expense.accessible_attributes)
          case expense_type
            when "administrative"
              expense.expense_type = 0
            when "financiare"
              expense.expense_type = 1
            when "investitii"
              expense.expense_type = 2
            when "alte_cheltuieli"
              expense.expense_type = 3
            else
          end
          expense
        end
      end
    else
      errors.add :base, "Fisieru nu contine coloanele corespunzatoare. Acestea ar trebui sa fie: ID | Denumire cheltuiala"
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