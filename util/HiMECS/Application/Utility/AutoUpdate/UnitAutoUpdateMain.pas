{******************************************************************************}
{ TWEBUPDATE component sample project                                          }
{ for Delphi & C++Builder                                                      }
{                                                                              }
{ Uses update control file at : http://www.tmssoftware.com/update/sampapp.inf  }
{                                                                              }
{ written by                                                                   }
{    TMS Software                                                              }
{    copyright ?1998-2013                                                     }
{    Email : info@tmssoftware.com                                              }
{    Web   : http://www.tmssoftware.com                                        }
{                                                                              }
{ The source code is given as is. The author is not responsible                }
{ for any possible damage done due to the use of this code.                    }
{ The component can be freely used in any application. The source              }
{ code remains property of the writer and may not be distributed               }
{ freely as such.                                                              }
{******************************************************************************}

unit UnitAutoUpdateMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  wupdate, StdCtrls, UnitAutoUpdateproxy, ExtCtrls, UnitAutoUpdateSelComp, ComCtrls, Registry;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    WebUpdate1: TWebUpdate;
    Threaded: TCheckBox;
    ProgressBar1: TProgressBar;
    Label2: TLabel;
    Button2: TButton;
    Dlgs: TCheckBox;
    Image1: TImage;
    StatusBar1: TStatusBar;
    procedure Button1Click(Sender: TObject);
    procedure WebUpdate1Status(Sender: TObject; statusstr: String;
      statuscode, errcode: Integer);
    procedure WebUpdate1AppRestart(Sender: TObject; var allow: Boolean);
    procedure WebUpdate1FileProgress(Sender: TObject; filename: String;
      pos, size: Integer);
    procedure Button2Click(Sender: TObject);
    procedure WebUpdate1GetFileList(Sender: TObject; list: TStringList);
    procedure FormCreate(Sender: TObject);
    procedure WebUpdate1AppDoClose(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

const

  D3 = '\Software\Borland\Delphi\3.0';
  D4 = '\Software\Borland\Delphi\4.0';
  D5 = '\Software\Borland\Delphi\5.0';
  D6 = '\Software\Borland\Delphi\6.0';

  C3 = '\Software\Borland\C++Builder\3.0';
  C4 = '\Software\Borland\C++Builder\4.0';
  C5 = '\Software\Borland\C++Builder\5.0';
  C6 = '\Software\Borland\C++Builder\6.0';

procedure TForm1.Button1Click(Sender: TObject);
var
  VerInfo: TOSVersionInfo;
  OSVersion: string;
  DevPlatforms: string;

  function IsPlatformInstalled (const Platform: string): Boolean;
  var
    Reg: TRegistry;
  begin
    Reg := TRegistry.Create;
    try
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      Result := Reg.OpenKey (Platform, False);
      Reg.CloseKey;
    finally
      Reg.Free
    end;
  end;

begin
  VerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  GetVersionEx(verinfo);
  OSVersion := IntToStr(verinfo.dwMajorVersion)+':'+IntToStr(verinfo.dwMinorVersion);

  DevPlatforms := '';

  if IsPlatformInstalled(D3) then
    DevPlatforms := DevPlatforms + 'D3';
  if IsPlatformInstalled(D4) then
    DevPlatforms := DevPlatforms + 'D4';
  if IsPlatformInstalled(D5) then
    DevPlatforms := DevPlatforms + 'D5';
  if IsPlatformInstalled(D6) then
    DevPlatforms := DevPlatforms + 'D6';

  if IsPlatformInstalled(C3) then
    DevPlatforms := DevPlatforms + 'C3';
  if IsPlatformInstalled(C4) then
    DevPlatforms := DevPlatforms + 'C4';
  if IsPlatformInstalled(C5) then
    DevPlatforms := DevPlatforms + 'C5';
  if IsPlatformInstalled(C6) then
    DevPlatforms := DevPlatforms + 'C6';

  WebUpdate1.PostUpdateInfo.Data :=
    WebUpdate1.PostUpdateInfo.Data + '&TIME='+FormatDateTime('dd/mm/yyyy@hh:nn',Now)+'&OS='+OSVersion+'&DEV='+DevPlatforms;

  if Threaded.Checked then
    WebUpdate1.DoThreadupdate
  else
    WebUpdate1.DoUpdate;
end;

procedure TForm1.WebUpdate1Status(Sender: TObject; StatusStr: String;
  Statuscode, Errcode: Integer);
begin
  if Dlgs.Checked then
    MessageDlg(StatusStr,mtInformation,[mbok],0);

  if StatusCode = WebUpdateNoNewVersion then
    MessageDlg('No new version available',mtinformation,[mbok],0);

  if StatusCode = WebUpdateNotFound then
    MessageDlg(StatusStr + #13'Update discontinued',mtinformation,[mbok],0);

  StatusBar1.SimpleText := StatusStr;
end;

procedure TForm1.WebUpdate1AppRestart(Sender: TObject; var allow: Boolean);
begin
  Allow := MessageDlg('Shutting down application to update executable files ?',mtConfirmation,[mbYes,mbNo],0)=mrYes;
end;

procedure TForm1.WebUpdate1FileProgress(Sender: TObject; filename: String;
  pos, size: Integer);
begin
  progressbar1.max:=size;
  progressbar1.position:=pos;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  proxy:tproxy;
begin
  proxy:=tproxy.Create(self);
  with proxy do
  begin
    edit1.text:=webupdate1.proxy;
    edit2.text:=webupdate1.proxyuserid;
    edit3.text:=webupdate1.proxypassword;
  end;
  try
  if proxy.showmodal=mrok then
  begin
    webupdate1.proxy:=proxy.edit1.text;
    webupdate1.proxyuserid:=proxy.edit2.text;
    webupdate1.proxypassword:=proxy.edit3.text;
  end;
  finally
   proxy.free;
 end;
end;

procedure TForm1.WebUpdate1GetFileList(Sender: TObject; list: TStringList);
var
  i:integer;
  selcomp: TSelcomp;
  mr:integer;
begin
  selcomp := TSelcomp.create(self);
  try
    SelComp.Checklist.items.Assign(list);

    for i := 1 to list.Count do
      SelComp.Checklist.Checked[i - 1] := True;

    mr := selcomp.ShowModal;

    for i := 1 to list.count do
    begin
      if (mr = mrCancel) or
        (not SelComp.checklist.Checked[i - 1]) then
          list.strings[i-1] := '';
    end;
  finally
    SelComp.Free;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Image1.Picture.loadfromfile('logo.bmp');
end;

procedure TForm1.WebUpdate1AppDoClose(Sender: TObject);
begin
  Close;
end;

end.
