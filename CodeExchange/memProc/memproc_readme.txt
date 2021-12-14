README.TXT for MEMPROC

Description of program
----------------------

Note, this is intended as a development tool, to help identify memory leaks
caused by using Synergy dynamic memory.

MEMPROC.DBL allows users to "overload" the Synergy routine %mem_proc() to
log allocation/deallocation of dynamic memory segemnts and thus identify
potential memory leaks.

This works when you create the define .DEFINE MEM_PROC MY_MEM_PROC.  This must
be defined in every routine that uses %mem_proc().  In Synergy/DE 9.3 (& later),
the easiest way to do this is to utilize the environment variable SYNUSERDEF.
For convenience, a sample include file myApp.def is included in this project.
In Synergy/DE 7/8, you can modify DBLDIR:dbl.def to create the MEM_PROC define.
There is no "easy" way to globally add the MEM_PROC define in Synergy/DE 9.1.

The pre-DBLv9 functions are defined as ^val, so that you can use the -X compiler
option to avoid having to define the external function (my_mem_proc).
The DBLv9 variant assumes that you're using strong prototyping, and so do not
need to define external functions.


Because the use of a user subroutine to allocate memory, all dynamic memory is
created as STATIC dynamic memory, so this may change the behavior of your
application.  Logic that relies upon allocating non-static memory and the
Synergy behavior of auto-releasing memory on routine exit, will be reported as
a false positive, and because of the change to use STATIC memory, is now a real
memory leak.  To prevent this, you can add an explicit call to
%mem_proc(DM_FREE, hdl) in the appropriate routine(s) and/or undefine MEM_PROC.


You need to build memProc.dbl into an application library, so that your entire
application can use the included mem_proc overload, and recompile your entire
application.

main_memProc.dbl is a simple application that manages the mem_proc logging files
and  can create a log file from the mem_proc isam file.


Submission details
------------------

Author:                 William Hawkins
Company:                Synergex
Email:                  William.Hawkins@synergex.com
Date:                   27th Sept 2010
Minimum version:        Synergy 7
Platforms:              Any

Modification history
--------------------

27th Sept 2010
        Initial version

