-------------------------------------------------------------------------------

Name:            SynPsg.Rps.zip

Author:          Steve Ives
                 Synergex Professional Services Group

Platforms:       All

Minimum version: Synergy/DE 9.1.5b

Revisions:       Version  Date               Comment
                 -------  -----              --------
                 1.0      12th March 2008    Original version
                 1.1      5th May 2008       Updated to continue to use 1-based
                                             collections when Synergy/DE V9.1.5
                                             is released
                 1.2      2nd February 2010  Updated with additional features
                                             for 9.3.1

Disclaimer:      All code is supplied as seen and without warranty or support.
                 Use at your own risk. Neither the author nor Synergex accept
                 any responsibility for any loss or damage which may result
                 from the use of this code.

-------------------------------------------------------------------------------

SynPsg.Rps is a namespace containing a set of classes which represent and
expose information about a Synergy/DE repository. The main reason for adding
these classes to CodeExchange was for it to be an example of OO coding in
Synergy Language, but you may also find the classes useful, as they give you
an alternative to using the Repository API ( DDLIB.ELB / xcall dd_* ).

Internally these classes manipulate the DDLIB routines, and present you with
a more natural interface to the Repository.
-------------------------------------------------------------------------------

