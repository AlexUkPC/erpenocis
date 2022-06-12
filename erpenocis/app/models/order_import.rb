class OrderImport
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  attr_accessor :file
  attr_accessor :project_id
  attr_accessor :proj_id
  attr_accessor :show
  attr_accessor :current_user
  require 'roo'
  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def save
    if imported_orders.compact.map(&:valid?).all?
      imported_orders.compact.each(&:save!)
      true
    else
      imported_orders.each_with_index do |order, index|
        order.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+3}: #{message}"
        end
      end
      false
    end
  end

  def imported_orders
    @imported_orders ||= load_imported_orders
  end

  def load_imported_orders
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(2)
    header.each_with_index do |x,i|
      case x.downcase
      when "id"
        header[i]="id"
      when "categorie"
        header[i]="category"
      when "denumire/tip/nuanta"
        header[i]="name_type_color"
      when "cant. necesara"
        header[i]="needed_quantity"
      when "um"
        header[i]="unit"
      when "cote"
        header[i]="cote"
      when "observatii"
        header[i]="obs"
      else      
      end
    end
    if (header.include? "id") && (header.include? "category") && (header.include? "name_type_color") && (header.include? "needed_quantity") && (header.include? "unit") && (header.include? "cote") && (header.include? "obs")
      (3..spreadsheet.last_row).map do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        order = Order.find_by_id(row["id"]) || Order.new
        order.attributes = row.to_hash.slice(*Order.accessible_attributes)
        order.user_id = current_user.id
        order.project_id = project_id
        order.status = 0
        if order.needed_quantity==""
          order.needed_quantity = 0
        else
          order.needed_quantity = order.needed_quantity.to_i
        end
        order
      end
    else
      errors.add :base, "Fisieru nu contine coloanele corespunzatoare. Acestea ar trebui sa fie: Id | Categorie | Denumire/Tip/Nuanta | Cant. necesara | UM | Cote | Observatii"
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