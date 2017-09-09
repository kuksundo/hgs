{ *********************************************************************** }
{                                                                         }
{ GraphBuilder                                                            }
{                                                                         }
{ Copyright (c) 2006 Pisarev Yuriy (post@pisarev.net)                     }
{                                                                         }
{ *********************************************************************** }

program GraphBuilder;

uses
  Forms,
  MainForm in 'MainForm.pas' {Main};

begin
  Application.Initialize;
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
