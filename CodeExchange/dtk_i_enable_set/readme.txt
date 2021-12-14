					readme.txt

Name			i_enable_set.dbl, i_disable_set.dbl

Developed By		Richard C. Morris
			Technical consultant
			Synergex

Contact			Richard.Morris@Synergex.com

Description		i_enable_set 

			This function is a supplement to the Synergy/DE UI 
			Toolkit API.  It accepts an input window ID, and 
			set name.  The routine then reads through the fields 
			within the set and enables each field.

			i_enable_set required two arguments;

			        arg1    window_id
			        arg2    set_name

			This enables all the fields contained within the set 
			in the window.  This routine should be used in 
			conjunction with i_disable_set.

Description		i_disable_set

			This function is also a supplement to the Synergy/DE 
			UI Toolkit API.  It accepts an input window ID and 
			set name.  The routine then reads through the fields 
			within the set, and disables each field.

			Usage:

			On the input window define two sets.  One set should 
			contain all fields, and the other just the fields 
			you want to disable.  Call this routine to disable 
			all the non-input fields, and then perform input on 
			the set which contains all the fields.  Input will 
			not be allowed within the fields in this set which 
			are disabled.


			i_disable_set takes the same arguments mentioned 
			required for i_enable_set which disables the fields 
			contained within the set in the window.

Files included: 	i_enable_set.dbl, i_disable_set.dbl, readme.txt

Platforms 
supported		All Supported Platforms

Minimum Synergy/DE 
version supported:	Synergy Toolkit 3.7.6

Date posted:		March 18, 1999

