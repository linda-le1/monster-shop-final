require 'rails_helper'

describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it { should have_many :items }
    it { should have_many :users }
    it { should have_many :coupons }
  end

  describe 'status' do
    it "has a default of enabled" do
      merchant = create(:random_merchant)

      expect(merchant.enabled?).to be_truthy
    end

    it "can be disabled" do
      another_merchant = create(:random_merchant, status: 1)

      expect(another_merchant.disabled?).to be_truthy
    end
  end

  describe 'instance methods' do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @user = create(:random_user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end
    it 'no_orders' do
      expect(@meg.no_orders?).to eq(true)

      order_1 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      item_order_1 = order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.no_orders?).to eq(false)
    end

    it 'item_count' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 30, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)

      expect(@meg.item_count).to eq(2)
    end

    it 'average_item_price' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)

      expect(@meg.average_item_price).to eq(70)
    end

    it 'distinct_cities' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)
      order_1 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order_2 = @user.orders.create!(name: 'Brian', address: '123 Brian Ave', city: 'Denver', state: 'CO', zip: 17033)
      order_3 = @user.orders.create!(name: 'Dao', address: '123 Mike Ave', city: 'Denver', state: 'CO', zip: 17033)
      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      order_2.item_orders.create!(item: chain, price: chain.price, quantity: 2)
      order_3.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.distinct_cities.include?('Denver')).to be_truthy
      expect(@meg.distinct_cities.include?('Hershey')).to be_truthy
    end

    it "orders" do
      steve = create(:random_merchant)
      chain = steve.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)
      order_1 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order_2 = @user.orders.create!(name: 'Brian', address: '123 Brian Ave', city: 'Denver', state: 'CO', zip: 17033)
      order_3 = @user.orders.create!(name: 'Dao', address: '123 Mike Ave', city: 'Denver', state: 'CO', zip: 17033)
      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      order_2.item_orders.create!(item: chain, price: chain.price, quantity: 2)
      order_3.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(steve.orders).to eq([order_2])
      expect(@meg.orders.include?(order_1)).to be_truthy
      expect(@meg.orders.include?(order_3)).to be_truthy
    end

    it "toggle_status" do
      steve = create(:random_merchant)
      stevie = create(:random_merchant, status: 1)

      expect(steve.enabled?).to be_truthy
      steve.toggle_status
      expect(steve.disabled?).to be_truthy

      expect(stevie.disabled?).to be_truthy
      stevie.toggle_status
      expect(stevie.enabled?).to be_truthy
    end

    it ".deactivate_items" do
      merchant = create(:random_merchant)
      item = create(:random_item, merchant_id: merchant.id, active?: false)
      item_2 = create(:random_item, merchant_id: merchant.id)

      merchant.deactivate_items

      item.reload
      item_2.reload

      expect(item.active?).to eq(false)
      expect(item_2.active?).to eq(false)
    end

    it ".activate_items" do
      merchant = create(:random_merchant)
      item = create(:random_item, merchant_id: merchant.id, active?: false)
      item_2 = create(:random_item, merchant_id: merchant.id)

      merchant.activate_items

      item.reload
      item_2.reload

      expect(item.active?).to eq(true)
      expect(item_2.active?).to eq(true)
    end

    it '.item_orders_for' do
      item_1 = create(:random_item, merchant_id: @meg.id)
      order_1 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order_2 = @user.orders.create!(name: 'Brian', address: '123 Brian Ave', city: 'Denver', state: 'CO', zip: 17033)
      item_order_1 = order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 5)
      item_order_2 = order_1.item_orders.create!(item: item_1, price: item_1.price, quantity: 8)
      item_order_3 = order_2.item_orders.create!(item: @tire, price: @tire.price, quantity: 8)

      expect(@meg.item_orders_for(order_1)).to eq([item_order_1, item_order_2])
    end
  end
end
