
{*******************************************************}
{                                                       }
{       OPC status and error codes                      }
{                                                       }
{       Delphi conversion supplied by                   }
{       OPC Programmers' Connection                     }
{       http://dspace.dial.pipex.com/opc/               }
{       mailto:opc@dial.pipex.com                       }
{                                                       }
{*******************************************************}

unit OPCerror;

{
Module Name:
    OpcError.h
Author:
    OPC Task Force
Revision History:
Release 1.0A
     Removed Unused messages
     Added OPC_S_INUSE, OPC_E_INVALIDCONFIGFILE, OPC_E_NOTFOUND
Release 2.0
     Added OPC_E_INVALID_PID

Module Name:
    opcae_er.h
Author:
    Jim Luth - OPC Alarm & Events Committee
Revision History:
}

{
Code Assignements:
  0000 to 0200 are reserved for Microsoft use 
  (although some were inadverdantly used for OPC Data Access 1.0 errors). 
  0200 to 7FFF are reserved for future OPC use. 
  8000 to FFFF can be vendor specific.
}

interface

uses
  Windows;

const

  //
  //  Values are 32 bit values laid out as follows:
  //
  //   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
  //   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
  //  +---+-+-+-----------------------+-------------------------------+
  //  |Sev|C|R|     Facility          |               Code            |
  //  +---+-+-+-----------------------+-------------------------------+
  //
  //  where
  //
  //      Sev - is the severity code
  //
  //          00 - Success
  //          01 - Informational
  //          10 - Warning
  //          11 - Error
  //
  //      C - is the Customer code flag
  //
  //      R - is a reserved bit
  //
  //      Facility - is the facility code
  //
  //      Code - is the facility's status code
  //

  // OPC Data Access
  
  //
  // MessageId: OPC_E_INVALIDHANDLE
  //
  // MessageText:
  //
  //  The value of the handle is invalid.
  //
  OPC_E_INVALIDHANDLE = HResult($C0040001);

  //
  // MessageId: OPC_E_BADTYPE
  //
  // MessageText:
  //
  //  The server cannot convert the data between the
  //  requested data type and the canonical data type.
  //
  OPC_E_BADTYPE = HResult($C0040004);

  //
  // MessageId: OPC_E_PUBLIC
  //
  // MessageText:
  //
  //  The requested operation cannot be done on a public group.
  //
  OPC_E_PUBLIC = HResult($C0040005);

  //
  // MessageId: OPC_E_BADRIGHTS
  //
  // MessageText:
  //
  //  The Items AccessRights do not allow the operation.
  //
  OPC_E_BADRIGHTS = HResult($C0040006);

  //
  // MessageId: OPC_E_UNKNOWNITEMID
  //
  // MessageText:
  //
  //  The item is no longer available in the server address space.
  //
  OPC_E_UNKNOWNITEMID = HResult($C0040007);

  //
  // MessageId: OPC_E_INVALIDITEMID
  //
  // MessageText:
  //
  //  The item definition doesn't conform to the server's syntax.
  //
  OPC_E_INVALIDITEMID = HResult($C0040008);

  //
  // MessageId: OPC_E_INVALIDFILTER
  //
  // MessageText:
  //
  //  The filter string was not valid.
  //
  OPC_E_INVALIDFILTER = HResult($C0040009);

  //
  // MessageId: OPC_E_UNKNOWNPATH
  //
  // MessageText:
  //
  //  The item's access path is not known to the server.
  //
  OPC_E_UNKNOWNPATH = HResult($C004000A);

  //
  // MessageId: OPC_E_RANGE
  //
  // MessageText:
  //
  //  The value was out of range.
  //
  OPC_E_RANGE = HResult($C004000B);

  //
  // MessageId: OPC_E_DUPLICATENAME
  //
  // MessageText:
  //
  //  Duplicate name not allowed.
  //
  OPC_E_DUPLICATENAME = HResult($C004000C);

  //
  // MessageId: OPC_S_UNSUPPORTEDRATE
  //
  // MessageText:
  //
  //  The server does not support the requested data rate
  //  but will use the closest available rate.
  //
  OPC_S_UNSUPPORTEDRATE = HResult($0004000D);

  //
  // MessageId: OPC_S_CLAMP
  //
  // MessageText:
  //
  //  A value passed to WRITE was accepted but the output was clamped.
  //
  OPC_S_CLAMP = HResult($0004000E);

  //
  // MessageId: OPC_S_INUSE
  //
  // MessageText:
  //
  //  The operation cannot be completed because the
  //  object still has references that exist.
  //
  OPC_S_INUSE = HResult($0004000F);

  //
  // MessageId: OPC_E_INVALIDCONFIGFILE
  //
  // MessageText:
  //
  //  The server's configuration file is an invalid format.
  //
  OPC_E_INVALIDCONFIGFILE = HResult($C0040010);

  //
  // MessageId: OPC_E_NOTFOUND
  //
  // MessageText:
  //
  //  The server could not locate the requested object.
  //
  OPC_E_NOTFOUND = HResult($C0040011);

  //
  // MessageId: OPC_E_INVALID_PID
  //
  // MessageText:
  //
  //  The server does not recognise the passed property ID.
  //
  OPC_E_INVALID_PID = HResult($C0040203);

  // OPC Alarms & Events
  
  //
  // MessageId: OPC_S_ALREADYACKED
  //
  // MessageText:
  //
  //  The condition has already been acknowleged
  //
  OPC_S_ALREADYACKED = HResult($00040200);
  
  //
  // MessageId: OPC_S_INVALIDBUFFERTIME
  //
  // MessageText:
  //
  //  The buffer time parameter was invalid
  //
  OPC_S_INVALIDBUFFERTIME = HResult($00040201);
  
  //
  // MessageId: OPC_S_INVALIDMAXSIZE
  //
  // MessageText:
  //
  //  The max size parameter was invalid
  //
  OPC_S_INVALIDMAXSIZE = HResult($00040202);
  
  //
  // MessageId: OPC_E_INVALIDBRANCHNAME
  //
  // MessageText:
  //
  //  The string was not recognized as an area name
  //
  OPC_E_INVALIDBRANCHNAME = HResult($C0040203);
  
  //
  // MessageId: OPC_E_INVALIDTIME
  //
  // MessageText:
  //
  //  The time does not match the latest active time
  //
  OPC_E_INVALIDTIME = HResult($C0040204);
  
  //
  // MessageId: OPC_E_BUSY
  //
  // MessageText:
  //
  //  A refresh is currently in progress
  //
  OPC_E_BUSY = HResult($C0040205);
  
  //
  // MessageId: OPC_E_NOINFO
  //
  // MessageText:
  //
  //  Information is not available
  //
  OPC_E_NOINFO = HResult($C0040206);
  
implementation

end.
