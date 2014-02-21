#!/usr/bin/ruby

require 'sqlite3'

begin
db = SQLite3::Database.new 'what2eat'
puts db.get_first_value 'SELECT SQLITE_VERSION()'

###COMMENTS ARE ALREADY DONE###

#db.execute "CREATE TABLE IF NOT EXISTS FOODS(food_id INTEGER PRIMARY KEY, food_name TEXT)"
#db.execute "CREATE TABLE IF NOT EXISTS USERS_FOODS(user_food_id INTEGER PRIMARY KEY, user_id INTEGER, food_id INTEGER, rating INTEGER, FOREIGN KEY(user_id) REFERENCES USERS(user_id), FOREIGN KEY (food_id) REFERENCES FOODS(food_id)  )"
#db.execute "DESCRIBE USERS"

rescue SQLite3::Exception => e

puts "Exception occured"
puts e

ensure
db.close if db
end

