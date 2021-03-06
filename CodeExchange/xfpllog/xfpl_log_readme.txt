;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; XFPL_LOG_README.TXT
;
; Readme file for XFPL_LOG.
; This program can be used to extract data from an xfServerPlus log file.
;
; Author : William Hawkins (william.hawkins@synergex.com)
;
; Requires : Synergy/DE 7.3 or later
;
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
; Files required to build
;
; xfpl_log.dbl                  Program source code
; xfpl_log.def                  commonly used data and defines
;
; To build this program :
;
; dbl xfpl_log
; dblink xfpl_log WND:tklib.elb
;
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
; Discussion:
;
; dbr xfpl_log -l logfile -f outfile -o option -v verbose -p pid -h help
;
;
; This program can be used in one of three main functions as determined by
; the -o command line option:
;
; OPTION (-o)
;
; -o 0 : get the maximum number of concurrent sessions (default)
; -o 1 : get connect, disconnect and "last method call" date/time for all
;        processes
; -o 2 : get connect, disconnect and method call history for a single process
;
; if the -o command line option is not specified, option 0 will be used.
;
; LOGFILE (-l)
;
; if the -l command line option is not specified, the program will look at
; the contents of the logical XFPL_LOGFILE.  If this is not set, an error
; will be reported.
;
; OUTFILE (-f)
;
; if the -f command line option is not specified, "TT:" will be used.
;
; VERBOSE MODE (-v)
;
; Verbose mode can be 0 (no logging) or 1 (log the record nubmer being read)
; if the -v command line option is not specified, no logging will be used.
;
; PID (-p)
;
; This option is only used by "-o 2" and is required.  If the -p option is
; not specified, an error will be reported.
;
;
;
; The program will read xfServerPlus log file records of up to 20000 bytes.
; If this is insufficient, change the ".define BUFF_SIZE ,20000" to an
; appropriate value.  Alternatively, you can define "GETS_MODE" to force
; XFPL_LOG to read the xfServerPlus log file in GETS mode, 1 character at a
; time.
;
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Modification history
--------------------

20th Sept 2010
        Updated for compatibility with Synergy 9.5

