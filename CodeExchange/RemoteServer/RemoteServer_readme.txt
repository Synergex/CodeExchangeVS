RemoteServer README
------------------

RemoteServer allows devlopers to compile (or execute other commands) on a
remote server.

Author : William Hawkins Synergex PSG. (william.hawkins@synergex.com)

History : 17th Feb 2010 v1.1
          20th Sep 2010 v1.2 Updated for compatibility with Synergy 9.5
          22nd Sep 2010 v1.3 Improved logic to ensure logicals are setup ok &
                             improved SlickEdit code to make connections more
                             reliable
          11th Oct 2010 v1.4 Added rmtprototype, rmtcompile & rmtlink


Files
-----

CLIENT

RemoteServer.e - SlickEdit macro
RemoteServerForms.sh - SlickEdit forms
rsClient.dbl - Synergy test program for RemoteServer.

SERVER

RemoteServer.dbl - Synergy executable that acts as a listener.
rsProcess.dbl - Synergy executable, launched by RemoteServer.
rsProcessFileName.dbl - routine to generate the name of the logfile.
RemoteServer.def - defines used by Remote Server sources
RemoteServer.inc - record layout for REMOTESERVERLOG:rs_<pid>.txt
dbl2dibol.dbl - routines to convert DBL commands to DIBOL commands.
endOfToken.dbl - determines if the current character is the last char in a token
logging.dbl - routines for debug logging
stringCase.dbl - upcase/locase functions
stringReplace.dbl - replace occurances of string2 with string3 in string1
pipe.dbc - pipe class
dns.dbc - System.DNS class
IPEndPoint.dbc - System.IPEndPoint class
IPHostEntry.dbc - System.IPHostEntry class
NetWorkStream.dbc - System.NetWorkStream class
Socket.dbc - System.Socket class
SocketException.dbc - System.SocketException class
TcpCLient.dbc - System.TcpCLient class
TcpListener.dbc - System.TcpListener class



Logicals used
-------------

The RemoteServer (and rsProcess) executables require the following logicals to
be set.

REMOTESERVEREXE - location of all runtime executable / script files
REMOTESERVERLOG - location of log files

The rsProcess executable will use the following logicals.

REMOTESERVERMINPORT - lowest port number that will be used by rsProcess
REMOTESERVERMAXPORT - highest port number that will be used by rsProcess

The min and max ports must be in the range 1025 to 65535.  Either they must
both be defined, or neither must be defined.   If neither are defined (or they
are both set to zero) rsProcess will use a random port.

Debugging logicals:

The following logicals are intended for debugging purposes only.

REMOTESERVERDBG
    1=use TT:
    2=use REMOTESERVERLOG:rs_*.log

also used by Workbench
    1=Output debug messages to RemoteServer window
    2=Output debug messages to SlickEdit SAY window

REMOTESERVERPORT - used by rsClient & RemoteServer when -p option is not
specified on command line

REMOTESERVERHOST - used by rsClient when -s option is not specified on command
line

REMOTESERVERFILE - used by rsClient to tell RemoteServer which source file to
recompile

REMOTESERVERPROCESSPORT - used by rsProcess to determine wihch port to use


How to build application
------------------------

See build.bat (Windows), build.script (Unix) or build.vms_com (OpenVMS)



WorkBench Configuration
-----------------------

Load Module

You will need to load the module "RemoteServer.e" from the RemoteServer/Client
folder into Workbench.  you can do this by selecting the "Load Module" option
on the "Tools" menu.  Then selecting RemoteServer.e in the file open fialog.
You should see a "module loaded" message in the Workbqnch footer line.  Now you
can select the "Tool Windows" option on the "View" menu column, and check the
RemoteServer window, to make it visible.  This window is dockable.  Now you can
use the "Setup" option to create the connection information, to allow Workbench
to connect to the RemoteServer process, that is running on a remote server.

Local Map / Remote Map

RemoteServer works best when you're using NFS/SAMBA/CIFS etc to map a remote
drive to a "local" widnows drive.  For exmaple.  you have all you sources on
OpenVMS in the directory  DKA0:[MYAPP.SOURCE] and within the SOURCE folder, you
have subdirectories AP/AR/GL etc.   You have the main source folder mapped to
the windows drive letter S:\. So in Workbench you have a project that have files
using the S:\AP\ folder.  e.g. S:\AP\statements.dbl   Now, you can compile this
file using the Windows compiler by using the standard compile/build/etc options.
but you will end up with a Windows dbr file.  If you want to compile this on
OpenVMS, you would use the rmtbld command (see below for more info).  However,
all workbench knows about the file is that it's called S:\AP\statement.dbl, but
your OpenVMS environment doesn't know what S:\AP is, so RemoteServer translates
the Windows file specification into an OpenVMS file specification by replacing
the S: (local map) with DKA0:[MYAPP.SOURCE] (remote map) and resolves the
directory delimiter differences.  This occurs both when you send the filename
to the remote server for the compiler to use, and any errors output by the
compiler.  This allows you to click on errors in the RemoteServer window, and
go to the appropriate line of code in the source file.


Project Tools

To add a remote build facility to your project menu (or a button), you can use
the "rmtbld" command. e.g. "rmtbld dbl -qstrict -qalign -n %rn"   rmtbld will
take a windows dbl/dblink/dblibr command line, and transform it into a command
line that will execute on the remote server.   If you have commands that do not
need translation, you can use the "rmtcmd" command instead.
If you issue the command rmtprototype, rmtcompile or rmtlink, the appropriate
command from the Synergy Project will be issued.


Project Properties Open

If you want to automatically connect to a remote server, when the project opens,
add "rmtsrv <hostname>" to your Project Open dialog.

If you add one (or more) "rmtcfg <command>" lines to your Project Open dialog,
those commands will be sent to the RemoteServer server when you connect.
If you want to have more than one remote server, you can add a qualifier to the
rmtcfg command.  Use this syntax "rmtcfg (<hostname>) <command>" lines in your
Project Open dialog.  e.g.  "rmtcfg (TRITON) set SRC=DKA0:[SRC]", where TRITON
is the name of a remote server in the remote build window.  If you connect to
a different remote server, this command will be ignored.  If the hostname is
blank or *, the rmtcfg will apply to all remote servers.

If the command is "set" or "syn_set" it assumes that you want to set a
logical / environment variable, and the command is in the form
"set <logical>=<value>"  Note: <value> can be enclosed with double quote
characters to allow spaces in <value>.

WorkBench will ignore rmtcfg commands (for local Windows configuration) when
opening the project.

You can use the "rmtcmd setdir <directory>" command, to change your default
directory.  This should only be used in the Project Open dialog, if you have
used rmtsrv first.


RemoteServer commands (summary)

syn_set / set - set environment variable during project open
rmtcfg [<hostname>] - issue command on <hostname> during project open

rmtcmd - issue native command
rmtbld - issue Synergy DBL/DBLINK/DBLIBR command,
          coverting windows syntax into OpenVMS syntax
rmtprototype - issue SynProto command
rmtcompile - issue SynCompile command
rmtlink - issue SynLink (or CreateLibrary) command


Other Workbench RemoteServer commands

rmtsvrservershutdown - tells the RemoteServer program to shutdown.

ShowRemoteServer - shows the RemoteServer window.  This window is also listed in
the Tools Windows option on the View menu column.


RemoteServer Window

While this is intended to be used to show the output from RMTBLD/RMTCMD commands
that are added to the Project Tools, you can also type commands directly into
the window.  You can execute any command that can be executed using an open pipe
command in synergy.  Note, if you try to execute a command that canned be
executed via open pipes, the remote server process is likely to abort, and
disconnect you from the server.  If the RemoteServer process is unresponsive,
please check to see if you have a "Connect" or a "Disconnect" button in the
RemoteServer window.  So if you can see a "Connect" button, you are no longer/
not connected to the server.



Issues running RemoteServer on non-Windows operating systems
------------------------------------------------------------

Certain compile options require filenames/directories. When compiling, those
options may cause problems if logicals are not used, as WorkBench will provide
a Windows format filename/directory, and not the native server format.
e.g. -o -l -qimpdir


OpenVMS
-------

RemoteServer assumes that the compile verb is DIBOL on OpenVMS.


Concepts
--------

Start RemoteServer on a known port on the server.

rsClient (aka WorkBench) will connect to the RemoteServer with a "hello"
message.  RemoteServer will then launch rsProcess to service the client, and
wait for rsProcess to create the pid file. Once the file has been created,
RemoteServer will respond to the clients "hello" message with a "connect"
message, delete the pid file and go into a wait state, for the next "hello"
message.
rsProcess will start running on a random port, and will write the port number
into the file RemoteServerLOG:rb_<pid>.txt, and then go into a socket server
wait state, until the client reconnects to it on the required port. Once the
client connects to the rsProcess, rsProcess will execute the client commands.
See RemoteServerProtocol.txt for mote information on the protocol used.


Restrictions
------------

RemoteServer commands are executed using Synergy open pipe. This means that you
are restricted to commands that can be executed with this mechanism. e.g.
you cannot use DIR when the RemoteServer is a Windows server, because DIR is
built into the Windows command processor.

