User.create!(name:  "Duc Admin",
             email: "admin@gmail.com",
             password: "123456",
             role: 1,
             phone: "0909897061",
             address: "A1606, Tan Huong, Tan Phu, HCM")

99.times do |n|
  name  = Faker::Name.name
  email = "example#{n+1}@gmail.vn"
  password = "123456"
  User.create!(name:  name,
               email: email,
               password: password,
               phone: "0909897061",
               address: "A1606, Tan Huong, Tan Phu, HCM")
end


3.times do |n|
  Category.create name: Faker::Pokemon.name,
    description: Faker::Lorem.sentence, parent_id: nil
end

Category.roots.each do |cat|
  2.times do |n|
    Category.create name: Faker::Pokemon.name,
      description: Faker::Lorem.sentence, parent_id: cat.id
  end
end

Category.where(depth: 1).find_each do |cat|
  cats = rand(1..2)
  cats.times do |n|
    Category.create name: Faker::Pokemon.name,
      description: Faker::Lorem.sentence, parent_id: cat.id
  end
end

25.times do |p|
  product_name = Faker::Cat.name + p.to_s
  description = Faker::Lorem.sentence
  price = rand(10000..2000000)
  in_stock = rand(0..20)
  category_id = rand(Category.first.id..Category.last.id)
  rating = rand(0..5)
  Product.create! name: product_name,
    description: description,
    price: price,
    in_stock: in_stock,
    category_id: category_id,
    avg_rating: rating,
    code: "PRO."+Faker::Code.ean
end

User.all.order("RANDOM()").limit(25).find_each do |user|
  orders = rand(1..6)
  address = Faker::Address.street_address + ", " +
        Faker::Address.city + ", " +
        Faker::Address.country
  orders.times do |n|
    o_status = rand(0..3)
    o_bill = rand(1..15)*105000
    order = Order.create! code: "ORD"+Faker::Code.ean,
    status: o_status,
    total_bill: o_bill,
    ship_address: address,
    contact_phone: user.phone,
    user_id: user.id
    prod_num = rand(1..3)
    prod_num.times do |p|
      order.order_details.create! order_id: order.id,
      quantity: rand(1..3),
      price: (order.total_bill/prod_num).to_i,
      product_id: Product.offset(rand(Product.count)).first
    end
  end
end
