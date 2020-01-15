require 'rails_helper'

RSpec.describe 'As a merchant' do
    describe 'When I am on the coupons page' do
        before :each do
            @merchant = create(:random_merchant)
            @merchant_2 = create(:random_merchant)
            @merchant_user = create(:random_user, role: 3, merchant_id: @merchant.id)
            @coupon_1 = Coupon.create(name: '10 Percent Off Total Purchase', code: '10OFF', percent_off: 0.10)
            @coupon_2 = Coupon.create(name: '20 Percent Off Total Purchase', code: '20OFF', percent_off: 0.20)
            @merchant.coupons << @coupon_1
            @merchant_2.coupons << @coupon_2

            visit '/login'
            fill_in :email, with: @merchant_user.email
            fill_in :password, with: @merchant_user.password
            click_button "Login"
        end

        it 'can edit an existing coupon' do
            visit '/merchant/coupons'

            within "#coupon-#{@coupon_1.id}" do
                click_on 'Edit This Coupon'
            end

            expect(current_path).to eql("/merchant/coupons/#{@coupon_1.id}/edit")


            fill_in :name, with: '5 Percent Off'
            fill_in :code, with: '5OFF'
            fill_in :percent_off, with: 0.05

            click_on 'Update Coupon'
            expect(current_path).to eql('/merchant/coupons')
            expect(page).to have_content("You've successfully edited this coupon!")

            within "#coupon-#{@coupon_1.id}" do
                expect(page).to have_content("Coupon Name: 5 Percent Off")
                expect(page).to have_content("Coupon Code: 5OFF")
                expect(page).to have_content('Percent Off: 5.0%')
            end
        end

        it 'cannot edit a coupon if any submitted info is bad' do

            visit '/merchant/coupons'

            within "#coupon-#{@coupon_1.id}" do
                click_on 'Edit This Coupon'
            end

            expect(current_path).to eql("/merchant/coupons/#{@coupon_1.id}/edit")


            fill_in :name, with: '20 Percent Off Total Purchase'
            fill_in :code, with: '20OFF'
            fill_in :percent_off, with: 0.20

            click_on 'Update Coupon'
            expect(page).to have_content('Name has already been taken')
            expect(page).to have_content('Code has already been taken')
        end
    end
end