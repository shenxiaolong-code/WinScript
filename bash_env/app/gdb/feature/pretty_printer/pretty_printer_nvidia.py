
import inspect
import gdb.printing


print(f'+++++++++ loading \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
# print("+++++++++ loading ${BASH_DIR}/app/gdb/feature/pretty_printer/pretty_printer_nvidia.py ...")

class bcolors:
    PURPLE = '\033[95m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    END = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

class nv_GpcSkyline:
    """Print a cask6::GpcSkyline."""

    def __init__(self, val):
        self.val = val

    def to_string(self):
        # return self.val['_M_dataplus']['_M_p']        
        print(f'\033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
        valStr="cask6::GpcSkyline : {} - {} ".format( self.val['gpcs_'][0]['multiProcessorCount_'] , self.val['gpcs_'][3]['multiProcessorCount_'] )
        # print(valStr)
        # return self.val['gpcs_'][0]['multiProcessorCount_']
        # return self.val['size_']
        return valStr

    def display_hint(self):
        return 'cask6::GpcSkyline'

class nv_KernelLaunch:
    """Print a cask6::tester::KernelLaunch."""

    def __init__(self, val):
        self.val = val

    def to_string(self):
        # print('pretty-printer :${BASH_DIR}/app/gdb/feature/pretty_printer/pretty_printer_nvidia.py:41')
        # print( bcolors.GREEN + '${BASH_DIR}/app/gdb/feature/pretty_printer/pretty_printer_nvidia.py:60' + bcolors.END )
        print(f'\n\033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
        valStr="pr *({}*){} \nname_={} \nkernel_name_= {} \nis_ref_={}\nrun_info_->runtimeKernelName={}\ntensor_descs_={}\ntensors_={}\nxformed_tensor_buffs_={}...".format(
            str(self.val.type)  , self.val.address, self.val['name_'] , self.val['kernel_name_'] , self.val['is_ref_'] , 
            self.val['run_info_']['runtimeKernelName'] ,  str(self.val['tensor_descs_']), str(self.val['tensors_']) , str(self.val['xformed_tensor_buffs_']) )
        # print(valStr)
        # return self.val['gpcs_'][0]['multiProcessorCount_']
        # return self.val['size_']
        return valStr

    def display_hint(self):
        return 'cask6::tester::KernelLaunch'

class nv_TensorDesc:
    """Print a cask6::TensorDesc."""

    def __init__(self, val):
        self.val = val

    def to_string(self):        
        print(f'\033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
        valStr="[ pr *({}*){} ] dimensions={}  scalarType={} ".format( str(self.val.type)  , self.val.address, self.val['dimensions'] , self.val['scalarType']  )
        return valStr

    def display_hint(self):
        return 'cask6::TensorDesc'

class nv_Tensor:
    """Print a cask6::tester::Tensor."""

    def __init__(self, val):
        self.val = val

    def to_string(self):
        # return self.val['_M_dataplus']['_M_p']
        print(f'\033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
        valStr="[ pr *({}*){} ] fill_mode_={} ".format( str(self.val.type) , self.val.address, self.val['fill_mode_'] )
        # print(valStr)
        # return self.val['gpcs_'][0]['multiProcessorCount_']
        # return self.val['size_']
        return valStr

    def display_hint(self):
        return 'cask6::tester::Tensor'
        
class nv_FillMode:
    """Print a cask6::tester::FillMode."""

    def __init__(self, val):
        self.val = val

    def to_string(self):
        valStr="{} ".format( self.val['mode'] )
        return valStr

    def display_hint(self):
        return 'cask6::tester::FillMode'

class dim3:
    """Print a dim3."""

    def __init__(self, val):
        self.val = val

    def to_string(self):
        valStr="[{},{},{}] ".format( self.val['x'] , self.val['y'], self.val['x'] )
        return valStr

    def display_hint(self):
        return 'dim3'        

class nv_ScalarType:
    """Print a cask6::ScalarType."""

    def __init__(self, val):
        self.val = val

    def to_string(self):
        valStr="{} ".format( self.val['mValue'] )
        return valStr

    def display_hint(self):
        return 'cask6::ScalarType'

class nv_RingBufferArray:
    """Print a cask6::tester::RingBufferArray."""

    def __init__(self, val):
        self.val = val

    def to_string(self):
        valStr=self.val['ptr_']
        return valStr

    def display_hint(self):
        return 'cask6::tester::RingBufferArray'

class nv_StringView:
    """Print a cask6::StringView."""

    def __init__(self, val):
        self.val = val

    def to_string(self):
        # print(f'  \033[90m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
        # hide address : set print address off
        valStr="\033[91m{}\033[0m  {} ".format(self.val['start_'],f'\033[90m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
        # valStr=self.val['start_']
        return valStr

    def display_hint(self):
        return 'cask6::StringView'        

class nv_TensorDescription:
    """Print a cask6::tools::TensorDescription."""

    def __init__(self, val):
        self.val = val

    def to_string(self):
        valStr="{} {}".format(self.val['name'],self.val['extent'])
        return valStr

    def display_hint(self):
        return 'cask6::tools::TensorDescription'

class nv_StructureType:
    """Print a cask6::StructureType."""

    def __init__(self, val):
        self.val = val

    def to_string(self):
        print(f'\033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\r\n\033[91mp impl_->member_name_map_\033[0m')
        # p struct_ty->impl_->member_name_map_
        valStr=self.val['impl_']
        return valStr

    def display_hint(self):
        return 'cask6::StructureType'

class nv_StructureTypeImpl:
    """Print a cask6::StructureType::Impl."""

    def __init__(self, val):
        self.val = val

    def to_string(self):
        print(f'\033[91m{str(self.val.type)} : \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
        valStr=self.val['members_']#.dereference().val['member_name_map_']
        return valStr

    def display_hint(self):
        return 'cask6::StructureType::Impl'     

class nv_Reference:
    """cask6::Reference."""

    def __init__(self, val):
        self.val = val

    def to_string(self):
        print(f'\033[91m{str(self.val.type)} : \033[90m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
        valStr=self.val['type_']#.dereference().val['member_name_map_']
        return valStr

    def display_hint(self):
        return 'cask6::Reference'     

class nv_Type:
    """Print a cask6::Type."""

    def __init__(self, val):
        self.val = val

    def to_string(self):
        valStr="\033[91m{}\033[0m  {} ".format(self.val['start_'],f'\033[90m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')
        valStr=self.val['kind_'].string()
        return valStr

    def display_hint(self):
        return 'cask6::Type'

class nv_FunctionType:
    """Print a cask6::FunctionType."""

    def __init__(self, val):
        self.val = val

    def to_string(self):
        # valStr='{} {}'.format(self.val['argument_types_'],self.val['return_ty_.ptr_'])
        # return valStr
        return "cask6::FunctionType"

    def display_hint(self):
        return 'cask6::FunctionType'

class nv_ManagedString:
    """Print a cask6::ManagedString."""

    def __init__(self, val):
        self.val = val

    def to_string(self):
        valStr='{}'.format(self.val['view_'])
        return valStr

    def display_hint(self):
        return 'cask6::ManagedString'

class nv_DynamicShader:
    """Print a cask6::DynamicShader."""

    def __init__(self, val):
        self.val = val

    def to_string(self):
        valStr='{}'.format(self.val['name_'])
        return valStr

    def display_hint(self):
        return 'cask6::DynamicShader'     

def pretty_printer_nvidia_list(val):
#     if(str(val.type) == 'cask6::GpcSkyline'): return nv_GpcSkyline(val)
#    if(str(val.type) == 'cask6::tester::KernelLaunch'): return nv_KernelLaunch(val)
#    print(f'\033[92m{inspect.stack()[0][1]}\033[93m:{inspect.stack()[0][2]}\033[0m : {str(val.type)}')
    if(str(val.type) == 'cask6::TensorDescBase<36>'): return nv_TensorDesc(val)
    if(str(val.type) == 'cask6::TensorDescBase<8>'): return nv_TensorDesc(val)
    if(str(val.type) == 'cask6::TensorDesc'): return nv_TensorDesc(val)
    if(str(val.type) == 'cask6::tester::Tensor'): return nv_Tensor(val)
    if(str(val.type) == 'cask6::tester::FillMode'): return nv_FillMode(val)
    if(str(val.type) == 'cask6::ScalarType'): return nv_ScalarType(val)
    if(str(val.type) == 'cask6::DynamicShader'): return nv_DynamicShader(val)
    if(str(val.type) == 'cask6::tester::RingBufferArray'): return nv_RingBufferArray(val)
    if(str(val.type) == 'cask6::tester::StringView'): return nv_StringView(val)
    if(str(val.type) == 'cask6::StringView'): return nv_StringView(val)
    if(str(val.type) == 'cask6::tools::TensorDescription'): return nv_TensorDescription(val)
    # if(str(val.type) == 'cask6::StructureType'): return nv_StructureType(val)
    # if(str(val.type) == 'cask6::PimplBase<cask6::StructureType::Impl>'): return nv_StructureTypeBase(val)   
    if(str(val.type) == 'cask6::StructureType::Impl'): return nv_StructureTypeImpl(val)   
    if(str(val.type) == 'cask6::Reference'): return nv_Reference(val)
    if(str(val.type) == 'cask6::ConstReference'): return nv_Reference(val)
    if(str(val.type) == 'cask6::Type'): return nv_Type(val)
    if(str(val.type) == 'cask6::FunctionType'): return nv_Type(val)
    if(str(val.type) == 'cask6::NumericType'): return nv_Type(val)
    if(str(val.type) == 'cask6::FunctionType::Key'): return nv_FunctionType(val)
    if(str(val.type) == 'cask6::ManagedString'): return nv_ManagedString(val)

gdb.pretty_printers.append(pretty_printer_nvidia_list)

# print("--------- leaving ${BASH_DIR}/app/gdb/feature/pretty_printer/pretty_printer_nvidia.py ...")
print(f'--------- leaving \033[92m{inspect.stack()[0][1]}:{inspect.stack()[0][2]}\033[0m')

