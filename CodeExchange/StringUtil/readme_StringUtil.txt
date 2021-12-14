SUBMISSION AUTHOR:      Tod Phillips
                        mail to: tod.phillips@synergex.com
                        PSG
                        Synergex
                        2330 Gold Meadow Way
                        Gold River, CA 95670
                        Phone: 916-635-7300
                        http://www.synergex.com

SUBMISSION NAME:        StringUtil.DBL

PLATFORM:               Windows, VMS, Unix

SYNERGY VERSION:        Synergy v9.1.3 or higher

MODIFICATION HISTORY:   November 13, 2008
                        September 20th, 2010 - Updated for compatibility with Synergy 9.5
			17th Nov 2010 - Improved format for datetime



DESCRIPTION:            StringUtil is a class that includes two methods for modifying strings (or
                        alphas).

ADDITIONAL NOTES:       In order to use this class, it must first be prototyped with the DBLPROTO
                        utility.  Ensure that your SYNIMPDIR and SYNEXPDIR environment variables
                        have been set, then run the protyper by typing:

                                dblproto StringUtil

                        from a command prompt in the directory where the StringUtil.dbl file has
                        been saved. (Alternately, import the file into a Workbench project, right-
                        click the project in the Projects tab and select "Generate Synergy
                        Protypes..."). The included file can then be compiled and added to any
                        library or ELB.  To use the provided class methods, simply type

                                import SynPSG

                        at the top of your source code. (See Example, below).

CLASS:
        StringUtil      (Public)

ENUMERATION(S):

        StringSplitOptions
                None
                RemoveEmptyEntries


METHOD(S):

        Split   (Public Static)
                Returns a Dynamic Array of String types containing the substrings in the passed
                string that are delimited by the specified character(s).

                Usage & Overloads

                Split(string a_string, string a_delimeter)
                        a_string is the string that will be split
                        a_delimeter is the delimeter character(s)

                Split(string a_string, string a_delimeter, enum StringSplitOptions)
                        a_string is the string that will be split
                        a_delimeter is the delimeter character(s)
                        StringSplitOptions specifies whether to return empty array elements

        Replace (Public Static)
                Replaces all occurrences of a specified string with another specified string

                Usage

                Replace(string a_string, string a_find, string a_replace)
                        a_string is the string that will be searched
                        a_find is the string that will be replaced
                        a_replace is the string that will replace all occurrences of the found string

EXAMPLE(S):

        The following program demonstrates the use of the Split and Replace methods.


;; Program to demonstrate StringUtil.Split and StringUtil.Replace
import SynPSG

main
record
        newString       ,string
        oldString       ,string
        splitArray      ,[#]string
        findString      ,string
        replaceString   ,string
endrecord

proc
        oldString = "This   is a test of the Split method."
        findString = " "
        splitArray = StringUtil.Split(oldString, findString)
;       splitArray now has the following values:
;               This
;
;
;               is
;               a
;               test
;               of
;               the
;               Split
;               method.

        splitArray = StringUtil.Split(oldString, findString, StringSplitOptions.RemoveEmptyEntries)
;       splitArray now has the following values:
;               This
;               is
;               a
;               test
;               of
;               the
;               Split
;               method.


        findString = "Split"
        replaceString = "Replace"
        newString = StringUtil.Replace(oldString, findString, replaceString)
;       newString now has the following value:
;               This   is a test of the Replace method.

end
