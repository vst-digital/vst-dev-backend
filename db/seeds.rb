# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
User.create(email: "toro@gmail.com", first_name: "Toro", last_name: "Singh", contact: "9876543210", role: "subscription_owner", password: "123123123", password_confirmation: "123123123")