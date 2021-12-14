;;=============================================================================
;; Synergy Licensing Toolkit Example
;;=============================================================================
;;
;; Author:      Steve Ives, Synergex Professional Services Group
;; Date:        17th April 2009
;; Revision:    1
;;
;; Introduction
;; ------------
;; The Synergy Licensing Toolkit allows you to take advantage of the Synergex
;; product licensing technologies in your own applications.  This download
;; contains examples of how to create license keys, install license keys onto
;; runtime systems, and how to implement license checking in your applications.
;; 
;; Requirements and Setup
;; ----------------------
;; The availability of the Synergy Licensing Toolkit coincided with the release
;; of Synergy/DE V9.1.5b in April 2009.  In order to use these examples you
;; will need to have Synergy/DE V9.1.5b or higher installed on a supported 
;; Microsoft Windows system.
;; 
;; To obtain a copy of the Synergy Licensing Toolkit you will need to contact
;; Synergex and request it.  You will need to tell Synergex the "Licensee name"
;; and "Registration String" from your Synergy License Server.  You can find
;; this information using the Synergy Configuation Program, or using the LMU
;; command at the Windows command prompt.
;; 
;; As well as providing you with a copy of the Licensing Toolkit files and
;; documentation Synergex will provide you with a unique "Producer Code", and
;; an LMK9 license for that producer code.  You must install that license onto
;; your license server in order to be able to use the KMK.EXE program to
;; produce license keys for your producer code.
;; 
;; You will also need to edit the file "LicensingDemo.dbl" that is
;; provided as part of this example and change the value of the variable
;; "ProducerCode" to match the unique producer code provided by Synergex.
;; Once you have done this you will need to recompile the program (see below).
;; 
;; 
;; Development Environment
;; -----------------------
;; This download includes a pre-configured Workbench development environment.
;; Use workbench to open the Workspace LicensingToolkit.vpw. Note that to open
;; a workspace you use the menu commands "Project" > "Open Workspace".
;; 
;; Once you have the workspace open you can compile the demo program by
;; selecting "Build" > "Compile" from the menu.  Then link it with "Build" >
;; "Build" and run it with "Build" > Execute".
;; 
;; Running the demo
;; ----------------
;; When you run the demo the program will check that you have an LMK9 license
;; for your producer code installed on your license server.  You will not be
;; able to proceed if this is not the case, or if the LMK9 license is a
;; temporary license which has expired.
;; 
;; Next the program checks to see if there are any licenses FROM your producer
;; code installed on the system. If there are it will display them.
;; 
;; The demo uses license codes for five imaginary products.  These are:
;; 
;; Application             Version         License Code
;; -------------------     -------         ------------
;; Accounts Payable        1.0             AP010
;; Accounts Receivable     1.0             AR010
;; General Ledger          1.0             GL010
;; Fixed Assets            1.0             FA010
;; Inventoty               1.0             IN010
;; 
;; To get started you need to create some license keys for these applications,
;; and install the license keys onto your system.  From the "Manage Keys" menu,
;; select "Create License Install Key File".  You should see a warning telling
;; you that no license keys were found and that default demo data is being
;; used. Click OK and you will see an input window that allows you to enter the
;; number of users for each of the five products, and an optional expiry date
;; for each license. You will notice that the "Licensee" and "Registration
;; String" fields have been pre-populated with the data from your own system.
;; If you wish you can enter the details from a different system in order to
;; generate licenses for that system.
;; 
;;   Note: The default demo data sets the Fixed Assets license (FA010) as
;;         having expired 10 days earlier, and sets the Inventory license
;;         (IN010) to expire in 20 days time.  This is so that you can see how
;;         temporary and expired licenses are handled.
;; 
;; When you click the OK button the program uses the LMK utiltity to create the
;; license keys that you have specified.  These license keys are stored in a
;; "Key File" called "installkeys.skf". The program will then ask if you would
;; like to install the keys on the system.
;; 
;; To be able to install the keys from within the program you need to be
;; running ON the license server system.  If you are not on the license server
;; then you will need to manually install the keys on the license server. You
;; can do this by copying the generated license file (installkeys.skf) to the
;; license server, and then on the server you can use:
;; 
;;   - The Synergy Configuration program (Windows)
;;   - The LMU utility at a command prompt (Windows or UNIX)
;; 
;;   Note: Installing and uninstalling license keys takes a few seconds,
;;         because the Synergy License Manager service is restarted.
;; 
;; Once you have installed the keys you should see that the keys are displayed
;; in the body of the application.  If you installed the keys outside of the
;; demo program then press F5 to refresh the display.
;; 
;; On the "Key Status" menu you can use several options to programatically
;; check the status of a license key.  This simulates what you could do in a
;; program to determine if licenses you require are installed and available.
;; 
;; On the "Simulation" menu you can simulate starting and stopping programs
;; which allocate and deallocate licenses.  The license usage column in the
;; display will be updated to reflect the number of licenses installed and
;; used.  This display is built by capturing the output of the LMU command, so
;; you should find that you will see the same status if you use the LMU command
;; at a command prompt.
;; 
;; You can create different combinations of licenses and install them on your
;; system at any time.  When you are done you can remove the licenses by
;; selecting the "Generate License Uninstall Keyfile" from the "Manage Keys"
;; menu and then execute the resulting key file (removekeys.skf).
;; 
;;   Note: Licenses are removed by installing a license for 0 users.
;;
;; The DotNetClient folder contains an example of using the WIN32 Licensing
;; toolkit API from a C# Windows aplication.
;; 
;; IMPORTANT NOTE RE SEAT NUMBERS
;; ------------------------------
;; To be able to simulate multiple users logging licenses in and out the code
;; in this demo application uses "seat numbers".  A seat number is a mechanism
;; which allows the Licensing Toolkit to allocate unique licenses to individual
;; users who may be using a single process on a system.  For example, with
;; xfNetLink client applications multiple physical users may be represented by
;; a single xfServerPlus session, so passing a unique (application defined)
;; seat number allows the Licensing Toolkit toolkit to recognise one user from
;; another and allocate licenses to the "user" not the "process".  When you use
;; seat numbers in a Windows application like this one the result is that
;; licenses are allocated to each running program, rather than all instances of
;; a program a users workstation sharing one license.
;;
;; Enjoy!
