@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )

for  %%i in ( T ) do if not exist %%i: (
@echo Create virtual disk %%i: =^> \\127.0.0.1\c$\temp
net use %%i: \\127.0.0.1\c$\temp 1>nul && @echo OK
) else (
echo virtual disk %%i: exists.
)