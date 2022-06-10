class CarImport
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
    if imported_cars.map(&:valid?).all?
      imported_cars.each(&:save!)
      true
    else
      imported_cars.each_with_index do |car, index|
        car.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+3}: #{message}"
        end
      end
      false
    end
  end

  def imported_cars
    @imported_cars ||= load_imported_cars
  end

  def load_imported_cars
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(2)
    header.each_with_index do |x,i|
      case x.downcase
        when "id"
          header[i]="id"
        when "nr inmatriculare"
          header[i]="number_plate"
        when "data expirare rca"
          header[i]="rca_expiry_date"
        when "data expirare rovinieta"
          header[i]="rov_expiry_date"
        when "data expirare itp"
          header[i]="itp_expiry_date"
        else      
      end
    end
    if (header.include? "id") && (header.include? "number_plate") && (header.include? "rca_expiry_date") && (header.include? "rov_expiry_date") && (header.include? "itp_expiry_date")
      (3..spreadsheet.last_row).map do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        car = Car.find_by_id(row["id"]) || Car.new
        car.attributes = row.to_hash.slice(*Car.accessible_attributes)
        car
      end
    else
      errors.add :base, "Fisieru nu contine coloanele corespunzatoare. Acestea ar trebui sa fie: Id | Nr inmatriculare | Data expirare Rca | Data expirare Rovinieta | Data expirare Itp"
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