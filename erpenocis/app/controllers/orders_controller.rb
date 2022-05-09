class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit update destroy ]
  # GET /orders or /orders.json
  def index
    @orders = Order.all.order("id DESC")
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
        format.html { redirect_to orders_url, notice: "Order was successfully created." }
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
          format.html { redirect_to orders_url, notice: "Order was successfully updated." }
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
        format.html { redirect_to orders_url, notice: "Order was successfully destroyed." }
        format.json { head :no_content }
      end
    # end
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
