#
# Toby Opferman
#   MakeFile For Debug Extentions
#   Copyright (c) September 2003
#   https://www.codeproject.com/Articles/6522/Debug-Tutorial-Part-Writing-WINDBG-Extensions

   
 
TARGET = dbgExt
TARGETDIR = .\bin
OBJDIR = .\int\i386

CPP = cl
RSC = rc.exe
F90 = df.exe
MTL = midl.exe
REBASE = editbin.exe



#RES_PROJ=/I ".\inc" \
#        /D "WIN32" /D "_WINDOWS" /fo$(OBJDIR)\cubix.res
RES_PROJ=

CPP_PROJ=/nologo /MD /W3 /Oxs /Zi \
	/I ".\inc" \
        /D "WIN32" /DLL /D "_WINDOWS" \
	/FR$(OBJDIR)\\ /Fo$(OBJDIR)\\ /Fd$(OBJDIR)\\ /c

LIB32= link.exe 
LIB32_FLAGS = /DLL /nologo /def:$(TARGET).def /out:$(TARGETDIR)\$(TARGET).dll  /pdb:$(TARGETDIR)\$(TARGET).pdb /debug /debugtype:CV 


#RESFILE = \
#        $(OBJDIR)\cubix.res

OBJS   = \
	$(OBJDIR)\$(TARGET).obj

LIBS = \
        USER32.LIB \
	KERNEL32.LIB

# This is a comment
# see rebase usage : https://blog.csdn.net/chenwanming507507507/article/details/6070882
$(TARGETDIR)\$(TARGET).dll: $(OBJDIR) $(TARGETDIR) $(OBJS) $(RESFILE)
    $(LIB32) $(LIB32_FLAGS) $(LIBS) $(OBJS) $(RESFILE)

{.\}.c{$(OBJDIR)}.obj::
	$(CPP) $(CPP_PROJ) $<

{.\}.cpp{$(OBJDIR)}.obj::
	$(CPP) $(CPP_PROJ) $<


{.\}.rc{$(OBJDIR)}.res::
	$(RSC) $(RES_PROJ) $<

$(OBJDIR):
    if not exist "$(OBJDIR)/$(NULL)" mkdir "$(OBJDIR)"

$(TARGETDIR):
    if not exist "$(TARGETDIR)/$(NULL)" mkdir "$(TARGETDIR)"


CLEAN:
	-@erase /S /Q $(OBJDIR)
