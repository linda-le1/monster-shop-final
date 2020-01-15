class Coupon < ApplicationRecord
    belongs_to :merchant
    has_many :orders

    validates :name, uniqueness: true, presence: true
    validates :code, uniqueness: true, presence: true
    validates_presence_of :percent_off

    validates_numericality_of :percent_off, greater_than: 0, less_than: 1
end