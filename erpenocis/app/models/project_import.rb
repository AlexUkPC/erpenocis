class ProjectImport
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
    if imported_projects.compact.map(&:valid?).all?
      imported_projects.compact.each do |project|
        if Project.find_by_id(project.id)
          old_info_project = Project.find_by_id(project.id).dup
          if project.save
            old_s = ""
            s = ""
            if old_info_project.name != project.name
              old_s += "Nume proiect: #{old_info_project.name} | "
              s += "Nume proiect: #{project.name} | "
            end
            if old_info_project.start_date != project.start_date
              old_s += "Data inceput: #{old_info_project.start_date} | "
              s += "Data inceput: #{project.start_date} | "
            end
            if old_info_project.end_date != project.end_date
              old_s += "Data finalizare: #{old_info_project.end_date} | "
              s += "Data finalizare: #{project.end_date} | "
            end
            if old_info_project.value != project.value
              old_s += "Valoare: #{old_info_project.value} | "
              s += "Valoare: #{project.value} | "
            end
            if old_info_project.obs != project.obs
              old_s += "Observatii: #{old_info_project.obs} | "
              s += "Observatii: #{project.obs} | "
            end
            if s!="" || old_s != ""
              Record.create(record_type: "Modificare prin import", location: "Proiecte", model_id: project.id, initial_data: old_s[0..-3], modified_data: s[0..-3], user_id: current_user.id)
            end
          end
        else
          if project.save
            Record.create(record_type: "Adaugare prin import", location: "Proiecte", model_id: project.id, initial_data: "", modified_data: "Nume proiect: #{project.name} | Data inceput: #{project.start_date} | Data finalizare: #{project.end_date} | Valoare: #{project.value} | Observatii: #{project.obs}", user_id: current_user.id)
            project_situation = ProjectSituation.new(project_id: project.id)
            project_situation.save
            project_cost = ProjectCost.new(project_id: project.id)
            project_cost.save
          end
        end
      end
      true
    else
      imported_projects.each_with_index do |project, index|
        project.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+3}: #{message}"
        end
      end
      false
    end
  end

  def imported_projects
    @imported_projects ||= load_imported_projects
  end

  def load_imported_projects
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(2)
    header.each_with_index do |x,i|
      case x.downcase
        when "id"
          header[i]="id"
        when "nume proiect"
          header[i]="name"
        when "data inceput"
          header[i]="start_date"
        when "data finalizare"
          header[i]="end_date"
        when "valoare"
          header[i]="value"
        when "observatii"
          header[i]="obs"
        else      
      end
    end
    if (header.include? "id") && (header.include? "name") && (header.include? "start_date") && (header.include? "end_date") && (header.include? "value") && (header.include? "obs")
      (3..spreadsheet.last_row).map do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        project = Project.find_by_id(row["id"]) || Project.new
        project.attributes = row.to_hash.slice(*Project.accessible_attributes)
        project.stoc = false
        project.user_id = current_user.id
        if project.value==""
          project.value = 0
        else
          project.value = project.value.to_f
        end
        project
      end
    else
      errors.add :base, "Fisieru nu contine coloanele corespunzatoare. Acestea ar trebui sa fie: Id | Nume proiect | Data inceput | Data finalizare | Valoare | Observatii"
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