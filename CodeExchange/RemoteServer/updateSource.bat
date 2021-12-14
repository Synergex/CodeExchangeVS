rem updateSource.bat
set DEVROOTNODE=C:\Development

set DEVROOT=%DEVROOTNODE%\SynPSG\CodeExchange\RemoteServer

set UTLRMTSRC=%DEVROOTNODE%\SynPSG\Utilities\RemoteServer
set CORUTLSRC=%DEVROOTNODE%\SynPSG\Core\src\Utilities
set SYSNETSRC=%DEVROOTNODE%\SynPSG\System\src\Net

rem local files
rem %DEVROOT%\build.bat
rem %DEVROOT%\build.script
rem %DEVROOT%\build.vms_com
rem %DEVROOT%\updateSource.bat
rem %DEVROOT%\RemoteServer_readme.txt

rem SynPSG.Utilities.RemoteServer
copy %UTLRMTSRC%\RemoteServerProtocol.txt     %DEVROOT%\RemoteServerProtocol.txt
copy %UTLRMTSRC%\start_remote_server.vms_com  %DEVROOT%\start_remote_server.vms_com
copy %UTLRMTSRC%\remoteserver.vms_com         %DEVROOT%\remoteserver.vms_com

rem RemoteBuild client components
copy %UTLRMTSRC%\RemoteServer.e           %DEVROOT%\Client\RemoteServer.e
copy %UTLRMTSRC%\RemoteServerForms.sh     %DEVROOT%\Client\RemoteServerForms.sh
copy %UTLRMTSRC%\rsClient.dbl             %DEVROOT%\Client\rsClient.dbl

rem RemoteBuild server components
copy %UTLRMTSRC%\RemoteServer.def         %DEVROOT%\Server\RemoteServer.def
copy %UTLRMTSRC%\RemoteServer.inc         %DEVROOT%\Server\RemoteServer.inc
copy %UTLRMTSRC%\RemoteServer.dbl         %DEVROOT%\Server\RemoteServer.dbl
copy %UTLRMTSRC%\rsProcess.dbl            %DEVROOT%\Server\rsProcess.dbl
copy %UTLRMTSRC%\rsProcessFileName.dbl    %DEVROOT%\Server\rsProcessFileName.dbl

rem SynPSG.Core.Utilities
copy %CORUTLSRC%\dbl2dibol.dbl       %DEVROOT%\Server\dbl2dibol.dbl
copy %CORUTLSRC%\endOfToken.dbl      %DEVROOT%\Server\endOfToken.dbl
copy %CORUTLSRC%\logging.dbl         %DEVROOT%\Server\logging.dbl
copy %CORUTLSRC%\stringCase.dbl      %DEVROOT%\Server\stringCase.dbl
copy %CORUTLSRC%\stringReplace.dbl   %DEVROOT%\Server\stringReplace.dbl
copy %CORUTLSRC%\pipe.dbc            %DEVROOT%\Server\pipe.dbc

rem SynPSG.System.Net
copy %SYSNETSRC%\dns.dbc             %DEVROOT%\Server\dns.dbc
copy %SYSNETSRC%\IPEndPoint.dbc      %DEVROOT%\Server\IPEndPoint.dbc
copy %SYSNETSRC%\IPHostEntry.dbc     %DEVROOT%\Server\IPHostEntry.dbc
copy %SYSNETSRC%\NetWorkStream.dbc   %DEVROOT%\Server\NetWorkStream.dbc
copy %SYSNETSRC%\Socket.dbc          %DEVROOT%\Server\Socket.dbc
copy %SYSNETSRC%\SocketException.dbc %DEVROOT%\Server\SocketException.dbc
copy %SYSNETSRC%\TcpClient.dbc       %DEVROOT%\Server\TcpClient.dbc
copy %SYSNETSRC%\TcpListener.dbc     %DEVROOT%\Server\TcpListener.dbc

