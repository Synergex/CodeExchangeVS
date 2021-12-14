;-------------------------------------------------------------------------------
;
;Routine:       http_query_string
;
;Author:        Steve Ives (Synergex Professional Services Group)
;
;Platforms:     All Synergy-supported platforms
;
;Revisions:     Version Date            Comment
;               1.0     23 Jan 2002     Original version
;                       20 Sep 2010     Updated for compatibility with 9.5
;
;Diclaimer:     This code is supplied as seen and without warranty or support.
;               You may use and redistribute this code as you wish, but doing
;               so is entirely your own risk. Neither the author or Synergex
;               accept responsability for any loss or damage which may result
;               from the use of this code.
;
;-------------------------------------------------------------------------------
;
;When passing form data via the HTTP protocol, field names and values are often
;passed in the form of a "query string", which is essentially an ampersand (&)
;delimited string containing field name and value pairs. For example:
;
;       firstname=John&lastname=Doe&city=Gold+River&state=CA
;
;Query strings are typically used in one of two ways, depending on the HTTP
;"method" being used.  If you are using a HTTP GET then the query string is
;appended to the end of the URI, following a question mark (?).  For example:
;
;       http://www.domain.com/page.asp?firstname=John&lastname=Doe
;
;If you are using an HTTP POST (for example to POST data to an Active Server
;Pages form) then the querystring is passed in the BODY of the HTTP request.
;
;This function accepts an array of field names and an array of field values
;and then builds and returns a query string in a dynamic memory handle. The
;arrays you pass in MUST BE REAL ARRAYS (i.e. declared with the [] syntax).
;An additional optional parameter returns the length of the returned data.
;
;An example of using this routine is:
;
;       field[1] = "name"
;       field[2] = "location"
;
;       value[1] = "John Doe"
;       value[2] = "Sacramento, CA"
;
;       handle = %http_query_string(field,value)
;
;In this instance, the content of the returned memory handle would be:
;
;       name=John+Doe&location=Sacramento%2C+CA
;
;Notice that data passed through a query string must also be URL Encoded, and
;this routine uses the URL_ENCODE routine (also available from the Synergy
;Code Exchange) for that purpose.
;
;DEALLOCATION OF THE STATIC DYNAMIC MEMORY ALLOCATED BY THIS ROUTINE IS THE
;RESPONSIBILITY OF THE CALLING ROUTINE.
;
;-------------------------------------------------------------------------------
;
