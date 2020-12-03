::Author    : Shen Xiaolong((xlshen@126.com))
::Copyright : free use,modify,spread, but MUST include this original two line information(Author and Copyright).

@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
cls
echo %0 %*
set browerMode=1
call :parseFtpUrl "%~1"
call :setOutputFolder %*
call :setRecordFilePath %*

:: the url might include xml escape characters % , it will be skipped in any batch subfunction and variable.
:: here is a wordaround as using it main flow.
if not exist "%reOpenFtpPath%" (
(
echo %date%  %time%
echo download from ftp server :
echo %*
) > "%ftpUrl%"
)

if not exist "%reOpenFtpPath%" echo %0 %* > "%reOpenFtpPath%"
call :openFtpUrl
start "" "%outputFolder%"
goto :End

::******************************DOS API section**************************************************************************
:parseFtpUrl
:: "%ftpClientFolder%\filezilla.exe" "ftp://support:support@cmbu-ftp.cisco.com:21/BEMS01156102/"
set "_tmpLine=%~1"
set "_ftpUserName=%_tmpLine:@=" & set "dump=%"
set _ftpUserName=%_ftpUserName:~6%
if defined _ftpUserName call :setCred.%_ftpUserName%

set _ftpIP=%_tmpLine:*@=%
set _ftpPath=%_ftpIP:*/=%
set "_ftpIP=%_ftpIP:/=" & set "dump=%"

call :fetchDir "%_ftpPath%"
goto :eof

:setCred.support
call :setCred.checkPwdDefine ftp_pwd_support
set "_cred=support:%ftp_pwd_support%@"
goto :eof

:setCred.cmbu
:: escape specified chars
:: https://03k.org/ftp-special-password.html
:: set _cred=cmbu:"Cisco123!@#"@
call :setCred.checkPwdDefine ftp_pwd_cmbu
set "_cred=cmbu:%ftp_pwd_cmbu%@"
goto :eof

:setCred.checkPwdDefine
if not defined %~1 call :errorMsg "No environment '%~1' is defined, it is needed by FTP user login."
goto :eof

:fetchDir
set "_ftpFile=%~1"
set pathID=%~n1
if {"%~x1"}=={""} set "_ftpFile=" & goto :eof
set "_tmpName=%~nx1"
set "_ftpPath=%~1"
call set _ftpPath=%%_ftpPath:/%_tmpName%=%%
:: set _ftpPath=%_ftpPath:\=/%
goto :eof

:setOutputFolder
set "outputFolder=%temp%\Ftp_Download\%_ftpPath:/=\%"
if not exist "%outputFolder%\" md "%outputFolder%"
goto :eof

:setRecordFilePath
set ftpUrl=%outputFolder%\ftpUrl_%pathID%.txt
set reOpenFtpPath=%outputFolder%\reOpenFtpPath_%pathID%.bat
goto :eof

:openFtpUrl
if      defined _ftpFile if not defined browerMode call :openFtpUrl.file
if      defined _ftpFile if     defined browerMode call :openFtpUrl.Foler
if not  defined _ftpFile call :openFtpUrl.Foler
goto :eof

:openFtpUrl.file
echo ftp host IP   : %_ftpIP%
echo ftp user name : %_ftpUserName%
echo ftp file path : %_ftpFile%
echo.
call :buit-inFtp.downloadFile
start "" "%outputFolder%"
goto :eof

:openFtpUrl.Foler
echo ftp host IP     : %_ftpIP%
echo ftp user name   : %_ftpUserName%
echo ftp folder path : %_ftpPath%
echo.
call :filezilla.openFolder
goto :eof

:filezilla.openFolder
:: https://wiki.filezilla-project.org/Command-line_arguments_(Client)
if 		defined _cred call :filezilla.openFolder.impl "ftp://%_cred%%_ftpIP%/%_ftpPath%" --local="%outputFolder%"
if not 	defined _cred call :filezilla.openFolder.impl "ftp://%_ftpIP%/%_ftpPath%" --local="%outputFolder%" --logontype=ask
goto :eof

:filezilla.openFolder.impl
where tools_path.bat 1>nul 2>nul || set "path=%~dp0..;%path%"
call tools_path.bat :FindAppPathinDisk "filezilla.exe" ftpClientFolder 
if not defined ftpClientFolder call :errorMsg "can't find filezilla.exe path, please defined filezilla.exe folder variable : ftpClientFolder"
echo.
echo start "" "%ftpClientFolder%\filezilla.exe" %*
start "" "%ftpClientFolder%\filezilla.exe" %*
echo.
goto :eof

:buit-inFtp.downloadFile.example
call :buit-inFtp.downloadFile.genFtpScript  ftpScript
ftp
open cmbu-ftp.cisco.com
user cmbu %ftp_pwd_cmbu%
cd  /FTPServer/users/xiaolosh/temp
lcd D:\Local_Temp
get myFile.zip
quit
goto :eof

:buit-inFtp.downloadFile
call :buit-inFtp.downloadFile.genFtpScript  ftpScript
type "%ftpScript%"
echo call ftp.exe -n -s:"%ftpScript%"
goto :eof

:buit-inFtp.downloadFile.genFtpScript
if not defined ftp_pwd_%_ftpUserName%  call :errorMsg "ftp user '%_ftpUserName%' password is not defined!  please defined environment 'ftp_pwd_%_ftpUserName%'."
set "_tmpFtpFile=%temp%\ftp_%random%.ftp"
(
echo open %_ftpIP%
echo user %_ftpUserName%
@if {"%_ftpUserName%"}=={"support"} echo %ftp_pwd_support%
@if {"%_ftpUserName%"}=={"cmbu"}    echo %ftp_pwd_cmbu%
echo lcd /d "%outputFolder%"
echo get %_ftpFile%
echo disconnect
echo quit
) > "%_tmpFtpFile%"
set "%~1=%_tmpFtpFile%"
goto :eof

:errorMsg
echo.
echo %*
echo.
pause 
goto :End
goto :eof

::*******************************************************************************************************************

:End