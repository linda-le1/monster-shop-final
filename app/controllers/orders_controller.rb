class OrdersController <ApplicationController

  def new
  end

  def index
    @user = current_user
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    order = current_user.orders.create(order_params)
    if current_coupon.present?
      create_discount_order(order)
    elsif order.save && current_coupon == nil
      create_order_with_no_discount(order)
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end

  def update
    order = Order.find(params[:id])
    order.cancel
    redirect_to "/profile"
    flash[:notice] = "Your order has been cancelled."
  end


  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip, :current_status)
  end

  def create_discount_order(order)
    order.update(coupon_id: current_coupon.id)
    cart.items.each do |item,quantity|
      order.item_orders.create({
        item: item,
        quantity: quantity,
        price: item.total_discount_applied(current_coupon)
        })
    end
    session.delete(:cart)
    session.delete(:coupon)
    flash[:success] = 'You have placed your order!'
    redirect_to '/profile/orders'
  end

  def create_order_with_no_discount(order)
    cart.items.each do |item,quantity|
      order.item_orders.create({
        item: item,
        quantity: quantity,
        price: item.price
        })
    end
    session.delete(:cart)
    flash[:success] = 'You have placed your order!'
    redirect_to '/profile/orders'
  end
end
