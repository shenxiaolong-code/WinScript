
:: get string (e.g. url, filePath) has md5 code , to avoid repeat thing
:: usage example : .\getHashMd5Code.bat  bbb "C:\work\OneDrive\work_skills\svnRepo\shenxiaolong\core\WinScript\common\getHashMd5Code.bat"
::                 set bbb=a9fe80d9a6fd07b79269df5c1e3e7128

:: python version
:: python -c "import hashlib; h = hashlib.md5(); h.update(""%WORK_DIR%"".encode(""utf-8"")); print(h.hexdigest()[0:8])" > dir.name || goto :ERROR
:: set /p build_suffix=<dir.name || goto :ERROR
:: set "SHORT_BUILD_DIR=%BUILD_ROOT_DIR%\jnk-%build_suffix%" || goto :ERROR

:: on Linux:
:: echo "to generate md5 string" | md5sum 
:: set mdStr=`"to generate md5 string" | md5sum | cut -d"-" -f1 -`

:: C:\Program Files\Git\usr\bin\md5sum.exe
@for /f "usebackq tokens=1" %%a in ( ` echo "%~2" ^| md5sum ` ) do echo set %~1=%%~a
