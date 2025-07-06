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

::[DOS_API:Help]display help information
:Help
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call %~dp0.\tools_miscellaneous.bat DisplayHelp "%~f0"
goto :eof

::[DOS_API:Test]Test DOS API in this script file
:Test
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
@echo [%~nx0] Run test case [%0 %*]

echo.
echo current user Active Directory info :
call :showActiveDirectory
echo.

echo.
echo current user Domain controller :
call :showUserDC
echo.

echo.
echo current DNS Domain controller:
call :showDnsDC
echo.

echo.
echo [skip]all DCs in current user domain:
echo call :showCurUserDCList
echo.

echo.
echo all DC name in current user DNS domain:
call :showCurDnsDcName
echo.

echo.
echo [skip]current dns record of _kerberos._tcp
echo call :showSRVRecord _kerberos._tcp
echo.

goto :eof

::[DOS_API:showActiveDirectory]show current user's Active Directory info , e.g. CN , OU , DC ,site name
::call e.g  : call :showActiveDirectory
:showActiveDirectory
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
echo [cmdline] gpresult /r
gpresult /r
goto :eof

::[DOS_API:showDomainDC]show which Domain controller of specified domain
::call e.g  : call :showDomainDC
:showDomainDC
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkEmptyParam %* "%~f0" "showDomainDCMark1"
echo [cmdline] nltest /dsgetdc:%~1
nltest /dsgetdc:%~1
goto :eof

::[DOS_API:showUserDC]show which Domain controller I'm authenticated to
::call e.g  : call :showUserDC
:showUserDC
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
rem dc is also stored in %LOGONSERVER%
call :showDomainDC %USERDOMAIN%
goto :eof

::[DOS_API:showDnsDC]show which Domain controller I'm authenticated to
::call e.g  : call :showDnsDC
:showDnsDC
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :showDomainDC %userdnsdomain%
goto :eof

::[DOS_API:showDCList]show all DCs in specified domain
::call e.g  : call :showDCList
:showDCList
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkEmptyParam %* "%~f0" "showDomainDCListMark1"
echo [cmdline] nltest /dclist:%~1
nltest /dclist:%~1
goto :eof

::[DOS_API:showCurUserDCList]show all DCs in current user domain
::call e.g  : call :showCurUserDCList
:showCurUserDCList
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :showDCList %USERDOMAIN%
goto :eof

::[DOS_API:showDcName]show all DC name in specified domain
::call e.g  : call :showDcName "%userdnsdomain%"
:showDcName
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkEmptyParam %* "%~f0" "showDcNameMark1"
echo [cmdline] nslookup -type=any %~1
nslookup -type=any %~1
goto :eof

::[DOS_API:showCurDnsDcName]show all DC name in current user DNS domain
::call e.g  : call :showCurDnsDcName
:showCurDnsDcName
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call :showDcName %userdnsdomain%
goto :eof

::[DOS_API:showSRVRecord] using dns to check for SRV records (e.g. _kerberos._tcp, _kpasswd._tcp, _LDAP._TCP.dc._msdcs, and _ldap._tcp).
::call e.g  : call :showSRVRecord
:showSRVRecord
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkEmptyParam %*
call :dnsService.SRVRecord.query %~1
goto :eof

:dnsService.SRVRecord.query
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
call tools_error.bat checkSupportedCmd "%~1" ";_kerberos._tcp;_kerberos._udp;_kpasswd._tcp;_kpasswd._udp;_ldap._tcp;_ldap._tcp.dc._msdcs;_ldap._tcp.pdc._msdcs;" "%~f0" "SRVRecord.query.Mark"
echo [cmdline] nslookup -type=SRV %~1.%userdnsdomain%
nslookup -type=SRV %~1.%userdnsdomain%
goto :eof

:dnsService.listType
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
:: https://network-tools.com/nslook/
echo 1      - A         # Address
echo 2      - NS        # Name server
echo 5      - CNAME     # Canonical name
echo 6      - SOA       # Start of authority
echo 7      - MB        # Mailbox domain
echo 8      - MG        # Mail group member
echo 9      - MR        # Mail rename domain
echo 10     - NULL      # Raw data record
echo 11     - WKS       # Well-known services
echo 12     - PTR       # Domain pointer
echo 13     - HINFO     # Host info
echo 14     - MINFO     # Mailing list info
echo 15     - MX        # Mail exchange
echo 16     - TXT       # Text strings
echo 17     - RP        # Responsible person
echo 18     - AFSDB     # AFS database
echo 19     - X25       # X25 PSDN address
echo 20     - ISDN      # ISDN address
echo 21     - RT        # Route through
echo 22     - NSAP      # NSAP address
echo 23     - NSAP      # PTR - NSAP-style pointer
echo 24     - SIG       # Security signature
echo 25     - KEY       # Security key
echo 26     - PX        # X.400 mail mapping info
echo 28     - AAAA      # IPv6 address
echo 29     - LOC       # Location
echo 30     - NXT       # Next domain
echo 33     - SRV       # Location of services
echo 35     - NAPTR     # Naming authority pointer
echo 36     - KX        # Key exchange delegation
echo 100    - UINFO     # User info
echo 101    - UID       # User ID
echo 102    - GID       # Group ID
echo 253    - MAILB     # Mailbox-related records
echo 255    - ANY       # Any type
goto :eof

:dnsService.SRVRecord.hostList
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [      %~nx0] commandLine: %0 %*
echo kerberos
echo _kerberos._tcp.%userdnsdomain%
echo _kerberos._udp.%userdnsdomain%
echo.
echo _kpasswd._tcp.%userdnsdomain%
echo _kpasswd._udp.%userdnsdomain%
echo.
echo _ldap._tcp.%userdnsdomain%
echo _ldap._tcp.dc._msdcs.%userdnsdomain%
echo _ldap._tcp.pdc._msdcs.%userdnsdomain%
goto :eof

:End
@if defined _Stack @for %%a in ( 1 "%~nx0" "%0" ) do @if {"%%~a"}=={"%_Stack%"} @echo [----- %~nx0] commandLine: %0 %* & @echo.