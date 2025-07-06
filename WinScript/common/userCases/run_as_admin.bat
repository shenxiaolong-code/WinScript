
@echo off
where "tools_error.bat" 1>nul 2>nul || set "path=%~dp0..;%path%"
call tools_error.bat :checkAdmin "%~f0"