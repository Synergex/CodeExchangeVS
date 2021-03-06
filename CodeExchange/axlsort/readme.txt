README.TXT for AXLSORT

Description of function
-----------------------

AXLSORT - plugin to enable sorting of ActiveX lists by column

This code module can be applied to ActiveX lists to enable sorting by column.
If the list has headings, the user can click a heading to sort by that column.
Clicking again on the same heading will toggle ascending/descending sort.
You can also programmatically sort by a column.


Submission details
------------------

Author:                 Chip Camden
Company:                Synergex
Email:                  chip.camden@synergex.com
Date:                   19th May 2006
Minimum version:        Synergy 8.3.1b
Platforms:              Windows

Modification History    20th September 2010 - Updated for Synergy 9.5


Notes
-----

result = %axl_sortable(listid [, setname] [, methodset] [, asc_ind] [, desc_ind] [, front])

where

result is the returned result (TRUE if successful).
listid is the ID of the ActiveX list to be affected
setname is the optional input set name within the list's associated input window
methodset is an optional UWNDEVENTS_METHOD set to apply to the list
asc_ind is an optional string to add to a column header when sorted in ascending order.
desc_ind is an optional string to add to a column header when sorted in descending order.
front is an optional Boolean for inserting sort indicators at the front



result = %axl_sort(listid, [mdata, ...])

where

result is the returned result (TRUE for success)
listid is the ID of the list to sort
mdata are up to 20 optional method data arguments



result = %axl_reset(listid [, keepsort])

where

result is returned TRUE of successful, or FALSE if not
keepsort is an optional flag to indicate that existing sort be preserved



result = %axl_getsort(listid [, column] [, order])

where

result is returned TRUE if the list is sortable, otherwise FALSE
column is the optional returned sort column
order is the optional returned sort order



result = %axl_setsort(listid [, column] [, order])

where

result is returned TRUE if successful, otherwise FALSE
listid is the ID of the list
column is the optional column number to sort by
order is the optional order (ascending or descending)



The default method AXLE_LEFT_CLICK is provided for you, but
it is possible for this method to override the provided click
method by providing a method set id to %axl_sortable,



Discussion
----------

To enable sorting for an ActiveX list, you must first call axl_sortable.
For example you would do:

        xcall axl_sortable(listid,,, "^", "v")

This tells the axlsort plugin that we will sort the list based on field
definitions in the first input set of the window (you can pass the set name
if you want to use a different set).  We'll let axlsort handle all of the
window events (that's another optional parameter), and we'll use "^" and "v"
as indicators that get added to the end of the column header text when that
column is sorted ascending and descending, respectively.

The only other thing you must do to enable user sorting by clicking the headings
is to handle the menu entry "O_SORTLIST" by calling axl_sort.  For example:

        repeat
          begin
            xcall l_select(listid, req, data)
            if (g_select)
              begin
                using g_entnam select
("O_SORTLIST "),  xcall axl_sort(listid)
                endusing
              end
          end

If your load method uses method data arguments, you can pass them to axl_sort
as optional parameters.  axl_sort will load the entire list into memory and
sort it according to the last selected criteria or user mouse click.

Another routine, axl_setsort, can be used to programmatically select the
sort order:

        xcall axl_setsort(listid, columnnum, order)

where columnnum is the ordinal column number, and order is D_SORT_ASC or
D_SORT_DESC, defined in axlsort.def.  The list is not actually sorted until
you call axl_sort, so that you can pass the method data arguments if needed.

A final routine, axl_reset, can be used to force the list to reload.  You might
need to do that before calling L_RESTART.  Otherwise, the load method would
not be invoked, and any new items you wanted to load would not be seen.  When
calling axl_reset, you have the option to preserve the current sort order, or
to reset to an unsorted state.  Again, the list is not actually sorted until
axl_sort is called.  For an example of how this works, see testsort.dbl.

To build the example on Windows, use bld.bat.  This creates testsort.dbr.  If
you look at the code in testsort.dbl, you will see four .defines that can be
commented out or not to test various options:

.define FRONT_SORT_IND          ; Places the sort indicators at the front
.define MULTILINE_LIST          ; Creates a multi-line list (def = single)
.define USE_LINPUT              ; Uses L_INPUT instead of L_SELECT
.define RELOAD_KEEPS_SORT       ; Pressing the "Reload" button keeps the sort order

We decided to provide axlsort in Code Exchange rather than building it into
the UI Toolkit because it doesn't meet the needs of all lists for all developers.
There are so many things you might want to customize about this feature that we
thought you should just have the code and make whatever modifications you desire.
You might not even use this code, but maybe you'll get some ideas from it, or be
able to use parts of it.
