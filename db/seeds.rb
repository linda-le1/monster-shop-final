# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Merchant.destroy_all
Item.destroy_all
ItemOrder.destroy_all
Order.destroy_all
User.destroy_all
Coupon.destroy_all

#merchants
bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
phone_shop = Merchant.create(name: "Daniel's Phone Shop", address: '456 Doggo St.', city: 'Denver', state: 'CO', zip: 80220)
watch_shop = Merchant.create(name: "Danny's Watch Shop", address: '456 Puppo St.', city: 'Denver', state: 'CO', zip: 80221)
liquor_store = Merchant.create(name: "Danny's Liquor store", address: '456 Liquor St.', city: 'Denver', state: 'CO', zip: 80222)

#coupons
ten_off = Coupon.create(name: "10% Off Whole Purchase", code: "10OFF", percent_off: 0.10, merchant_id: liquor_store.id)
five_off = Coupon.create(name: "5% Off Whole Purchase", code: "5OFF", percent_off: 0.05, merchant_id: bike_shop.id)
three_off = Coupon.create(name: "3% Off Whole Purchase", code: "3OFF", percent_off: 0.03, merchant_id: dog_shop.id)
twenty_off = Coupon.create(name: "20% Off Whole Purchase", code: "10OFF", percent_off: 0.20, merchant_id: phone_shop.id)

#bike_shop items
tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

#dog_shop items
pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

#phone_shop items
iphone = phone_shop.items.create(name: "Iphone XR", description: "Oldest new phone!", price: 800, image: "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone8-gold-select-2018?wid=940&hei=1112&fmt=png-alpha&qlt=80&.v=1550795416637", inventory: 32)
android = phone_shop.items.create(name: "Android 1", description: "Slowest new phone!", price: 400, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgi4uWht9jhk0EwSp5TYpELMGNgtSW1L9QLNdJTOFuPV18xQVrAA&s", inventory: 34)
flip_phone = phone_shop.items.create(name: "Flip", description: "Not your grandma's phone!", price: 40, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ8nPXoZcZDMspHo9vxUf2f9lXVbNv1Y7UlFTMKieA_WURkoIiD&s", inventory: 35)
nokia = phone_shop.items.create(name: "Nokia", description: "World's toughest phone!", price: 45, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT0w9g0LfbdHVJnfoL8Svw2vgXo1YXUOxr_Bvr_sDa3JEMfCI__Lw&s", inventory:100)

#watch_shop items
rolex = watch_shop.items.create(name: "Rolex", description: "The watch that doesn't stop!", price: 10000, image: "https://s.yimg.com/aah/movadobaby/rolex-submariner-blue-watch-16613lb-32.jpg", inventory: 1)

#liquor_store items
royal = liquor_store.items.create(name: "Royal", description: "One glass 'ill do ya'!", price: 100, image: "https://image.insider.com/5b8060763cccd122008b4579?width=1100&format=jpeg&auto=webp", inventory: 8)
yamazaki = liquor_store.items.create(name: "The Yamazaki", description: "Imported whiskey!", price: 180, image: "https://whisky.suntory.com/sites/default/files/2019-02/us-products-header-yamazaki-frame1.jpg", inventory: 7)
nikka = liquor_store.items.create(name: "Nikka", description: "Straight from the barrel!", price: 180, image: "https://cdn11.bigcommerce.com/s-zhp7f0lunw/images/stencil/1024x1024/products/17352/4757/Nikka_From_the_Barrel__52967.1577829892.jpg?c=2", inventory: 10)


user = User.create(name: "Jordan",
                    address: "394 High St",
                    city: "Denver",
                    state: "CO",
                    zip_code: "80602",
                    email: "prisonmike@hotmail.com",
                    password: "password",
                    password_confirmation: "password",
                    role: 0)

user = User.create(name: "Linda",
    address: "123 Oak Drive",
    city: "Denver",
    state: "CO",
    zip_code: "80228",
    email: "user@gmail.com",
    password: "password",
    password_confirmation: "password",
    role: 0)

admin = User.create(name: "Admin",
                    address: "394 High St",
                    city: "Denver",
                    state: "CO",
                    zip_code: "80602",
                    email: "admin@hotmail.com",
                    password: "password",
                    password_confirmation: "password",
                    role: 1)

merchant_admin = User.create(name: "Merchant Admin",
                            address: "394 High St",
                            city: "Denver",
                            state: "CO",
                            zip_code: "80602",
                            email: "merchantadmin@hotmail.com",
                            password: "password",
                            password_confirmation: "password",
                            role: 2)

second_merchant_admin = User.create(name: 'Dog Merchant Admin',
                                    address: '1979 Blake St',
                                    city: 'Denver',
                                    state: 'CO',
                                    zip_code: '80211',
                                    email: 'dogshopmerchant@gmail.com',
                                    password: 'password',
                                    password_confirmation: 'password',
                                    role: 2,
                                    merchant_id: dog_shop.id)

third_merchant_admin = User.create(name: 'Phone Merchant Admin',
                                    address: '197 lake St',
                                    city: 'Denver',
                                    state: 'CO',
                                    zip_code: '80210',
                                    email: 'phonemerchant@gmail.com',
                                    password: 'password',
                                    password_confirmation: 'password',
                                    role: 2,
                                    merchant_id: phone_shop.id)

fourth_merchant_admin = User.create(name: 'Watch Merchant Admin',
                                    address: '19 razor St',
                                    city: 'Denver',
                                    state: 'CO',
                                    zip_code: '80222',
                                    email: 'watchmerchant@gmail.com',
                                    password: 'password',
                                    password_confirmation: 'password',
                                    role: 2,
                                    merchant_id: watch_shop.id)

fifth_merchant_admin = User.create(name: 'Liquor Merchant Admin',
                                    address: '19 Razor St',
                                    city: 'Denver',
                                    state: 'CO',
                                    zip_code: '80223',
                                    email: 'liquormerchant@gmail.com',
                                    password: 'password',
                                    password_confirmation: 'password',
                                    role: 2,
                                    merchant_id: liquor_store.id)

merchant_employee = User.create(name: "Merchant Employee",
                                address: "394 High St",
                                city: "Denver",
                                state: "CO",
                                zip_code: "80602",
                                email: "merchant@hotmail.com",
                                password: "password",
                                password_confirmation: "password",
                                role: 3)

merchant_employee_2 = User.create(name: "Merchant Employee 2",
                                address: "394 Low St",
                                city: "Denver",
                                state: "CO",
                                zip_code: "80602",
                                email: "merchant2@hotmail.com",
                                password: "password",
                                password_confirmation: "password",
                                role: 3)

merchant_employee_3 = User.create(name: "Merchant Employee 3",
                                address: "394 Mid St",
                                city: "Denver",
                                state: "CO",
                                zip_code: "80602",
                                email: "merchant3@hotmail.com",
                                password: "password",
                                password_confirmation: "password",
                                role: 3)

merchant_employee_4 = User.create(name: "Merchant Employee 4",
                                address: "394 Super St",
                                city: "Denver",
                                state: "CO",
                                zip_code: "80602",
                                email: "merchant4@hotmail.com",
                                password: "password",
                                password_confirmation: "password",
                                role: 3)

bike_shop.users << merchant_admin
bike_shop.users << merchant_employee
phone_shop.users << merchant_employee_2
watch_shop.users << merchant_employee_3
liquor_store.users << merchant_employee_4

order_1 = user.orders.create(name: "Jordan", address: "123 Hi Road", city: "Cleveland", state: "OH", zip: "44333", current_status: 0)
ItemOrder.create(item: tire, order: order_1, price: tire.price, quantity: 2, status: 0)

order_2 = user.orders.create(name: "Jordan", address: "123 Hi Road", city: "Cleveland", state: "OH", zip: "44333", current_status: 1)
ItemOrder.create(item: tire, order: order_2, price: tire.price, quantity: 2, status: 1)

order_3 = user.orders.create(name: "Danny", address: "123 Low Road", city: "Cleveland", state: "OH", zip: "44334", current_status: 0)
ItemOrder.create(item: android, order: order_3, price: android.price, quantity: 1, status: 0)
ItemOrder.create(item: rolex, order: order_3, price: rolex.price, quantity: 1, status: 0)
ItemOrder.create(item: royal, order: order_3, price: royal.price, quantity: 1, status: 0)

order_4 = user.orders.create(name: "Linda", address: "456 Low Road", city: "Cleveland", state: "OH", zip: "44335", current_status: 0)
ItemOrder.create(item: yamazaki, order: order_4, price: yamazaki.price, quantity: 3, status: 0)
ItemOrder.create(item: nikka, order: order_4, price: nikka.price, quantity: 2, status: 0)
ItemOrder.create(item: rolex, order: order_4, price: rolex.price, quantity: 1, status: 0)
ItemOrder.create(item: flip_phone, order: order_4, price: flip_phone.price, quantity: 10, status: 0)

order_5 = user.orders.create(name: "Jordie", address: "456 Low Street", city: "Cleveland", state: "OH", zip: "44336", current_status: 0)
ItemOrder.create(item: rolex, order: order_5, price: rolex.price, quantity: 1, status: 0)
ItemOrder.create(item: iphone, order: order_5, price: iphone.price, quantity: 1, status: 0)
ItemOrder.create(item: flip_phone, order: order_5, price: flip_phone.price, quantity: 1, status: 0)
ItemOrder.create(item: nikka, order: order_5, price: nikka.price, quantity: 100, status: 0)

#orders for use with coupons
order_6 = user.orders.create(name: "Linda", address: "456 Whiskey Ave", city: "Denver", state: "CO", zip: "80228", current_status: 0)
ItemOrder.create(item: yamazaki, order: order_6, price: yamazaki.price, quantity: 1, status: 0)

ten_off.orders << order_6

#reviews
review_1 = iphone.reviews.create(title: "Best phone!", content: "!!!", rating: 5)
review_2 = iphone.reviews.create(title: "OK phone", content: "Meh, it's fine", rating: 3)
review_3 = rolex.reviews.create(title: "So ice", content: "niceeeeee", rating: 5)
review_4 = royal.reviews.create(title: "Not too impressed", content: "v basic", rating: 2)
review_5 = nikka.reviews.create(title: "Okay", content: "It's ok", rating: 3)
