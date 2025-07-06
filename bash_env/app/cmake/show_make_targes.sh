

# add_custom_target
# e.g. add_custom_target(run_custom_commands ... )
dumpinfo "search add_custom_target in CMakeLists.txt or .cmake file to get all targets"

tmp_log_path=${EXT_DIR}/tmp/to_del/make_target_${RANDOM}

# make -qp -C ./build | grep -v "^#" | grep -B 1 '$(MAKE)'  >| ${tmp_log_path}
make -qp -C ./build > ${tmp_log_path}_raw.log

grep -niRH -v "^#" ${tmp_log_path}_raw.log | grep -B 1 '$(MAKE)' | sed 's/:/  /2'  | sed 's#$(MAKE) $(MAKESILENT) -f #make ./build -f ./build/#g'  >| ${tmp_log_path}.log

# 

echo  ${tmp_log_path}.log
echo 'make ./build -f <targe_path>'