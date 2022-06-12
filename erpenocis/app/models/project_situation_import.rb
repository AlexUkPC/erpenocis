class ProjectSituationImport
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
    if imported_project_situations.compact.map(&:valid?).all?
      imported_project_situations.compact.each(&:save!)
      true
    else
      imported_project_situations.each_with_index do |project_situation, index|
        project_situation.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+3}: #{message}"
        end
      end
      false
    end
  end

  def imported_project_situations
    @imported_project_situations ||= load_imported_project_situations
  end

  def load_imported_project_situations
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(2)
    header.each_with_index do |x,i|
      case x.downcase
        when "id"
          header[i]="id"
        when "data ff avans"
          header[i]="advance_invoice_date"
        when "ff avans"
          header[i]="advance_invoice_number"
        when "data avans"
          header[i]="advance_payment_date"
        when "avans"
          header[i]="advance_payment"
        when "luna comanda/avans"
          header[i]="advance_month"
        when "an comanda/avans"
          header[i]="advance_year"
        when "data ff finala"
          header[i]="closure_invoice_date"
        when "ff finala"
          header[i]="closure_invoice_number"
        when "data inchidere"
          header[i]="closure_payment_date"
        when "inchidere"
          header[i]="closure_payment"
        when "luna finalizare/rest de plata"
          header[i]="closure_month"
        when "an finalizare/rest de plata"
          header[i]="closure_year"
        else      
      end
    end
    if (header.include? "id") && (header.include? "advance_invoice_date") && (header.include? "advance_invoice_number") && (header.include? "advance_payment_date") && (header.include? "advance_payment") && (header.include? "advance_month")&& (header.include? "advance_year") && (header.include? "closure_invoice_date") && (header.include? "closure_invoice_number") && (header.include? "closure_payment_date") && (header.include? "closure_payment") && (header.include? "closure_month") && (header.include? "closure_year")
      (3..spreadsheet.last_row).map do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
          if ProjectSituation.find_by(project_id: row["id"])
            project_situation = ProjectSituation.find_by(project_id: row["id"])
            project_situation.attributes = row.to_hash.slice(*ProjectSituation.accessible_attributes) 
            if project_situation.advance_payment==""
              project_situation.advance_payment = 0
            else
              project_situation.advance_payment = project_situation.advance_payment.to_f
            end
            if project_situation.closure_payment==""
              project_situation.closure_payment = 0
            else
              project_situation.closure_payment = project_situation.closure_payment.to_f
            end
              project_situation 
          else
            if row["id"].to_s==""
              errors.add :base, "Randul #{i} - id proiect necompletat" 
            else
              errors.add :base, "Randul #{i} - id proiect inexistent in baza de date"
            end
          end
      end
    else
      errors.add :base, "Fisieru nu contine coloanele corespunzatoare. Acestea ar trebui sa fie: Id | Data ff avans | FF avans | Data avans | Avans | Luna comanda/avans | An comanda/avans | Data ff finala | FF finala | Data inchidere | Inchidere | Luna finalizare/rest de plata | An finalizare/rest de plata"
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