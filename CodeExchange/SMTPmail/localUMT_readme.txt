
SUBMISSION AUTHOR:      Tod Phillips
                        mail to: tod.phillips@synergex.com
                        PSG
                        Synergex
                        2330 Gold Meadow Way
                        Gold River, CA 95670
                        Phone: 916-635-7300
                        http://www.synergex.com

SUBMISSION NAME:        LocalUMTOffset.dbl

PLATFORM:               Windows, VMS, Unix

SYNERGY VERSION:        Tested and compiled on Synergy v8.3.  May work on earlier versions.

LAST MODIFIED:          January 23, 2009

DESCRIPTION:            LocalUMTOffset is a function that returns the local time offset (from UMT/UCT
                        or Universal Mean Time) based on a user-editable time zone settings file (localTZ.ini).
                        The return value represents the number of hours (plus or minus) that
                        the current time differs from UMT (Universal Mean Time).  This function
                        comes in handy for such programs as sendmail, where the header information
                        must reflect a date/time based on UMT, and must match the SMTP server's time
                        or risk disposal by the client server as an invalid (and potentially spam)
                        email.

ADDITIONAL NOTES:       In order to use this function, the localTZ.ini file must be
                        placed in a pre-defined directory.  This directory may be either an absolute
                        path or a logical, and must then be included in the LocalUMTOffset.dbl as a
                        .DEFINE. For example:

                                .define TZ_INI_PATH  'DAT:'

                        This allows for a more easily distributed application, in which time zone
                        information may be altered locally for each client running the application
                        by using a simple text editor. By incorporating a "standard" path to the
                        settings (.ini) file, there should be no need to recompile the function or update
                        libraries for each particular user/client in differing time zones.

                        The localTZ.ini file should have been downloaded with the source
                        code, but if it has been misplaced, the format is shown below. This sample
                        is for the Pacific Time Zone, and represents a Standard Time offset of -8:00 hours
	        in a time zone that recognizes Daylight Savings Time.  DST begins on the 2nd Sunday
	        of March at 2:00am, and ends on the first Sunday in November at 2:00am.

		[Local-Time-Zone]
		UMToffset = -0800
		useDST = 1
		beginMonth = 3
		beginWeek = 2
		beginDay = 0
		beginHour = 2
		endMonth = 11
		endWeek = 1
		endDay = 0
		endHour = 2

	        Settings Descriptions
	        -------------------------------
	        UMToffset is the number of hours (from -1200 to +1200) difference between GMT and
		the local time zone
	        useDST signifies whether the local time zone recognizes daylight savings time.  For
                                instance, Arizona, USA does not recognize DST so this value would be set to 0.
	        beginMonth is the month (from 1 through 12) in which Daylight Savings Time begins
	        endMonth is the month (from 1 through 12) in which Daylight Savings Time ends
	        BeginWeek is the nth week of the month on which Daylight Savings Time begins. For the
		last week of the month, use BeginWeek = 5.
	        EndWeek is the nth week of the month on which Daylight Savings Time ends. For the
		last week of the month, use BeginWeek = 5.
	        BeginDay is the day of the week (0 - 6) on which Daylight Savings Time begins. Sunday is
		represented by 0, Saturday by 6.
	        EndDay is the day of the week on which Daylight Savings Time ends. Sunday is
		represented by 0, Saturday by 6.
	        BeginHour is the hour at which Daylight Savings Time begins.
	        EndHour is the hour at which Daylight Savings Time ends.

                        Again, this file should be placed in a specific directory on all client
                        machines, and can be accessed by defining the path in the main function (see
                        above).

FUNCTION:
        LocalUMTOffset

EXAMPLE(S):

        The following program demonstrates the use of the LocalUMTOffset function.

;; ---------------------------------------------------------------
;; Program to demonstrate and/or test the LocalUMTOffset function.
;; ---------------------------------------------------------------
.main

external function
        localUMTOffset  ,^val

record
    offset  ,i4
    aOffset ,a5

.proc
    open(1,O,'TT:')
    offset = %localUMTOffset()
    aOffset(2:4) = %string(offset,'XXXX')
    if (offset<0) then
        aOffset(1:1) = '-'
    else
        aOffset(1:1) = '+'

    display(1,'Local UMT offset is: '+aOffset)

.end
;; ---------------------------------------------------------------

