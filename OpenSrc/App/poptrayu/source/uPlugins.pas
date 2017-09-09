unit uPlugins;

{-------------------------------------------------------------------------------
POPTRAY
Copyright (C) 2003-2005  Renier Crause
All Rights Reserved.

This is free software.

Permission to use, copy, modify, and distribute this software and
its documentation for any purpose, without fee, and without written
agreement is hereby granted, provided that the above copyright
notice appear in all copies of this software.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
-------------------------------------------------------------------------------}

interface


const
  INTERFACE_VERSION = 3;

type
  TPluginType = (piNotify, piProtocol, piRuleAction);


  TPlugin = class(TObject)
  public
    PluginType : TPluginType;
    Name : string;
    DLLName : string;
    hPlugin : THandle;
    Enabled : boolean;
    FInit : procedure; stdcall;
    FFreePChar : procedure (var p : PChar); stdcall;
    FUnload : procedure; stdcall;
    procedure Init;
    procedure FreePChar(var p : PChar);
    procedure Unload;
  end;

  TPluginNotify = class(TPlugin)
  public
    FNotify : procedure (MailCount,UnviewedCount,NewCount : integer; ResetTray : boolean);  stdcall;
    FNotifyAccount : procedure (AccountNo:integer; AccountName,AccountColor:PChar; MailCount,UnviewedCount,NewCount : integer; ResetTray : boolean);  stdcall;
    FMessageCheck : procedure (MsgFrom,MsgTo,MsgSubject : PChar; MsgDate : TDateTime; Viewed,New,Important,Spam : boolean);  stdcall;
    FMessageBody : procedure (MsgHeader,MsgBody : PChar);  stdcall;
    procedure Notify(MailCount,UnviewedCount,NewCount : integer; ResetTray : boolean);
    procedure NotifyAccount(AccountNo:integer; AccountName,AccountColor:PChar; MailCount,UnviewedCount,NewCount : integer; ResetTray : boolean);
    procedure MessageCheck(MsgFrom,MsgTo,MsgSubject : PChar; MsgDate : TDateTime; Viewed,New,Important,Spam : boolean);
    procedure MessageBody(MsgHeader,MsgBody : PChar);
  end;



var
  Plugins : array of TPlugin;

implementation

uses
  SysUtils;

{ TPlugin }

procedure TPlugin.Init;
begin
  if Assigned(FInit) then FInit;
end;

procedure TPlugin.FreePChar(var p : PChar);
begin
  if Assigned(FFreePChar) then
    FFreePChar(p)
  else begin
    StrDispose(p);
    p := nil;
  end;
end;

procedure TPlugin.Unload;
begin
  if Assigned(FUnload) then FUnload;
end;

{ TPluginNotify }

procedure TPluginNotify.Notify(MailCount, UnviewedCount, NewCount: integer; ResetTray: boolean);
begin
  if Assigned(FNotify) then
    FNotify(MailCount, UnviewedCount, NewCount,  ResetTray);
end;

procedure TPluginNotify.NotifyAccount(AccountNo:integer; AccountName,AccountColor:PChar; MailCount,UnviewedCount,NewCount : integer; ResetTray : boolean);
begin
  if Assigned(FNotifyAccount) then
    FNotifyAccount(AccountNo, AccountName, AccountColor, MailCount, UnviewedCount, NewCount,  ResetTray);
end;

procedure TPluginNotify.MessageCheck(MsgFrom, MsgTo, MsgSubject: PChar;
  MsgDate: TDateTime; Viewed, New, Important, Spam: boolean);
begin
  if Assigned(FMessageCheck) then
    FMessageCheck(MsgFrom, MsgTo, MsgSubject, MsgDate, Viewed, New, Important, Spam);
end;


procedure TPluginNotify.MessageBody(MsgHeader, MsgBody : PChar);
begin
  if Assigned(FMessageBody) then
    FMessageBody(MsgHeader, MsgBody);
end;



end.
