require 'rails_helper'

RSpec.describe "Order Creation" do
  describe "When I check out from my cart" do
    before(:each) do
      @mike = Merchant.create!(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

      @user = create(:random_user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"

      visit "/cart"
      click_on "Checkout"
    end

    it 'I can create a new order' do
      name = "Bert"
      address = "123 Sesame St."
      city = "NYC"
      state = "New York"
      zip = 10001

      fill_in :name, with: name
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip

      click_button "Create Order"

      new_order = Order.last

      expect(current_path).to eq("/profile/orders")

      within '.shipping-address' do
        expect(page).to have_content(name)
        expect(page).to have_content(address)
        expect(page).to have_content(city)
        expect(page).to have_content(state)
        expect(page).to have_content(zip)
      end

      within "#item-#{@paper.id}" do
        expect(page).to have_link(@paper.name)
        expect(page).to have_link("#{@paper.merchant.name}")
        expect(page).to have_content("$#{@paper.price}")
        expect(page).to have_content("2")
        expect(page).to have_content("$40")
      end

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_link("#{@tire.merchant.name}")
        expect(page).to have_content("$#{@tire.price}")
        expect(page).to have_content("1")
        expect(page).to have_content("$100")
      end

      within "#item-#{@pencil.id}" do
        expect(page).to have_link(@pencil.name)
        expect(page).to have_link("#{@pencil.merchant.name}")
        expect(page).to have_content("$#{@pencil.price}")
        expect(page).to have_content("1")
        expect(page).to have_content("$2")
      end

      within "#grandtotal" do
        expect(page).to have_content("Total: $142")
      end

      within "#datecreated" do
        expect(page).to have_content(new_order.created_at)
      end
    end

    it 'i cant create order if info not filled out' do
      name = ""
      address = "123 Sesame St."
      city = "NYC"
      state = "New York"
      zip = 10001

      fill_in :name, with: name
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip

      click_button "Create Order"

      expect(page).to have_content("Please complete address form to create an order.")
      expect(page).to have_button("Create Order")
    end

    describe "And when I create a new order" do
      before :each do
        name = "Bert"
        address = "123 Sesame St."
        city = "NYC"
        state = "New York"
        zip = 10001

        fill_in :name, with: name
        fill_in :address, with: address
        fill_in :city, with: city
        fill_in :state, with: state
        fill_in :zip, with: zip

        click_button 'Create Order'
      end

      it "the order belongs to me and I am directed to my profile where I see a flash" do
        new_order = Order.last

        expect(@user.orders.include?(new_order)).to be_truthy

        expect(current_path).to eq('/profile/orders')

        flash = 'You have placed your order!'
        expect(page).to have_content(flash)

        expect(page).to have_content(new_order.grandtotal.to_i)
        expect(page).to have_content("4")
      end
    end
    describe "Create a discounted order" do
      it "can create a discounted order with the last coupon entered applied" do
        merchant = create(:random_merchant)
        merchant_2 = create(:random_merchant)
        coupon_1 = Coupon.create(name: '10 Percent Off Total Purchase', code: '10OFF', percent_off: 0.10)
        coupon_2 = Coupon.create(name: '20 Percent Off Total Purchase', code: '20OFF', percent_off: 0.20)
        merchant.coupons << coupon_1
        merchant.coupons << coupon_2
        user = create(:random_user, role: 0)
        item_1 = create(:random_item, merchant_id: merchant.id, price: 20, inventory: 10)
        item_2 = create(:random_item, merchant_id: merchant_2.id, price: 150, inventory: 10)

        visit '/cart'
        expect(page).to have_link("Empty Cart")
        click_on "Empty Cart"

        visit "/items/#{item_1.id}"
        click_on "Add To Cart"
        visit "/items/#{item_2.id}"
        click_on "Add To Cart"

        visit '/cart'

        within "#checkout" do
          fill_in :code, with: '10OFF'
          click_on 'Apply Coupon'
        end

        expect(page).to have_content("Discounted Total: $168.00")

        visit "/items/#{item_2.id}"

        visit '/cart'

        within "#checkout" do
          fill_in :code, with: '20OFF'
          click_on 'Apply Coupon'
        end

        expect(page).to have_content("Discounted Total: $166.00")

        click_on "Checkout"

        fill_in :name, with: 'Linda Le'
        fill_in :address, with: '123 Oak St.'
        fill_in :city, with: 'Denver'
        fill_in :state, with: 'CO'
        fill_in :zip, with: '80228'
        click_on 'Create Order'
      end
    end
  end
end
