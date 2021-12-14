README.TXT for SYNCKODBC.DBL

Description of program
----------------------

This program is intended to help debugging xfODBC connection issues.  It will
show the value of xfODBC logicals, allow you to open a connect file and confirm
the date that the system catalog files were last rebuilt.  You can also view
and/or edit the connect files.

Editing connect files

By default, the program will launch notepad, vi or EDIT (on Windows, UNIX and
OpenVMS respectively), but you can override this by setting the environment
variable EDIT_COMMAND to the appropriate command to launch your favorite
editor.  e.g. To use the TPU editor on OpenVMS, you would set EDIT_COMMAND to
"EDIT/TPU"


Submission details
------------------

Author:           William Hawkins
Company:          Synergex
Email:            William.Hawkins@synergex.com
Date:             9th September 2004
Minimum version:  Synergy 8.1
Platforms:        Any
Compiler command: dbl -XT synckodbc
Link command: dblink synckodbc WND:tklib.elb RPSLIB:ddlib.elb DBLDIR:axlib.elb

Modification History
--------------------

1.0 24th June 2004      Initial version
1.1 9th September 2004  Improved UI for UNIX / OpenVMS systems
1.2 20th September 2010 Compatibility changes with Synergy 9.5

