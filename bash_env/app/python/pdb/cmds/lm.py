
import sys
print("{os.environ['HOME']}/bash_env/app/pdb/cmds/lm.py\n")

# reverse python dictionary
for modName in sys.modules:	
    print('{} : {}'.format(modName,sys.modules[modName]))
	

    

