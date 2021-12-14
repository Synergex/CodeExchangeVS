README_socketExamples.txt

Description
-----------

Client.dbl and Server.dbl are updated versions of code in the Synergy Language
Reference Manual (LRM).   These examples have been modified to present a more
realistic implementation of the Synergy Socket API.

However, Synergy Language is single threaded, so implementing a Socket Server
that can respond to multiple clients concurrently is not possible.  You can have
a server that acts as a listener and when a new client connects, launch a child
process that responds to the client requests.  Each child only responds to a
single client. This technique is used in the RemoteBuild utility.  This utility
can also be downloaded from the Synergy CodeExchange (http://www.synergyde.com).

Note, When using the -p option to alter the program logic to use SS_MSG_PEEK,
I have used a technique that places the message size in the first 4 bytes of the
message (in network byte order).  This is not a requirement of SS_MSG_PEEK.
Also note, message acknowledgments do not use SS_MSG_PEEK technique.

Submission details
------------------

Author:                 William Hawkins
Company:                Synergex
Email:                  William.Hawkins@synergex.com
Date:                   2nd February 2010
Minimum version:        Synergy 8.1
Platforms:              ALL

Modification history
--------------------

20th Sept 2010
        Updated for compatibility with Synergy 9.5


