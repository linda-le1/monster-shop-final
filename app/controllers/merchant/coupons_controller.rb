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
        create_coupon(@coupon)
    end

    def destroy
        coupon = Coupon.find(params[:id])
        destroy_coupon(coupon)
        redirect_to "/merchant/coupons"
    end

    private

    def coupon_params
        params.permit(:name,:code,:percent_off)
    end

    def destroy_coupon(coupon)
        if coupon.orders.empty?
            coupon.destroy
            flash[:success] = "You deleted #{coupon.name}"
        else
            flash[:error] = "This coupon has been used on orders and cannot be deleted at this time."
        end
    end

    def create_coupon(coupon)
        if coupon.save
            flash[:success] = "You've successfully added a new coupon!"
            redirect_to "/merchant/coupons"
        else
            flash[:error] = coupon.errors.full_messages.to_sentence
            render :new
        end
    end
end