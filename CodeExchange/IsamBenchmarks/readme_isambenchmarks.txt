README.TXT for ISAMBENCHMARKS.DBL

Description
-----------

This CodeExchange submission allows a performance comparison between using
xfServer and mapped drive technology for accessing Synergy DBMS data files.

When comparing performance, mapped drives can sometimes outperform xfServer,
when nobody else is using the data files.   However in real life, this is very
unlikely to occur.  In this case, xfServer should out perform mapped drives.
The provided programs allow the performance characteristics to be compared.
It's also important to note that mapped drive technology does not really
support the concept of record locking, and usually can only support file
locking.  As such, it's not uncommon for data to be written "out of order"
resulting in data integrity issues.

In order to test isam access performance, the file DAT:ismbench.ism is used.
If you create a test environment that has both a mapped drive (to a remote
machine) and that machine also is running xfServer, you can simply modify the
value of the DAT: logical to use the mapped drive specification or xfServer.

Programs
--------

IsamBenchmark.dbl - this program will create a new isam file (DAT:ismbench.ism),
 and perform two timed tests
 1) store a number of records and
 2) randomly read a number of records, and output the elapsed time for each test.

IBcontrol.dbl - this program is used to control the behavior of IsamBenchmark.

Both programs use command line parameters to configure the options they use.
You can use the command line option -h or -? to get program help.

dbr IsamBenchmark  [-c] [-i <info>] [-k <n>] [-o <file>] [-r <n>] [-s <n>] [-w]

 -c        : Create new benchmark file
 -i <info> : Information text to add to output file
             Default=
             (used to differentiate test runs)
 -k <n>    : Number of keys to create in benchmark file(1-8)
             Default=8
 -o <file> : Output file name
             Default=test.ddf
 -r <n>    : Number of records to create in benchmark file
             Default=20000
 -s <n>    : Benchmark file open (SHARE:) mode
              0 = Exclusive read/write mode
              1 = Exclusive write mode
              2 = Nonexclusive mode
             Default=2
 -w        : Wait for "IBcontrol -b" to be executed
             (IBcontrol -b opens the benchmark file)



dbr IBcontrol  [-b] [-c] [-i <x.x>]

 -b       : Open benchmark file (default mode)

 -c       : Create lock file DAT:lock.ddf
 -i <x.x> : Lock file unlock interval (seconds)
            Default=1.0


IsamBenchmark test process
--------------------------

Create a new isam test file (if needed)

Check for locks, and wait if locks exist

Store <n> records in the isam test file

Check for locks, and wait if locks exist

read <n> records (randomly) in the isam test file

Delete Isam test file (if not in use)


Suggested test plan
-------------------

The following test plan should be run (at least) twice, once with DAT set to
the mapped drive specification, and a second time set to xfServer specification.
It's recommended that you actually run each test multiple times and use an
average time, to reduce the impact of network latency.


1)      Test Single user access.

In this test, we are just storing and reading the specified number of records.

        Run IsamBenchmark -c


2)      Test multiple user access.

In this test, we are using IBcontrol to act as a second user that has the file
open, but is not accessing the file.  The IsamBenchmark test is identical to
test 1.

        Run IsamBenchmark -c -w
        <when asked>
        Run IBcontrol -b <on another computer/session>
        <a "Press RETURN to close" message will appear - do not press any keys>
        <return to IsamBenchmark and press RETURN>
        <once IsamBenchmark has completed>
        <return to IBControl and press RETURN>


3)      Test multiple users accessing same file concurrently.

In this test, we use IBcontrol to create a locked record in the file
DAT:lock.ddf.  This locked record prevents IsamBenchmark from commencing its
tests.  This allows the tester time to start multiple instances of IsamBenchmark
on difference sessions/computers.  Once the record is released, all instances of
IsamBenchmark start their tests at the same time.  IBcontrol will release the 
lock for (by default) 1 second, but if this is not long enough, you may need to 
override the default using the command line option.  The lock release should not 
be longer than the amount of time required to perform the test.

        Run IBcontrol -c
        Run IsamBenchmark -c <on one computer/session>
        Run IsamBenchmark <on one or more computers/sessions>
        <return to IBcontrol, and press RETURN>
        <all the IsamBenchmark sessions will run the store test concurrently>
        <once all IsamBenchmark has completed the store test>
        <return to IBControl and press RETURN>
        <all the IsamBenchmark sessions will run the read test concurrently>
        <once all IsamBenchmark has completed the read test>
        <return to IBControl and press RETURN>


You may need to add additional command line options to adjust behaviour and/or
modify the log file generated.



Submission details
------------------

Author:                 William Hawkins
Company:                Synergex
Email:                  William.Hawkins@synergex.com
Date:                   25th September 2010
Minimum version:        Synergy 5.1
Platforms:              Any
Compiler command:       DBL IsamBenchmark  (or IBcontrol)
Link command            DBLINK IsamBenchmark  (or IBcontrol)

Modification history
--------------------

25th Sept 2010
        Initial version subbmitted to CodeExchange

