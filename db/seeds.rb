# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

steve = User.create!(email: 'steve@example.com', password: 'foobar', password_confirmation: 'foobar')

User.create!(email: 'david@example.com', password: 'barfoo', password_confirmation: 'barfoo')

25.times do |n|
  show_date = n.days.ago
  date_played = n.days.ago
  steve.games.create!(show_date: show_date, date_played: date_played)
end

utoc = steve.games.create!(show_date: Date.new(2005, 5, 25),
                           date_played: DateTime.new(2016, 6, 1, 14, 0, 0, '-04:00'),
                           play_type: "UToC")

j_cats = [
  ['DINOSAURS', 3, 2, 2, 2, 2],
  ['WOMEN OF COUNTRY', 1, 2, 2, 2, 2],
  ["WEBSTER'S NEW WORLD COLLEGE DICTIONARY", 3, 2, 3, 3, 2],
  ['MUSICAL INSTRUMENTS', 2, 3, 7, 2, 2],
  ["IF IT'S TUESDAY", 3, 3, 2, 2, 3],
  ['THIS MUST BE BELGIAN', 3, 2, 2, 2, 2]
]
dj_cats = [
  ['ASIAN HISTORY', 2, 2, 2, 2, 2],
  ['GLOVE, AMERICAN STYLE', 3, 3, 3, 2, 2],
  ['POETS &amp; POETRY', 2, 1, 2, 2, 2],
  ['"G" PEOPLE', 1, 3, 1, 6, 2],
  ['LATIN CLASS', 1, 3, 3, 7, 2],
  ['ROCKS', 3, 3, 3, 2, 2]
]

j_cats.each_with_index do | cat, index |
  utoc.round_one_categories.create!(board_position: index + 1,
                                    title: cat[0],
                                    result1: cat[1],
                                    result2: cat[2],
                                    result3: cat[3],
                                    result4: cat[4],
                                    result5: cat[5])
end
dj_cats.each_with_index do | cat, index |
  utoc.round_two_categories.create!(board_position: index + 1,
                                    title: cat[0],
                                    result1: cat[1],
                                    result2: cat[2],
                                    result3: cat[3],
                                    result4: cat[4],
                                    result5: cat[5])
end

utoc.create_final!(category_title: '20th CENTURY AMERICANS',
                   result: 1,
                   contestants_right: 1,
                   contestants_wrong: 2)

topic_list = %w(Animals Science Lowbrow PopMusic Words General Language Music
                PlaceBios Europe History Asia Sports Highbrow Poetry People
                InQuotes Latin)

topic_list.each do |topic|
  eval "#{topic.downcase} = steve.topics.create!(name: '#{topic}')"
end

# TODO: Pick up here now that cat_top ordering is taken care of in
#       the categories. Continue putting a full game into the database,
#       then have a full game available in the fixtures.
