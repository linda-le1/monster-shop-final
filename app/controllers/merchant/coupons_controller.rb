class Merchant::CouponsController < Merchant::BaseController
    def index
        @coupons = Coupon.all
    end

end