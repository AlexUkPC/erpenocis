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
        @order.update(brother_id: @order.id)
        if @new_order
          @new_order.update(brother_id: @order.id)
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
      respond_to do |format|
        if @order.update(order_params)
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
        end
      end
      @existing_order_project2.save #salveaza modificarile
    end
    @order.ordered_quantity -= order_params_move[:quantity].to_i #scade din comanda proiectului 1 cantiatea ce s-a cerut mutata
    if !@order.project.stoc #Daca proiect1 nu este marcat ca stoc
      @existing_order_project1 = Order.where(brother_id: @order.brother_id, ordered_quantity: 0).first
      if @existing_order_project1 && @existing_order_project1.id!=@order.id
        Order.find(@existing_order_project1.id).update(needed_quantity: @existing_order_project1.needed_quantity + order_params_move[:quantity].to_i)
      else
        @new_order_project1 = Order.new(@order.attributes.reject{|k,_v| k.to_s == 'id' || k.to_s == 'ordered_quantity' || k.to_s == 'supplier_id' || k.to_s == 'supplier_contact' || k.to_s == 'order_date' || k.to_s == 'delivery_date' || k.to_s == 'obs' || k.to_s == 'created_at' || k.to_s == 'updated_at' })
            @new_order_project1.status = 0
            @new_order_project1.brother_id = @order.brother_id
            @new_order_project1.needed_quantity = order_params_move[:quantity].to_i
            @new_order_project1.save
      end
    end
    if @order.ordered_quantity > 0 #Daca mai sunt produse in comanda din care se muta
      @order.save #salveaza modificarile
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
            Order.find(existing_order.id).update(needed_quantity: existing_order.needed_quantity + order_params[:needed_quantity].to_i - order_params[:ordered_quantity].to_i)
          else
            @new_order = Order.new(@order.attributes.reject{|k,_v| k.to_s == 'id' || k.to_s == 'ordered_quantity' || k.to_s == 'supplier_id' || k.to_s == 'supplier_contact' || k.to_s == 'order_date' || k.to_s == 'delivery_date' || k.to_s == 'obs' || k.to_s == 'created_at' || k.to_s == 'updated_at' })
            @new_order.status = 0
            @new_order.brother_id = @order.brother_id
            @new_order.needed_quantity = order_params[:needed_quantity].to_i - order_params[:ordered_quantity].to_i
            @new_order.save
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
