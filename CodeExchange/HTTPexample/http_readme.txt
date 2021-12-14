;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; HTTP_README.TXT
;
; Readme file for an example program demonstrating the use of the Synergy
; HTTP document transport API. This example program can be used to run an
; HTTP server or an HTTP client.
;
; Author : William Hawkins (william.hawkins@synergex.com)
;
; Requires : Synergy/DE 8 (or later)
;
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
; Files required to build
;
; http.dbl                      UI Toolkit front end to http subroutines
; http_ctrl.rec                 UI Toolkit control parameters
; http_inp_rec.rec              UI Toolkit data input record
;
; http.def                      Defines used by http_*.dbl
; http_utils.dbl                Utility routines used by http_*.dbl
; http_client.dbl               HTTP client routines
; http_server.dbl               HTTP server routines
; http_server_shutdown.dbl      HTTP server shutdown routines
;
; To build this program :
;
; dbl -XT http
; dblink http WND:tklib.elb RPSLIB:ddlib.elb DBLDIR:synxml.elb
;
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
; Discussion:
;
; This program can be used in one of three main functions:
;
; 1) Perform HTTP Client functions (get/put file)
; 2) Start HTTP Server (on this machine)
; 3) Stop HTTP Server
;
; Please comment/uncomment one or more of the following defines in HTTP.DBL
; to exclude/include the appropriate functions.
;
; Allow HTTP Client options
;.define HTTPCLIENT
;
; Allow Shutdown HTTP Server option
;.define HTTPSHUTDOWN
;
; Allow Start HTTP Server option
;.define HTTPSERVER
;
;
; Normally, each of these three functions would be run as seperate programs,
; with the start/stop server programs running on the server machine, and the
; client options built into your Synergy/DE application.
;
; If you build this program with the "Start Server" option combined with
; either of the other two options, you cannot start the http server and then
; perform any other option within the same instance of the program.
; (i.e. you must start the program a second time to start a second server
; process, to execute a client function or to shutdown a server process.
;
; According to HTTP standards, text documents must always have trailing CR/LF
; characters. This program adds a trailing CR/LF at the end of the file.
; Note: If the HTTP_* routines are used to transfer files between system that
; have different record terminators, it's up to the transfer program to
; ensure the correct record terminators are in the output stream.
; This program makes no attempt to perform any record terminator translation.
;
; Further information on HTTP can be found at
; http://www.microsoft.com/mind/0796/protocol/protocol.htm
;
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
; Modification history
; v1.1  2-Jun-2004 Added support for spaces in filename
; v1.2  20th Sept 2010 Updated for compatibility with Synergy 9.5
;
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

