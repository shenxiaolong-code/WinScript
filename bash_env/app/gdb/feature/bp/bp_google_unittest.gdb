
echo load ${BASH_DIR}/app/gdb/feature/bp/bp_google_unittest.gdb ... \r\n

if 1
    b TestBody
end

if 0
    # debug unit test
    # all ut
    b googletest/src/gtest.cc:2588    
end
