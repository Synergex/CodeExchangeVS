rem rbCopy.bat
set DEVROOTNODE=C:\Development

set DEVROOT=%DEVROOTNODE%\SynPSG\CodeExchange\creditCard

set CORUTLSRC=%DEVROOTNODE%\SynPSG\Core\src\Utilities

rem local files
rem %DEVROOT%\build.bat
rem %DEVROOT%\cctest_readme.txt
rem %DEVROOT%\cctest.dbl
rem %DEVROOT%\ccrec.inc

rem SynPSG.Core.Utilities
copy %CORUTLSRC%\CCutils.dbc         %DEVROOT%\CCutils.dbc
copy %CORUTLSRC%\Encryption.dbc      %DEVROOT%\Encryption.dbc

