require 'rails_helper'

RSpec.describe 'Cart show' do
  describe 'When I have added items to my cart' do
    describe 'and visit my cart path' do
      before(:each) do
        @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
        @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

        @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
        @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

        visit "/items/#{@paper.id}"
        click_on "Add To Cart"
        visit "/items/#{@tire.id}"
        click_on "Add To Cart"
        visit "/items/#{@pencil.id}"
        click_on "Add To Cart"
        @items_in_cart = [@paper,@tire,@pencil]
      end

      it 'I can empty my cart by clicking a link' do
        visit '/cart'
        expect(page).to have_link("Empty Cart")
        click_on "Empty Cart"
        expect(current_path).to eq("/cart")
        expect(page).to_not have_css(".cart-items")
        expect(page).to have_content("Cart is currently empty")
      end

      it 'I see all items Ive added to my cart' do
        visit '/cart'

        @items_in_cart.each do |item|
          within "#cart-item-#{item.id}" do
            expect(page).to have_link(item.name)
            expect(page).to have_css("img[src*='#{item.image}']")
            expect(page).to have_link("#{item.merchant.name}")
            expect(page).to have_content("$#{item.price}")
            expect(page).to have_content("1")
            expect(page).to have_content("$#{item.price}")
          end
        end
        expect(page).to have_content("Total: $122")

        visit "/items/#{@pencil.id}"
        click_on "Add To Cart"

        visit '/cart'

        within "#cart-item-#{@pencil.id}" do
          expect(page).to have_content("2")
          expect(page).to have_content("$4")
        end

        expect(page).to have_content("Total: $124")
      end

      it 'I can add a coupon code and see the discounted and updated total' do
            merchant = create(:random_merchant)
            merchant_2 = create(:random_merchant)
            merchant_user = create(:random_user, role: 3, merchant_id: merchant.id)
            coupon_1 = Coupon.create(name: '10 Percent Off Total Purchase', code: '10OFF', percent_off: 0.10)
            merchant.coupons << coupon_1

            user = create(:random_user, role: 0)
            item_1 = create(:random_item, merchant_id: merchant.id, price: 20, inventory: 10)
            item_2 = create(:random_item, merchant_id: merchant_2.id, inventory: 10)
            merchant.coupons << coupon_1

            visit '/cart'
            expect(page).to have_link("Empty Cart")
            click_on "Empty Cart"

            visit "/items/#{item_1.id}"
            click_on "Add To Cart"
            visit "/items/#{item_2.id}"
            click_on "Add To Cart"

            visit '/cart'

            within "#discount" do
              fill_in :code, with: '10OFF'
              click_on 'Apply Coupon'
            end

            expect(current_path).to eql('/cart')
            expect(page).to have_content('Discount Applied: $2.00')
            expect(page).to have_content('Total: $18.00')
        end

        it 'cannot add a bad coupon code' do
          merchant = create(:random_merchant)
          merchant_2 = create(:random_merchant)
          merchant_user = create(:random_user, role: 3, merchant_id: merchant.id)
          coupon_1 = Coupon.create(name: '10 Percent Off Total Purchase', code: '10OFF', percent_off: 0.10)
          merchant.coupons << coupon_1

          user = create(:random_user, role: 0)
          item_1 = create(:random_item, merchant_id: merchant.id, price: 20, inventory: 10)
          item_2 = create(:random_item, merchant_id: merchant_2.id, inventory: 10)
          merchant.coupons << coupon_1

          visit "/items/#{item_1.id}"
          click_on "Add To Cart"
          visit "/items/#{item_2.id}"
          click_on "Add To Cart"

          visit '/cart'

          within "#discount" do
            fill_in :code, with: '25OFF'
            click_on 'Apply Coupon'
          end

          expect(current_path).to eql('/cart')
          expect(page).to have_content('This is an invalid coupon. Please try again.')
      end
    end
  end

  describe "When I haven't added anything to my cart" do
    describe "and visit my cart show page" do
      it "I see a message saying my cart is empty" do
        visit '/cart'
        expect(page).to_not have_css(".cart-items")
        expect(page).to have_content("Cart is currently empty")
      end

      it "I do NOT see the link to empty my cart" do
        visit '/cart'
        expect(page).to_not have_link("Empty Cart")
      end
    end
  end
end
