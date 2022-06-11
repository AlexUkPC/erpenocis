class ProjectCostImport
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
    if imported_project_costs.map(&:valid?).all?
      imported_project_costs.each(&:save!)
      true
    else
      imported_project_costs.each_with_index do |project_cost, index|
        project_cost.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+3}: #{message}"
        end
      end
      false
    end
  end

  def imported_project_costs
    @imported_project_costs ||= load_imported_project_costs
  end

  def load_imported_project_costs
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(2)
    header.each_with_index do |x,i|
      case x.downcase
        when "id"
          header[i]="id"
        when "cost"
          header[i]="amount"
        when "luna cost"
          header[i]="month"
        when "an cost"
          header[i]="year"
        else      
      end
    end
    if (header.include? "id") && (header.include? "amount") && (header.include? "month") && (header.include? "year")
      @new = true
      puts "========@new = true==========="
      puts @new
      (3..spreadsheet.last_row).map do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
          if ProjectCost.find_by(project_id: row["id"])
            if ProjectCost.find_by(project_id: row["id"]).amount==nil && @new
              project_cost = ProjectCost.find_by(project_id: row["id"])
              @new = false
            else
              project_cost = ProjectCost.new
              project_cost.project_id = row["id"]
            end
            project_cost.attributes = row.to_hash.slice(*ProjectCost.accessible_attributes) 
            if project_cost.amount==""
              project_cost.amount = 0
            else
              project_cost.amount = project_cost.amount.to_f
            end
            if project_cost.month==""
              errors.add :base, "Randul #{i} - luna necompletata"
              raise "No month"
            else
              project_cost.month = project_cost.month.to_i
              if project_cost.month < 1 || project_cost.month > 12 
                errors.add :base, "Randul #{i} - luna este gresita"
                raise "Wrong month"
              end
            end
            if project_cost.year==""
              errors.add :base, "Randul #{i} - an necompletat"
              raise "No year"
            else
              project_cost.year = project_cost.year.to_i
              if project_cost.year < 2020
                errors.add :base, "Randul #{i} - anul este inainte de 2020"
                raise "Wrong year"
              end
            end
              project_cost 
          else
            if row["id"].to_s==""
              errors.add :base, "Randul #{i} - id proiect necompletat" 
            else
              errors.add :base, "Randul #{i} - id proiect inexistent in baza de date"
            end
          end
      end
    else
      errors.add :base, "Fisieru nu contine coloanele corespunzatoare. Acestea ar trebui sa fie: ID | Cost | Luna cost | An cost"
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