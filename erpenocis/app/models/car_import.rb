class CarImport
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
    if imported_cars.compact.map(&:valid?).all?
      imported_cars.compact.each do |car|
        if car.id
          old_info_car = Car.find_by_id(car.id).dup
          if car.save
            old_s = ""
            s = ""
            if old_info_car.number_plate != car.number_plate
              old_s += "Nr inmatriculare #{old_info_car.number_plate} | "
              s += "Nr inmatriculare #{car.number_plate} | "
            end
            if old_info_car.rca_expiry_date != car.rca_expiry_date
              old_s += "Data expirare Rca: #{old_info_car.rca_expiry_date} | "
              s += "Data expirare Rca: #{car.rca_expiry_date} | "
            end
            if old_info_car.rov_expiry_date != car.rov_expiry_date
              old_s += "Data expirare Rovinieta: #{old_info_car.rov_expiry_date} | "
              s += "Data expirare Rovinieta: #{car.rov_expiry_date} | "
            end
            if old_info_car.itp_expiry_date != car.itp_expiry_date
              old_s += "Data expirare Itp: #{old_info_car.itp_expiry_date} | "
              s += "Data expirare Itp: #{car.itp_expiry_date} | "
            end
            Record.create(record_type: "Import M", location: "Flota auto", model_id: car.id, initial_data: old_s[0..-3], modified_data: s[0..-3], user_id: current_user.id)
          end
        else
          if car.save
            Record.create(record_type: "Import A", location: "Flota auto", model_id: car.id, initial_data: "", modified_data: "Nr inmatriculare: #{car.number_plate} | Data expirare Rca: #{car.rca_expiry_date} | Data expirare Rovinieta: #{car.rov_expiry_date} | Data expirare Itp: #{car.itp_expiry_date}", user_id: current_user.id)
          end
        end
      end
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