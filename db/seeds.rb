# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

99.times do |n|
  name  = Faker::Name.name
  email = "user#{n+1}@email.com"
  password = email.split('@')[0]+"pass"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end

99.times do |n|
  name = "Class %03d" % (n+1)
  Klass.create!(name: name)
end

users = User.all
klass1 = Klass.first
klass2 = Klass.find(2)
members1 = users[1..50]
members1.each { |m| m.join(klass1) }
members2 = users[51..99]
members2.each { |m| m.join(klass2) }
