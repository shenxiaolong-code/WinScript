@if {"%_Echo%"}=={"1"} ( @echo on ) else ( @echo off )
::rem 启用/禁用计算机休眠功能，可以节省hiberfil.sys所占用的磁盘空间(10G左右)
if {%~1}=={1} (
set param=on
echo enable pc power sleep feature, hiberfil.sys will be generated
) else (
set param=off
echo disable pc power sleep feature, No hiberfil.sys
)

powercfg -h %param%