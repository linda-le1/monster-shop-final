class Item <ApplicationRecord
  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders, dependent: :destroy
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :description,
                        :price,
                        :image,
                        :inventory

  validates_inclusion_of :active?, :in => [true, false]

  validates_numericality_of :price, greater_than: 0
  validates_numericality_of :inventory, greater_than: 0


  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def self.popularity(desc_or_asc = "asc")
    joins(:item_orders).select('items.*, sum(item_orders.quantity) as quantity').group(:id).order("quantity #{desc_or_asc}").limit(5)
  end

  def toggle_active_status
    toggle!(:active?)
  end

  def eligible_for_discount?(current_coupon)
    current_coupon.merchant_id == merchant_id
  end

  def total_discount_applied(current_coupon)
      price * current_coupon.percent_off.to_f
  end
end
