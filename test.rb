#!/usr/bin/ruby

# ZetCode Ruby GTK tutorial
#
# This example shows message
# dialogs
#
# author: jan bodnar
# website: www.zetcode.com
# last modified: June 2009

require 'gtk2'


class RubyApp < Gtk::Window

    def initialize
        super
    
        set_title "Messages"
        signal_connect "destroy" do 
            Gtk.main_quit 
        end
        
        init_ui

        set_default_size 250, 100
        set_window_position Gtk::Window::POS_CENTER
        
        show_all
    end
    
    def init_ui
    
        table = Gtk::Table.new 2, 2, true
        
        info = Gtk::Button.new "Information"
        warn = Gtk::Button.new "Warning"
        ques = Gtk::Button.new "Question"
        erro = Gtk::Button.new "Error" 

        info.signal_connect "clicked" do
            on_info
        end    
        
        warn.signal_connect "clicked" do
            on_warn
        end
        
        ques.signal_connect "clicked" do
            on_ques
        end
        
        erro.signal_connect "clicked" do
            on_erro
        end
        
        table.attach info, 0, 1, 0, 1
        table.attach warn, 1, 2, 0, 1
        table.attach ques, 0, 1, 1, 2
        table.attach erro, 1, 2, 1, 2
        
        add table

    end
    
    def on_info
        md = Gtk::MessageDialog.new(self,
            Gtk::Dialog::DESTROY_WITH_PARENT, Gtk::MessageDialog::INFO, 
            Gtk::MessageDialog::BUTTONS_CLOSE, "Download completed")
        md.run
        md.destroy
    end
        
    
    def on_erro
        md = Gtk::MessageDialog.new(self, Gtk::Dialog::MODAL |
            Gtk::Dialog::DESTROY_WITH_PARENT, Gtk::MessageDialog::ERROR, 
            Gtk::MessageDialog::BUTTONS_CLOSE, "Error loading file")
        md.run
        md.destroy
    end
    
    
    def on_ques
        md = Gtk::MessageDialog.new(self,
            Gtk::Dialog::DESTROY_WITH_PARENT, Gtk::MessageDialog::QUESTION, 
            Gtk::MessageDialog::BUTTONS_CLOSE, "Are you sure to quit?")
        md.run
        md.destroy
    end
    
    def on_warn
        md = Gtk::MessageDialog.new(self,
            Gtk::Dialog::DESTROY_WITH_PARENT, Gtk::MessageDialog::WARNING, 
            Gtk::MessageDialog::BUTTONS_CLOSE, "Unallowed operation")
        md.run
        md.destroy
    end
end

Gtk.init
    window = RubyApp.new
Gtk.main
