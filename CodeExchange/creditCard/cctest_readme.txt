README for ccTest

Descriptions
------------

The source files enclosed in this zip files are:

ccTest.dbl
This is a Synergy/DE UI Toolkit test program that manages a simple Synergy DBMS isam file.
This file contains basic credit card information, as defined in the file ccrec.inc.
Based upon the defines near the top of the file, various encryption options can be
exercised by this program.  The defines can change the format of the data file, as some
encryption options require additional record space to save the encrypted data.

CCutils.dbc
This file contains a few utility methods used in the validation of credit card numbers.

Encryption.dbc
This file contains a data encryption class, that can be used to encrypt data.
You will need to adjust the logic in the method getEncryptionCode() so that the
encryption code is correctly managed.  Currently this uses the Synergy License Manager
licensee name as the encryption code.

Build.bat
Windows/Unix build command file


Modification history
--------------------

24th Nov 2009
  Initial version
4th Jan 2010
  Updated ccUtils to recognize more credit cards
20ty Sept 2010
  Updated for compatiblity with Synergy 9.5

Submission details
------------------

Author:                 William Hawkins
Company:                Synergex
Email:                  william.hawkins@synergex.com
Date:                   24th Nov 2009
Minimum version:        v9.2.2
Platforms:              OpenVMS or Unix or Windows

