#!/usr/bin/ruby

require 'sqlite3'

begin
db = SQLite3::Database.new 'what2eat'
puts db.get_first_value 'SELECT SQLITE_VERSION()'

#db.execute "CREATE TABLE IF NOT EXISTS USERS(user_id INTEGER PRIMARY KEY, name TEXT, email TEXT)"
#db.execute "DESCRIBE USERS"

rescue SQLite3::Exception => e

puts "Exception occured"
puts e

ensure
db.close if db
end

