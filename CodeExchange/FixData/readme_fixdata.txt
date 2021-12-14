README.TXT for FIXDATA.DBL

Description of program
----------------------

This program will read through a Synergy DBMS file, and will modify data to
match the repository definition.

The program requires the Repository data files and two of three other peices
of information:

SDBMS filename and RPS structure

or

RPS filename (and optionally RPS structure)


If you provide SDBMS filename and RPS structure, the entire file will be
processed using the provided RPS structure.  Note, if structure tags are
defined, only matching records will be processed.

If you provide RPS filename, the file will be processed using the assigned
structures.  It will use the RPS structure tags to apply each structure to
it's appropriate record.  If you do not have tags defined, and you have
multiple structures assigned to the RPS file, the last structure wins. You
can restrict the processing to just a single structure, by specifying the
RPS structure name, note tags (if present) still apply.  The RPS file must
be "DBL ISAM" if the file is a SDBMS isam file, any other value will treat
the file as a relative file.

Overlay fields are ignored.

Currently, only Synergy decimal fields are processed.

Dates with a 4 digit year, and the year < 1900 are treated as invalid.



Submission details
------------------

Author:                 William Hawkins
Company:                Synergex
Email:                  William.Hawkins@synergex.com
Date:                   22nd October 2009
Minimum version:        Synergy 9.1.5
Platforms:              Any
Compiler command:       DBL fixdata
Link command            DBLINK fixdata WND:tklib.elb, RPSLIB:ddlib.elb

Modification history
--------------------

20th Sept 2010
        Updated for compatibility with Synergy 9.5

