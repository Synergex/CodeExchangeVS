;-------------------------------------------------------------------------------
;
;Routine:          url_encode
;
;Author:           Steve Ives (Synergex Professional Services Group)
;
;Platforms:        All Synergy-supported platforms
;
;Revisions:        Version  Date            Comment
;                  1.0      23 Jan 2002     Original version
;                  1.1      20 Sep 2010     Updated for compatibility with 9.5
;
;Diclaimer:        This code is supplied as seen and without warranty or support.
;                  You may use and redistribute this code as you wish, but doing
;                  so is entirely your own risk. Neither the author or Synergex
;                  accept responsability for any loss or damage which may result
;                  from the use of this code.
;
;-------------------------------------------------------------------------------
;
;When passing data via the HTTP protocol, either as URI parameters in an HTTP GET
;operation, or as body data in an HTTP POST operation, certain characters must be
;'escaped', usually by replacing them with their hexadecimal values. This process
;is referred to as "URL Encoding".
;
;More details can be found in RFC 2396 (URI General Syntax)
;
;This function accepts a string in parameter 1 and returns a URL encoded version
;of that string.
;
;This function must be declared before use, as follows:
;
;     external function
;          url_encode          ,a
;
;An example of using this function is:
;
;     url = "http://www.domain.com/page.asp?location=" + %url_encode("Gold River (CA)")
;
;Which would set the variable url to:
;
;     http://www.domain.com/page.asp?location=Gold+River+%28CA%29
