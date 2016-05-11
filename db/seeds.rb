# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(email: 'steve@example.com', password: 'foobar', password_confirmation: 'foobar')

User.create!(email: 'david@example.com', password: 'barfoo', password_confirmation: 'barfoo')

25.times do |n|
  show_date = n.days.ago
  date_played = n.days.ago
  user = User.first
  user.games.create!(show_date: show_date, date_played: date_played)
end
