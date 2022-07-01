class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit update destroy move move_order ]
  before_action :set_dates_params
  # GET /orders or /orders.json
  def index
    @orders = Order.between_dates(set_start_date(@start_month, @start_year),set_end_date(@end_month, @end_year)).order("id DESC")
    @users = User.all
    @suppliers = Supplier.all
  end

  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    @order = Order.new(order_params)
    update_quantity_create

    respond_to do |format|
      if @order.save
        Record.create(record_type: "Adaugare", location: "Comenzi", model_id: @order.id, initial_data: "", modified_data: "Proiect: #{@order.project.name} | Status: #{@order.status.titleize} | Categorie: #{@order.category} | Denumire/Tip/Nuanta: #{@order.name_type_color} | Cant. necesara: #{@order.needed_quantity} | UM: #{@order.unit} | Cote: #{@order.cote} | Cant. comandata: #{@order.ordered_quantity} | Furnizor: #{@order.supplier_id ? Supplier.find(@order.supplier_id).name : ""} | Contact furnizor: #{@order.supplier_contact} | Data comanda: #{@order.order_date} | Data livrare: #{@order.delivery_date} | Observatii: #{@order.obs}", user_id: current_user.id)
        @order.update(brother_id: @order.id)
        if @new_order
          @new_order.update(brother_id: @order.id)
          Record.create(record_type: "Adaugare", location: "Comenzi", model_id: @new_order.id, initial_data: "", modified_data: "Deorece la comanda cu id-ul #{@order.id} Cant. necesara a fost mai mare decat Cant. comandata, a fost creeata urmatoarea comanda pentru cantitatea ramasa: Proiect: #{@new_order.project.name} | Status: #{@new_order.status.titleize} | Categorie: #{@new_order.category} | Denumire/Tip/Nuanta: #{@new_order.name_type_color} | Cant. necesara: #{@new_order.needed_quantity} | UM: #{@new_order.unit} | Cote: #{@new_order.cote} | Cant. comandata: #{@new_order.ordered_quantity} | Furnizor: #{@new_order.supplier_id ? Supplier.find(@new_order.supplier_id).name : ""} | Contact furnizor: #{@new_order.supplier_contact} | Data comanda: #{@new_order.order_date} | Data livrare: #{@new_order.delivery_date} | Observatii: #{@new_order.obs}", user_id: current_user.id)
        end
        format.html { redirect_to orders_url(sm: @start_month, sy: @start_year, em: @end_month, ey: @end_year), notice: "Comanda a fost creeata." }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    # (@order.ordered_quantity && @order.ordered_quantity.to_i!=0) ? @create = false : @create = true
    update_quantity_update
    if @zero!=0
      @old_info_order = Order.find_by_id(@order.id).dup
      respond_to do |format|
        if @order.update(order_params)
          old_s = ""
          s = ""
          if @old_info_order.project_id != @order.project_id
            old_s += "Proiect: #{@old_info_order.project.name} | "
            s += "Proiect: #{@order.project.name} | "
          end
          if @old_info_order.status != @order.status
            old_s += "Status: #{@old_info_order.status.titleize} | "
            s += "Status: #{@order.status.titleize} | "
          end
          if @old_info_order.category != @order.category
            old_s += "Categorie: #{@old_info_order.category} | "
            s += "Categorie: #{@order.category} | "
          end
          if @old_info_order.name_type_color != @order.name_type_color
            old_s += "Denumire/Tip/Nuanta: #{@old_info_order.name_type_color} | "
            s += "Denumire/Tip/Nuanta: #{@order.name_type_color} | "
          end
          if @old_info_order.needed_quantity != @order.needed_quantity
            old_s += "Cant. necesara: #{@old_info_order.needed_quantity} | "
            s += "Cant. necesara: #{@order.needed_quantity} | "
          end
          if @old_info_order.unit != @order.unit
            old_s += "UM: #{@old_info_order.unit} | "
            s += "UM: #{@order.unit} | "
          end
          if @old_info_order.cote != @order.cote
            old_s += "Cote: #{@old_info_order.cote} | "
            s += "Cote: #{@order.cote} | "
          end
          if @old_info_order.ordered_quantity != @order.ordered_quantity
            old_s += "Cant. comandata: #{@old_info_order.ordered_quantity} | "
            s += "Cant. comandata: #{@order.ordered_quantity} | "
          end
          if @old_info_order.supplier_id != @order.supplier_id
            old_s += "Furnizor: #{@old_info_order.supplier_id ? Supplier.find(@old_info_order.supplier_id).name : ""} | "
            s += "Furnizor: #{@order.supplier_id ? Supplier.find(@order.supplier_id).name : ""} | "
          end
          if @old_info_order.supplier_contact != @order.supplier_contact
            old_s += "Contact furnizor: #{@old_info_order.supplier_contact} | "
            s += "Contact furnizor: #{@order.supplier_contact} | "
          end
          if @old_info_order.order_date != @order.order_date
            old_s += "Data comanda: #{@old_info_order.order_date} | "
            s += "Data comanda: #{@order.order_date} | "
          end
          if @old_info_order.delivery_date != @order.delivery_date
            old_s += "Data livrare: #{@old_info_order.delivery_date} | "
            s += "Data livrare: #{@order.delivery_date} | "
          end
          if @old_info_order.obs != @order.obs
            old_s += "Observatii: #{@old_info_order.obs} | "
            s += "Observatii: #{@order.obs} | "
          end
          if s!="" || old_s != ""
            Record.create(record_type: "Modificare", location: "Comenzi", model_id: @order.id, initial_data: old_s[0..-3], modified_data: s[0..-3], user_id: current_user.id)
          end
          format.html { redirect_to orders_url(sm: @start_month, sy: @start_year, em: @end_month, ey: @end_year), notice: "Comanda a fost modificata." }
          format.json { render :show, status: :ok, location: @order }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @order.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    update_quantity_delete
    # x = @order.id == @order.brother_id.to_i ? true : false
    id = @order.id
    bi = @order.brother_id
    # if x && !@from_update
      @order.destroy
      Record.create(record_type: "Stergere", location: "Comenzi", model_id: @order.id, initial_data: "Proiect: #{@order.project.name} | Status: #{@order.status.titleize} | Categorie: #{@order.category} | Denumire/Tip/Nuanta: #{@order.name_type_color} | Cant. necesara: #{@order.needed_quantity} | UM: #{@order.unit} | Cote: #{@order.cote} | Cant. comandata: #{@order.ordered_quantity} | Furnizor: #{@order.supplier_id ? Supplier.find(@order.supplier_id).name : ""} | Contact furnizor: #{@order.supplier_contact} | Data comanda: #{@order.order_date} | Data livrare: #{@order.delivery_date} | Observatii: #{@order.obs}", modified_data: "", user_id: current_user.id)
      if id==bi.to_i
        update_brother_id_delete(id)
      end
      respond_to do |format|
        format.html { redirect_to orders_url(sm: @start_month, sy: @start_year, em: @end_month, ey: @end_year), notice: "Comanda a fost stearsa." }
        format.json { head :no_content }
      end
    # end
  end
  def move_order
  end

  def move
    # Mutare de la proiect1 la proiect2
    if order_params_move[:to_order_id]=="" #Daca nu a fost selectata o comanda pe care sa se mute
      @new_order_project2 = Order.new(@order.attributes.reject{|k,_v| k.to_s == 'id' || k.to_s == 'brother_id' || k.to_s == 'created_at' || k.to_s == 'updated_at' }) #creeaza o copie a comenzii din proiect1 ca o comanda pt proiect2 
      @new_order_project2.user_id = order_params_move[:user_id] #retine userul care a modificat
      @new_order_project2.project_id = order_params_move[:to_project_id] #ataseaza la proiect2
      
      @new_order_project2.needed_quantity = order_params_move[:quantity] #seteaza cantitatea necesara ca si cantitatea ceruta pt mutare
      @new_order_project2.ordered_quantity = order_params_move[:quantity] #seteaza cantitatea comandata ca si cantitatea ceruta pt mutare
      @new_order_project2.obs ? @new_order_project2.obs = @new_order_project2.obs + " | Mutat de la #{@order.project.name} | " : @new_order_project2.obs = "Mutat de la #{@order.project.name}" #adauga observatii cum ca a fost mutat de la proiectul1
      @new_order_project2.save #salveaza noua comanda
      @new_order_project2.brother_id = @new_order_project2.id #seteaza brother id
      @new_order_project2.save #salveaza noua comanda
      Record.create(record_type: "Mutare", location: "Comenzi", model_id: @new_order_project2.id, initial_data: "Proiect: #{@order.project.name}", modified_data: "Proiect: #{@new_order_project2.project.name}", user_id: current_user.id)
    else #Daca a fost selectata o comanda pe care sa se mute
      @existing_order_project2 = Order.find(order_params_move[:to_order_id]) #ia detaliile comenzii
      @existing_order_project2.user_id = order_params_move[:user_id] #retine userul care a modificat
      @existing_order_project2.brother_id = @existing_order_project2.id == @existing_order_project2.brother_id ? @existing_order_project2.id : @existing_order_project2.brother_id #seteaza brother_id ca id propriu daca nu mai exista alta comanda cu acelasi brother_id
      if Project.find(order_params_move[:to_project_id]).stoc 
        @existing_order_project2.ordered_quantity += order_params_move[:quantity].to_i 
        @existing_order_project2.needed_quantity += order_params_move[:quantity].to_i  
      else
        @existing_order_project2.ordered_quantity = order_params_move[:quantity].to_i
        @existing_order_project2.status = @order.status
          #seteaza cantitatea comandata ca si cantitatea ceruta pt mutare
        @existing_order_project2.supplier_id = @order.supplier_id #copiaza furnizorul din comanda 1
        @existing_order_project2.supplier_contact = @order.supplier_contact #copiaza contact furnizor din comanda 1
        @existing_order_project2.order_date = @order.order_date #copiaza data comenzii din comanda 1
        @existing_order_project2.delivery_date = @order.delivery_date #copiaza data livrarii din comanda 1
        @existing_order_project2.obs ? @existing_order_project2.obs = @order.obs + " | Mutat de la #{@order.project.name} | " : @existing_order_project2.obs = "Mutat de la #{@order.project.name}" #adauga observatii cum ca a fost mutat de la proiectul1
        if @existing_order_project2.needed_quantity > order_params_move[:quantity].to_i #Daca cantiatea mutata este mai mica decat necesar
          @new_order_project2 = Order.new(@existing_order_project2.attributes.reject{|k,_v| k.to_s == 'id' || k.to_s == 'brother_id' || k.to_s == 'ordered_quantity' || k.to_s == 'supplier_id' || k.to_s == 'supplier_contact' || k.to_s == 'order_date' || k.to_s == 'delivery_date' || k.to_s == 'obs' || k.to_s == 'created_at' || k.to_s == 'updated_at' }) #creeaza o copie a comenzii cu necesarul ramas
          @new_order_project2.user_id = order_params_move[:user_id] #retine userul care a modificat
          @new_order_project2.project_id = order_params_move[:to_project_id] #leaga comanda de proiectul 2
          @new_order_project2.needed_quantity = @existing_order_project2.needed_quantity -  order_params_move[:quantity].to_i #calculeaza cantiatea necesara ramasa
          @new_order_project2.brother_id = @existing_order_project2.brother_id #seteaza acelasi brother_id cu comanda existenta
          @new_order_project2.status = 0 #seteaza statusul in necesar materiale
          @new_order_project2.save #salveaza modificarile
          Record.create(record_type: "Adaugare prin mutare", location: "Comenzi", model_id: @new_order_project2.id, initial_data: "", modified_data: "Proiect: #{@new_order_project2.project.name} | Status: #{@new_order_project2.status.titleize} | Categorie: #{@new_order_project2.category} | Denumire/Tip/Nuanta: #{@new_order_project2.name_type_color} | Cant. necesara: #{@new_order_project2.needed_quantity} | UM: #{@new_order_project2.unit} | Cote: #{@new_order_project2.cote} | Cant. comandata: #{@new_order_project2.ordered_quantity} | Furnizor: #{@new_order_project2.supplier_id ? Supplier.find(@new_order_project2.supplier_id).name : ""} | Contact furnizor: #{@new_order_project2.supplier_contact} | Data comanda: #{@new_order_project2.order_date} | Data livrare: #{@new_order_project2.delivery_date} | Observatii: #{@new_order_project2.obs}", user_id: current_user.id)
        end
      end
      @old_info_order = Order.find_by_id(@existing_order_project2.id)
      @existing_order_project2.save #salveaza modificarile
      old_s = "Proiect: #{@old_info_order.project.name} | "
      s = "Proiect: #{@existing_order_project2.project.name} | "
      if @old_info_order.status != @existing_order_project2.status
        old_s += "Status: #{@old_info_order.status.titleize} | "
        s += "Status: #{@existing_order_project2.status.titleize} | "
      end
      if @old_info_order.category != @existing_order_project2.category
        old_s += "Categorie: #{@old_info_order.category} | "
        s += "Categorie: #{@existing_order_project2.category} | "
      end
      if @old_info_order.name_type_color != @existing_order_project2.name_type_color
        old_s += "Denumire/Tip/Nuanta: #{@old_info_order.name_type_color} | "
        s += "Denumire/Tip/Nuanta: #{@existing_order_project2.name_type_color} | "
      end
      if @old_info_order.needed_quantity != @existing_order_project2.needed_quantity
        old_s += "Cant. necesara: #{@old_info_order.needed_quantity} | "
        s += "Cant. necesara: #{@existing_order_project2.needed_quantity} | "
      end
      if @old_info_order.unit != @existing_order_project2.unit
        old_s += "UM: #{@old_info_order.unit} | "
        s += "UM: #{@existing_order_project2.unit} | "
      end
      if @old_info_order.cote != @existing_order_project2.cote
        old_s += "Cote: #{@old_info_order.cote} | "
        s += "Cote: #{@existing_order_project2.cote} | "
      end
      if @old_info_order.ordered_quantity != @existing_order_project2.ordered_quantity
        old_s += "Cant. comandata: #{@old_info_order.ordered_quantity} | "
        s += "Cant. comandata: #{@existing_order_project2.ordered_quantity} | "
      end
      if @old_info_order.supplier_id != @existing_order_project2.supplier_id
        old_s += "Furnizor: #{@old_info_order.supplier_id ? Supplier.find(@old_info_order.supplier_id).name : ""} | "
        s += "Furnizor: #{@existing_order_project2.supplier_id ? Supplier.find(@existing_order_project2.supplier_id).name : ""} | "
      end
      if @old_info_order.supplier_contact != @existing_order_project2.supplier_contact
        old_s += "Contact furnizor: #{@old_info_order.supplier_contact} | "
        s += "Contact furnizor: #{@existing_order_project2.supplier_contact} | "
      end
      if @old_info_order.order_date != @existing_order_project2.order_date
        old_s += "Data comanda: #{@old_info_order.order_date} | "
        s += "Data comanda: #{@existing_order_project2.order_date} | "
      end
      if @old_info_order.delivery_date != @existing_order_project2.delivery_date
        old_s += "Data livrare: #{@old_info_order.delivery_date} | "
        s += "Data livrare: #{@existing_order_project2.delivery_date} | "
      end
      if @old_info_order.obs != @existing_order_project2.obs
        old_s += "Observatii: #{@old_info_order.obs} | "
        s += "Observatii: #{@existing_order_project2.obs} | "
      end
      Record.create(record_type: "Mutare", location: "#{Project.find(order_params_move[:to_project_id]).stoc ? "Stoc" : "Comenzi"}", model_id: @existing_order_project2.id, initial_data: old_s[0..-3], modified_data: s[0..-3], user_id: current_user.id)
    end
    @order.ordered_quantity -= order_params_move[:quantity].to_i #scade din comanda proiectului 1 cantiatea ce s-a cerut mutata
    if !@order.project.stoc #Daca proiect1 nu este marcat ca stoc
      @existing_order_project1 = Order.where(brother_id: @order.brother_id, ordered_quantity: 0).first
      if @existing_order_project1 && @existing_order_project1.id!=@order.id
        Record.create(record_type: "Modificare prin mutare", location: "Comenzi", model_id: @existing_order_project1.id, initial_data: "Cant. necesara: #{@existing_order_project1.needed_quantity}", modified_data: "Cant. necesara:  #{@existing_order_project1.needed_quantity + order_params_move[:quantity].to_i}", user_id: current_user.id)
        Order.find(@existing_order_project1.id).update(needed_quantity: @existing_order_project1.needed_quantity + order_params_move[:quantity].to_i)
      else
        if @order.ordered_quantity < @order.needed_quantity
          @new_order_project1 = Order.new(@order.attributes.reject{|k,_v| k.to_s == 'id' || k.to_s == 'ordered_quantity' || k.to_s == 'supplier_id' || k.to_s == 'supplier_contact' || k.to_s == 'order_date' || k.to_s == 'delivery_date' || k.to_s == 'obs' || k.to_s == 'created_at' || k.to_s == 'updated_at' })
            @new_order_project1.status = 0
            @new_order_project1.brother_id = @order.brother_id
            @new_order_project1.needed_quantity = order_params_move[:quantity].to_i
            @new_order_project1.save
            Record.create(record_type: "Adaugare prin mutare", location: "Comenzi", model_id: @new_order_project1.id, initial_data: "", modified_data: "Proiect: #{@new_order_project1.project.name} | Status: #{@new_order_project1.status.titleize} | Categorie: #{@new_order_project1.category} | Denumire/Tip/Nuanta: #{@new_order_project1.name_type_color} | Cant. necesara: #{@new_order_project1.needed_quantity} | UM: #{@new_order_project1.unit} | Cote: #{@new_order_project1.cote} | Cant. comandata: #{@new_order_project1.ordered_quantity} | Furnizor: #{@new_order_project1.supplier_id ? Supplier.find(@new_order_project1.supplier_id).name : ""} | Contact furnizor: #{@new_order_project1.supplier_contact} | Data comanda: #{@new_order_project1.order_date} | Data livrare: #{@new_order_project1.delivery_date} | Observatii: #{@new_order_project1.obs}", user_id: current_user.id)
        end
      end
    end
    if @order.ordered_quantity > 0 #Daca mai sunt produse in comanda din care se muta

      @old_info_order = Order.find_by_id(@order.id)
      @order.save #salveaza modificarile
      old_s = "Proiect: #{@old_info_order.project.name} | "
      s = "Proiect: #{@order.project.name} | "
      if @old_info_order.status != @order.status
        old_s += "Status: #{@old_info_order.status.titleize} | "
        s += "Status: #{@order.status.titleize} | "
      end
      if @old_info_order.category != @order.category
        old_s += "Categorie: #{@old_info_order.category} | "
        s += "Categorie: #{@order.category} | "
      end
      if @old_info_order.name_type_color != @order.name_type_color
        old_s += "Denumire/Tip/Nuanta: #{@old_info_order.name_type_color} | "
        s += "Denumire/Tip/Nuanta: #{@order.name_type_color} | "
      end
      if @old_info_order.needed_quantity != @order.needed_quantity
        old_s += "Cant. necesara: #{@old_info_order.needed_quantity} | "
        s += "Cant. necesara: #{@order.needed_quantity} | "
      end
      if @old_info_order.unit != @order.unit
        old_s += "UM: #{@old_info_order.unit} | "
        s += "UM: #{@order.unit} | "
      end
      if @old_info_order.cote != @order.cote
        old_s += "Cote: #{@old_info_order.cote} | "
        s += "Cote: #{@order.cote} | "
      end
      if @old_info_order.ordered_quantity != @order.ordered_quantity
        old_s += "Cant. comandata: #{@old_info_order.ordered_quantity} | "
        s += "Cant. comandata: #{@order.ordered_quantity} | "
      end
      if @old_info_order.supplier_id != @order.supplier_id
        old_s += "Furnizor: #{@old_info_order.supplier_id ? Supplier.find(@old_info_order.supplier_id).name : ""} | "
        s += "Furnizor: #{@order.supplier_id ? Supplier.find(@order.supplier_id).name : ""} | "
      end
      if @old_info_order.supplier_contact != @order.supplier_contact
        old_s += "Contact furnizor: #{@old_info_order.supplier_contact} | "
        s += "Contact furnizor: #{@order.supplier_contact} | "
      end
      if @old_info_order.order_date != @order.order_date
        old_s += "Data comanda: #{@old_info_order.order_date} | "
        s += "Data comanda: #{@order.order_date} | "
      end
      if @old_info_order.delivery_date != @order.delivery_date
        old_s += "Data livrare: #{@old_info_order.delivery_date} | "
        s += "Data livrare: #{@order.delivery_date} | "
      end
      if @old_info_order.obs != @order.obs
        old_s += "Observatii: #{@old_info_order.obs} | "
        s += "Observatii: #{@order.obs} | "
      end
      Record.create(record_type: "Mutare", location: "#{Project.find(order_params_move[:to_project_id]).stoc ? "Stoc" : "Comenzi"}", model_id: @order.id, initial_data: old_s[0..-3], modified_data: s[0..-3], user_id: current_user.id)
    else 
      @order.destroy #sterge
    end
    redirect_to orders_url(sm: @start_month, sy: @start_year, em: @end_month, ey: @end_year), notice: "Comanda a fost mutata."
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:status, :category, :name_type_color, :needed_quantity, :unit, :cote, :brother_id, :ordered_quantity, :supplier_id, :supplier_contact, :order_date, :delivery_date, :obs, :project_id, :user_id)
    end

    def order_params_move
      params.permit(:to_project_id, :_method, :authenticity_token, :user_id, :quantity, :commit, :id, :to_order_id, :from_project_id)
    end

    def update_quantity_create
      if order_params[:ordered_quantity].to_i!=0
        if order_params[:needed_quantity].to_i>order_params[:ordered_quantity].to_i
          @new_order = Order.new(@order.attributes.reject{|k,_v| k.to_s == 'id' || k.to_s == 'ordered_quantity' || k.to_s == 'supplier_id' || k.to_s == 'supplier_contact' || k.to_s == 'order_date' || k.to_s == 'delivery_date' || k.to_s == 'obs' || k.to_s == 'created_at' || k.to_s == 'updated_at' })
          @new_order.status = 0
          @new_order.needed_quantity = order_params[:needed_quantity].to_i - order_params[:ordered_quantity].to_i
          @new_order.save
        end
      end
    end
    def update_quantity_update
      if order_params[:ordered_quantity].to_i!=0
        if order_params[:needed_quantity].to_i>order_params[:ordered_quantity].to_i
          existing_order = Order.where(brother_id: @order.brother_id, ordered_quantity: 0).first
          if existing_order && existing_order.id!=@order.id
            Record.create(record_type: "Modificare", location: "Comenzi", model_id: existing_order.id, initial_data: "Cant. necesara: #{existing_order.needed_quantity}", modified_data: "Cant. necesara:  #{existing_order.needed_quantity + order_params[:needed_quantity].to_i - order_params[:ordered_quantity].to_i}", user_id: current_user.id)
            Order.find(existing_order.id).update(needed_quantity: existing_order.needed_quantity + order_params[:needed_quantity].to_i - order_params[:ordered_quantity].to_i)
          else
            @new_order = Order.new(@order.attributes.reject{|k,_v| k.to_s == 'id' || k.to_s == 'ordered_quantity' || k.to_s == 'supplier_id' || k.to_s == 'supplier_contact' || k.to_s == 'order_date' || k.to_s == 'delivery_date' || k.to_s == 'obs' || k.to_s == 'created_at' || k.to_s == 'updated_at' })
            @new_order.status = 0
            @new_order.brother_id = @order.brother_id
            @new_order.needed_quantity = order_params[:needed_quantity].to_i - order_params[:ordered_quantity].to_i
            @new_order.save
            Record.create(record_type: "Adaugare", location: "Comenzi", model_id: @new_order.id, initial_data: "", modified_data: "Deorece la comanda cu id-ul #{@order.id} Cant. necesara a fost mai mare decat Cant. comandata, a fost creeata urmatoarea comanda pentru cantitatea ramasa: Proiect: #{@new_order.project.name} | Status: #{@new_order.status.titleize} | Categorie: #{@new_order.category} | Denumire/Tip/Nuanta: #{@new_order.name_type_color} | Cant. necesara: #{@new_order.needed_quantity} | UM: #{@new_order.unit} | Cote: #{@new_order.cote} | Cant. comandata: #{@new_order.ordered_quantity} | Furnizor: #{@new_order.supplier_id ? Supplier.find(@new_order.supplier_id).name : ""} | Contact furnizor: #{@new_order.supplier_contact} | Data comanda: #{@new_order.order_date} | Data livrare: #{@new_order.delivery_date} | Observatii: #{@new_order.obs}", user_id: current_user.id)
          end
        end
      else 
        if @order.ordered_quantity != 0 
          existing_order = Order.where(brother_id: @order.brother_id, ordered_quantity: 0).first
          existing_order ? destroy : ""
          order_params[:supplier_id]=""
          return existing_order ? @zero = 0 : ""
        end
      end
    end
    def update_quantity_delete
      existing_order = Order.where(brother_id: @order.brother_id, ordered_quantity: 0).first
      if existing_order && existing_order.id!=@order.id
        Record.create(record_type: "Modificare", location: "Comenzi", model_id: existing_order.id, initial_data: "Cant. necesara: #{existing_order.needed_quantity}", modified_data: "Cant. necesara:  #{existing_order.needed_quantity + @order.needed_quantity}", user_id: current_user.id)
        Order.find(existing_order.id).update(needed_quantity: existing_order.needed_quantity + @order.needed_quantity)
      end
    end
    def update_brother_id_delete(id)
      existing_orders = Order.where(brother_id: id).all
      existing_orders.each do |order|
        Order.find(order.id).update(brother_id: existing_orders.last.id)
      end
    end
end
