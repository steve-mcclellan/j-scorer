# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

steve = User.create!(email: 'steve@example.com',
                     password: 'foobar',
                     password_confirmation: 'foobar',
                     shared_stats_name: 'steve')

User.create!(email: 'david@example.com',
             password: 'barfoo',
             password_confirmation: 'barfoo')

3.times do |n|
  show_date = n.days.ago
  date_played = n.days.ago
  game = steve.games.create!(show_date: show_date,
                             date_played: date_played,
                             play_type: "regular",
                             round_one_score: -1,
                             round_two_score: 0,
                             final_result: 0)
  1.upto(6) { |i| game.round_one_categories.create!(board_position: i,
                                                    topics_string: '') }
  1.upto(6) { |i| game.round_two_categories.create!(board_position: i,
                                                    topics_string: '') }
  game.create_final!(topics_string: '')
end

utoc = steve.games.create!(show_date: Date.new(2005, 5, 25),
                           date_played: DateTime.new(2016, 6, 1, 14, 0, 0, '-04:00'),
                           play_type: "utoc",
                           round_one_score: 22,
                           round_two_score: 16,
                           final_result: 1)

topic_list = %w(Animals Science Lowbrow PopMusic Words General Language Music
                PlaceBios Europe History Asia Sports Highbrow Poetry People
                InQuotes Latin)

topic_list.each do |topic|
  eval "@#{topic.downcase} = steve.topics.create!(name: '#{topic}')"
end

j_cats = [
  ['DINOSAURS', 3, 2, 2, 2, 2, [@science, @animals]],
  ['WOMEN OF COUNTRY', 1, 2, 2, 2, 2, [@lowbrow, @popmusic]],
  ["WEBSTER'S NEW WORLD COLLEGE DICTIONARY",
    3, 2, 3, 3, 2, [@words, @language, @general]],
  ['MUSICAL INSTRUMENTS', 2, 3, 7, 2, 2, [@music]],
  ["IF IT'S TUESDAY", 3, 3, 2, 2, 3, [@general]],
  ['THIS MUST BE BELGIAN', 3, 2, 2, 2, 2, [@placebios, @europe]]
]
dj_cats = [
  ['ASIAN HISTORY', 2, 2, 2, 2, 2, [@history, @asia]],
  ['GLOVE, AMERICAN STYLE', 3, 3, 3, 2, 2, [@lowbrow, @sports]],
  ['POETS &amp; POETRY', 2, 1, 2, 2, 2, [@highbrow, @poetry]],
  ['"G" PEOPLE', 1, 3, 1, 6, 2, [@inquotes, @people]],
  ['LATIN CLASS', 1, 3, 3, 7, 2, [@language, @latin]],
  ['ROCKS', 3, 3, 3, 2, 2, [@science]]
]

j_cats.each_with_index do | cat, index |
  topics_string = cat[6].map(&:name).join(', ')
  sixth = utoc.round_one_categories.create!(board_position: index + 1,
                                            title: cat[0],
                                            result1: cat[1],
                                            result2: cat[2],
                                            result3: cat[3],
                                            result4: cat[4],
                                            result5: cat[5],
                                            topics_string: topics_string)
  sixth.topics = cat[6]
  sixth.save
end
dj_cats.each_with_index do | cat, index |
  topics_string = cat[6].map(&:name).join(', ')
  sixth = utoc.round_two_categories.create!(board_position: index + 1,
                                            title: cat[0],
                                            result1: cat[1],
                                            result2: cat[2],
                                            result3: cat[3],
                                            result4: cat[4],
                                            result5: cat[5],
                                            topics_string: topics_string)
  sixth.topics = cat[6]
  sixth.save
end

final = utoc.create_final!(category_title: '20th CENTURY AMERICANS',
                           result: 1,
                           third_right: false,
                           second_right: false,
                           first_right: true,
                           topics_string: "History, People")
final.topics = [@history, @people]
final.save
