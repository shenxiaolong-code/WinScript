

define run_cmd_by_python
  python gdb.execute("echo 'cmd from comes from python'")
end


run_cmd_by_python