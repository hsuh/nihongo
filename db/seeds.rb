# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Note.create(kanji: "去年", kana: 'きょねん', meaning: 'Last year')
Note.create(kanji: "今年 去年", kana: 'ことし', meaning: 'This year, last year')
