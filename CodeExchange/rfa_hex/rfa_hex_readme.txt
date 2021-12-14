; README for RFA_HEX.DBL
;
; The main purpose of these function was intended to allow xfServerPlus methods
; to pass RFA's (which contain binary data) across the network to the xfNetLink
; client, and then for the client to pass back the RFA to the xfServerPlus
; method.  By converting binary data to hexadecimal text values, all issues
; with endian type and embedded binary data are circumvented.
;
;
; Description of functions
; ------------------------
;
; a6 = %RFA_TO_HEX(a12) converts an a6 RFA into an a12 hex string
;
; a12 = %HEX_TO_RFA(a6) converts an a12 hex string into an a6 RFA
;
; a18 = %SHOW_RFA(a6) converts an a6 RFA into an a18 (space delimited) hex string
;
;
; By removing the Synergy v9 function signature information from RFA_HEX.DBL,
; the functions can work with earlier versions of Synergy
;
;
;
; Submission details
; ------------------
;
; Author:                 William Hawkins
; Company:                Synergex
; Email:                  William.Hawkins@synergex.com
; Date:                   3rd July 2008
; Minimum version:        Synergy 9.1
; Platforms:              Any
;
; RFA_HEX.DBL
; Compiler command:       DBL rfa_hex
; Link command            none (link it into an elb)
;
; RFA_HEX_TEST.DBL (a simple test program)
; Compiler command:       DBL rfa_hex_test
; Link command            DBLINK rfa_hex_test

Modification history
--------------------

20th Sept 2010
        Updated for compatibility with Synergy 9.5


