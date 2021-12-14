README.TXT for USPS.ZIP

Description of routine
----------------------

This routine is intended to show how to use use the USPS web services that
allow address validation, zip code lookup and US domestic postal rate
calculations.

You will need a USPS User ID.  This can be obtained (for free) by registering
at http://www.usps.com/webtools  You can also get full documentation on all
USPS web services at this website.

Submission details
------------------

Author:                 William Hawkins
Company:                Synergex
Email:                  William.Hawkins@synergex.com
Date:                   30th October 2009
Minimum version:        Synergy/DE 9.1.5
Platforms:              Any
Prototype command:      DBLPROTO USPSaddressValidation.dbl USPSrateCalculator.dbl
Compiler command:       DBL uspsTest.DBL USPSaddressValidation.dbl USPSrateCalculator.dbl
Link command            DBLINK uspsTest.DBO DBLDIR:synxml.elb
Files:                  uspsTest.DBL, USPSaddressValidation.dbl & USPSrateCalculator.dbl

Modification history
--------------------

20th Sept 2010
        Updated for compatibility with Synergy 9.5

