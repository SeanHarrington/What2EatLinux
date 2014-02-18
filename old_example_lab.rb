#!/usr/bin/ruby

require 'mysql'
require 'rubygems'
require 'tk'
   
##############################################################################
## clean_string (string)                                                    ##
## in: STRING                                                               ##
## out: string                                                              ##
##############################################################################
## purpose: Mysql returns strings with a [" "] encapsulating them.          ##
##          This method will remove the encapsulation from a string.        ##
##############################################################################
## Creator: Sean Harrington                                                 ##
## Date: 3/12/13                                                            ##
##############################################################################
    def clean_string(passed_string)
        passed_string[0]= ""
        passed_string[0]= ""
        passed_string[passed_string.length-1]=""
        passed_string[passed_string.length-1]=""
        return passed_string
    end

########################### 1.)PARSE PATIENT NUMBER#######
def parse_patient(doctor_number)
    doctor_number = doctor_number.to_s
    doctor_number = doctor_number[4] + doctor_number[5] + doctor_number[6] + doctor_number[7] + doctor_number[8] + doctor_number[9] + doctor_number[10] + doctor_number[11] + doctor_number[12]
    return doctor_number.to_i
end
########################### 1.)INSERT NEW PATIENT DATA INTO DB#############
    def create_mysql_patient( first, last, gender, dob_month, dob_day, dob_year, phone, number, street, city, state, zip)
        con = Mysql.new('instance39835.db.xeround.com', 'system', 'csci344', 'tes123', 7617)
        max_num = con.query("SELECT MAX(patient_number) FROM sh_patient;")
        max_num = clean_string(max_num.fetch_row.to_s)
        patient_number = max_num.to_i
        if patient_number < 100000000
            patient_number = 100000000
        end
        patient_number += 1
        pst = con.prepare "INSERT INTO sh_patient (patient_number, patient_name_first, patient_name_last, patient_gender, patient_dob_month, patient_dob_day, patient_dob_year, patient_phone, patient_address_number, patient_address_street, patient_address_city, patient_address_state, patient_address_zip) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?);"
        pst.execute patient_number, first.to_s.upcase,last.to_s.upcase,gender.to_s.upcase,dob_month.to_s.upcase, dob_day.to_s.upcase, dob_year.to_s.upcase, phone.to_s.upcase,number.to_i,street.to_s.upcase,city.to_s.upcase,state.to_s.upcase,zip.to_i
        con.close
    end
########################## 1.) CREATE WINDOW TO INSERT NEW PATIENT DATA INTO DB ###################
    def create_window_patient_info
        begin
            $win.destroy
        rescue
        end
        $win = TkToplevel.new
        $win.title("ENTER PATIENT DATA"); $win.geometry("500x200")
  
        quit_out = TkButton.new($win) {}
        quit_out.text 'RETURN TO MAIN MENU'; quit_out.command "$win.destroy"; quit_out.pack('side' => 'bottom')
        quit_out.background "#CCFFFF"; quit_out.relief 'groove'; quit_out.borderwidth = 5
        

        #patient first name
        f_name_label = TkLabel.new($win)
        f_name_label.font AppHighlightFont; f_name_label.padx 16; f_name_label.pady 5; f_name_label.borderwidth = 5
        f_name_label.relief = 'groove'; f_name_label.background "#FFFFF0"; f_name_label.foreground "blue"
        f_name_label.text ("First Name"); f_name_label.place('height' => 25, 'width' => 120, 'x' => 10,'y' => 2)      
        
        patient_first_name = TkEntry.new($win)
        patient_first_name_var = TkVariable.new
        patient_first_name.textvariable = patient_first_name_var; patient_first_name_var.value = ""
        patient_first_name.place('height' => 25, 'width' => 100, 'x' => 140,'y' => 2)

        #patient last name
        l_name_label = TkLabel.new($win)
        l_name_label.font AppHighlightFont; l_name_label.padx 16; l_name_label.pady 5; l_name_label.borderwidth = 5
        l_name_label.relief = 'groove'; l_name_label.background "#FFFFF0"; l_name_label.foreground "blue"
        l_name_label.text ("Last Name"); l_name_label.place('height' => 25, 'width' => 120, 'x' => 250,'y' => 2) 
        
        patient_last_name = TkEntry.new($win)
        patient_last_name_var = TkVariable.new
        patient_last_name.textvariable = patient_last_name_var; patient_last_name_var.value = ""
        patient_last_name.place('height' => 25, 'width' => 110, 'x' => 380,'y' => 2)
 
        #patient address number
        address_label = TkLabel.new($win)
        address_label.font AppHighlightFont; address_label.padx 16; address_label.pady 5; address_label.borderwidth = 5
        address_label.relief = 'groove'; address_label.background "#FFFFF0"; address_label.foreground "blue"
        address_label.text ("Address"); address_label.place('height' => 25, 'width' => 120, 'x' => 10,'y' => 32) 
        
        patient_address_number = TkEntry.new($win)
        patient_address_number_var = TkVariable.new
        patient_address_number.textvariable = patient_address_number_var; patient_address_number.value = "NUM"
        patient_address_number.place('height' => 25, 'width' => 40, 'x' => 140,'y' => 32)
  
        #Patient_Address_Street
        patient_address_street = TkEntry.new($win)
        patient_address_street_var = TkVariable.new
        patient_address_street.textvariable = patient_address_street_var; patient_address_street.value = "STREET"
        patient_address_street.place('height' => 25, 'width' => 85, 'x' => 190,'y' => 32)

        #Patient_Address_City
        patient_address_city = TkEntry.new($win)
        patient_address_city_var = TkVariable.new
        patient_address_city.textvariable = patient_address_city_var; patient_address_city.value = "CITY"
        patient_address_city.place('height' => 25, 'width' => 85, 'x' => 285,'y' => 32)

        #Patient_Address_State
        patient_address_state = TkEntry.new($win)
        patient_address_state_var = TkVariable.new
        patient_address_state.textvariable = patient_address_state_var; patient_address_state.value = "STATE"
        patient_address_state.place('height' => 25, 'width' => 50, 'x' => 380,'y' => 32)
  
        #Patient_Address_Zip
        patient_address_zip = TkEntry.new($win)
        patient_address_zip_var = TkVariable.new
        patient_address_zip.textvariable = patient_address_zip_var; patient_address_zip.value = "ZIP"
        patient_address_zip.place('height' => 25, 'width' => 50, 'x' => 440,'y' => 32)

        #Patient_Phone
        phone_label = TkLabel.new($win)
        phone_label.font AppHighlightFont; phone_label.padx 16; phone_label.pady 5; phone_label.borderwidth = 5
        phone_label.relief = 'groove'; phone_label.background "#FFFFF0"; phone_label.foreground "blue"
        phone_label.text ("Phone"); phone_label.place('height' => 25, 'width' => 120, 'x' => 10,'y' => 62) 
        
        patient_phone = TkEntry.new($win)
        patient_phone_var = TkVariable.new
        patient_phone.textvariable = patient_phone_var
        patient_phone.value = ""
        patient_phone.place('height' => 25, 'width' => 130, 'x' => 140,'y' => 62)

        gender_label = TkLabel.new($win)
        gender_label.font AppHighlightFont; gender_label.padx 16; gender_label.pady 5; gender_label.borderwidth = 5
        gender_label.relief = 'groove'; gender_label.background "#FFFFF0"; gender_label.foreground "blue"
        gender_label.text ("Gender"); gender_label.place('height' => 25, 'width' => 120, 'x' => 280,'y' => 62) 
        
        $gendervar = TkVariable.new
        patient_gender = Tk::Tile::Combobox.new($win) 
        patient_gender.textvariable $gendervar; patient_gender.values = [ 'Male', 'Female'] 
        patient_gender.place('height' => 25, 'width' => 80, 'x' => 410,'y' => 62)
        tryarray = Array.new
        iternum = 1900
        while iternum < 2015
            tryarray.push iternum.to_s
            iternum += 1
        end

        date_label = TkLabel.new($win)
        date_label.font AppHighlightFont; date_label.padx 16; date_label.pady 5; date_label.borderwidth = 5
        date_label.relief = 'groove'; date_label.background "#FFFFF0"; date_label.foreground "blue"
        date_label.text ("Date Of Birth"); date_label.place('height' => 25, 'width' => 140, 'x' => 10,'y' => 92) 
        
        $monthvar = TkVariable.new
        patient_month = Tk::Tile::Combobox.new($win) 
        patient_month.textvariable $monthvar; patient_month.place('height' => 25, 'width' => 90, 'x' => 160,'y' => 92)
        patient_month.values = [ 'January', 'Febraury', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'] 
        
        $dayvar = TkVariable.new
        patient_day = Tk::Tile::Combobox.new($win) 
        patient_day.textvariable $dayvar; patient_day.place('height' => 25, 'width' => 40, 'x' => 260,'y' => 92)
        patient_day.values = [ '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31'] 
        
        $yearvar = TkVariable.new
        patient_year = Tk::Tile::Combobox.new($win) 
        patient_year.textvariable $yearvar; patient_year.place('height' => 25, 'width' => 70, 'x' => 310,'y' => 92)
        patient_year.values = tryarray
       
        accept = TkButton.new($win) {}
        accept.text 'ACCEPT INFORMATION'; accept.pack('side' => 'bottom')
        accept.background "#CCFFFF "; accept.relief 'groove'; accept.borderwidth = 5
        accept.command(proc {create_mysql_patient( patient_first_name_var, patient_last_name_var, $gendervar, $monthvar, $dayvar, $yearvar, patient_phone_var, patient_address_number_var, patient_address_street_var, patient_address_city_var, patient_address_state_var, patient_address_zip_var); $win.destroy})
    end
########################### 2.) UPDATES PATIENT DATA INTO DB #########
    def update_mysql_patient( pat_num, first, last, gender, dob_month, dob_day, dob_year, phone, number, street, city, state, zip)
        con = Mysql.new('instance39835.db.xeround.com', 'system', 'csci344', 'tes123', 7617)
        con.query("UPDATE sh_patient SET patient_name_first='#{first.to_s.upcase}', patient_name_last='#{last.to_s.upcase}', patient_gender='#{gender.to_s.upcase}', patient_dob_month='#{dob_month.to_s.upcase}', patient_dob_day='#{dob_day.to_s.upcase}', patient_dob_year='#{dob_year.to_s.upcase}', patient_phone='#{phone.to_s.upcase}', patient_address_number='#{number.to_i}', patient_address_street='#{street.to_s.upcase}', patient_address_city='#{city.to_s.upcase}', patient_address_state='#{state.to_s.upcase}', patient_address_zip='#{zip.to_i}' WHERE patient_number='#{pat_num.to_i}';")
        con.close
    end 
##################### 2.) CREATE WINDOW TO UPDATE PATIENT DATA INTO DB ###################
    def update_window_patient_info(patient_num)
        begin
            $win.destroy
        rescue
        end
        $win = TkToplevel.new
        $win.title("UPDATE PATIENT DATA")
        $win.geometry("500x200")
        
        quit_out = TkButton.new($win) {}
        quit_out.text 'RETURN TO MAIN MENU'; quit_out.command "$win.destroy"; quit_out.pack('side' => 'bottom')
        quit_out.background "#CCFFFF"; quit_out.relief 'groove'; quit_out.borderwidth = 5
        
        patient_array = Array.new
        con = Mysql.new('instance39835.db.xeround.com', 'system', 'csci344', 'tes123', 7617)
        query_string = con.query("SELECT * FROM sh_patient WHERE patient_number = '#{patient_num.to_i}';")
        con.close        
        query_string = query_string.fetch_row
        x = 12
        while x >= 0
        patient_array[x] = query_string[x]
        x -= 1
        end
        f_name_label = TkLabel.new($win)
        f_name_label.font AppHighlightFont; f_name_label.padx 16; f_name_label.pady 5; f_name_label.borderwidth = 5
        f_name_label.relief = 'groove'; f_name_label.background "#FFFFF0"; f_name_label.foreground "blue"
        f_name_label.text ("First Name"); f_name_label.place('height' => 25, 'width' => 120, 'x' => 10,'y' => 2)      
        
        patient_first_name = TkEntry.new($win)
        patient_first_name_var = TkVariable.new
        patient_first_name.textvariable = patient_first_name_var; patient_first_name_var.value = patient_array[1]
        patient_first_name.place('height' => 25, 'width' => 100, 'x' => 140,'y' => 2)

        l_name_label = TkLabel.new($win)
        l_name_label.font AppHighlightFont; l_name_label.padx 16; l_name_label.pady 5; l_name_label.borderwidth = 5
        l_name_label.relief = 'groove'; l_name_label.background "#FFFFF0"; l_name_label.foreground "blue"
        l_name_label.text ("Last Name"); l_name_label.place('height' => 25, 'width' => 120, 'x' => 250,'y' => 2) 
        
        patient_last_name = TkEntry.new($win)
        patient_last_name_var = TkVariable.new
        patient_last_name.textvariable = patient_last_name_var; patient_last_name_var.value = patient_array[2]
        patient_last_name.place('height' => 25, 'width' => 110, 'x' => 380,'y' => 2)
 
        address_label = TkLabel.new($win)
        address_label.font AppHighlightFont; address_label.padx 16; address_label.pady 5; address_label.borderwidth = 5
        address_label.relief = 'groove'; address_label.background "#FFFFF0"; address_label.foreground "blue"
        address_label.text ("Address"); address_label.place('height' => 25, 'width' => 120, 'x' => 10,'y' => 32) 
        
        patient_address_number = TkEntry.new($win)
        patient_address_number_var = TkVariable.new
        patient_address_number.textvariable = patient_address_number_var; patient_address_number.value = patient_array[8]
        patient_address_number.place('height' => 25, 'width' => 40, 'x' => 140,'y' => 32)
  
        patient_address_street = TkEntry.new($win)
        patient_address_street_var = TkVariable.new
        patient_address_street.textvariable = patient_address_street_var; patient_address_street.value = patient_array[9]
        patient_address_street.place('height' => 25, 'width' => 85, 'x' => 190,'y' => 32)

        patient_address_city = TkEntry.new($win)
        patient_address_city_var = TkVariable.new
        patient_address_city.textvariable = patient_address_city_var; patient_address_city.value = patient_array[10]
        patient_address_city.place('height' => 25, 'width' => 85, 'x' => 285,'y' => 32)

        patient_address_state = TkEntry.new($win)
        patient_address_state_var = TkVariable.new
        patient_address_state.textvariable = patient_address_state_var; patient_address_state.value = patient_array[11]
        patient_address_state.place('height' => 25, 'width' => 50, 'x' => 380,'y' => 32)
  
        patient_address_zip = TkEntry.new($win)
        patient_address_zip_var = TkVariable.new
        patient_address_zip.textvariable = patient_address_zip_var; patient_address_zip.value = patient_array[12]
        patient_address_zip.place('height' => 25, 'width' => 50, 'x' => 440,'y' => 32)

        phone_label = TkLabel.new($win)
        phone_label.font AppHighlightFont; phone_label.padx 16; phone_label.pady 5; phone_label.borderwidth = 5
        phone_label.relief = 'groove'; phone_label.background "#FFFFF0"; phone_label.foreground "blue"
        phone_label.text ("Phone"); phone_label.place('height' => 25, 'width' => 120, 'x' => 10,'y' => 62) 
        
        patient_phone = TkEntry.new($win)
        patient_phone_var = TkVariable.new
        patient_phone.textvariable = patient_phone_var
        patient_phone.value = patient_array[7]
        patient_phone.place('height' => 25, 'width' => 130, 'x' => 140,'y' => 62)

        gender_label = TkLabel.new($win)
        gender_label.font AppHighlightFont; gender_label.padx 16; gender_label.pady 5; gender_label.borderwidth = 5
        gender_label.relief = 'groove'; gender_label.background "#FFFFF0"; gender_label.foreground "blue"
        gender_label.text ("Gender"); gender_label.place('height' => 25, 'width' => 120, 'x' => 280,'y' => 62) 
        
        if patient_array[3] == "" ##THIS SHOULD NEVER FIRE AS A PERSON SHOULD HAVE A GENDER ENTERED... BUT JUST IN CASE...
            $gendervar = TkVariable.new
            patient_gender = Tk::Tile::Combobox.new($win) 
            patient_gender.textvariable $gendervar; 
            patient_gender.place('height' => 25, 'width' => 80, 'x' => 410,'y' => 62)
            patient_gender.values = [ 'Male', 'Female'] 
        else
            $gendervar = TkVariable.new
            patient_gender = TkEntry.new($win) 
            patient_gender.textvariable $gendervar; 
            patient_gender.place('height' => 25, 'width' => 80, 'x' => 410,'y' => 62)
            patient_gender.value = patient_array[3]
        end
        
        #######An array for selecting a year#####
        tryarray = Array.new
        iternum = 1900
        while iternum < 2015
            tryarray.push iternum.to_s
            iternum += 1
        end

        date_label = TkLabel.new($win)
        date_label.font AppHighlightFont; date_label.padx 16; date_label.pady 5; date_label.borderwidth = 5
        date_label.relief = 'groove'; date_label.background "#FFFFF0"; date_label.foreground "blue"
        date_label.text ("Date Of Birth"); date_label.place('height' => 25, 'width' => 140, 'x' => 10,'y' => 92) 
        
        $monthvar = TkVariable.new
        patient_month = TkEntry.new($win) 
        patient_month.textvariable $monthvar; patient_month.place('height' => 25, 'width' => 90, 'x' => 240,'y' => 92)
        patient_month.value = patient_array[4]
        
        $dayvar = TkVariable.new
        patient_day = TkEntry.new($win) 
        patient_day.textvariable $dayvar; patient_day.place('height' => 25, 'width' => 40, 'x' => 340,'y' => 92)
        patient_day.value = patient_array[5]
        
        $yearvar = TkVariable.new
        patient_year = TkEntry.new($win) 
        patient_year.textvariable $yearvar; patient_year.place('height' => 25, 'width' => 70, 'x' => 160,'y' => 92)
        patient_year.value = patient_array[6]
        
        accept = TkButton.new($win) {}
        accept.text 'UPDATE INFORMATION'; accept.pack('side' => 'bottom')
        accept.background "#CCFFFF "; accept.relief 'groove'; accept.borderwidth = 5
        accept.command(proc {update_mysql_patient( patient_num, patient_first_name_var, patient_last_name_var, $gendervar, $monthvar, $dayvar, $yearvar, patient_phone_var, patient_address_number_var, patient_address_street_var, patient_address_city_var, patient_address_state_var, patient_address_zip_var); $win.destroy})
    end
    
####################### 1.)POPULATE PATIENT LIST BOX BY PATIENT NUMBER ###################
    def create_update_patient_listbox
        begin
            $win.destroy
        rescue
        end
        $win = TkToplevel.new
        $win.title("SELECT PATIENT DATA"); $win.geometry("400x300")
                
        quit_out = TkButton.new($win) {
        text 'RETURN TO MAIN MENU'
        command "$win.destroy"
        pack('side' => 'bottom')
        background "#CCFFFF"
        }
        list = TkListbox.new($win) do
            height 15
            width 40
            selectmode 'single' #allow user to only select a single entry
            background "black"
            foreground "white"
        end
        list.place('x' => 70,'y' => 35)
        con = Mysql.new('instance39835.db.xeround.com', 'system', 'csci344', 'tes123', 7617)
        query_string = con.query("SELECT patient_number, patient_name_last, patient_name_first FROM sh_patient ORDER BY patient_number;")
        n_rows = query_string.num_rows
        n_rows.times do
            fetched_row = query_string.fetch_row
            query_num = fetched_row[0]
            query_first = fetched_row[1]
            query_last = fetched_row[2]
            insert_place = query_num.to_i
            list.insert insert_place - 1, "ID: " + insert_place.to_s + " "  + query_last.to_s + ", " + query_first.to_s    
        end
        con.close
          
        scroll = TkScrollbar.new($win) do
            orient 'vertical'
            
        end
        list.yscrollcommand(proc { |*args|
            scroll.set(*args)
        })
        scroll.command(proc { |*args|
            list.yview(*args)
        }) 
        selection = TkButton.new($win) {
        text 'UPDATE'
        background "#CCFFFF"
        command {update_window_patient_info(parse_patient(list.get(list.curselection)))}
        pack('side' => 'bottom')}
        
        fname_sort = TkButton.new($win) {}
        fname_sort.text 'First'; fname_sort.command {''}; fname_sort.place('height' => 25, 'width' => 40, 'x' => 170, 'y' => 10)
        fname_sort.background "#CCFFFF"
        fname_sort.command {create_update_patient_listbox_first}
        
        lname_sort = TkButton.new($win) {}
        lname_sort.text 'Last'; lname_sort.command {''}; lname_sort.place('height' => 25, 'width' => 40, 'x' => 220, 'y' => 10)
        lname_sort.background "#CCFFFF"
        lname_sort.command {create_update_patient_listbox_last}
        
    end
####################### 2.)POPULATE PATIENT LIST BOX BY LAST NAME ###################
    def create_update_patient_listbox_last
        begin
            $win.destroy
        rescue
        end
        $win = TkToplevel.new
        $win.title("SELECT PATIENT DATA"); $win.geometry("400x300")
                
        quit_out = TkButton.new($win) {
        text 'RETURN TO MAIN MENU'
        command "$win.destroy"
        pack('side' => 'bottom')
        background "#CCFFFF"
        }
        list = TkListbox.new($win) do
            height 15
            width 40
            selectmode 'single' #allow user to only select a single entry
            background "black"
            foreground "white"
        end
        list.place('x' => 70,'y' => 35)
        
        con = Mysql.new('instance39835.db.xeround.com', 'system', 'csci344', 'tes123', 7617)
        query_string = con.query("SELECT patient_number, patient_name_last, patient_name_first FROM sh_patient ORDER BY patient_name_last;")
        n_rows = query_string.num_rows
        n_rows.times do
            fetched_row = query_string.fetch_row
            query_num = fetched_row[0]
            query_first = fetched_row[1]
            query_last = fetched_row[2]
            insert_place = query_num.to_i
            list.insert 'end', "ID: " + insert_place.to_s + " "  + query_last.to_s + ", " + query_first.to_s    
        end
        con.close

        scroll = TkScrollbar.new($win) do
            orient 'vertical'
            
        end
        list.yscrollcommand(proc { |*args|
            scroll.set(*args)
        })
        scroll.command(proc { |*args|
            list.yview(*args)
        }) 
        selection = TkButton.new($win) {
        text 'UPDATE'
        background "#CCFFFF"
        command {update_window_patient_info(parse_patient(list.get(list.curselection)))}
        pack('side' => 'bottom')}
        
        id_sort = TkButton.new($win) {}
        id_sort.text 'ID#'; id_sort.command {create_update_patient_listbox}; id_sort.place('height' => 25, 'width' => 40, 'x' => 120, 'y' => 10)
        id_sort.background "#CCFFFF"
        
        fname_sort = TkButton.new($win) {}
        fname_sort.text 'First'; fname_sort.command {''}; fname_sort.place('height' => 25, 'width' => 40, 'x' => 170, 'y' => 10)
        fname_sort.background "#CCFFFF"
        fname_sort.command {create_update_patient_listbox_first}
    end    
####################### 2.)POPULATE PATIENT LIST BOX BY FIRST NAME ###################
    def create_update_patient_listbox_first
        begin
            $win.destroy
        rescue
        end
        $win = TkToplevel.new
        $win.title("SELECT PATIENT DATA"); $win.geometry("400x300")
                
        quit_out = TkButton.new($win) {
        text 'RETURN TO MAIN MENU'
        command "$win.destroy"
        pack('side' => 'bottom')
        background "#CCFFFF"
        }
        list = TkListbox.new($win) do
            height 15
            width 40
            selectmode 'single' #allow user to only select a single entry
            background "black"
            foreground "white"
        end
        list.place('x' => 70,'y' => 35)
        
        con = Mysql.new('instance39835.db.xeround.com', 'system', 'csci344', 'tes123', 7617)
        query_string = con.query("SELECT patient_number, patient_name_last, patient_name_first FROM sh_patient ORDER BY patient_name_first;")
        n_rows = query_string.num_rows
        n_rows.times do
            fetched_row = query_string.fetch_row
            query_num = fetched_row[0]
            query_first = fetched_row[1]
            query_last = fetched_row[2]
            insert_place = query_num.to_i
            list.insert 'end', "ID: " + insert_place.to_s + " "  + query_last.to_s + ", " + query_first.to_s    
        end
        con.close
     
        scroll = TkScrollbar.new($win) do
            orient 'vertical'
            
        end
        list.yscrollcommand(proc { |*args|
            scroll.set(*args)
        })
        scroll.command(proc { |*args|
            list.yview(*args)
        }) 
        selection = TkButton.new($win) {
        text 'UPDATE'
        background "#CCFFFF"
        command {update_window_patient_info(parse_patient(list.get(list.curselection)))}
        pack('side' => 'bottom')}
        
        id_sort = TkButton.new($win) {}
        id_sort.text 'ID#'; id_sort.command {create_update_patient_listbox}; id_sort.place('height' => 25, 'width' => 40, 'x' => 120, 'y' => 10)
        id_sort.background "#CCFFFF"
       
        lname_sort = TkButton.new($win) {}
        lname_sort.text 'Last'; lname_sort.command {create_update_patient_listbox_last}; lname_sort.place('height' => 25, 'width' => 40, 'x' => 220, 'y' => 10)
        lname_sort.background "#CCFFFF"
    end
######################################################################################    
################################ 3.)PARSE DOCTOR NUMBER ##############################
    def parse_doctor(doctor_number)
        doctor_number = doctor_number.to_s
        doctor_number = doctor_number[4] + doctor_number[5] + doctor_number[6] + doctor_number[7] + doctor_number[8] + doctor_number[9] + doctor_number[10] + doctor_number[11] + doctor_number[12]
        return doctor_number.to_i
    end
########################### 3.) INSERT NEW DOCTOR DATA INTO DB #############
    def create_mysql_doctor( id, first, last, phone, number, street, city, state, zip)
        con = Mysql.new('instance39835.db.xeround.com', 'system', 'csci344', 'tes123', 7617)
        pst = con.prepare "INSERT INTO sh_doctor (doctor_number, doctor_name_first, doctor_name_last, doctor_phone, doctor_address_number, doctor_address_street, doctor_address_city, doctor_address_state, doctor_address_zip) VALUES(?,?,?,?,?,?,?,?,?);"
        pst.execute id.to_i, first.to_s.upcase,last.to_s.upcase, phone.to_s.upcase,number.to_i,street.to_s.upcase,city.to_s.upcase,state.to_s.upcase,zip.to_i
        con.close
    end
####################### 3.) CREATE WINDOW TO INSERT NEW DOCTOR DATA INTO DB ##############
    def create_window_doctor_info
        begin
            $win.destroy
        rescue
        end
        $win = TkToplevel.new
        $win.title("ENTER NEW DOCTOR DATA")
        $win.geometry("500x200")
  
   quit_out = TkButton.new($win) {}
        quit_out.text 'RETURN TO MAIN MENU'; quit_out.command "$win.destroy"; quit_out.pack('side' => 'bottom')
        quit_out.background "#CCFFFF"; quit_out.relief 'groove'; quit_out.borderwidth = 5
        

        #patient first name
        f_name_label = TkLabel.new($win)
        f_name_label.font AppHighlightFont; f_name_label.padx 16; f_name_label.pady 5; f_name_label.borderwidth = 5
        f_name_label.relief = 'groove'; f_name_label.background "#FFFFF0"; f_name_label.foreground "blue"
        f_name_label.text ("First Name"); f_name_label.place('height' => 25, 'width' => 120, 'x' => 10,'y' => 2)      
        
        patient_first_name = TkEntry.new($win)
        patient_first_name_var = TkVariable.new
        patient_first_name.textvariable = patient_first_name_var; patient_first_name_var.value = ""
        patient_first_name.place('height' => 25, 'width' => 100, 'x' => 140,'y' => 2)

        #patient last name
        l_name_label = TkLabel.new($win)
        l_name_label.font AppHighlightFont; l_name_label.padx 16; l_name_label.pady 5; l_name_label.borderwidth = 5
        l_name_label.relief = 'groove'; l_name_label.background "#FFFFF0"; l_name_label.foreground "blue"
        l_name_label.text ("Last Name"); l_name_label.place('height' => 25, 'width' => 120, 'x' => 250,'y' => 2) 
        
        patient_last_name = TkEntry.new($win)
        patient_last_name_var = TkVariable.new
        patient_last_name.textvariable = patient_last_name_var; patient_last_name_var.value = ""
        patient_last_name.place('height' => 25, 'width' => 110, 'x' => 380,'y' => 2)
 
        #patient address number
        address_label = TkLabel.new($win)
        address_label.font AppHighlightFont; address_label.padx 16; address_label.pady 5; address_label.borderwidth = 5
        address_label.relief = 'groove'; address_label.background "#FFFFF0"; address_label.foreground "blue"
        address_label.text ("Address"); address_label.place('height' => 25, 'width' => 120, 'x' => 10,'y' => 32) 
        
        patient_address_number = TkEntry.new($win)
        patient_address_number_var = TkVariable.new
        patient_address_number.textvariable = patient_address_number_var; patient_address_number.value = "NUM"
        patient_address_number.place('height' => 25, 'width' => 40, 'x' => 140,'y' => 32)
  
        #Patient_Address_Street
        patient_address_street = TkEntry.new($win)
        patient_address_street_var = TkVariable.new
        patient_address_street.textvariable = patient_address_street_var; patient_address_street.value = "STREET"
        patient_address_street.place('height' => 25, 'width' => 85, 'x' => 190,'y' => 32)

        #Patient_Address_City
        patient_address_city = TkEntry.new($win)
        patient_address_city_var = TkVariable.new
        patient_address_city.textvariable = patient_address_city_var; patient_address_city.value = "CITY"
        patient_address_city.place('height' => 25, 'width' => 85, 'x' => 285,'y' => 32)

        #Patient_Address_State
        patient_address_state = TkEntry.new($win)
        patient_address_state_var = TkVariable.new
        patient_address_state.textvariable = patient_address_state_var; patient_address_state.value = "STATE"
        patient_address_state.place('height' => 25, 'width' => 50, 'x' => 380,'y' => 32)
  
        #Patient_Address_Zip
        patient_address_zip = TkEntry.new($win)
        patient_address_zip_var = TkVariable.new
        patient_address_zip.textvariable = patient_address_zip_var; patient_address_zip.value = "ZIP"
        patient_address_zip.place('height' => 25, 'width' => 50, 'x' => 440,'y' => 32)

        #Patient_Phone
        phone_label = TkLabel.new($win)
        phone_label.font AppHighlightFont; phone_label.padx 16; phone_label.pady 5; phone_label.borderwidth = 5
        phone_label.relief = 'groove'; phone_label.background "#FFFFF0"; phone_label.foreground "blue"
        phone_label.text ("Phone"); phone_label.place('height' => 25, 'width' => 100, 'x' => 10,'y' => 62) 
        
        patient_phone = TkEntry.new($win)
        patient_phone_var = TkVariable.new
        patient_phone.textvariable = patient_phone_var
        patient_phone.value = ""
        patient_phone.place('height' => 25, 'width' => 110, 'x' => 120,'y' => 62)

        fid_label = TkLabel.new($win)
        fid_label.font AppHighlightFont; fid_label.padx 16; fid_label.pady 5; fid_label.borderwidth = 5
        fid_label.relief = 'groove'; fid_label.background "#FFFFF0"; fid_label.foreground "blue"
        fid_label.text ("FED ID#"); fid_label.place('height' => 25, 'width' => 120, 'x' => 240,'y' => 62) 
        
        patient_fid = TkEntry.new($win)
        patient_fid_var = TkVariable.new
        patient_fid.textvariable = patient_fid_var
        patient_fid.value = ""
        patient_fid.place('height' => 25, 'width' => 120, 'x' => 370,'y' => 62)
        
        accept = TkButton.new($win) {}
        accept.text 'ACCEPT INFORMATION'; accept.pack('side' => 'bottom')
        accept.background "#CCFFFF "; accept.relief 'groove'; accept.borderwidth = 5
        accept.command(proc {create_mysql_doctor( patient_fid_var, patient_first_name_var, patient_last_name_var, patient_phone_var, patient_address_number_var, patient_address_street_var, patient_address_city_var, patient_address_state_var, patient_address_zip_var); $win.destroy})
    end

########################### 4.) UPDATE DOCTOR DATA INTO DB #########
    def update_mysql_doctor( id, first, last, phone, number, street, city, state, zip)
        con = Mysql.new('instance39835.db.xeround.com', 'system', 'csci344', 'tes123', 7617)
        con.query("UPDATE sh_doctor SET doctor_name_first='#{first.to_s.upcase}', doctor_name_last='#{last.to_s.upcase}', doctor_phone='#{phone.to_s.upcase}', doctor_address_number='#{number.to_i}', doctor_address_street='#{street.to_s.upcase}', doctor_address_city='#{city.to_s.upcase}', doctor_address_state='#{state.to_s.upcase}', doctor_address_zip='#{zip.to_i}' WHERE doctor_number='#{id}';")
        con.close
    end
####################### 4.) POPULATE DOCTOR LIST BOX BY FIRST NAME ###################
    def create_update_doctor_listbox_first
        begin
            $win.destroy
        rescue
        end
        $win = TkToplevel.new
        $win.title("SELECT DOCTOR DATA"); $win.geometry("400x300")
                
        quit_out = TkButton.new($win) {}
        quit_out.text 'RETURN TO MAIN MENU'; quit_out.command "$win.destroy"
        quit_out.pack('side' => 'bottom'); quit_out.background "#CCFFFF"
        
        list = TkListbox.new($win) do
            height 15
            width 40
            selectmode 'single' #allow user to only select a single entry
            background "black"
            foreground "white"
        end
        list.place('x' => 70,'y' => 35)
        con = Mysql.new('instance39835.db.xeround.com', 'system', 'csci344', 'tes123', 7617)
        query_string = con.query("SELECT doctor_number, doctor_name_last, doctor_name_first FROM sh_doctor ORDER BY doctor_name_first;")
        n_rows = query_string.num_rows
        n_rows.times do
            fetched_row = query_string.fetch_row
            query_num = fetched_row[0]
            query_first = fetched_row[1]
            query_last = fetched_row[2]
            insert_place = query_num.to_i
            list.insert 'end', "ID: " + insert_place.to_s + " "  + query_last.to_s + ", " + query_first.to_s    
        end
        con.close
     
        scroll = TkScrollbar.new($win) do
            orient 'vertical'
        end
        list.yscrollcommand(proc { |*args|
            scroll.set(*args)
        })
        scroll.command(proc { |*args|
            list.yview(*args)
        }) 
        
        selection = TkButton.new($win) {}
        selection.text 'UPDATE'; selection.background "#CCFFFF"; selection.pack('side' => 'bottom')
        selection.command {update_window_doctor_info(parse_doctor(list.get(list.curselection)))}        
        
        id_sort = TkButton.new($win) {}
        id_sort.text 'ID#'; id_sort.command {create_update_doctor_listbox}; id_sort.place('height' => 25, 'width' => 40, 'x' => 120, 'y' => 10)
        id_sort.background "#CCFFFF"
        
        lname_sort = TkButton.new($win) {}
        lname_sort.text 'Last'; lname_sort.command {create_update_doctor_listbox_last}; lname_sort.place('height' => 25, 'width' => 40, 'x' => 220, 'y' => 10)
        lname_sort.background "#CCFFFF"
    end
####################### 4.) POPULATE DOCTOR LIST BOX BY LAST NAME###################
    def create_update_doctor_listbox_last
        begin
            $win.destroy
        rescue
        end
        $win = TkToplevel.new
        $win.title("SELECT DOCTOR DATA"); $win.geometry("400x300")
                
        quit_out = TkButton.new($win) {
        text 'RETURN TO MAIN MENU'
        command "$win.destroy"
        pack('side' => 'bottom')
        background "#CCFFFF"
        }
        list = TkListbox.new($win) do
            height 15
            width 40
            selectmode 'single' #allow user to only select a single entry
            background "black"
            foreground "white"
        end
        list.place('x' => 70,'y' => 35)
        
        con = Mysql.new('instance39835.db.xeround.com', 'system', 'csci344', 'tes123', 7617)
        query_string = con.query("SELECT doctor_number, doctor_name_last, doctor_name_first FROM sh_doctor ORDER BY doctor_name_last;")
        n_rows = query_string.num_rows
        n_rows.times do
            fetched_row = query_string.fetch_row
            query_num = fetched_row[0]
            query_first = fetched_row[1]
            query_last = fetched_row[2]
            insert_place = query_num.to_i
            list.insert 'end', "ID: " + insert_place.to_s + " "  + query_last.to_s + ", " + query_first.to_s    
        end
        con.close
        scroll = TkScrollbar.new($win) do
            orient 'vertical'
            
        end
        list.yscrollcommand(proc { |*args|
            scroll.set(*args)
        })
        scroll.command(proc { |*args|
            list.yview(*args)
        }) 
        selection = TkButton.new($win) {
        text 'UPDATE'
        background "#CCFFFF"
        command {update_window_doctor_info(parse_doctor(list.get(list.curselection)))}
        pack('side' => 'bottom')}
        
        id_sort = TkButton.new($win) {}
        id_sort.text 'ID#'; id_sort.command {create_update_doctor_listbox}; id_sort.place('height' => 25, 'width' => 40, 'x' => 120, 'y' => 10)
        id_sort.background "#CCFFFF"

        fname_sort = TkButton.new($win) {}
        fname_sort.text 'First'; fname_sort.command {create_update_doctor_listbox_first}; fname_sort.place('height' => 25, 'width' => 40, 'x' => 170, 'y' => 10)
        fname_sort.background "#CCFFFF"
    end
####################### 4.) POPULATE DOCTOR LIST BOX BY DOCTOR NUMBER ###################
    def create_update_doctor_listbox
        begin
            $win.destroy
        rescue
        end
        $win = TkToplevel.new
        $win.title("SELECT DOCTOR DATA"); $win.geometry("400x300")
                
        quit_out = TkButton.new($win) {
        text 'RETURN TO MAIN MENU'
        command "$win.destroy"
        pack('side' => 'bottom')
        background "#CCFFFF"
        }
        list = TkListbox.new($win) do
            height 15
            width 40
            selectmode 'single' #allow user to only select a single entry
            background "black"
            foreground "white"
        end
        list.place('x' => 70,'y' => 35)
        
     ###SORT BY fname
        con = Mysql.new('instance39835.db.xeround.com', 'system', 'csci344', 'tes123', 7617)
        query_string = con.query("SELECT doctor_number, doctor_name_last, doctor_name_first FROM sh_doctor ORDER BY doctor_number;")
        n_rows = query_string.num_rows
        n_rows.times do
            fetched_row = query_string.fetch_row
            query_num = fetched_row[0]
            query_first = fetched_row[1]
            query_last = fetched_row[2]
            insert_place = query_num.to_i
            list.insert 'end', "ID: " + insert_place.to_s + " "  + query_last.to_s + ", " + query_first.to_s    
        end
        con.close
     ###SORT BY fnameEND
     
        scroll = TkScrollbar.new($win) do
            orient 'vertical'
            
        end
        list.yscrollcommand(proc { |*args|
            scroll.set(*args)
        })
        scroll.command(proc { |*args|
            list.yview(*args)
        }) 
        selection = TkButton.new($win) {
        text 'UPDATE'
        background "#CCFFFF"
        command {update_window_doctor_info(parse_doctor(list.get(list.curselection)))}
        pack('side' => 'bottom')}
        
        fname_sort = TkButton.new($win) {}
        fname_sort.text 'First'; fname_sort.command {create_update_doctor_listbox_first}; fname_sort.place('height' => 25, 'width' => 40, 'x' => 170, 'y' => 10)
        fname_sort.background "#CCFFFF"
        
        
        lname_sort = TkButton.new($win) {}
        lname_sort.text 'Last'; lname_sort.command {create_update_doctor_listbox_last}; lname_sort.place('height' => 25, 'width' => 40, 'x' => 220, 'y' => 10)
        lname_sort.background "#CCFFFF"
    end


####################### 4.) CREATE WINDOW TO UPDATE DOCTOR DATA INTO DB ##############
    def update_window_doctor_info(doctor_number)
        begin
            $win.destroy
        rescue
        end
        $win = TkToplevel.new
        $win.title("UPDATE DOCTOR DATA")
        $win.geometry("500x200")
  
   quit_out = TkButton.new($win) {}
        quit_out.text 'RETURN TO MAIN MENU'; quit_out.command "$win.destroy"; quit_out.pack('side' => 'bottom')
        quit_out.background "#CCFFFF"; quit_out.relief 'groove'; quit_out.borderwidth = 5

        #puts doctor_number.to_s
        doctor_array = Array.new
        con = Mysql.new('instance39835.db.xeround.com', 'system', 'csci344', 'tes123', 7617)
        query_string = con.query("SELECT * FROM sh_doctor WHERE doctor_number = '#{doctor_number.to_i}';")
        con.close        
        query_string = query_string.fetch_row
        x = 8
        while x >= 0
        #puts query_string.to_s
        #puts query_string[x].to_s
        doctor_array[x] = query_string[x]
        x -= 1
        end
        
        #dr first name
        f_name_label = TkLabel.new($win)
        f_name_label.font AppHighlightFont; f_name_label.padx 16; f_name_label.pady 5; f_name_label.borderwidth = 5
        f_name_label.relief = 'groove'; f_name_label.background "#FFFFF0"; f_name_label.foreground "blue"
        f_name_label.text ("First Name"); f_name_label.place('height' => 25, 'width' => 120, 'x' => 10,'y' => 2)      
        
        patient_first_name = TkEntry.new($win)
        patient_first_name_var = TkVariable.new
        patient_first_name.textvariable = patient_first_name_var; patient_first_name_var.value = doctor_array[1]
        patient_first_name.place('height' => 25, 'width' => 100, 'x' => 140,'y' => 2)

        #patient last name
        l_name_label = TkLabel.new($win)
        l_name_label.font AppHighlightFont; l_name_label.padx 16; l_name_label.pady 5; l_name_label.borderwidth = 5
        l_name_label.relief = 'groove'; l_name_label.background "#FFFFF0"; l_name_label.foreground "blue"
        l_name_label.text ("Last Name"); l_name_label.place('height' => 25, 'width' => 120, 'x' => 250,'y' => 2) 
        
        patient_last_name = TkEntry.new($win)
        patient_last_name_var = TkVariable.new
        patient_last_name.textvariable = patient_last_name_var; patient_last_name_var.value = doctor_array[2]
        patient_last_name.place('height' => 25, 'width' => 110, 'x' => 380,'y' => 2)
 
        #patient address number
        address_label = TkLabel.new($win)
        address_label.font AppHighlightFont; address_label.padx 16; address_label.pady 5; address_label.borderwidth = 5
        address_label.relief = 'groove'; address_label.background "#FFFFF0"; address_label.foreground "blue"
        address_label.text ("Address"); address_label.place('height' => 25, 'width' => 120, 'x' => 10,'y' => 32) 
        
        patient_address_number = TkEntry.new($win)
        patient_address_number_var = TkVariable.new
        patient_address_number.textvariable = patient_address_number_var; patient_address_number.value = doctor_array[4]
        patient_address_number.place('height' => 25, 'width' => 40, 'x' => 140,'y' => 32)
  
        #Patient_Address_Street
        patient_address_street = TkEntry.new($win)
        patient_address_street_var = TkVariable.new
        patient_address_street.textvariable = patient_address_street_var; patient_address_street.value = doctor_array[5]
        patient_address_street.place('height' => 25, 'width' => 85, 'x' => 190,'y' => 32)

        #Patient_Address_City
        patient_address_city = TkEntry.new($win)
        patient_address_city_var = TkVariable.new
        patient_address_city.textvariable = patient_address_city_var; patient_address_city.value = doctor_array[6]
        patient_address_city.place('height' => 25, 'width' => 85, 'x' => 285,'y' => 32)

        #Patient_Address_State
        patient_address_state = TkEntry.new($win)
        patient_address_state_var = TkVariable.new
        patient_address_state.textvariable = patient_address_state_var; patient_address_state.value = doctor_array[7]
        patient_address_state.place('height' => 25, 'width' => 50, 'x' => 380,'y' => 32)
  
        #Patient_Address_Zip
        patient_address_zip = TkEntry.new($win)
        patient_address_zip_var = TkVariable.new
        patient_address_zip.textvariable = patient_address_zip_var; patient_address_zip.value = doctor_array[8]
        patient_address_zip.place('height' => 25, 'width' => 50, 'x' => 440,'y' => 32)

        #Patient_Phone
        phone_label = TkLabel.new($win)
        phone_label.font AppHighlightFont; phone_label.padx 16; phone_label.pady 5; phone_label.borderwidth = 5
        phone_label.relief = 'groove'; phone_label.background "#FFFFF0"; phone_label.foreground "blue"
        phone_label.text ("Phone"); phone_label.place('height' => 25, 'width' => 100, 'x' => 10,'y' => 62) 
        
        patient_phone = TkEntry.new($win)
        patient_phone_var = TkVariable.new
        patient_phone.textvariable = patient_phone_var
        patient_phone.value = doctor_array[3]
        patient_phone.place('height' => 25, 'width' => 110, 'x' => 120,'y' => 62)

        fid_label = TkLabel.new($win)
        fid_label.font AppHighlightFont; fid_label.padx 16; fid_label.pady 5; fid_label.borderwidth = 5
        fid_label.relief = 'groove'; fid_label.background "#FFFFF0"; fid_label.foreground "blue"
        fid_label.text ("FED ID#"); fid_label.place('height' => 25, 'width' => 120, 'x' => 240,'y' => 62) 
        
        patient_fid = TkEntry.new($win)
        patient_fid_var = TkVariable.new
        patient_fid.textvariable = patient_fid_var
        patient_fid.value = doctor_array[0]
        patient_fid.place('height' => 25, 'width' => 120, 'x' => 370,'y' => 62)
        
        accept = TkButton.new($win) {}
        accept.text 'UPDATE INFORMATION'; accept.pack('side' => 'bottom')
        accept.background "#CCFFFF "; accept.relief 'groove'; accept.borderwidth = 5
        accept.command(proc {update_mysql_doctor( doctor_number.to_s, patient_first_name_var, patient_last_name_var, patient_phone_var, patient_address_number_var, patient_address_street_var, patient_address_city_var, patient_address_state_var, patient_address_zip_var); $win.destroy})
    end
###############################################################################

####################### 5.) CREATES WINDOW TO INSERT NEW VISIT INTO DB ##############
    def create_visit_window
        begin
            $win.destroy
        rescue
        end
        $win = TkToplevel.new
        $win.title("CREATE A VISIT")
        $win.geometry("500x250")
  
        quit_out = TkButton.new($win) {}
        quit_out.text 'RETURN TO MAIN MENU'; quit_out.command "$win.destroy"; quit_out.pack('side' => 'bottom')
        quit_out.background "#CCFFFF"; quit_out.relief 'groove'; quit_out.borderwidth = 5
        

        #VISIT NUMBER
        visit_number_label = TkLabel.new($win)
        visit_number_label.font AppHighlightFont; visit_number_label.padx 16; visit_number_label.pady 5; visit_number_label.borderwidth = 5
        visit_number_label.relief = 'groove'; visit_number_label.background "#FFFFF0"; visit_number_label.foreground "blue"
        visit_number_label.text ("Visit#"); visit_number_label.place('height' => 25, 'width' => 70, 'x' => 10,'y' => 2)      
        
        #THIS NEEDS TO BE NON INTERACTIVE, POPULATED BY CALL TO DB
        visit_num = TkEntry.new($win)
        visit_num_var = TkVariable.new
        visit_num.textvariable = visit_num_var; visit_num_var.value = ""
        visit_num.place('height' => 25, 'width' => 70, 'x' => 90,'y' => 2)

        #patient name
        visit_name_label = TkLabel.new($win)
        visit_name_label.font AppHighlightFont; visit_name_label.padx 16; visit_name_label.pady 5; visit_name_label.borderwidth = 5
        visit_name_label.relief = 'groove'; visit_name_label.background "#FFFFF0"; visit_name_label.foreground "blue"
        visit_name_label.text ("Patient Name"); visit_name_label.place('height' => 25, 'width' => 110, 'x' => 170,'y' => 2) 
        
        patient_last_name = TkEntry.new($win)
        patient_last_name_var = TkVariable.new
        patient_last_name.textvariable = patient_last_name_var; patient_last_name_var.value = ""
        patient_last_name.place('height' => 25, 'width' => 110, 'x' => 290,'y' => 2)
        
        patient_search = TkButton.new($win) {}
        patient_search.text 'Search'; patient_search.place('height' => 25, 'width' => 50, 'x' => 410,'y' => 2)
        patient_search.background "#CCFFFF "; patient_search.relief 'groove'; patient_search.borderwidth = 5
      
        dr_name_label = TkLabel.new($win)
        dr_name_label.font AppHighlightFont; dr_name_label.padx 16; dr_name_label.pady 5; dr_name_label.borderwidth = 5
        dr_name_label.relief = 'groove'; dr_name_label.background "#FFFFF0"; dr_name_label.foreground "blue"
        dr_name_label.text ("Doctor Name"); dr_name_label.place('height' => 25, 'width' => 110, 'x' => 170,'y' => 32) 
      
        dr_last_name = TkEntry.new($win)
        dr_last_name_var = TkVariable.new
        dr_last_name.textvariable = dr_last_name_var; dr_last_name_var.value = ""
        dr_last_name.place('height' => 25, 'width' => 110, 'x' => 290,'y' => 32)
        
        dr_search = TkButton.new($win) {}
        dr_search.text 'Search'; dr_search.place('height' => 25, 'width' => 50, 'x' => 410,'y' => 32)
        dr_search.background "#CCFFFF "; dr_search.relief 'groove'; dr_search.borderwidth = 5
        
        #VISIT WEIGHT
        visit_weight_label = TkLabel.new($win)
        visit_weight_label.font AppHighlightFont; visit_weight_label.padx 16; visit_weight_label.pady 5; visit_weight_label.borderwidth = 5
        visit_weight_label.relief = 'groove'; visit_weight_label.background "#FFFFF0"; visit_weight_label.foreground "blue"
        visit_weight_label.text ("Weight"); visit_weight_label.place('height' => 25, 'width' => 70, 'x' => 10,'y' => 32)      
        
        visit_weight = TkEntry.new($win)
        visit_weight_var = TkVariable.new
        visit_weight.textvariable = visit_weight_var; visit_weight_var.value = ""
        visit_weight.place('height' => 25, 'width' => 70, 'x' => 90,'y' => 32)
       
        tryarray = Array.new
        iternum = 1900
        while iternum < 2015
            tryarray.push iternum.to_s
            iternum += 1
        end

        date_label = TkLabel.new($win)
        date_label.font AppHighlightFont; date_label.padx 16; date_label.pady 5; date_label.borderwidth = 5
        date_label.relief = 'groove'; date_label.background "#FFFFF0"; date_label.foreground "blue"
        date_label.text ("Date"); date_label.place('height' => 25, 'width' => 70, 'x' => 10,'y' => 62) 
        
        $monthvar = TkVariable.new
        patient_month = Tk::Tile::Combobox.new($win) 
        patient_month.textvariable $monthvar; patient_month.place('height' => 25, 'width' => 80, 'x' => 90,'y' => 62)
        patient_month.values = [ 'January', 'Febraury', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'] 
        
        $dayvar = TkVariable.new
        patient_day = Tk::Tile::Combobox.new($win) 
        patient_day.textvariable $dayvar; patient_day.place('height' => 25, 'width' => 40, 'x' => 180,'y' => 62)
        patient_day.values = [ '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31'] 
        
        $yearvar = TkVariable.new
        patient_year = Tk::Tile::Combobox.new($win) 
        patient_year.textvariable $yearvar; patient_year.place('height' => 25, 'width' => 50, 'x' => 230,'y' => 62)
        patient_year.values = tryarray
       
        visit_color_label = TkLabel.new($win)
        visit_color_label.font AppHighlightFont; visit_color_label.padx 16; visit_color_label.pady 5; visit_color_label.borderwidth = 5
        visit_color_label.relief = 'groove'; visit_color_label.background "#FFFFF0"; visit_color_label.foreground "blue"
        visit_color_label.text ("Candy Color"); visit_color_label.place('height' => 25, 'width' => 110, 'x' => 290,'y' => 62)      
        
        $colorvar = TkVariable.new
        candy_color = Tk::Tile::Combobox.new($win) 
        candy_color.textvariable $colorvar; candy_color.place('height' => 25, 'width' => 80, 'x' => 410,'y' => 62)
        candy_color.values = [ 'Red', 'Blue', 'Green', 'Yellow', 'Orange', 'Purple'] 

        t2 = TkLabel.new($win)
        t2.text ("Allergies"); t2.font AppHighlightFont; t2.padx 16; t2.pady 5; t2.borderwidth = 5
        t2.relief = 'groove'; t2.background "#FFFFF0"; t2.foreground "blue"
        t2.place('height' => 25, 'width' => 275, 'x' => 134,'y' => 92)

        $animal_allergy = TkVariable.new
        animal_allergies = Tk::Tile::CheckButton.new($win) {}
        animal_allergies.text 'Animal Products'; animal_allergies.command ''; animal_allergies.variable $animal_allergy;
	    animal_allergies.place('height' => 25, 'width' => 100, 'x' => 90,'y' => 122)
        #animal_allergies.invoke##THIS WORKS
        
        $insect_allergy = TkVariable.new
        insect_allergies = Tk::Tile::CheckButton.new($win) {text 'Insect Stings'; 
	    command ''; variable $insect_allergy; onvalue 'true'; offvalue 'false'}
        insect_allergies.place('height' => 25, 'width' => 100, 'x' => 210,'y' => 122)
        
        $mold_allergy = TkVariable.new
        mold_allergies = Tk::Tile::CheckButton.new($win) {text 'Mold Spores'; 
	    command ''; variable $mold_allergy; onvalue 'true'; offvalue 'false'}
        mold_allergies.place('height' => 25, 'width' => 100, 'x' => 330,'y' => 122)
        
        $drug_allergy = TkVariable.new
        drug_allergies = Tk::Tile::CheckButton.new($win) {text 'Drugs'; 
	    command ''; variable $drug_allergy; onvalue 'true'; offvalue 'false'}
        drug_allergies.place('height' => 25, 'width' => 100, 'x' => 180,'y' => 152)
        
        $food_allergy = TkVariable.new
        food_allergies = Tk::Tile::CheckButton.new($win) {text 'Foods'; 
	    command ''; variable $food_allergy; onvalue 'true'; offvalue 'false'}
        food_allergies.place('height' => 25, 'width' => 100, 'x' => 290,'y' => 152)

        $plant_allergy = TkVariable.new
        plant_allergies = Tk::Tile::CheckButton.new($win) {text 'Plants'; 
	    command ''; variable $plant_allergy; onvalue 'true'; offvalue 'false'}
        plant_allergies.place('height' => 25, 'width' => 100, 'x' => 70,'y' => 152)
        
        $other_allergy = TkVariable.new
        other_allergies = Tk::Tile::CheckButton.new($win) {text 'Other'; 
	    command ''; variable $other_allergy; onvalue 'true'; offvalue 'false'}
        other_allergies.place('height' => 25, 'width' => 100, 'x' => 400,'y' => 152)

        accept = TkButton.new($win) {}
        accept.text 'SUBMIT INFORMATION'; accept.pack('side' => 'bottom')
        accept.background "#CCFFFF "; accept.relief 'groove'; accept.borderwidth = 5

        #accept.command(proc {create_mysql_VISIT( patient_first_name_var, patient_last_name_var, patient_gender_var, patient_dob_var, patient_phone_var, patient_address_number_var, patient_address_street_var, patient_address_city_var, patient_address_state_var, patient_address_zip_var); $win.destroy})
    end


############## 6.) CREATE WINDOW TO INSERT FOLLOW UP DATA INTO DB ##########################
 def create_followup_window
        begin
            $win.destroy
        rescue
        end
        $win = TkToplevel.new
        $win.title("Follow Up Call")
        $win.geometry("500x200")
  
        quit_out = TkButton.new($win) {}
        quit_out.text 'RETURN TO MAIN MENU'; quit_out.command "$win.destroy"; quit_out.pack('side' => 'bottom')
        quit_out.background "#CCFFFF"; quit_out.relief 'groove'; quit_out.borderwidth = 5

        accept = TkButton.new($win) {}
        accept.text 'SUBMIT INFORMATION'; accept.pack('side' => 'bottom')
        accept.background "#CCFFFF "; accept.relief 'groove'; accept.borderwidth = 5

        #dr name
        dr_name_label = TkLabel.new($win)
        dr_name_label.font AppHighlightFont; dr_name_label.padx 16; dr_name_label.pady 5; dr_name_label.borderwidth = 5
        dr_name_label.relief = 'groove'; dr_name_label.background "#FFFFF0"; dr_name_label.foreground "blue"
        dr_name_label.text ("Doctor Name"); dr_name_label.place('height' => 25, 'width' => 120, 'x' => 10,'y' => 2)      
        
        dr_name = TkEntry.new($win)
        dr_name_var = TkVariable.new
        dr_name.textvariable = dr_name_var; dr_name_var.value = ""
        dr_name.place('height' => 25, 'width' => 100, 'x' => 140,'y' => 2)
        
        f_name_label = TkLabel.new($win)
        f_name_label.font AppHighlightFont; f_name_label.padx 16; f_name_label.pady 5; f_name_label.borderwidth = 5
        f_name_label.relief = 'groove'; f_name_label.background "#FFFFF0"; f_name_label.foreground "blue"
        f_name_label.text ("Patient Name"); f_name_label.place('height' => 25, 'width' => 120, 'x' => 250,'y' => 2)      
        
        patient_first_name = TkEntry.new($win)
        patient_first_name_var = TkVariable.new
        patient_first_name.textvariable = patient_first_name_var; patient_first_name_var.value = ""
        patient_first_name.place('height' => 25, 'width' => 100, 'x' => 380,'y' => 2)
        
        #Patient_Phone
        phone_label = TkLabel.new($win)
        phone_label.font AppHighlightFont; phone_label.padx 16; phone_label.pady 5; phone_label.borderwidth = 5
        phone_label.relief = 'groove'; phone_label.background "#FFFFF0"; phone_label.foreground "blue"
        phone_label.text ("Phone"); phone_label.place('height' => 25, 'width' => 120, 'x' => 10,'y' => 32) 
        
        patient_phone = TkEntry.new($win)
        patient_phone_var = TkVariable.new
        patient_phone.textvariable = patient_phone_var
        patient_phone.value = ""
        patient_phone.place('height' => 25, 'width' => 100, 'x' => 140,'y' => 32)

        tryarray = Array.new
        iternum = 1900
        while iternum < 2015
            tryarray.push iternum.to_s
            iternum += 1
        end
        date_label = TkLabel.new($win)
        date_label.font AppHighlightFont; date_label.padx 16; date_label.pady 5; date_label.borderwidth = 5
        date_label.relief = 'groove'; date_label.background "#FFFFF0"; date_label.foreground "blue"
        date_label.text ("Date"); date_label.place('height' => 25, 'width' => 70, 'x' => 10,'y' => 62) 
        
        $monthvar = TkVariable.new
        patient_month = Tk::Tile::Combobox.new($win) 
        patient_month.textvariable $monthvar; patient_month.place('height' => 25, 'width' => 80, 'x' => 90,'y' => 62)
        patient_month.values = [ 'January', 'Febraury', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'] 
        
        $dayvar = TkVariable.new
        patient_day = Tk::Tile::Combobox.new($win) 
        patient_day.textvariable $dayvar; patient_day.place('height' => 25, 'width' => 40, 'x' => 180,'y' => 62)
        patient_day.values = [ '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31'] 
        
        $yearvar = TkVariable.new
        patient_year = Tk::Tile::Combobox.new($win) 
        patient_year.textvariable $yearvar; patient_year.place('height' => 25, 'width' => 50, 'x' => 230,'y' => 62)
        patient_year.values = tryarray
        
        gender_label = TkLabel.new($win)
        gender_label.font AppHighlightFont; gender_label.padx 16; gender_label.pady 5; gender_label.borderwidth = 5
        gender_label.relief = 'groove'; gender_label.background "#FFFFF0"; gender_label.foreground "blue"
        gender_label.text ("Got The Flu?"); gender_label.place('height' => 25, 'width' => 120, 'x' => 290,'y' => 62) 
        
        $gendervar = TkVariable.new
        patient_gender = Tk::Tile::Combobox.new($win) 
        patient_gender.textvariable $gendervar; patient_gender.values = [ 'Yes', 'No'] 
        patient_gender.place('height' => 25, 'width' => 70, 'x' => 420,'y' => 62)
        #use patient_gender.current to get the current selected field
end


############## 7.) CREATE WINDOW TO OUTPUT VACCINE SEARCH RESULTS ##########################
 def create_vaccine_window
        begin
            $win.destroy
        rescue
        end
        $win = TkToplevel.new
        $win.title("Search For Vaccine")
        $win.geometry("500x250")
  
        dr_name_label = TkLabel.new($win)
        dr_name_label.font AppHighlightFont; dr_name_label.padx 16; dr_name_label.pady 5; dr_name_label.borderwidth = 5
        dr_name_label.relief = 'groove'; dr_name_label.background "#FFFFF0"; dr_name_label.foreground "blue"
        dr_name_label.text ("Lassen View Medical Recommends: " ); dr_name_label.place('height' => 25, 'width' => 480, 'x' => 10,'y' => 75)    
        
        vac_name_label = TkLabel.new($win)
        vac_name_label.font AppHighlightFont; vac_name_label.padx 16; vac_name_label.pady 5; vac_name_label.borderwidth = 5
        vac_name_label.relief = 'groove'; vac_name_label.background "#FFFFF0"; vac_name_label.foreground "blue"
        vac_name_label.text ("DOSAGE HERE" + " cc's of " + "VACCINE HERE"); vac_name_label.place('height' => 25, 'width' => 480, 'x' => 10,'y' => 125)    
 
        quit_out = TkButton.new($win) {}
        quit_out.text 'RETURN TO MAIN MENU'; quit_out.command "$win.destroy"; quit_out.pack('side' => 'bottom')
        quit_out.background "#CCFFFF"; quit_out.relief 'groove'; quit_out.borderwidth = 5

        accept = TkButton.new($win) {}
        accept.text 'Prescribe Vaccine'; accept.pack('side' => 'bottom')
        accept.background "#CCFFFF "; accept.relief 'groove'; accept.borderwidth = 5
end

#################### 0.) CREATE WINDOW FOR MAIN MENU ################################
    root = TkRoot.new{}
    root.title("MAIN MENU"); root.geometry("300x490"); root.borderwidth = 3; root.relief = 'groove' 
    #root.background 'black'
    root.padx 5

    image = TkPhotoImage.new
    image.file = "lassen.gif"
    t1 = TkLabel.new(root)
    t1.image = image
    t1.padx 20; t1.pady 5; t1.borderwidth = 5; t1.relief = 'groove'; t1.background "blue"
    t1.foreground "#FFFFF0"; t1.place('x' => 15,'y' => 40); 
            
    AppHighlightFont = TkFont.new :family => 'Times', :size => 12, :weight => 'bold'
    t2 = TkLabel.new(root)
    t2.font AppHighlightFont; t2.padx 16; t2.pady 5; t2.borderwidth = 5; t2.relief = 'groove'
    t2.background "#FFFFF0"; t2.foreground "blue";  t2.text ("LASSEN VIEW MEDICAL")
    t2.place('height' => 25, 'width' => 275, 'x' =>2, 'y' => 10)
    
    t3 = TkLabel.new(root); t3.font AppHighlightFont; t3.padx 16; t3.pady 5; t3.borderwidth = 5; t3.relief = 'groove'
    t3.background "#FFFFF0"; t3.foreground "blue";  t3.text ("MAIN MENU"); 
    t3.place('height' => 25, 'width' => 275, 'x' => 2,'y' => 180)            
            
    
    TkButton.new {
        text 'ADD NEW PATIENT INFO'
        command 'create_window_patient_info'
        place('height' => 25, 'width' => 225, 'x' => 25,'y' => 210)
        background "#CCFFFF "
        relief 'groove'
        borderwidth = 5
    }

    TkButton.new {
        text 'UPDATE PATIENT INFO'
        command 'create_update_patient_listbox'
        place('height' => 25, 'width' => 225, 'x' => 25,'y' => 240)
        background "#CCFFFF "
        relief 'groove'
        borderwidth = 5
    }

    TkButton.new {
        text 'EXIT'
        command 'exit'
        
        pack('side' => 'bottom')
        
        background "#CCFFFF "
        relief 'groove'
        borderwidth = 5
    }

    TkButton.new {
        text 'ADD NEW VISIT INFORMATION'
        command 'create_visit_window'
        place('height' => 25, 'width' => 225, 'x' => 25,'y' => 330)
        background "#CCFFFF "
        relief 'groove'
        borderwidth = 5
    }

    TkButton.new {
        text 'FOLLOW UP VISIT INFORMATION'
        command 'create_followup_window'
        place('height' => 25, 'width' => 225, 'x' => 25,'y' => 360)
        background "#CCFFFF "
        relief 'groove'
        borderwidth = 5
    }

    TkButton.new {
        text 'ADD NEW DOCTOR INFO'
        command 'create_window_doctor_info'
        place('height' => 25, 'width' => 225, 'x' => 25,'y' => 270)
        background "#CCFFFF "
        relief 'groove'
        borderwidth = 5
    }

    TkButton.new {
        text 'UPDATE DOCTOR INFO'
        command 'create_update_doctor_listbox'
        place('height' => 25, 'width' => 225, 'x' => 25,'y' => 300)
        background "#CCFFFF "
        relief 'groove'
        borderwidth = 5
    }

    TkButton.new {
        text 'SEARCH FOR VACCINE'
        command 'create_vaccine_window'
        place('height' => 25, 'width' => 225, 'x' => 25,'y' => 390)
        background "#CCFFFF "
        relief 'groove'
        borderwidth = 5
    }

    TkButton.new {
        text 'PATIENT HISTORY'
        command ''
        place('height' => 25, 'width' => 225, 'x' => 25,'y' => 420)
        background "#CCFFFF "
        relief 'groove'
        borderwidth = 5
    }

    # Start the window's event-loop
Tk.mainloop
