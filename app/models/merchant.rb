class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :item_orders, through: :items
  has_many :users
  has_many :orders, through: :item_orders
  has_many :coupons

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip

  enum status: %w(enabled disabled)

  def no_orders?
    item_orders.empty?
  end

  def item_count
    items.count
  end

  def average_item_price
    items.average(:price)
  end

  def distinct_cities
    item_orders.distinct.joins(:order).pluck(:city)
  end

  def toggle_status
    if enabled?
      update(status: 1)
      deactivate_items
    elsif disabled?
      update(status: 0)
      activate_items
    end
  end

  def deactivate_items
    items.each do |item|
      item.update(active?: false)
    end
  end

  def activate_items
    items.each do |item|
      item.update(active?: true)
    end
  end

  def item_orders_for(order)
    item_orders.where("item_orders.order_id = #{order.id}")
  end

end
