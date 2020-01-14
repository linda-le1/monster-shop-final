require 'rails_helper'

RSpec.describe 'As a merchant' do
    describe 'When I am on the coupons page' do
        before :each do
            @merchant = create(:random_merchant)
            @merchant_2 = create(:random_merchant)
            @merchant_user = create(:random_user, role: 3, merchant_id: @merchant.id)
            @coupon_1 = Coupon.create(name: "10 Percent Off Total Purchase", code: "10OFF", percent_off: 0.10)
            @coupon_2 = Coupon.create(name: "20 Percent Off Total Purchase", code: "20OFF", percent_off: 0.20)
            @merchant.coupons << @coupon_1
            @merchant_2.coupons << @coupon_2

            visit '/login'
            fill_in :email, with: @merchant_user.email
            fill_in :password, with: @merchant_user.password
            click_button "Login"
        end

        it 'shows me a list of all the coupons for our store' do
            visit "/merchant/coupons"

            within "#coupon-#{@coupon_1.id}" do
                expect(page).to have_content("Coupon Name: #{@coupon_1.name}")
                expect(page).to have_content("Coupon Code: #{@coupon_1.code}")
                expect(page).to have_content("Percent Off: 10.0%")
            end

            expect(page).not_to have_content("Coupon Name: #{@coupon_2.name}")
            expect(page).not_to have_content("Coupon Code: #{@coupon_2.code}")
        end
    end
end
