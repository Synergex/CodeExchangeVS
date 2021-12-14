SUBMISSION AUTHOR:      Steve Ives
                        mail to: steve.ives@synergex.com
                        PSG
                        Synergex
                        2330 Gold Meadow Way
                        Gold River, CA 95670
                        Phone: 916-635-7300
                        http://www.synergex.com

SUBMISSION NAME:        FINDNPCHARS.DBL

PLATFORM:               Windows, VMS, Unix

SYNERGY VERSION:        Synergy v9.1.1 or higher

DESCRIPTION:            Identifies embedded characters that need to be replaced
                        when migrating to Synergy v9


Previous versions of Synergy allowed for embedded characters in the code for
Carriage Return, Line Feed and Null. Due to changes in the version 9 compiler,
these characters are not recognized properly and can return incorrect results.
This program will search for any .DBL files in the directory it is placed in,
parse each line and look for the embedded characters, if found, the file name
and line number where the embedded character was found will be displayed.

Modification history
--------------------

20th Sept 2010
        Updated for compatibility with Synergy 9.5

