#!/usr/bin/env rubyT
require 'gtk2'
require 'sqlite3'

#############################################
# add_user_to_local_db(object,object,object)
#############################################
def add_user_to_local_db(cb,userAddEntry,emailAddEntry)
    $con = SQLite3::Database.open "what2eat"
	$stm = $con.prepare "SELECT name from USERS where name = '#{userAddEntry.text}'" #prepare sql statement
    rs = $stm.execute #fire the sql statement
    row = rs.next
	$stm.close
	
	if row.nil?
	$con.execute "INSERT INTO USERS(name,email) VALUES ('#{userAddEntry.text}','#{emailAddEntry.text}')"
    cb.append_text(userAddEntry.text)
    userAddEntry.text = ""
    emailAddEntry.text = ""
    $con.close
	else
		puts "ALREADY EXISTS"
		$con.close
		#BAD! RETURN
		return
    end
end
#############################################
# populate_user_select_cb(object)
#############################################
def populate_user_select_cb(cb)
	$con = SQLite3::Database.open "what2eat"
    $stm = $con.prepare "SELECT * from USERS" #prepare sql statement
    $rs = $stm.execute #fire the sql statement
    $rs.each do |row|
		cb.append_text(row[1]) #add to combobox
    end
    $stm.close #close sql statement
    $con.close
    cb.set_active(0)
end

#############################################
# populate_food_select(object)
# Thoughts: Currently Looks at everyfood
# for every user. May want to put it to 
# only foods for current user
#############################################
def populate_food_select_cb(cb)
	$con = SQLite3::Database.open "what2eat"
	$stm = $con.prepare "SELECT * from FOODS" #prepare sql statement
	$rs = $stm.execute #fire the sql statement
	$rs.each do |row|
	        cb.append_text(row[1]) #add to combobox
	end
	$stm.close #close sql statement
	$con.close
	cb.set_active(0)
end

#############################################
# get_email(string)
#############################################
def get_email(user_name)
	$con = SQLite3::Database.open "what2eat"
	$stm = $con.prepare "SELECT email from USERS where name = '#{user_name}'" #prepare sql statement
    rs = $stm.execute #fire the sql statement
	row = rs.next
    $stm.close #close sql statement
    $con.close
	return row[0]
end

#############################################
# get_user_id(string)
#############################################
def get_user_id(user_name)
	$con = SQLite3::Database.open "what2eat"
    $stm = $con.prepare "SELECT user_id from USERS where name = '#{user_name}'" #prepare sql statement
    rs = $stm.execute #fire the sql statement
    row = rs.next
    $stm.close #close sql statement
    $con.close
    return row[0]
end

#############################################
# get_food_id(string)
#############################################
def get_food_id(food_name)
        $con = SQLite3::Database.open "what2eat"
        $stm = $con.prepare "SELECT food_id from FOODS where food_name = '#{food_name}'" #prepare sql statement
        rs = $stm.execute #fire the sql statement
        row = rs.next
        $stm.close #close sql statement
        $con.close
        return row[0]
end
#############################################
# add_food_to_local_db(string, integer, integer)
# UPDATE STATEMENT IF EXISTS
#
#############################################
def add_food_to_local_db(food_name,user_id,rating)
	$con = SQLite3::Database.open "what2eat"
    $stm = $con.prepare "SELECT food_name from FOODS where food_name = '#{food_name}'" #prepare sql statement
    rs = $stm.execute #fire the sql statement
    row = rs.next
    $stm.close
	if row.nil? #brand new
		$con.execute "INSERT INTO FOODS(food_name) VALUES ('#{food_name}')"
		$con.execute "INSERT INTO USERS_FOODS(user_id,food_id,rating) VALUES (#{user_id},#{get_food_id(food_name).to_i},#{rating})"
		$con.close
		return true
	else #It exists in the foods table
		
	    puts "ALREADY EXISTS"
		$stm = $con.prepare "SELECT user_food_id from USERS_FOODS where food_id = #{get_food_id(food_name).to_i} AND user_id = #{user_id}" #prepare sql statement
		rs = $stm.execute #fire the sql statement
		row = rs.next
		$stm.close
		if row.nil? #brand new
		$con.execute "INSERT INTO USERS_FOODS(user_id,food_id,rating) VALUES (#{user_id},#{get_food_id(food_name).to_i},#{rating})"
		else
		$con.execute "UPDATE USERS_FOODS SET rating = #{rating} WHERE user_id = #{user_id} and food_id = #{get_food_id(food_name).to_i}"
				#update  Author='Lev Nikolayevich Tolstoy' WHERE Id=1;
		end
		$con.close
		#NEED TO CHECK IF USER_FOODS exists already
		return false
	end
        
end      

#############################################
# update_email(string,string)
#############################################
def update_email(user_name,email)
	$con = SQLite3::Database.open "what2eat"
        $con.execute "UPDATE USERS SET email= '#{email}' WHERE name = '#{user_name}' "
	$con.close
end
#############################################
# GetFoodSelect(object,object,integer,integer)
#############################################
def GetFoodSelect(entry_food_new,cb_food,user_id,rating)
	if entry_food_new.text.length == 0 && cb_food.active_text.length == 0
		return 0
	elsif entry_food_new.text.length == 0 #if its an existing food
		add_food_to_local_db(cb_food.active_text,user_id,rating)
	else #if its a new food
		if add_food_to_local_db(entry_food_new.text,user_id,rating)
			cb_food.append_text(entry_food_new.text)
			entry_food_new.text = ""
		end	
	end
end

#############################################
# select_user_window(string)
#############################################
def select_user_window(user_name)
	$user_window = Gtk::Window.new(Gtk::Window::TOPLEVEL)
	$user_window_table = Gtk::Table.new(9,2,false)
	$user_window.set_title "USER DATA ENTRY"
	$user_window.border_width = 10
	$user_window.resizable=(false)
	$user_window.modal=(true)
	$user_window.set_size_request(300,-1)
	$show_name = Gtk::Label.new("Name: #{user_name}")
	$email_update_field = Gtk::Entry.new
	$email_update_button = Gtk::Button.new("Update")
	$email_update_button.signal_connect("clicked") {
		update_email(user_name,$email_update_field.text)     
	}
	$email_update_field.text = get_email(user_name)
	$entry_food_new = Gtk::Entry.new
	$entry_food_new.text = ""
	$button_food_new_love = Gtk::Button.new("Love It!")
	$button_food_new_ok = Gtk::Button.new("It's Ok...")
	$button_food_new_hate = Gtk::Button.new("Hate It!")	
	$cb_food = Gtk::ComboBox.new
	$frame_rate = Gtk::Frame.new()
	$hzLine = Gtk::HSeparator.new
	$button_food_quit = Gtk::Button.new("Quit")
	$label_new_food = Gtk::Label.new("Enter New Food")
	$label_rate_it = Gtk::Label.new("Rate It!")
	$label_existing = Gtk::Label.new("Existing Food")
	populate_food_select_cb($cb_food)
	$cb_food.set_active(0)
	$button_food_quit.signal_connect("clicked") {$user_window.destroy}
	$button_food_new_love.signal_connect("clicked") {
	GetFoodSelect($entry_food_new,$cb_food,get_user_id(user_name).to_i,3)
	}
	$user_window_table.attach($show_name,0,2,0,1)
	$user_window_table.attach($email_update_field,0,1,1,2)
	$user_window_table.attach($email_update_button,1,2,1,2)
	$user_window_table.attach($label_new_food,0,1,3,4)
	$user_window_table.attach($label_rate_it,1,2,3,4)
	$user_window_table.attach($hzLine,0,2,2,3)
	$user_window_table.attach($label_existing,0,1,5,6)
	$user_vbox = Gtk::VBox.new()	
	$user_window_table.attach($entry_food_new,0,1,4,5)
	$user_window_table.attach($frame_rate,1,2,4,7)
	$frame_rate.set_shadow_type( Gtk::SHADOW_ETCHED_OUT )
	$frame_rate.add($user_vbox)
	$user_vbox.pack_start($button_food_new_love,false,false,0)
	$user_vbox.pack_start($button_food_new_ok,false,false,0)
	$user_vbox.pack_start($button_food_new_hate,false,false,0)
	$user_window_table.attach($cb_food,0,1,6,7)
	$user_window_table.attach($button_food_quit,0,2,8,9)
	$user_window.add($user_window_table)
	$user_window.show_all
end


#############################################
# another_tab
# Notes: Just a debug
#############################################

def another_tab; puts "Switching"; end

window = Gtk::Window.new(Gtk::Window::TOPLEVEL)
window.set_title  "WHAT2EAT?"
window.border_width = 10
window.set_size_request(465, -1)
window.resizable=(false)
window.signal_connect('delete_event') { Gtk.main_quit }

########GUI OBJECTS##################################
$nbMain = Gtk::Notebook.new
$addTab = Gtk::Label.new("Add Data")
$reportTab = Gtk::Label.new("Reports")
$updateTab = Gtk::Label.new("Update Remote")
button_report  = Gtk::Button.new("Click Here to:\nGet Information")
button_update = Gtk::Button.new("Click here to:\nPush and pull information\nfrom the server")
$optionTab = Gtk::Label.new("Options")
$tableAdd = Gtk::Table.new(3,3,false)
$tableMainMenu = Gtk::Table.new(2,1,false)
$tableOption = Gtk::Table.new(2,2,false)
$buttonQuit = Gtk::Button.new("Quit")
button_option = Gtk::Button.new("Others")
$buttonAddSelect = Gtk::Button.new("Select")
$buttonAddNewUser = Gtk::Button.new("Create")
$cb = Gtk::ComboBox.new
$AddNameLabel = Gtk::Label.new("Name")
$AddEmailLabel = Gtk::Label.new("Email")
$userAddEntry = Gtk::Entry.new
$emailAddEntry = Gtk::Entry.new
$imageScale = Gdk::Pixbuf.new "food.jpg"
$imageScale = $imageScale.scale(400,200,'bilinear')
$imageMain = Gtk::Image.new ($imageScale) 

$fixed = Gtk::Fixed.new
#####################################################

#########DEFINE BUTTONS##############################
$buttonQuit.signal_connect("clicked"){Gtk.main_quit} #quits
button_report.signal_connect("clicked") {puts "TBI GO TO REPORTS PAGE"} #Temp
button_update.signal_connect( "clicked" ) {puts "TBI UPLOAD/DOWNLOAD FROM REMOTE"} #temp
$nbMain.signal_connect('change-current-page') {	another_tab}
$buttonAddSelect.signal_connect("clicked") {select_user_window($cb.active_text)}
button_option.signal_connect("clicked"){puts "TBI GO TO OPTIONS PAGE"}
$buttonAddNewUser.signal_connect("clicked"){
	if $userAddEntry.text.length == 0
		puts "DEBUG: Nothing was entered"
	else
		add_user_to_local_db($cb,$userAddEntry,$emailAddEntry)
	end
}
########################################################

populate_user_select_cb($cb)


################ATTACH TO OPTIONS TAB############################
$tableOption.attach($buttonQuit,0,1,1,2)
$tableOption.attach(button_option,0,1,0,1)
###################ATTACHMENT TO ADD TAB####################################
$tableAdd.attach($AddNameLabel,0,1,0,1)
$tableAdd.attach($AddEmailLabel,1,2,0,1)
$tableAdd.attach($userAddEntry,0,1,1,2)
$tableAdd.attach($emailAddEntry,1,2,1,2)
$tableAdd.attach($buttonAddNewUser,2,3,0,2)
$tableAdd.attach($cb,0,2,2,3) #attached combobox to add table
$tableAdd.attach($buttonAddSelect,2,3,2,3) #attaches select button to add table
##############ATTACHMENT TO NOTEBOOK#############################
$nbMain.append_page(button_report, $reportTab) #creates reports tab
$nbMain.append_page($tableAdd, $addTab) #creates add tab
$nbMain.append_page(button_update,  $updateTab) #creates update tab
$nbMain.append_page($tableOption, $optionTab) #creates options tab
##########ATTACHMENT TO MAIN WINDOW###############################
$fixed.put $imageMain, 20, 20
$tableMainMenu.attach($fixed,0,1,0,1) #Adds image to main table
$tableMainMenu.attach($nbMain,0,1,1,2) #adds Notebook to main table
###################MAIN################################

window.add($tableMainMenu)
window.show_all

Gtk.main
