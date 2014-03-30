#!/usr/bin/env ruby
require 'mysql'

# db = Mysql.new('54.186.174.138', 'oracle', 'dragon', 'What2Eat')

begin
    con = Mysql.new('54.186.174.138', 'sean', 'dragon', 'What2Eat')
    puts con.get_server_info
    
    ##USE THIS TO FLUSH THE REMOTE DB########
    #con.query("DROP TABLE USERS_DATA")
	#con.query("CREATE TABLE IF NOT EXISTS USERS_DATA(email varchar(50) PRIMARY KEY, food VARCHAR(50), sum_rating INT(3), sum_votes INT(3))")
	#########################################
	
	
	#con.query("INSERT INTO USERS_DATA (email,food,sum_rating,sum_votes) VALUES ('sharringtonm@aol.comn','hamburger',2,1)")
	
	
	#rs = con.query("SELECT * FROM USERS_DATA")
    #n_rows = rs.num_rows
   # 
   # puts "There are #{n_rows} rows in the result set"
   # 
   # n_rows.times do
   #     puts rs.fetch_row.join("\s")
   # end
	
		
    #con.query "CALL new_data('sean@you.com','burger',2,1)"
    
    #con.query("TRUNCATE TABLE USERS_DATA")
    n = "nothing"
    
    n = con.query ("SELECT tFunc('seanarrington7@mail.csuchico.edu')")
	
    n_rows = n.num_rows
    puts n_rows
    n_rows.times do
		puts n.fetch_row
    end
    
    
    
    
rescue Mysql::Error => e
    puts e.errno
    puts e.error
    
ensure
    con.close if con
end


