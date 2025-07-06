for /F "usebackq" %%i in ( ` powershell -Command "Get-Date -format yyyyMMdd_HHmmss" ` ) do set "newFolderName=%~1\%%i"
md "%newFolderName%"
start "" "%newFolderName%"
echo %newFolderName% | clip
