;*****************************************************************************
;
; Title:        CopyHandle
;
; Description:  Copies the contents of one memory handle to another
;
; Author:       Steve Ives (Synergex Professional Services Group)
;
; Date:         1st June 2006
;
; Platforms:    All platforms
;
; Discussion:   This routine copies the comtents of one memory handle into a
;               second memory handle, and returns the second handle.  The
;               size of the retruned handle will always be the same as the size
;               of the original handle. It is the responsibility of the calling
;               routine to deallocate the returned memory handle, which is
;               static.
;
; Modification History:
;               Updated for compatiblity with Synergy 9.5
;
;*****************************************************************************
;
; This code is supplied as seen and without warranty or support, and is used
; at your own risk. Neither the author or Synergex accept any responsability
; for any loss or damage which may result from the use of this code.
;
;*****************************************************************************
;
