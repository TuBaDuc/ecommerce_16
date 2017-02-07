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
