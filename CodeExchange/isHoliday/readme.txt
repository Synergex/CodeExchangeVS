IsHoliday.dbc

IsHoliday() is a static method that will execute a remote web service and then
return a status to determine if the passed date is a public holiday for the
passed country code.

Submission details
------------------

Author:                 Richard Morris
Company:                Synergex
Email:                  Richard.Morris@synergex.com
Minimum version:        Synergy 9.3.1a

Usage:

 begin
        data b,boolean
        data d,d8,20100215
        b=SynPSG.DateFunctions.IsHoliday(d, synpsg.CountryCode.UnitedStates)
        ;;if b == true the day is a holiday.
 end


Modification history
--------------------

20th Sept 2010
        Updated for compatibility with Synergy 9.5

