class Merchant::CouponsController < Merchant::BaseController
    def index
        @coupons = Merchant.find(current_user.merchant.id).coupons
    end

    def new
        @coupon = Coupon.new(coupon_params)
    end

    def create
        merchant = Merchant.find(current_user.merchant.id)
        @coupon = merchant.coupons.create(coupon_params)
        if @coupon.save
            flash[:success] = "You've successfully added a new coupon!"
            redirect_to "/merchant/coupons"
        else
            flash[:error] = @coupon.errors.full_messages.to_sentence
            render :new
        end
    end

    private

    def coupon_params
        params.permit(:name,:code,:percent_off)
    end
end