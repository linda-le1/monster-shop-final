require 'rails_helper'

RSpec.describe 'As a merchant employee/admin' do
  before :each do
    merchant = create(:random_merchant)
    merchant2 = create(:random_merchant)
    merchant_employee = create(:random_user, role: 3, merchant_id: merchant.id)
    @coupon_1 = Coupon.create(name: "10% Off Item", code: "10OFF", percent_off: 0.10)
    merchant2.coupons << @coupon_1
    @user = create(:random_user)

    @item_1 = create(:random_item, merchant_id: merchant.id, inventory: 10, price: 10)
    @item_2 = create(:random_item, merchant_id: merchant.id, inventory: 2)
    @item_3 = create(:random_item, merchant_id: merchant2.id, price: 20)

    @order = create(:random_order, user_id: @user.id)
    @order2 = create(:random_order, user_id: @user.id, current_status: 2, coupon_id: @coupon_1.id)


    @item_1_order = ItemOrder.create!(item: @item_1, order: @order, price: @item_1.price, quantity: 5)
    @item_2_order = ItemOrder.create!(item: @item_2, order: @order, price: @item_2.price, quantity: 3)
    @item_3_order = ItemOrder.create!(item: @item_3, order: @order, price: @item_3.price, quantity: 9)

    @item_4_order = ItemOrder.create!(item: @item_1, order: @order2, price: @item_1.price, quantity: 1, status: 1)
    @item_5_order = ItemOrder.create!(item: @item_3, order: @order2, price: @item_3.price, quantity: 2, status: 1)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_employee)
  end

  it 'from merchant dashboard can click order id to visit order show page' do
    visit '/merchant'

    within "#pending-#{@order.id}" do
      click_link "#{@order.id}"
    end

    expect(current_path).to eq("/merchant/orders/#{@order.id}")
  end

  it 'sees recipients information on order show page' do
    visit "/merchant/orders/#{@order.id}"

    expect(page).to have_content(@order.id)
    expect(page).to have_content(@user.name)
    expect(page).to have_content(@user.address)
    expect(page).to have_content(@user.city)
    expect(page).to have_content(@user.state)
    expect(page).to have_content(@user.zip_code)
  end

  it 'only displays items belonging to merchant' do
    order2 = create(:random_order, user_id: @user.id)
    item_1_order2 = ItemOrder.create!(item: @item_1, order: order2, price: @item_1.price, quantity: 5)

    visit "/merchant/orders/#{@order.id}"

    within "#item-#{@item_1.id}" do
      expect(page).to have_content(@item_1.name)
      expect(page).to have_css("img[src*='#{@item_1.image}']")
      expect(page).to have_content(@item_1.price)
      expect(page).to have_content("Quantity: #{@item_1_order.quantity}")
    end

    within "#item-#{@item_2.id}" do
      expect(page).to have_content(@item_2.name)
      expect(page).to have_css("img[src*='#{@item_2.image}']")
      expect(page).to have_content(@item_2.price)
      expect(page).to have_content("Quantity: #{@item_2_order.quantity}")
    end

    expect(page).not_to have_css("#item-#{@item_3.id}")
  end

  it "has link for item name to item's show page" do
    visit "/merchant/orders/#{@order.id}"

    within "#item-#{@item_1.id}" do
      click_link "#{@item_1.name}"
    end

    expect(current_path).to eq("/items/#{@item_1.id}")
  end

  it "shows a button to fulfill the item if order quantity is less than inventory quantity" do
    visit "/merchant/orders/#{@order.id}"

    within "#item-#{@item_1.id}" do
      expect(page).to have_button("Fulfill")
    end

    within "#item-#{@item_2.id}" do
      expect(page).not_to have_button("Fulfill")
    end
  end

  it 'fulfills the item and takes me back to the order show page' do
    visit "/merchant/orders/#{@order.id}"

    within "#item-#{@item_1.id}" do
      click_button ("Fulfill")
    end

    expect(current_path).to eq("/merchant/orders/#{@order.id}")

    within "#item-#{@item_1.id}" do
      expect(page).not_to have_button("Fulfill")
    end

    @item_1.reload

    item = Item.find(@item_1.id)

    expect(page).to have_content("You have fulfilled order for #{@item_1.name}")
    expect(item.inventory).to eq(5)

    within "#item-#{@item_1.id}" do
      expect(page).to have_content("This item is fulfilled for this order")
    end
  end

  it "shows a notice next to the item that I cannot fulfill if I do not have enough inventory" do
    visit "/merchant/orders/#{@order.id}"

    within "#item-#{@item_2.id}" do
      expect(page).not_to have_button("Fulfill")
      expect(page).to have_content('Not enough inventory to fulfill this order with this item')
    end
  end

    it "can see discounted order information" do
      visit "/merchant/orders/#{@order2.id}"

      expect(page).to have_content("Coupon Used: #{@coupon_1.name}")
      expect(page).to have_content("Discounted Total: $45.00")
  end
end
