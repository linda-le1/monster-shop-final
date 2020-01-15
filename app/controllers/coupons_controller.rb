class CouponsController < ApplicationController
    def update
        coupon = Coupon.find_by(code: params[:code])
        if coupon.nil?
            flash[:error] = 'This is an invalid coupon. Please try again.'
        else
            session[:coupon_id] = coupon.id
            flash[:success] = "Coupon applied for items from #{coupon.merchant.name}!"
        end
        redirect_to '/cart'
    end
end