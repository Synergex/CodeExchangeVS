;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; XFSPISM2XML_README.TXT
;
; Readme file for an example program demonstrating the use of the Synergy
; XML API to export data from Synergy DBMS files or to import data into
; Synergy DBMS data files
;
; Author : William Hawkins (william.hawkins@synergex.com)
;
; Requires : Synergy/DE 8 (or later)
;
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
; Files required to build
;
; xfspism2xml.dbl               subroutines and functions
; xfspism2xml.def               control parameters
; xfspism2xml.rec               data record
;
; xfspism2xmltest.dbl           UI Toolkit program
;
; To build this program :
;
; dbl xfspism2xmltest
; dblink xfspism2xmltest WND:tklib.elb
;
; dbl xfspism2xml
; dblink -l xfspism2xml.elb xfspism2xml.dbo
;
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
; Discussion:
;
;  If the filename contains a colon, it is assumed to be a physical filename,
;  and the structure name MUST be provided. You cannot specify a filename in
;  the current directory without using a logical
;
;  If the filename does not contains a colon, it must contain a Repository
;  filename, and the structure name is optional.  If the structure name is
;  provided, all records will use the provided structure.  If the structure
;  name is not provided, each record is checked against any Repository tags,
;  and the appropriate structure is used.
;
;  XMLtype is an alpha string, as represented in xfspism2xml.def.
;  The "ADO recordset" and "Data Island" are used by Crystal Reports, and
;  were implemented using information available on the CrystalDecisions web
;  site, but neither have been fully tested.  If you find any problems with
;  these formats, please email the author.
;
;
;  How to use these routines:
;
;
;
;  If you want to display progress information:
;
;    call xfsp_ism2xml_init(filename, structurename, xmltype,
;    &  key_number, first_key, last_key, type_type)
;
;    do
;
;      display progress info
;
;      status = %xfsp_ism2xml_data(20, numrecs)
;
;    until(status == DE_NOMOREDATA)
;
;    call xfsp_ism2xml_exit(xml_string)
;
;    process xml string
;
;
;
;  If you do not want to display progress information:
;
;    call xfsp_ism2xml_init(filename, structurename, xmltype,
;    &  key_number, first_key, last_key, type_type)
;
;    call xfsp_ism2xml_data
;
;    call xfsp_ism2xml_exit(xml_string)
;
;    process xml string
;
;
;
;
;  If you want an XML schema file to match the XML beging generated:
;
;    call xfsp_ism2xml_xsd(xsd_string)
;
;  between the xfsp_ism2xml_init routine and the xfsp_ism2xml_exit routine
;
;
;
;
; XFPL.INI
;
; XFPL_LOG=ON
; XFPL_SESS_INFO=NONE
; XFPL_FUNC_INFO=NONE
; XFPL_DEBUG=NONE
; XFPL_LOGICAL:RPSLIB=C:\Program Files\Synergex\SynergyDE\RPS\lib
; XFPL_LOGICAL:WND=C:\Program Files\Synergex\SynergyDE\Toolkit
; XFPL_LOGICAL:EXE=C:\Source
; XFPL_LOGICAL:TMP=C:\Source
; XFPL_LOGICAL:RPSMFIL=C:\Source\RPS\rpsmain.ism
; XFPL_LOGICAL:RPSTFIL=C:\Source\RPS\rpstext.ism
;
;
; Synergy Method Catalog descriptions
;
; <method name="xfsp_ism2xml_init" id="xfsp_ism2xml_init" elb="EXE:xfspism2xml">
;   <methodresult type="value" size="4"/>
;   <param name="filename" type="alpha" size="255"/>
;   <param name="structurename" type="alpha" size="30" required="no"/>
;   <param name="xml_type" type="alpha" size="25" required="no"/>
;   <param name="keynumber" type="decimal" size="3" required="no"/>
;   <param name="first_key" type="alpha" size="80" required="no"/>
;   <param name="last_key" type="alpha" size="80" required="no"/>
;   <param name="keyrangetype" type="decimal" size="1" required="no"/>
; </method>
;
; <method name="xfsp_ism2xml_data" id="xfsp_ism2xml_data" elb="EXE:xfspism2xml">
;   <methodresult type="value" size="4"/>
;   <param name="max_records" type="integer" size="4" required="no"/>
;   <param name="number_of_records" type="integer" size="4" required="no" dir="out"/>
; </method>
;
; <method name="xfsp_ism2xml_exit" id="xfsp_ism2xml_exit" elb="EXE:xfspism2xml">
;   <methodresult type="value" size="4"/>
;   <param name="xml_handle" type="handle" dir="out"/>
; </method>
;
; <method name="xfsp_ism2xml_xsd" id="xfsp_ism2xml_xsd" elb="EXE:xfspism2xml">
;   <methodresult type="value" size="4"/>
;   <param name="xsd_handle" type="handle" dir="out"/>
; </method>
;
; <method name="get_error_text" id="get_error_text" elb="EXE:xfspism2xml">
;   <methodresult type="value" size="4"/>
;   <param name="errornumber" type="integer" size="4" required="no"/>
;   <param name="errortext" type="alpha" size="80" required="no" dir="out"/>
; </method>
;
;
; The xmlstring parameter is coded as a numeric, but will work if passed as alpha.
;
; Synergy Method Catalog descriptions (alternate)
;
; <method name="xfsp_ism2xml_exit" id="xfsp_ism2xml_exit" elb="EXE:xfspism2xml">
;   <methodresult type="value" size="4"/>
;   <param name="xmlstring" type="alpha" size="65535" dir="out"/>
; </method>
;
; <method name="xfsp_ism2xml_xsd" id="xfsp_ism2xml_xsd" elb="EXE:xfspism2xml">
;   <methodresult type="value" size="4"/>
;   <param name="xsdstring" type="alpha" size="65535" dir="out"/>
; </method>
;
; N.B. first_key and last_key may need to be adjusted to allow for larger keys/records.


; Example XML formats
;
;<?xml version='1.0'?>
;<xfspism2xml XMLtype="nameTAG value=">
;  <file name="CUSTOMER">
;    <CUSTOMER keynum="0">
;      <cust_id value="999"/>
;      <cust_name value="Synergex International Corporation"/>
;      <cust_adr1 value="2330 Gold Meadow Way"/>
;      <cust_adr2 value=""/>
;      <cust_city value="Gold River"/>
;      <cust_state value="CA"/>
;      <cust_zip value="95670"/>
;      <cust_phone value=" + 1 (916) 635 7300"/>
;    </CUSTOMER>
;  </file>
;</xfspism2xml>
;
;<?xml version='1.0'?>
;<xfspism2xml XMLtype="TAG name= value=">
;  <file name="CUSTOMER">
;    <structure name="CUSTOMER" keynum="0">
;      <field name="cust_id" value="999"/>
;      <field name="cust_name" value="Synergex International Corporation"/>
;      <field name="cust_adr1" value="2330 Gold Meadow Way"/>
;      <field name="cust_adr2" value=""/>
;      <field name="cust_city" value="Gold River"/>
;      <field name="cust_state" value="CA"/>
;      <field name="cust_zip" value="95670"/>
;      <field name="cust_phone" value=" + 1 (916) 635 7300"/>
;    </structure>
;  </file>
;</xfspism2xml>
;
;<?xml version='1.0'?>
;<xfspism2xml XMLtype="nameTAG DATA nameENDTAG">
;  <file name="CUSTOMER">
;    <CUSTOMER keynum="0">
;      <cust_id>999</cust_id>
;      <cust_name>Synergex International Corporation</cust_name>
;      <cust_adr1>2330 Gold Meadow Way</cust_adr1>
;      <cust_adr2/>
;      <cust_city>Gold River</cust_city>
;      <cust_state>CA</cust_state>
;      <cust_zip>95670</cust_zip>
;      <cust_phone> + 1 (916) 635 7300</cust_phone>
;    </CUSTOMER>
;  </file>
;</xfspism2xml>
;
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Known Issues

When the XML string is more than 65535 bytes in length, it's possible for the
XML API to omit the space between an element name and an element attribute.
This will be corrected in Synergy/DE 8.1.3

The XML string handle parameter must be the last parameter for a method. If it
is not the last parameter, under certain conditions, other parameters can be
corrupted.  This will be corrected in Synergy/DE 8.1.3

Modification history
--------------------

20th Sept 2010
        Updated for compatibility with Synergy 9.5

