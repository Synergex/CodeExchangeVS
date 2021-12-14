rem call setenv.bat
set DEVROOTNODE=C:\Development

set DEVROOT=%DEVROOTNODE%\SynPSG\CodeExchange\RemoteServer

set RSCLNTSRC=%DEVROOT%\Client
set RSSRVRSRC=%DEVROOT%\Server
set CORUTLSRC=%DEVROOT%\Server
set SYSNETSRC=%DEVROOT%\Server

rem RemoteServer environment variables
set SYNEXPDIR=%DEVROOT%\hdr
set SYNIMPDIR=%DEVROOT%\hdr
set OBJ=%DEVROOT%\obj
set DEF=%RSSRVRSRC%

rem Runtime environment variables
set REMOTESERVERLOG=%DEVROOT%\log
set REMOTESERVEREXE=%DEVROOT%\exe


rem generate prototype files
IF EXIST %SYNEXPDIR%\*.dbp (
	del %SYNEXPDIR%\*.dbp
)
dblproto %RSCLNTSRC%\*.dbl
dblproto %RSSRVRSRC%\*.dbl
dblproto %RSSRVRSRC%\*.dbc

dbl -d -qstrict -qalign -o OBJ:RemoteServer       RSSRVRSRC:RemoteServer.dbl
dbl -d -qstrict -qalign -o OBJ:rsProcess          RSSRVRSRC:rsProcess.dbl
dbl -d -qstrict -qalign -o OBJ:rsProcessFileName  RSSRVRSRC:rsProcessFileName.dbl
dbl -d -qstrict -qalign -o OBJ:rsClient           RSCLNTSRC:rsClient.dbl

rem SynPSG.Core
dbl -d -qstrict -qalign -o OBJ:dbl2dibol       CORUTLSRC:dbl2dibol.dbl
dbl -d -qstrict -qalign -o OBJ:endOfToken      CORUTLSRC:endOfToken.dbl
dbl -d -qstrict -qalign -o OBJ:logging         CORUTLSRC:logging.dbl
dbl -d -qstrict -qalign -o OBJ:stringCase      CORUTLSRC:stringCase.dbl
dbl -d -qstrict -qalign -o OBJ:stringReplace   CORUTLSRC:stringReplace.dbl
dbl -d -qstrict -qalign -o OBJ:pipe            CORUTLSRC:pipe.dbc

rem SynPSG.System.Net
dbl -d -qstrict -qalign -o OBJ:dns             SYSNETSRC:dns.dbc
dbl -d -qstrict -qalign -o OBJ:IPEndPoint      SYSNETSRC:IPEndPoint.dbc
dbl -d -qstrict -qalign -o OBJ:IPHostEntry     SYSNETSRC:IPHostEntry.dbc
dbl -d -qstrict -qalign -o OBJ:NetWorkStream   SYSNETSRC:NetWorkStream.dbc
dbl -d -qstrict -qalign -o OBJ:Socket          SYSNETSRC:Socket.dbc
dbl -d -qstrict -qalign -o OBJ:SocketException SYSNETSRC:SocketException.dbc
dbl -d -qstrict -qalign -o OBJ:TcpClient       SYSNETSRC:TcpClient.dbc
dbl -d -qstrict -qalign -o OBJ:TcpListener     SYSNETSRC:TcpListener.dbc

rem build client
dblink -d -o REMOTESERVEREXE:rsClient OBJ:rsClient OBJ:rsProcessFileName OBJ:dns OBJ:IPEndPoint OBJ:IPHostEntry OBJ:logging OBJ:NetWorkStream OBJ:Socket OBJ:SocketException OBJ:stringCase OBJ:TcpClient OBJ:TCPListener

rem build server components
dblink -d -o REMOTESERVEREXE:rsProcess OBJ:rsProcess OBJ:rsProcessFileName OBJ:dbl2dibol OBJ:endOfToken OBJ:IPEndPoint OBJ:logging OBJ:NetWorkStream OBJ:pipe OBJ:Socket OBJ:SocketException OBJ:stringCase OBJ:stringReplace OBJ:TcpClient OBJ:TCPListener
dblink -d -o REMOTESERVEREXE:RemoteServer OBJ:RemoteServer OBJ:rsProcessFileName OBJ:IPEndPoint OBJ:logging OBJ:NetWorkStream OBJ:Socket OBJ:SocketException OBJ:stringCase OBJ:TcpClient OBJ:TCPListener

