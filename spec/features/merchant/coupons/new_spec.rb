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

        it 'can add a new coupon and see it on the coupons index page after creation' do
            visit '/merchant/coupons'

            click_on 'Add New Coupon'
            expect(current_path).to eql('/merchant/coupons/new')

            fill_in :name, with: '15 Percent Off'
            fill_in :code, with: '15OFF'
            fill_in :percent_off, with: 0.15

            click_on 'Create Coupon'
            expect(current_path).to eql('/merchant/coupons')
            expect(page).to have_content("You've successfully added a new coupon!")

            new_coupon = Coupon.last

            within "#coupon-#{new_coupon.id}" do
                expect(page).to have_content("Coupon Name: #{new_coupon.name}")
                expect(page).to have_content("Coupon Code: #{new_coupon.code}")
                expect(page).to have_content('Percent Off: 15.0%')
            end
        end

        it 'cannot add a new coupon if any submitted info is bad' do
            visit '/merchant/coupons'

            click_on 'Add New Coupon'
            expect(current_path).to eql('/merchant/coupons/new')

            fill_in :name, with: "#{@coupon_1.name}"
            fill_in :code, with: '15OFF'
            fill_in :percent_off, with: 0.15

            click_on 'Create Coupon'
            expect(page).to have_content('Name has already been taken')
        end
    end
end