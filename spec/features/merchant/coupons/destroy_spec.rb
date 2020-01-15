require 'rails_helper'

RSpec.describe 'As a merchant' do
    describe 'When I am on the coupons page' do
        before :each do
            @merchant = create(:random_merchant)
            @merchant_user = create(:random_user, role: 3, merchant_id: @merchant.id)
            @coupon_1 = Coupon.create(name: '10 Percent Off Total Purchase', code: '10OFF', percent_off: 0.10)
            @coupon_2 = Coupon.create(name: '20 Percent Off Total Purchase', code: '20OFF', percent_off: 0.20)
            @merchant.coupons << @coupon_1
            @merchant.coupons << @coupon_2

            @user = create(:random_user, role: 0)
            @item_1 = create(:random_item, merchant_id: merchant.id, inventory: 10)
            @order = create(:random_order, user_id: @user.id)
            @item_order = ItemOrder.create!(item: @item_1, order: @order, price: @item_1.price, quantity: 5)
            @coupon_2.orders << @order

            visit '/login'
            fill_in :email, with: @merchant_user.email
            fill_in :password, with: @merchant_user.password
            click_button "Login"
        end

        it 'can delete an existing coupon that is not connected to an order' do
            visit '/merchant/coupons'

            within "#coupon-#{@coupon_1.id}" do
                click_on "Delete This Coupon"
            end

            expect(current_path).to eql('/merchant/coupons')
            expect(page).to_not have_content("Coupon Name: #{@coupon_1.name}")
            expect(page).to_not have_content("Coupon Code: #{@coupon_1.code}")
            expect(page).to_not have_content('Percent Off: 10.0%')
        end

        it 'cannot delete a coupon connected to an order' do
            visit '/merchant/coupons'

            within "#coupon-#{@coupon_2.id}" do
                click_on "Delete This Coupon"
            end

            expect(page).to have_content('This coupon has been used on orders and cannot be deleted at this time.')
        end
    end
end