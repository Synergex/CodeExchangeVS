;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; RPSSQL.DBL
;
; This routine uses the Synergy/DE Repository to produce an SQL schema
;
; Requires with Synergy/DE version 7 or later
;
; Version :
;
;.define D_APP          ,"RPSSQL"
;.define D_VERSION      ,"1.1.4"
;
; Date : 9th November 2001
;
; Export does not support :
;  Tags
;
; Requires Repository :
;  Files, Structures, Keys
;
; Uses :
;  Relations (for foreign keys)
;
; Notes :
;  Gets an array of field names in ^m(fld_array, f_ptr)
;  Gets an array of field details in ^m(fld_dets, fd_ptr)
;
;  The field details array contain:
;  field name, group prefix, field position (in structure) and f_info.
;
;  The field details array contains entries for every field and every element
;  of a group array (where the group prefix is modified), but does not contain
;  every element of field array.


Contact:

        Bill Hawkins
        Synergex
        bill.hawkins@synergex.com



Modification history
--------------------

20th Sept 2010
        Updated for compatibility with Synergy 9.5

******************************
CODE IS MADE AVAILABLE "AS IS"
******************************