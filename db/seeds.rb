User.create!(name: "管理者",
  email: "admin@email.com",
  password: "password",
  password_confirmation: "password",
  admin: true)

User.create!(name: "上長A",
  email: "userA@email.com",
  password: "password",
  password_confirmation: "password",
  superiors: true)

User.create!(name: "上長B",
  email: "userB@email.com",
  password: "password",
  password_confirmation: "password",
  superiors: true)

25.times do |n|
name = Faker::Name.name
email = "sample-#{n+1}@email.com"
password = "password"
User.create!(name: name,
    email: email,
    password: password,
    password_confirmation: password)
end