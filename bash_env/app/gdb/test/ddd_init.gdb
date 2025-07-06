! DO NOT ADD ANYTHING BELOW THIS LINE -- DDD WILL OVERWRITE IT
Ddd*dddinitVersion: 3.3.12

! Debugger settings.
Ddd*autoDebugger: on
Ddd*debugger: gdb
Ddd*useSourcePath: off
! Ddd*bashSettings: 
! Ddd*dbgSettings: 
! Ddd*dbxSettings: 
! Ddd*gdbSettings: \
! set print asm-demangle on\n
! Ddd*jdbSettings: 
! Ddd*perlSettings: 
! Ddd*pydbSettings: 
! Ddd*xdbSettings: 

! Source.
Ddd*findWordsOnly: on
Ddd*findCaseSensitive: off
! Ddd*tabWidth: 8
! Ddd*indentSource: 0
! Ddd*indentCode: 4
Ddd*cacheSourceFiles: on
Ddd*cacheMachineCode: on
Ddd*displayGlyphs: on
Ddd*displayLineNumbers: on
Ddd*disassemble: off
Ddd*allRegisters: off

! Undo Buffer.
! Ddd*maxUndoDepth: -1
! Ddd*maxUndoSize: 2000000

! Misc preferences.
Ddd*keyboardFocusPolicy: POINTER
Ddd*statusAtBottom: on
Ddd*suppressWarnings: off
Ddd*warnIfLocked: off
Ddd*checkGrabs: on
Ddd*saveHistoryOnExit: on
Ddd*paperSize: 210mm x 297mm
Ddd*blinkWhileBusy: on
Ddd*splashScreen: on
Ddd*startupTips: off

! Keys.
Ddd*globalTabCompletion: on
Ddd*cutCopyPasteBindings: Motif
Ddd*selectAllBindings: KDE

! Data.
Ddd*pannedGraphEditor: off
Ddd*graph_edit.showGrid: on
Ddd*graph_edit.snapToGrid: on
Ddd*graph_edit.showHints: on
Ddd*graph_edit.showAnnotations: on
Ddd*graph_edit.layoutMode: regular
Ddd*graph_edit.autoLayout: off
Ddd*showBaseDisplayTitles: on
Ddd*showDependentDisplayTitles: off
Ddd*autoCloseDataWindow: on
! Ddd*graph_edit.GridSize: 16
Ddd*detectAliases: on
Ddd*clusterDisplays: off
Ddd*displayPlacement: XmVERTICAL
Ddd*align2dArrays: on
Ddd*arrayOrientation: XmVERTICAL
Ddd*structOrientation: XmVERTICAL
Ddd*showMemberNames: on

! Themes.
Ddd*themes: \
! tinyvalues.vsl	\n\
! suppress.vsl	\n\
! smallvalues.vsl	\n\
! smalltitles.vsl	\n\
! red.vsl	\n\
! green.vsl	\n\
! 	green.vsl\n\
x86.vsl	$eax*;$ebx*;$ecx*;$edx*;($eflags &*\n\
rednil.vsl	*\n

! Tips.
Ddd*buttonTips: on
Ddd*valueTips: on
Ddd*buttonDocs: on
Ddd*valueDocs: on

! Helpers.
! Ddd*editCommand: ${XEDITOR-false} +@LINE@ @FILE@ || xterm -e ${EDITOR-vi} +@LINE@ @FILE@
! Ddd*getCoreCommand: gcore -o @FILE@ @PID@
! Ddd*psCommand: ps x 2> /dev/null || ps -ef 2> /dev/null || ps
! Ddd*termCommand: xterm -bg \'grey96\' -fg \'black\' -cr \'DarkGreen\' -fn \'@FONT@\' -title \'DDD: Execution Window\' -e /bin/sh -c
! Ddd*uncompressCommand: gzip -d -c
! Ddd*wwwCommand: firefox -remote \'openURL(@URL@)\' || mozilla -remote \'openURL(@URL@)\' || opera -remote \'openURL(@URL@)\' || ${WWWBROWSER-false} \'@URL@\' || konqueror \'openURL(@URL@)\' || galeon \'openURL(@URL@)\' || skipstone \'openURL(@URL@)\' || light \'openURL(@URL@)\' || netscape -remote \'openURL(@URL@)\' || mozilla \'@URL@\' || kfmbrowser \'@URL@\' || netscape \'@URL@\' || gnudoit \'(w3-fetch \"@URL@\")\' || mosaic \'@URL@\' || Mosaic \'@URL@\' || xterm -e lynx \'@URL@\'
! Ddd*plotCommand: gnuplot -bg \'grey96\' -font \'@FONT@\' -name \'@NAME@\' -geometry +5000+5000
Ddd*plotTermType: xlib
! Ddd*printCommand: lp -c

! Tool Bars.
Ddd*toolbarsAtBottom: off
Ddd*buttonImages: on
Ddd*buttonCaptions: on
Ddd*FlatButtons: on
Ddd*buttonColorKey: g
Ddd*activeButtonColorKey: c

! Command Tool.
Ddd*commandToolBar: off
Ddd*toolRightOffset: 14
! Ddd*toolTopOffset: 8

! Buttons.
Ddd*consoleButtons: 
Ddd*sourceButtons: 
Ddd*dataButtons: 
Ddd*verifyButtons: on

! Display shortcuts.
Ddd*bashDisplayShortcuts: 
Ddd*dbgDisplayShortcuts: 
! Ddd*dbxDisplayShortcuts: 
! Ddd*gdbDisplayShortcuts: \
! /t ()	// Convert to Bin\n\
! /d ()	// Convert to Dec\n\
! /x ()	// Convert to Hex\n\
! /o ()	// Convert to Oct
Ddd*makeDisplayShortcuts: 
! Ddd*jdbDisplayShortcuts: 
! Ddd*perlDisplayShortcuts: \
! sprintf(\"%#x\", ())	// Convert to Hex\n\
! sprintf(\"%#o\", ())	// Convert to Oct
! Ddd*pydbDisplayShortcuts: \
! /t ()	// Convert to Bin\n\
! /d ()	// Convert to Dec\n\
! /x ()	// Convert to Hex\n\
! /o ()	// Convert to Oct
! Ddd*xdbDisplayShortcuts: 

! Fonts.
! Ddd*defaultFont: helvetica-medium
! Ddd*variableWidthFont: helvetica-medium
! Ddd*fixedWidthFont: lucidatypewriter-medium
! Ddd*dataFont: lucidatypewriter-medium
Ddd*FontSize: 120

! Windows.
Ddd*openDataWindow: off
Ddd*openSourceWindow: on
Ddd*openDebuggerConsole: on
Ddd*Separate: off
Ddd*separateExecWindow: off
Ddd*groupIconify: off
Ddd*uniconifyWhenReady: on

! Maintenance.
Ddd*dumpCore: on
Ddd*debugCoreDumps: off

! Window sizes.
Ddd*graph_edit.height: 150
Ddd*source_text_w.columns: 269
Ddd*source_text_w.rows: 48
Ddd*code_text_w.columns: 1
Ddd*code_text_w.rows: 1
Ddd*gdb_w.columns: 269
Ddd*gdb_w.rows: 25
