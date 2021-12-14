================================================================================
WINDIR README
================================================================================

Description:    Function to return information about files matching a wildcard
                file specification (like a dir command)

Author:         Steve Ives
                Synergex Professional Services Group

Date:           19th August 2005

Availability:   Windows only

Disclaimer:     This code is provided "as is" and without guarantee or warranty
                of any kind.  You may use the code freely, so long as this code
                header and disclaimer remains unchanged. In doing so you accept
                that neither the author or Synergex accept any responsibility
                for any damage or loss which may result from the use of the code.

Modification history
--------------------

20th Sept 2010
        Updated to prevent incompatibility with Synergy 9.5

================================================================================

USAGE NOTES:

  The WinDir function accepts between three and five parameters:

  ;Required parameters

    a_spec    ,a        ;Search spec

        The search spec could be something like C:\WINDOWS\*.EXE

    a_handle  ,n        ;Returned handle containing results

        WinDir allocates and returns a dynamic memory handle containing the
        details of the matching files.  The layout of the data is defined by
        the structure WINDIR$DATA in WinDir.def, which also defines several
        macros to allow you to easily access the return data.

    a_count   ,n        ;Returned number of matches

        This is the number of file records returned in the memory handle

  ;Optional parameters

    a_case              ,n      ;Return filenames in upper or lower case

        WinDir can optionally convert all file names to upper or lower case.
        Optionally pass WINDIR$UPPERCASE or WINDIR$LOWERCASE

    a_sort              ,n      ;Sort return data

        WinDir can optionally sort the return data in either ascending or
        descending sequence of file name or size.  Pass one of:

            WINDIR$SORT_NAME        (default)
            WINDIR$SORT_NAMEDESC
            WINDIR$SORT_SIZE
            WINDIR$SORT_SIZEDESC

IMPORTANT:

    The dynamic memory handle returned by WinDir is a STATIC memory handle. The
    WinDir function allocates the memory (you just pass an i4 handle), but it is
    the responsibility of the calling routine to deallocate the memory.

