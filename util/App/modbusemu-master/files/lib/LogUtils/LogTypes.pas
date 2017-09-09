unit LogTypes;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF WINDOWS}
  Windows, Messages,
  {$ENDIF}
  LogConst;

type
  TMsgType =( msgDebug   = -1, msgInfo    =  0, msgWarning =  1, msgError   =  2 );
  TEventlogMsgProc = procedure (Message: String; EventType: DWord = 1; Category: Integer = 0; ID: Integer = 0) of object;
  TSimpleLogProcType = procedure (Sender : TObject; LogMess: String) of object;
  PMsgRecord = ^TMsgRecord;
  TMsgRecord = record
   msgTime  : TDateTime;
   msgType  : TMsgType;
   msgCode  : Cardinal;
   msgLine1 : PChar;
   msgLine2 : PChar;
   msgLine3 : PChar;
  end;
const
  msgTypes: array [TMsgType] of String =( rsDebug, rsInfo, rsWarning, rsError);
  {$IFDEF WINDOWS}
  WM_LOG_MSG  = WM_APP+500;
  {$ENDIF}

implementation

end.
