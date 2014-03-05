#!/usr/bin/env rubyT
require 'gtk2'
require 'sqlite3'


#############################################
# print_report(integer,anything,anything)
# early reports debug
#############################################
def print_report(report_num,passed_1,passed_2)

	$con = SQLite3::Database.open "what2eat"
	if report_num == 1

    $stm = $con.prepare "SELECT * from USERS" #prepare sql statement
    $rs = $stm.execute #fire the sql statement
    $rs.each do |row|
		puts row[1] +" "+ row[2] #add to combobox
    end
    $stm.close #close sql statement

	elsif report_num == 2

	$stm = $con.prepare "SELECT FOODS.food_name, USERS_FOODS.rating FROM USERS, FOODS, USERS_FOODS WHERE USERS.user_id = USERS_FOODS.user_id AND USERS_FOODS.food_id = FOODS.food_id AND USERS.name = '#{passed_1}' ORDER BY FOODS.food_name" #prepare sql statement
    $rs = $stm.execute #fire the sql statement
    $rs.each do |row|
		rated = row[1]
		if rated == 1
		rated = "Hate it"
		elsif rated == 2
		rated = "It's Ok"
		elsif rated == 3
		rated = "Love It"
		else
		rated = "NONE"
		end
		puts row[0] + ", " + rated
		#puts row[0] + ", " + row[1]#add to combobox
    end
    $stm.close #close sql statement

	elsif report_num == 3

	else
	puts "unknown report number"
	end

	$con.close

end

def about_box()
		about = Gtk::AboutDialog.new
        about.set_program_name "What2Eat"
        about.set_version "0.1"
        about.set_copyright "(c) Sean Harrington"
        about.set_comments "A Simple Tool To Track Eating Habits"
        about.set_website "https://github.com/SeanHarrington/What2EatLinux"
        about.set_logo Gdk::Pixbuf.new "food1.png"
        about.run
        about.destroy
end


def createReportUser(user_name)

	user_number = get_user_id(user_name)
	$reportBox = Gtk::Window.new(Gtk::Window::TOPLEVEL)
	$reportBox.set_title "USER REPORTS"
	$reportBox.border_width = 10
	$reportBox.resizable=(false)
	$reportBox.modal=(true)
	$reportBox.set_size_request(300,-1)
	$reportBoxTable = Gtk::Table.new(1,2,false) 
$data1 = ""
$data2 = ""

	$con = SQLite3::Database.open "what2eat"
	#SELECT FOODS.food_name from FOODS, USERS_FOODS WHERE USERS_FOODS.food_id = FOODS.food_id AND USERS_FOODS.user_id = #{user-number}
	$stm = $con.prepare "SELECT FOODS.food_name, USERS_FOODS.rating from FOODS, USERS_FOODS WHERE USERS_FOODS.food_id = FOODS.food_id AND USERS_FOODS.user_id = #{user_number}" 
	$rs = $stm.execute #fire the sql statement
		$rs.each do |row|
		$data1 = $data1 + row[0] + "\n"
		temp_string = ""
		if row[1] == 3
			temp_string = "Loves It"
		elsif row[1] == 2
			temp_string = "It's OK"
		else
			temp_string = "Hates It"
		end
		$data2 = $data2 + temp_string + "\n"
	
	  end
	  
	$stm.close #close sql statement
	$con.close





	$labelReportBox1 = Gtk::Label.new $data1
	$labelReportBox2 = Gtk::Label.new $data2
    $reportBoxTable.attach($labelReportBox1,0,1,0,1)
    $reportBoxTable.attach($labelReportBox2,1,2,0,1)
    
    $reportBox.add($reportBoxTable)
	
	$reportBox.show_all
	
end


#############################################
# confirmation_box(string)
# Generic Popup Box with passed message
# and OK button
#############################################
def confirmation_box(message)
# Create the dialog
	md = Gtk::Dialog.new(
		"System Message",
		$main_application_window,
		Gtk::Dialog::DESTROY_WITH_PARENT,
		[ Gtk::Stock::OK, Gtk::Dialog::RESPONSE_NONE ]
	)
    add_message = Gtk::Label.new(message)
    md.vbox.pack_start(add_message)
    add_message.show
    md.run
    md.destroy
end

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
    $stm = $con.prepare "SELECT * from USERS ORDER BY name" #prepare sql statement
    $rs = $stm.execute #fire the sql statement
    $rs.each do |row|
		cb.append_text(row[1]) #add to combobox
    end
    $stm.close #close sql statement
    $con.close
    cb.set_active(0)
end

def populateFoodReportComboBox(cb)
$con = SQLite3::Database.open "what2eat"
    $stm = $con.prepare "SELECT * from FOODS ORDER BY food_name" #prepare sql statement
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
def populate_food_select_cb(cb,user_number)
	$con = SQLite3::Database.open "what2eat"
	#SELECT FOODS.food_name from FOODS, USERS_FOODS WHERE USERS_FOODS.food_id = FOODS.food_id AND USERS_FOODS.user_id = #{user-number}
	$stm = $con.prepare "SELECT FOODS.food_name from FOODS, USERS_FOODS WHERE USERS_FOODS.food_id = FOODS.food_id AND USERS_FOODS.user_id = #{user_number}" 
	$rs = $stm.execute #fire the sql statement
	#puts $rs.nil?
	#puts $rs.count
		$rs.each do |row|
			#puts row
		    cb.append_text(row[0]) #add to combobox
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
#############################################
def add_food_to_local_db(food_name,user_id,rating)



	$con = SQLite3::Database.open "what2eat"
    $stm = $con.prepare "SELECT food_name from FOODS where food_name = '#{food_name}'" #prepare sql statement
    rs = $stm.execute #fire the sql statement
    row = rs.next
    $stm.close
    $con.close

	if row.nil? #brand new
	$con = SQLite3::Database.open "what2eat"
    $con.execute "INSERT INTO FOODS(food_name) VALUES ('#{food_name}')"
	$con.close
	food_id = get_food_id(food_name).to_i
    $con = SQLite3::Database.open "what2eat"
	$con.execute "INSERT INTO USERS_FOODS(user_id,food_id,rating) VALUES (#{user_id},#{food_id},#{rating})"
	$con.close
	return true

	else #It exists in the foods table

	food_id = get_food_id(food_name).to_i
    $con = SQLite3::Database.open "what2eat"



		$stm = $con.prepare "SELECT user_food_id from USERS_FOODS where food_id = #{food_id} AND user_id = #{user_id}" #prepare sql statement
		rs = $stm.execute #fire the sql statement
		row = rs.next
		$stm.close
		if row.nil? #brand new
		$con.execute "INSERT INTO USERS_FOODS(user_id,food_id,rating) VALUES (#{user_id},#{food_id},#{rating})"
		else
		$con.execute "UPDATE USERS_FOODS SET rating = #{rating} WHERE user_id = #{user_id} and food_id = #{food_id}"
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


def userReport()
	$windowReportUser = Gtk::Window.new(Gtk::Window::TOPLEVEL)
	$windowReportUser.set_title "USER REPORTS"
	$windowReportUser.border_width = 10
	$windowReportUser.resizable=(false)
	$windowReportUser.modal=(true)
	$windowReportUser.set_size_request(300,-1)

	$tableReportUser = Gtk::Table.new(3,2,false)

	$cbReportUser = Gtk::ComboBox.new
	$labelReportUser = Gtk::Label.new("Select User")
	$buttonReportUser = Gtk::Button.new("Select")
	
	$tableReportUser.attach($labelReportUser,0,1,0,1)
	$tableReportUser.attach($cbReportUser,0,1,1,2)
	$tableReportUser.attach($buttonReportUser,0,1,2,3)
	
	$windowReportUser.add($tableReportUser)
	$windowReportUser.show_all

	populate_user_select_cb($cbReportUser)
	
	$buttonReportUser.signal_connect("clicked") {createReportUser($cbReportUser.active_text)}

end

def foodReport()
	$windowReportFood = Gtk::Window.new(Gtk::Window::TOPLEVEL)
	$windowReportFood.set_title "FOOD REPORTS"
	$windowReportFood.border_width = 10
	$windowReportFood.resizable=(false)
	$windowReportFood.modal=(true)
	$windowReportFood.set_size_request(300,-1)

	$tableReportFood = Gtk::Table.new(2,2,false)

	$cbReportFood = Gtk::ComboBox.new
	$labelReportFood = Gtk::Label.new("Select Food")
	
	$tableReportFood.attach($labelReportFood,0,1,0,1)
	$tableReportFood.attach($cbReportFood,0,1,1,2)
	
	$windowReportFood.add($tableReportFood)
	$windowReportFood.show_all
	
	populateFoodReportComboBox($cbReportFood)
	
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
		confirmation_box("Email Updated")
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
	#populate_food_select_cb($cb_food,get_user_id(user_name).to_i)
	populateFoodReportComboBox($cb_food)
	$cb_food.set_active(0)

	$button_food_quit.signal_connect("clicked") {
	$user_window.destroy
	}

	$button_food_new_love.signal_connect("clicked") {
	GetFoodSelect($entry_food_new,$cb_food,get_user_id(user_name).to_i,3)
	confirmation_box("Rating Set(Love It)")
	}
	$button_food_new_ok.signal_connect("clicked") {
	GetFoodSelect($entry_food_new,$cb_food,get_user_id(user_name).to_i,2)
	confirmation_box("Rating Set(It's Ok)")
	}
	$button_food_new_hate.signal_connect("clicked") {
	GetFoodSelect($entry_food_new,$cb_food,get_user_id(user_name).to_i,1)
	confirmation_box("Rating Set(Hate It)")
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
$tableMainMenu = Gtk::Table.new(2,1,false)

#tabs section
$addTab = Gtk::Label.new("Add Data")
$reportTab = Gtk::Label.new("Reports")
$updateTab = Gtk::Label.new("Update Remote")
$optionTab = Gtk::Label.new("Options")

#UPDATE SECTION
button_update = Gtk::Button.new("Click here to:\nPush and pull information\nfrom the server")

#OPTIONS SECTION
$tableOption = Gtk::Table.new(2,2,false)
$buttonQuit = Gtk::Button.new("Quit")
button_option = Gtk::Button.new("About")

#IMAGE SECTION
$imageScale = Gdk::Pixbuf.new "food1.png"
$imageScale = $imageScale.scale(200,200,'bilinear')
$imageMain = Gtk::Image.new ($imageScale)
$fixed = Gtk::Fixed.new


#add data section
$tableAdd = Gtk::Table.new(3,3,false)
$AddNameLabel = Gtk::Label.new("Name")
$AddEmailLabel = Gtk::Label.new("Email")
$userAddEntry = Gtk::Entry.new
$emailAddEntry = Gtk::Entry.new
$cb = Gtk::ComboBox.new
$buttonAddSelect = Gtk::Button.new("Select")
$buttonAddNewUser = Gtk::Button.new("Create")

#reports section
$tableReport = Gtk::Table.new(2,1,false) #creates a 2row/1 col table
$buttonUserReport = Gtk::Button.new("Users")
$buttonFoodReport = Gtk::Button.new("Foods")


#########DEFINE BUTTONS##############################
$buttonUserReport.signal_connect("clicked"){userReport()}

$buttonFoodReport.signal_connect("clicked"){foodReport()}

$buttonQuit.signal_connect("clicked"){Gtk.main_quit} #quits

button_update.signal_connect( "clicked" ) {puts "TBI UPLOAD/DOWNLOAD FROM REMOTE"} #temp

$nbMain.signal_connect('change-current-page') {	another_tab}

$buttonAddSelect.signal_connect("clicked") {select_user_window($cb.active_text)}

button_option.signal_connect("clicked"){about_box()}

$buttonAddNewUser.signal_connect("clicked"){
	if $userAddEntry.text.length == 0
		puts "DEBUG: Nothing was entered"
	else
		add_user_to_local_db($cb,$userAddEntry,$emailAddEntry)
		confirmation_box("New Person Successfuly Added")
	end
}

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
###############ATTACHMENT TO REPORT TAB
$tableReport.attach($buttonUserReport,0,1,0,1)
$tableReport.attach($buttonFoodReport,0,1,1,2)

##############ATTACHMENT TO NOTEBOOK#############################
$nbMain.append_page($tableReport, $reportTab) #creates reports tab
$nbMain.append_page($tableAdd, $addTab) #creates add tab
$nbMain.append_page(button_update,  $updateTab) #creates update tab
$nbMain.append_page($tableOption, $optionTab) #creates options tab
##########ATTACHMENT TO MAIN WINDOW###############################
$fixed.put $imageMain, 120, 0
$tableMainMenu.attach($fixed,0,1,0,1) #Adds image to main table
$tableMainMenu.attach($nbMain,0,1,1,2) #adds Notebook to main table
###################MAIN################################

populate_user_select_cb($cb)
window.add($tableMainMenu)
window.show_all

Gtk.main
