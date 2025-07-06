# bash_script_i

skip -rfu .*::availableRunners
skip -rfu  .*::NotNull
skip -rfu  .*::front
skip -rfu  .*::operator->
skip -rfu  .*::sync_host
skip -rfu  .*::extent
skip -rfu  .*::stride
skip -rfu  .*::Span
skip -rfu  cask::MakeSpan.*
skip -rfu  .*::rank
skip -rfu  .*::SafeEnum
skip -rfu  .*::Reference
skip -rfu  .*::~Reference
skip -rfu  .*::ConstReference
skip -rfu  .*::~ConstReference
skip -rfu  .*::Context::configData
skip -rfu  .*::StringView::.*
skip -rfu  .*::SymmProblemSize::.*
skip -rfu  .*::get

skip -rfu  .*::StringView::.*

skip function xmma_jit_PReMeRGe::cpp::Var::member
skip function xmma_jit_PReMeRGe::cpp::member_of
skip function cask::tester::TestCase::operation_launch
skip function cask::ConstReference::ConstReference
skip function cask::Reference::Reference
skip function cask::KernelEntry::getKernelPtr
skip function cask::Dim3::Dim3
skip function cask::ConstReference::~ConstReference
skip function cask::tester::TestCase::ref_operation_launch
skip function cask::tester::TestCase::operation_launch
skip function cask::LayoutAttributes::LayoutAttributes
skip function cask6::OperationComputeTargets::OperationComputeTargets
skip function cask6::cutlass3x::MmaTileKernelName::MmaTileKernelName
skip function cask6::ArgumentsView::ArgumentsView

skip function cask6::OperationFactory::provider
skip function cask6::Provider::kernels
skip function cask6::KernelFactory::kernelClass
skip function .*::Dim3::Dim3
skip function .*::LaunchConfiguration::LaunchConfiguration

skip -rfu  cask::LaunchSchedule::.*
skip -rfu  cask::ApiCallbackControl::.*

# ver 9.2 support
skip file       platform.hpp
skip file       api_callback_dispatch.hpp
skip file       testcase.hpp


define filter
    source ${BASH_DIR}/app/gdb/feature/skip_filter/loadFilter_nvidia.gdb
end

document filter
	reload the gdb alias script : source ${BASH_DIR}/app/gdb/feature/skip_filter/loadFilter_nvidia.gdb
end 

# bash_script_o
