RSpec.describe("New Order Page") do
  describe "When I check out from my cart" do
    before(:each) do
      @mike = create(:random_merchant)
      @meg = create(:random_merchant)
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
    end
    it "I see all the information about my current cart" do
      visit "/cart"

      click_on "Checkout"

      within "#order-item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_link("#{@tire.merchant.name}")
        expect(page).to have_content("$#{@tire.price}")
        expect(page).to have_content("1")
        expect(page).to have_content("$100")
      end

      within "#order-item-#{@paper.id}" do
        expect(page).to have_link(@paper.name)
        expect(page).to have_link("#{@paper.merchant.name}")
        expect(page).to have_content("$#{@paper.price}")
        expect(page).to have_content("2")
        expect(page).to have_content("$40")
      end

      within "#order-item-#{@pencil.id}" do
        expect(page).to have_link(@pencil.name)
        expect(page).to have_link("#{@pencil.merchant.name}")
        expect(page).to have_content("$#{@pencil.price}")
        expect(page).to have_content("1")
        expect(page).to have_content("$2")
      end

      expect(page).to have_content("Total(before any applied discounts): $142")

    end

    it "I see a form where I can enter my shipping info" do
      visit "/cart"
      click_on "Checkout"

      expect(page).to have_field(:name)
      expect(page).to have_field(:address)
      expect(page).to have_field(:city)
      expect(page).to have_field(:state)
      expect(page).to have_field(:zip)
      expect(page).to have_button("Create Order")
    end

    it "I see updated discounted totals if a coupon was applied in the cart and can checkout" do
      merchant = create(:random_merchant)
      merchant_2 = create(:random_merchant)
      coupon_1 = Coupon.create(name: '10 Percent Off Total Purchase', code: '10OFF', percent_off: 0.10)
      merchant.coupons << coupon_1

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

      click_on "Checkout"

      expect(page).to have_content('DISCOUNTED Total: $168.00')
    end
  end
end
