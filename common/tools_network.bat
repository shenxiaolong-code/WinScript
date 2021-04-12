::Author    : Shen Xiaolong((xlshen@126.com))
::Copyright : free use,modify,spread, but MUST include this original two line information(Author and Copyright).

::@set _Echo=1
::set _Stack=%~nx0
@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo. & @echo [+++++ %~nx0] commandLine: %0 %*
where "%~nx0" 1>nul 2>nul || set "path=%~dp0;%path%"

if {%1}=={} call :Test  & goto End
::if {%1}=={} call :Test NoOutput & goto End

call :%1 %2 %3 %4 %5 %6 %7 %8 %9
goto End

::******************************DOS API section**************************************************************************

::[DOS_API:download]download a file from one url
::call e.g  : call :download  'http://shanghai-nfs.cisco.com/builds/Trunk/BUILD_TRUNK_JABBERWIN-RELEASE/12667/archive/CiscoJabberSetup.msi' 'D:\CiscoJabberSetup.msi'"
:download
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if {"%~2"}=={""} (
call colorTxt.bat 0c "parameter is not enough. usage example:"
echo.
call colorTxt.bat 0b "call %~f0 download 'http://shanghai-nfs.cisco.com/builds/Trunk/BUILD_TRUNK_JABBERWIN-RELEASE/12667/archive/CiscoJabberSetup.msi' 'D:\CiscoJabberSetup.msi'"
echo.
call tools_txtFile.bat ShowCurLineNo "%~f0" mark97
pause
goto :End
)
set "_targetUrl=%~1"
set "_targetPath=%~2"
if not defined downloader set downloader=curl
call :download.%downloader% "%_targetUrl%" "%_targetPath%"
goto :eof

::[DOS_API:showDNS]show current DNS information in specified interface card
::                 call :showDNS  [option] 
::call e.g       : call :showDNS
::               : call :showDNS  "Ethernet"
:showDNS
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
if not  {"%~1"}=={""}   netsh interface ip show config "%~1"
if      {"%~1"}=={""}   netsh interface ip show config
:: ipconfig /displaydns
:: nslookup
goto :eof

::[DOS_API:queryFirewallRule] query alll firewall rule list if you forget it. e.g. when name when using disablePing
::                 call :queryFirewallRule
::call e.g       : call :queryFirewallRule
:queryFirewallRule
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
netsh advfirewall firewall show rule name=all
:: ipconfig /displaydns
:: nslookup
goto :eof

::[DOS_API:enablePing] create the ICMPv4 and ICMPv6 exception to allow ping service
::                 call :enablePing
::call e.g       : call :enablePing
:enablePing
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol=icmpv4:8,any dir=in action=allow
netsh advfirewall firewall add rule name="ICMP Allow incoming V6 echo request" protocol=icmpv6:8,any dir=in action=allow
:: ipconfig /displaydns
:: nslookup
goto :eof

::[DOS_API:disablePing] close the ICMPv4 and ICMPv6 exception to disable ping service
::                 call :disablePing
::call e.g       : call :disablePing
:disablePing
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol=icmpv4:8,any dir=in action=block
netsh advfirewall firewall add rule name="ICMP Allow incoming V6 echo request" protocol=icmpv6:8,any dir=in action=block
:: ipconfig /displaydns
:: nslookup
goto :eof

::[DOS_API:pingIP] close the ICMPv4 and ICMPv6 exception to disable ping service
::                 call :pingIP <IP>  <result>
::call e.g       : call :pingIP 10.79.100.79   bRet
:pingIP
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set %~2=
for /f "usebackq" %%i in ( ` ping %~1 -n 1 ^| find /c /i "Reply from" ` ) do set %~2=%%i
:: ipconfig /displaydns
:: nslookup
if defined _Debug call echo %~2=%%%~2%%
goto :eof

::[DOS_API:setDns]set DNS on specified interface card
::                 call :setDns interfaceName primaryDns [Opt_secondDns]
::call e.g       : call :setDns  "Ethernet" 64.104.14.184
::               : call :setDns  "Ethernet" 64.104.14.184  64.104.123.245
:setDns
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat 2 checkParamCount %*
call :deleteDNS
netsh int ipv4 set dns name="%~1" static %~2 primary validate=no
if not {"%~3"}=={""} netsh int ipv4 add dns name="%~1" %~3 index=2
ipconfig /flushdns
goto :eof

::[DOS_API:deleteDNS]delete DNS on specified interface card
::                 call :deleteDNS interfaceName [opt_dnsIp]
::call e.g       : call :deleteDNS  "Ethernet"
::               : call :deleteDNS  "Ethernet" 64.104.14.184
:deleteDNS
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
set "_tmpDNSIP=%~2"
if not defined _tmpDNSIP set _tmpDNSIP=all
netsh	interface	ipv4	delete  dnsserver "%~1" %_tmpDNSIP%
:: netsh interface ipv4 delete dns "Ethernet" 64.104.14.184
goto :eof

::[DOS_API:listNetworkCard]list al network interface and status in current PC
::                 call :listNetworkCard
:listNetworkCard
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
netsh interface show interface
goto :eof

::[DOS_API:setStaticIp]set static IP on specified interface card
::                 call :setStaticIp interfaceName ipaddr subnetmask gateway [opt_metric]
::call e.g       : call :setStaticIp  "Ethernet"    123.123.123.123    255.255.255.0     123.123.123.1    1
:setStaticIp
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
netsh interface ip set address name="%~1" %~2 %~3 %~4 %~5
goto :eof

::[DOS_API:setDynamicIp]set dynamic IP on specified interface card -- enable dhcp
::                 call :setDynamicIp interfaceName
::call e.g       : call :setDynamicIp  "Ethernet"
:setDynamicIp
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
netsh interface ip set address name="%~1" dhcp
goto :eof


::******************************inner implement  section**************************************************************************

:download.bitsadmin
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
::using bitsadmin.exe
::bitsadmin.exe is standard Windows component which is included XP and  2000 SP3 later, support many option, e.g. proxy
::if not defined optParam set optParam=/download  /priority normal
echo download command:
echo bitsadmin.exe /transfer "%~nx2" %optParam% "%~1" "%~2"
bitsadmin.exe /transfer "%~nx2" %optParam% "%~1" "%~2"
goto :eof

:download.powershell
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
::using powershell , powershell is very fast to download url but but without download rate and process
echo download command:
echo powershell -command "& { (New-Object Net.WebClient).DownloadFile('%~1', '%~2') }"
powershell -command "& { (New-Object Net.WebClient).DownloadFile('%~1', '%~2') }"
goto :eof

:download.curl
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
::using curl , curl is very fast to download url without download rate and process
echo download command:
echo curl "%~1" -o "%~2"
curl "%~1" -o "%~2"
goto :eof

::******************************help  and test  section**************************************************************

::[DOS_API:Help]display help information
:Help
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_miscellaneous.bat DisplayHelp "%~f0"
goto :eof

::[DOS_API:Test]Test DOS API in this script file
:Test
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
@echo [%~nx0] Run test case [%0 %*]
echo.
echo test call :Help
call :Help

echo.
echo download with default downloader : powershell
set target_url=http://shanghai-nfs.cisco.com/archive/12.0/FCS/260976/280/JabberWin/CiscoJabberSetup.msi
set target_path=D:\CiscoJabberSetup.msi
if exist "%target_path%" del /f/q "%target_path%"
echo test call :download "%target_url%" "%target_path%"
call :download "%target_url%" "%target_path%"
if not exist "%target_path%" (
call :colorTxt.bat 0c "test case[%~f0:%~0] fails."
echo.
) else (
echo test download sucessfully.
)
del /f/q "%target_path%"

echo.
echo download with downloader : bitsadmin
set downloader=bitsadmin
echo test call :download "%target_url%" "%target_path%"
call :download "%target_url%" "%target_path%"
if not exist "%target_path%" (
call :colorTxt.bat 0c "test case[%~f0:%~0] fails."
echo.
) else (
echo test download sucessfully.
)
del /f/q "%target_path%"


echo.
echo show all network cards and status.
call :listNetworkCard

echo.
echo show current dns
call :showDNS

echo.
goto :eof

::*******************************************************************************************************************

:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.