# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(email: "james.leong94@gmail.com",
            session_token: "ABCD1234",
            password: "mypassword",
            password_confirmation: "mypassword")

User.create(email: "alice@alice.com",
            session_token: "12341234",
            password: "password123",
            password_confirmation: "password123")