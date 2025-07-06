# WinScript
windows batch script programming support lib, used in my automatization tools/jobs.

# purpose
- This library is used in my regular work automatization:  
  right-click menu to run the general daily tasks.  
  One-clicking to collect all necessary information on our customer side without complex instructions.

- similar with many advanced programming languages  
  this library provides features by function with input/output parameters, it always is code-reused.  
  structure relation : module(s) -> function(s)/object(s) -> input parmeter(s) -> output parameter(s) + return code.    

## WinDbg Enhanced Scripts

This script suite significantly enhances WinDbg debugging experience for high-frequency failure analysis scenarios:

- **Right-click context menu integration**: One-click execution of complex debugging tasks without memorizing cumbersome commands.  
- **Scenario-specific analysis scripts**: Built-in specialized commands for typical scenarios including secondary exception stack loss, deadlocks, crashes, and memory leaks. Users can double-click commands or follow step-by-step prompts for rapid issue localization.  
- **Custom high-frequency command panel**: Integrates commonly used or hard-to-remember commands into a clickable panel, enabling double-click execution to maximize efficiency.  
- **Automatic debug configuration loading**: Dynamically loads application-specific debug configurations based on target binaries, enabling zero-switch cost through a unified entry point.  

> **Proven in Practice**: Efficiently processes 50+ daily production dump files in real-world environments, dramatically accelerating team troubleshooting and response speed.

# script summary 
1.   Self-documentation: generate module API documents automatically.
2.   Provide debugging support for a developer to locate the problem quickly for a developer.  
2.1  printing a function call stack.  
2.2  pause automatically when an error occurs.  
2.3  print the source file path, source line number, and error source code automatically in color text when an error occurs.
1.   usage examples to help unit test and improve usability.
2.   Easy to maintain and update, no redundant code.

# usage example  
  see <https://github.com/ShenXiaolong1976/WinScript/tree/master/common/userCases>
