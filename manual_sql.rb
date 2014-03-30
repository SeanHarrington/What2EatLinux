#!/usr/bin/ruby

require 'sqlite3'

begin
db = SQLite3::Database.open 'what2eat'
puts db.get_first_value 'SELECT SQLITE_VERSION()'

#db.execute ".schema"

###COMMENTS ARE ALREADY DONE###
#db.execute "DROP TABLE USERS_FOODS"
#db.execute "DROP TABLE USERS"
#db.execute "DROP TABLE FOODS"

#db.execute "CREATE TABLE USERS(user_id INTEGER PRIMARY KEY, name TEXT, email TEXT)"
#db.execute "CREATE TABLE FOODS(food_id INTEGER PRIMARY KEY, food_name TEXT)"
#db.execute "CREATE TABLE USERS_FOODS(user_food_id INTEGER PRIMARY KEY, user_id INTEGER, food_id INTEGER, rating INTEGER, FOREIGN KEY(user_id) REFERENCES USERS(user_id), FOREIGN KEY (food_id) REFERENCES FOODS(food_id)  )"
#db.execute "ALTER TABLE USERS_FOODS ADD COLUMN old_rating INTEGER"
#db.execute "ALTER TABLE USERS_FOODS ADD COLUMN updated INTEGER"
#db.execute "ALTER TABLE USERS_FOODS ADD COLUMN avg_rating INTEGER"
#db.execute "DESCRIBE USERS"

#db.execute "UPDATE USERS_FOODS SET updated = 0"

#"SELECT USERS.name, FOODS.food_name, USERS_FOODS.rating FROM USERS, FOODS, USERS_FOODS WHERE USERS.user_id = USERS_FOODS.user_id AND USERS_FOODS.food_id = FOODS.food_id WHERE USERS.name = 'Sean Harrington'"

#SELECT * from FOODS ORDER BY food_name
#SELECT FOODS.food_name from FOODS, USERS_FOODS WHERE USERS_FOODS.food_id = FOODS.food_id AND USERS_FOODS.user_id = #{user-number}


#SELECT sql FROM (SELECT * FROM sqlite_master UNION ALL SELECT * FROM sqlite_temp_master) WHERE type!='meta' ORDER BY tbl_name, type DESC, name
#The above statement is sqlite DESCRIBE COMMAND FOR THE WHOLE SCHEMA

#$stm = db.prepare "SELECT sql FROM (SELECT * FROM sqlite_master UNION ALL SELECT * FROM sqlite_temp_master) WHERE type!='meta' ORDER BY tbl_name, type DESC, name" #prepare sql statement
#    $rs = $stm.execute #fire the sql statement
#    $rs.each do |row|#
#		puts row
#	puts ""
#	end
#$stm.close #close sql statement
 
 #db.execute "delete from USERS_FOODS"
 #db.execute "delete from USERS"
 #db.execute "delete from FOODS"
 
#    $stm = db.prepare "SELECT * USERS where name = 'Becca Harrington'" #prepare sql statement
#    rs = $stm.execute #fire the sql statement
#    row = rs.next
#    puts row
#    $stm.close #close sql statement
#db.execute "DROP TABLE USERS_FOODS"
#db.execute "CREATE TABLE USERS_FOODS(user_food_id INTEGER PRIMARY KEY, user_id INTEGER, food_id INTEGER, rating INTEGER, old_rating INTEGER, updated INTEGER, avg_rating INTEGER, FOREIGN KEY(user_id) REFERENCES USERS(user_id), FOREIGN KEY (food_id) REFERENCES FOODS(food_id)  )"

#db.execute "UPDATE USERS_FOODS SET old_rating = 0"
#db.execute "UPDATE USERS_FOODS SET avg_rating = 0"
#db.execute "UPDATE USERS_FOODS SET updated = 1"
#db.execute "UPDATE USERS_FOODS SET rating = 3 where food_id = 16"
 
$stm = db.prepare "SELECT user_id, food_id, rating FROM USERS_FOODS" #prepare sql statement
    $rs = $stm.execute #fire the sql statement
    $rs.each do |row|##
puts row
puts ""
end
$stm.close #close sql statement 

rescue SQLite3::Exception => e

puts "Exception occured"
puts e

ensure
db.close if db
end

