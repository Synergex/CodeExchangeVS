README.TXT for RPSCHK.DBL

Description of function
-----------------------

This function will generate a validate a SynergyDE isamxf with it's
Synergy/DE Repository definition.  Any possible errors may be logged
in a specified log file.

A standalone program can be generated by using the compiler directive
.define RPSCHK_EXE_REQUIRED.  If a standalone program is generated,
this program also has the abilty to check a single file or all files.

Uses the logical INC: to point to the include file directories.

Uses UTILITIES.ZIP

Submission details
------------------

Author:                 William Hawkins
Company:                Synergex
Email:                  William.Hawkins@synergex.com
Date:                   24th Oct 2000
Minimum version:        Synergy 7.0.1
Platforms:              Any
Compiler command:       DBL RPSCHK
Link command            none (link it into an elb)
 (for program)          DBLINK RPSCHK WND:TKLIB.ELB RPSLIB:ddlib.elb


Modification history
--------------------

20th Sept 2010
        Updated for compatibility with Synergy 9.5

