
@echo off
set "src_template_path=%myWinScriptPath%\common\userCases\bat_script_template.bat"
if     {"%~1"}=={""} set "dst_bat_file=%cd%\temp.bat"
if not {"%~1"}=={""} set "dst_bat_file=%~dpn1.bat"

if not exist "%dst_bat_file%" copy %src_template_path%  %dst_bat_file% 1>nul && echo %dst_bat_file% is created.
call %myWinScriptPath%\common\tools_txtFile.bat openTxtFile %dst_bat_file%
