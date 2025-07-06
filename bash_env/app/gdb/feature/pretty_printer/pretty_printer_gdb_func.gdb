# bash_script_i

define pstr
   echo string $arg0 value:
   # print (char*)$arg0._M_dataplus._M_p
   p $arg0->_M_stringbuf.str()
   # x/s $arg0._M_dataplus._M_p
end

document pstr
	Prints std::wstring string information.
	Syntax: pstr <wstring>
	Example:
	pstr stringVarName
	path : ${BASH_DIR}/app/gdb/feature/pretty_printer/pretty_printer_gdb_func.gdb
end 

define pstruct
   echo ${BASH_DIR}/app/gdb/feature/pretty_printer/pretty_printer_gdb_func.gdb:19\r\n
   echo cask6::StructureType $arg0 value: p $arg0->impl_->member_name_map_\r\n
   # print (char*)$arg0._M_dataplus._M_p
   p $arg0->impl_->member_name_map_
   # x/s $arg0._M_dataplus._M_p
end

document pstruct
	Prints cask6::StructureType type.
	Syntax: pstruct pObj
	Example:
	pstruct this
	path : ${BASH_DIR}/app/gdb/feature/pretty_printer/pretty_printer_gdb_func.gdb
end 

echo \r\n--------- leaving ${BASH_DIR}/app/gdb/feature/pretty_printer/pretty_printer_gdb_func.gdb ...\r\n 