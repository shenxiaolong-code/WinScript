# bash_env
A Bash scripting support library for Linux.

# Purpose
- Simplifies repetitive daily tasks in the Linux bash environment.
- Encapsulates commonly used command combinations.
- Provides reusable, modular Bash functions with input/output parameters for better code reuse and maintainability.
- Can be automatically invoked via ~/.bashrc or ~/.profile; see setup.sh for details.

## Linux GDB Enhanced Scripts

This suite delivers Windows-comparable debugging enhancements via native GDB+Bash:

- **Editor seamless integration**: Automatically opens corresponding source lines in VS Code or any editor during GDB debugging sessions.  
- **Cross-machine source linkage**: Debugging on Machine A automatically triggers source file opening on Machine B for remote development scenarios.  
- **Ultra-low latency operations**: Core actions (e.g., single-stepping) outperform VS Code's built-in debugger with <50ms response time (validated in benchmarks).  
- **Lightweight implementation**: 90% pure Bash with optional Python helpers (no Py dependency for core functionality).  

