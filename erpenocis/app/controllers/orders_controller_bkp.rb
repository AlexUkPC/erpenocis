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
    @create = true
    update_quantity

    respond_to do |format|
      if @order.save
        @order.update(brother_id: @order.id)
        if @new_order
          @new_order.update(brother_id: @order.id)
        end
        format.html { redirect_to order_url(@order), notice: "Order was successfully created." }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    (@order.ordered_quantity && @order.ordered_quantity.to_i!=0) ? @create = false : @create = true
    update_quantity
    if @zero!=0
      respond_to do |format|
        if @order.update(order_params)
          format.html { redirect_to order_url(@order), notice: "Order was successfully updated." }
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
    other = Order.where(brother_id: @order.brother_id, ordered_quantity: nil).first
    if other && other.id!=@order.id
      Order.find(other.id).update(needed_quantity: other.needed_quantity + @order.needed_quantity)
    end
    x = @order.id == @order.brother_id.to_i ? true : false
    bi = @order.brother_id
    if x && !@from_update
      @order.destroy
      if x 
        other2 = Order.where(brother_id: bi).all
        other2.each do |el|
          Order.find(el.id).update(brother_id: other2.last.id)
        end
      end
      respond_to do |format|
        format.html { redirect_to orders_url, notice: "Order was successfully destroyed." }
        format.json { head :no_content }
      end
    end
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
    def update_quantity
      if order_params[:ordered_quantity]!="" && order_params[:ordered_quantity].to_i!=0
        if order_params[:needed_quantity].to_i>order_params[:ordered_quantity].to_i
          other = Order.where(brother_id: @order.brother_id, ordered_quantity: nil).first
          if other && other.id!=@order.id
            Order.find(other.id).update(needed_quantity: other.needed_quantity + order_params[:needed_quantity].to_i - order_params[:ordered_quantity].to_i)
          else
            @new_order = Order.new(@order.attributes.reject{|k,_v| k.to_s == 'id' || k.to_s == 'ordered_quantity' || k.to_s == 'supplier_id' || k.to_s == 'supplier_contact' || k.to_s == 'order_date' || k.to_s == 'delivery_date' || k.to_s == 'obs' || k.to_s == 'created_at' || k.to_s == 'updated_at' })
            @new_order.status = 0
            @new_order.brother_id = @order.brother_id
            @new_order.needed_quantity = order_params[:needed_quantity].to_i - order_params[:ordered_quantity].to_i
            @new_order.save
          end
        end
      else 
        if !@create
          @from_update = true
          destroy
          other = Order.where(brother_id: @order.brother_id, ordered_quantity: nil).first
          return other ? @zero = 0 : ""
        end
      end
    end
end
