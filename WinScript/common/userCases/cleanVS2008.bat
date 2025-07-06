@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
@cls 
@title ******清除VS2008中最近的项目****** 
::@color 2e 
@echo ★ 清除VS打开记录！★ 
@REG Delete HKCU\Software\Microsoft\VisualStudio\9.0\FileMRUList /va /f 
@REG Delete HKCU\Software\Microsoft\VisualStudio\9.0\ProjectMRUList /va /f 
@echo on 
@echo vs2005为8.0(版本号)，vs03为7.1,vs2008为9.0