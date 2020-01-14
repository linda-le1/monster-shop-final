class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip, :current_status

  has_many :item_orders
  has_many :items, through: :item_orders
  has_many :merchants, through: :item_orders

  belongs_to :user
  belongs_to :coupon, optional: true

  enum current_status: %w(pending packaged shipped cancelled)

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def cancel
    item_orders.each do |item_order|
      item_order.update(status: 0)
      item_order.item.update(inventory: item_order.item.inventory + item_order.quantity)
    end
    update(current_status: 3)
  end

  def fulfill
    item_orders.each do |item_order|
      item_order.update(status: 1)
    end
    update(current_status: 1)
  end

  def merchant_item_quantity(merchant)
    items.where(merchant: merchant).sum("item_orders.quantity")
  end

  def merchant_item_total(merchant)
    items.where(merchant: merchant).sum("item_orders.quantity * item_orders.price")
  end

  def ship
    update(current_status: 2)
  end
end
