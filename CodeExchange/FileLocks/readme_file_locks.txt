README.TXT for FILE_LOCKS.DBL

Description of function
-----------------------

This program uses the chklock utility to determine which record is locked
in a Synergy Isam file.  The program displays the User PID, isam key,
filename, username, terminal name and terminal number.


The file RECORD_LOCKED.DBL is not used by FILE_LOCKS.DBL, but contains two
subroutines; ISAM_READS which can be used to replace a READS statement, and
can return the key that is locked, and ISAM_READS_LOCKED which can be called,
after a READS statement has returned a record locked error, to get the key
of the record that was locked.

Submission details
------------------

Author:                 William Hawkins
Company:                Synergex
Email:                  William.Hawkins@synergex.com
Date:                   8th August 2001
Minimum version:        Synergy 5.1
Platforms:              UNIX
Compiler command:       DBL file_locks
Link command            DBLINK file_locks

Modification history
--------------------

20th Sept 2010
        Updated for compatibility with Synergy 9.5

