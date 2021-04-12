/************************************************************
 * 
 *                   Debug Extensions
 *
 * Toby Opferman
 *
 ************************************************************/
 
#include <windows.h>
#include <imagehlp.h>
#include <wdbgexts.h>

/***********************************************************
 * Global Variable Needed For Functions
 ***********************************************************/              
WINDBG_EXTENSION_APIS ExtensionApis = {0};

                      
/***********************************************************
 * Global Variable Needed For Versioning
 ***********************************************************/              
EXT_API_VERSION g_ExtApiVersion = {
         5 ,
         5 ,
         EXT_API_VERSION_NUMBER ,
         0
     } ;


/***********************************************************
 * DllMain
 *
 * Purpose: Entry point to dynamic link library.
 *
 *  Parameters:
 *     Handle To Module Instance, Reason For Calling, Reserved
 *
 *  Return Values:
 *     TRUE for success
 *     FALSE for error
 *
 ***********************************************************/              
BOOL WINAPI DllMain(HINSTANCE hModule, DWORD dwReason, PVOID pReserved)
{
   return TRUE;
}



/***********************************************************
 * ExtensionApiVersion
 *
 * Purpose: WINDBG will call this function to get the version
 *          of the API
 *
 *  Parameters:
 *     Void
 *
 *  Return Values:
 *     Pointer to a EXT_API_VERSION structure.
 *
 ***********************************************************/              
LPEXT_API_VERSION WDBGAPI ExtensionApiVersion (void)
{
    return &g_ExtApiVersion;
}


/***********************************************************
 * WinDbgExtensionDllInit
 *
 * Purpose: WINDBG will call this function to initialize
 *          the API
 *
 *  Parameters:
 *     Pointer to the API functions, Major Version, Minor Version
 *
 *  Return Values:
 *     Nothing
 *
 ***********************************************************/              
VOID WDBGAPI WinDbgExtensionDllInit (PWINDBG_EXTENSION_APIS lpExtensionApis, USHORT usMajorVersion, USHORT usMinorVersion)
{
     ExtensionApis = *lpExtensionApis;
}

/***********************************************************
 * !help
 *
 * Purpose: WINDBG will call this API when the user types !help
 *          
 *
 *  Parameters:
 *     N/A
 *
 *  Return Values:
 *     N/A
 *
 ***********************************************************/
DECLARE_API (help)
{
    dprintf("Toby's Debug Extensions\n\n");
    dprintf("!dumpstrings <address/register> - Dumps 20 strings in ANSI/UNICODE using this address as a pointer to strings (useful for dumping strings on the stack) \n");
}



/***********************************************************
 * !dumpstrings
 *
 * Purpose: WINDBG will call this API when the user types !dumpstrings
 *          
 *
 *  Parameters:
 *     !dumpstrings or !dumpstrings <address/register>
 *
 *  Return Values:
 *     N/A
 *
 ***********************************************************/
DECLARE_API (dumpstrings)
{
    static ULONG Address = 0;
    ULONG  GetAddress, StringAddress, Index = 0, Bytes;
    WCHAR MyString[51] = {0};
    
    
    GetAddress = GetExpression(args);

    if(GetAddress != 0)
    {
        Address = GetAddress;
    }
        
    dprintf("STACK   ADDR   STRING \n");

    for(Index = 0; Index < 4*20; Index+=4)
    {
        memset(MyString, 0, sizeof(MyString));
        
        Bytes = 0;

        ReadMemory(Address + Index, &StringAddress, sizeof(StringAddress), &Bytes);

        if(Bytes)
        {
           Bytes = 0;

           ReadMemory(StringAddress, MyString, sizeof(MyString) - 2, &Bytes);

           if(Bytes)
           {
              dprintf("%08x : %08x = (UNICODE) \"%ws\"\n", Address + Index, StringAddress, MyString);
              dprintf("%08x : %08x = (ANSI)    \"%s\"\n", Address + Index, StringAddress, MyString);
           }
           else
           {
              dprintf("%08x : %08x =  Address Not Valid\n", Address + Index, StringAddress);
           }
        }
        else
        {
           dprintf("%08x : Address Not Valid\n", Address + Index);
        }
    }

    Address += Index;
}










