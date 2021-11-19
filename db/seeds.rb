User.create!(name: "Example User",
            email:
            "example@railstutorial.org",
            password: "123123",
            password_confirmation: "123123",
            admin: true)
50.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "123456"
  User.create!(name: name,
    email: email,
    password: password,
    password_confirmation: password)
end
