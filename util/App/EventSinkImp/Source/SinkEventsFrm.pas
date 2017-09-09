//******************************************************************************
//
// EventSinkImp
//
// Copyright © 1999-2000 Binh Ly
// All Rights Reserved
//
// bly@techvanguards.com
// http://www.techvanguards.com
//******************************************************************************
unit SinkEventsFrm;

interface

uses
  Windows, Controls, Forms, Dialogs, ExtCtrls, Classes, StdCtrls,
  EventSinkParser, ComCtrls;

type
  TfrmSinkEvents = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    lbxTypeLibs: TListBox;
    Label2: TLabel;
    btnOk: TButton;
    Button2: TButton;
    Label3: TLabel;
    edtOutputFolder: TEdit;
    Button3: TButton;
    edtLibFilename: TEdit;
    Button1: TButton;
    dlgOpenLocalTypeLib: TOpenDialog;
    Button4: TButton;
    Button5: TButton;
    lvwInterfaces: TListView;
    Button6: TButton;
    procedure FormShow(Sender: TObject);
    procedure lbxTypeLibsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button3Click(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure lbxTypeLibsDblClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure lbxTypeLibsKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button6Click(Sender: TObject);
  private
    FLocalTypeLib: TRegTypeLib;
    FRegTypeLibs: TRegTypeLibs;
    FTypeLibNames: TStringList;
    FTypeLibTypeAhead: string;
    FTypeLibTypeAheadLastTime: integer;
    function OnHelp (Command: Word; Data: Longint;
      var CallHelp: Boolean): Boolean;
  public
    procedure BrowseLocalTypeLib;
    procedure BrowseOutputFolder;
    function Execute: integer;
    function GetDefaultImportFolder: string;
    procedure ImportSinkEvents;
    procedure LoadTypeLibraries;
    function OutputFolder: string;
    function SelRegTypeLib: TRegTypeLib;
    procedure UpdateLibFilename;
    procedure UpdateSinkInterfaces;
    procedure UpdateTypeLibInfo;
  end;

var
  frmSinkEvents: TfrmSinkEvents;

const
  cDelphiVersion6 = 'Delphi\6.0';
  cDelphiVersion5 = 'Delphi\5.0';
  cDelphiVersion4 = 'Delphi\4.0';
  cBCBVersion4 = 'C++Builder\4.0';
  cDelphiVersion3 = 'Delphi\3.0';

  cTLibImpExe: string = 'TLIBIMP.EXE';
  cOptionsFile: string = 'EventSinkImp.ini';

implementation

{$R *.DFM}

uses
  AboutFrm, EventSinkOptions, FileCtrl, OptionsFrm, Registry, SysUtils, Utils;

procedure RunAppAndWait (const App: string);
var
  si: TStartupInfo;
  pi: TProcessInformation;
  CmdLine: string;
begin
  Fillchar (si, sizeof (si), 0);
  Fillchar (pi, sizeof (pi), 0);
  CmdLine := App;
  if not (CreateProcess (
    nil, pchar (CmdLine), nil, nil, TRUE, 0, nil, nil, si, pi))
  then begin
    ShowMessage ('Unable to run: ' + CmdLine);
    RaiseLastWin32Error;
  end;
  Screen.Cursor := crHourglass;
  try
    WaitForSingleObject (pi.hProcess, INFINITE);
  finally
    Screen.Cursor := crDefault;
  end;  { finally }
end;

function GetDelphiFolderEx (var sVersion: string): string;
const
  cVersions: array [1..5] of string = (
    cDelphiVersion6,
    cDelphiVersion5,
    cDelphiVersion4,
    cBCBVersion4,
    cDelphiVersion3
  );
var
  reg: TRegistry;
  i: integer;
  sPath: string;
begin
  Result := '';
  sVersion := '';

  { HKLM\Software\Borland\Delphi\Version\RootDir }
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_LOCAL_MACHINE;
    for i := Low (cVersions) to High (cVersions) do
    begin
      sPath := Format ('Software\Borland\%s', [cVersions [i]]);
      if not (reg.OpenKey (sPath, FALSE)) then Continue;
      sPath := reg.ReadString ('RootDir');
      reg.CloseKey;

      if (sPath <> '') then
      begin
        Result := sPath;
        if (Result <> '') then
          if (Result [Length (Result)] = '\') then Delete (Result, Length (Result), 1);
        sVersion := cVersions [i];
        Break;
      end;  { if }
    end;  { for }
  finally
    reg.Free;
  end;  { finally }
end;

function GetDelphiFolder: string;
var
  sVersion: string;
begin
  Result := GetDelphiFolderEx (sVersion);
end;

function GetOptionsFilename: string;
begin
  Result := ExtractFilepath (Application.ExeName) + cOptionsFile;
end;


{ TfrmSinkEvents }

procedure TfrmSinkEvents.BrowseLocalTypeLib;
begin
  with dlgOpenLocalTypeLib do
  begin
    if not (Execute) then Exit;
    if (FLocalTypeLib = nil) then FLocalTypeLib := TRegTypeLib.Create;
    try
      try
        FLocalTypeLib.LoadInfo (Filename);
        lbxTypeLibs.ItemIndex := -1;
      except
        FLocalTypeLib.Free;
        FLocalTypeLib := nil;
        raise;
      end;  { except }
    finally
      UpdateLibFilename;
      UpdateSinkInterfaces;
    end;  { finally }
  end;  { with }
end;

procedure TfrmSinkEvents.BrowseOutputFolder;
var
  sFolder: string;
begin
  sFolder := '';
  if not (SelectDirectory ('Output folder:', sFolder, sFolder)) then Exit;
  edtOutputFolder.Text := sFolder;
end;

function TfrmSinkEvents.Execute: integer;
begin
  Result := mrOk;
  Show;
end;

function TfrmSinkEvents.GetDefaultImportFolder: string;
begin
  Result := GetDelphiFolder;
  if (DirectoryExists (Result + '\Imports')) then Result := Result + '\Imports';
end;

procedure TfrmSinkEvents.ImportSinkEvents;
var
  eso: TEventSinkOptions;

 procedure ValidateImportLib (lstInterfaces: TStrings);
 var
   i: integer;
 begin
   if (SelRegTypeLib = nil) then
     raise Exception.Create ('No selected type library');

   if not (FileExists (SelRegTypeLib.Filename)) then
     raise Exception.Create ('Unable to locate: ' + SelRegTypeLib.Filename);

   lstInterfaces.Clear;
   for i := 0 to lvwInterfaces.Items.Count - 1 do
     if (lvwInterfaces.Items [i].Checked) then
       lstInterfaces.Add (lvwInterfaces.Items [i].Caption);

   if (lstInterfaces.Count <= 0) then
     raise Exception.Create ('No selected interfaces for this type library');
 end;

 procedure ValidateOutputFolder;
 begin
   if not (DirectoryExists (OutputFolder)) then
     raise Exception.Create ('Invalid output folder: ' + OutputFolder);
 end;

 function GenerateTypeLibSource (rtl: TRegTypeLib; var sOutputFile: string): boolean;
 var
   sLibImpExe, sBaseCmdLine, sCmdLine, sLibImpVersion: string;
   mr: integer;
 begin
   Assert ((rtl <> nil) and (eso <> nil));
   //Result := FALSE;

   { check for overwrite }
   sOutputFile := Format ('%s_TLB.pas', [OutputFolder + '\' + rtl.Libname]);
   if (FileExists (sOutputFile)) then
   begin
     mr := MessageDlg ('File: ' + sOutputFile + ' already exists. Overwrite?',
                       mtConfirmation, [mbYes, mbNo], 0);
     if (mr <> mrYes) then Abort;
     //delete it
     DeleteFile (sOutputFile);
   end;  { if }

   { find TLibImp }
   sLibImpExe := cTLibImpExe;
   sLibImpVersion := '';  //unknown version

   { eso.TLibImpAutoFind overrides! }
   if not (eso.TLibImpAutoFind) then
     sLibImpExe := eso.TLibImpFile;

   if not (FileExists (sLibImpExe)) then
   begin
     sLibImpExe := GetDelphiFolderEx (sLibImpVersion) + '\bin\' + cTLibImpExe;
     if not (FileExists (sLibImpExe)) then
       sLibImpExe := ExtractFilepath (Application.ExeName) + cTLibImpExe;
   end;  { else }

   { verify TLibImp }
   if not (FileExists (sLibImpExe)) then
     raise Exception.Create ('Unable to locate Borland''s ' + cTLibImpExe + ' utility');

   sBaseCmdLine := Format ('"%s" -d"%s" "%s"', [sLibImpExe, OutputFolder, rtl.Filename]);
   sCmdLine := Format ('"%s" -p+ -c- -d"%s" "%s"', [sLibImpExe, OutputFolder, rtl.Filename]);

   { run it }
   RunAppAndWait (sCmdLine);
   //if output is not available, assume that tlibimp is D3 version and it choked
   //on -p and -c. therefore, try to run it again without the extra params
   if not (FileExists (sOutputFile)) then
     RunAppAndWait (sBaseCmdLine);

   { verify output }
   if not (FileExists (sOutputFile)) then
     raise Exception.Create ('Unable to import type library file: ' + rtl.Filename);

   Result := TRUE;
 end;

 procedure BuildSinkComponents (rtl: TRegTypeLib; const sLibSourceFile: string;
   lstSourceFiles, lstInterfaces: TStrings
 );
 var
   lstTypeLibSource, lstSinkSource: TStringList;
   scb: TSinkComponentBuilder;
   sUnitName, sSinkFile: string;
   mr: integer;
 begin
   Assert ((rtl <> nil) and (eso <> nil));
   lstTypeLibSource := TStringList.Create;
   lstSinkSource := TStringList.Create;
   scb := TSinkComponentBuilder.Create;
   try
     lstTypeLibSource.LoadFromFile (sLibSourceFile);
     scb.Template.LoadFromFile (ExtractFilepath (Application.ExeName) + eso.SinkTemplateName);

     { build sink component }
     lstSinkSource.Clear;

     sUnitName := Format ('%sEvents', [rtl.LibName]);

     { verify sink file }
     sSinkFile := Format ('%s.pas', [OutputFolder + '\' + sUnitName]);
     if (FileExists (sSinkFile)) then
     begin
       mr := MessageDlg ('File: ' + sSinkFile + ' already exists. Overwrite?',
                         mtConfirmation, [mbYes, mbNo], 0);
       if (mr <> mrYes) then Exit;
     end;  { if }

     Screen.Cursor := crHourglass;
     try
       scb.BuildSource (eso, sLibSourceFile, sUnitName, rtl.LibName,
         lstSinkSource, lstTypeLibSource, lstInterfaces);
       if (lstSourceFiles <> nil) then lstSourceFiles.Add (sUnitName + '.pas');
     finally
       Screen.Cursor := crDefault;
     end;  { finally }

     { write to file }
     lstSinkSource.SaveToFile (sSinkFile);

   finally
     scb.Free;
     lstSinkSource.Free;
     lstTypeLibSource.Free;
   end;  { finally }
 end;

var
  sOutputFile: string;
  lstSourceFiles, lstInterfaces: TStrings;
begin
  lstInterfaces := TStringList.Create;
  try
    ValidateImportLib (lstInterfaces);
    ValidateOutputFolder;

    eso := TEventSinkOptions.Create;
    lstSourceFiles := TStringList.Create;
    try
      eso.LoadFromFile (GetOptionsFilename);

      { generate TypeLib_TLB.pas }
      if not (GenerateTypeLibSource (SelRegTypeLib, sOutputFile)) then Abort;
      Application.ProcessMessages;

      { generate Sink source }
      BuildSinkComponents (SelRegTypeLib, sOutputFile, lstSourceFiles, lstInterfaces);

      { prompt user of what we did }
      if (lstSourceFiles.Count > 0) then
        MessageDlg (
          'The following component/class file(s) were generated.'#13 +
          'You may need to install these components/classes in order to use them in your applications.'#13#13 +
          lstSourceFiles.Text, mtInformation, [mbOk], 0
        );
    finally
      lstSourceFiles.Free;
      eso.Free;
    end;  { finally }
  finally
    lstInterfaces.Free;
  end;
end;

procedure TfrmSinkEvents.LoadTypeLibraries;
var
  i, j: integer;
begin
  Screen.Cursor := crHourglass;
  try
    lbxTypeLibs.Items.Clear;
    FTypeLibNames.Clear;
    if (FRegTypeLibs = nil) then FRegTypeLibs := TRegTypeLibs.Create;
    FRegTypeLibs.ReadRegistry;
    for i := 0 to FRegTypeLibs.Count - 1 do
    begin
      j := lbxTypeLibs.Items.AddObject (FRegTypeLibs.Items [i].Description, FRegTypeLibs.Items [i]);
      FTypeLibNames.AddObject (FRegTypeLibs.Items [i].Description, pointer (j));
    end;  { for }
  finally
    Screen.Cursor := crDefault;
  end;  { finally }
end;

function TfrmSinkEvents.OutputFolder: string;
begin
  Result := edtOutputFolder.Text;
  if (Result <> '') then
    if (Result [Length (Result)] = '\') then Delete (Result, Length (Result), 1);
end;

function TfrmSinkEvents.SelRegTypeLib: TRegTypeLib;
begin
  Result := FLocalTypeLib;
  if (Result <> nil) then Exit;
  if (lbxTypeLibs.ItemIndex < 0) then Exit;
  Result := TRegTypeLib (lbxTypeLibs.Items.Objects [lbxTypeLibs.ItemIndex]);
end;

procedure TfrmSinkEvents.UpdateLibFilename;
begin
  edtLibFilename.Text := '';
  if (SelRegTypeLib = nil) then Exit;
  edtLibFilename.Text := SelRegTypeLib.Filename;
end;

procedure TfrmSinkEvents.UpdateSinkInterfaces;
var
  i, SourceIndex: integer;
  IsSource: boolean;
  ListItem: TListItem;
  lstInterfaces: TStrings;
begin
  lvwInterfaces.Items.Clear;
  if (SelRegTypeLib = nil) then Exit;
  lstInterfaces := TStringList.Create;
  try
    //get list
    SelRegTypeLib.FindSourceInterfaces (lstInterfaces);
    //load list
    //SourceIndex is used to put all sink interfaces first
    SourceIndex := 0;
    for i := 0 to lstInterfaces.Count - 1 do
    begin
      IsSource := (lstInterfaces.Objects [i] <> nil);
      if (IsSource) then
      begin
        ListItem := lvwInterfaces.Items.Insert (SourceIndex);
        SourceIndex := SourceIndex + 1;
      end
      else
        ListItem := lvwInterfaces.Items.Add;
      ListItem.Caption := lstInterfaces [i];
      //if source, check it
      if (IsSource) then ListItem.Checked := True;
    end;
  finally
    lstInterfaces.Free;
  end;
end;

procedure TfrmSinkEvents.FormShow(Sender: TObject);
begin
  UpdateTypeLibInfo;
  edtOutputFolder.Text := GetDefaultImportFolder;
  Caption := Caption + ' ' + GetAppVersion;
end;

procedure TfrmSinkEvents.lbxTypeLibsClick(Sender: TObject);
begin
  FLocalTypeLib := nil;
  UpdateLibFilename;
  UpdateSinkInterfaces;
end;

procedure TfrmSinkEvents.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if (FRegTypeLibs <> nil) then FRegTypeLibs.Free;
  if (FLocalTypeLib <> nil) then FLocalTypeLib.Free;
  FTypeLibNames.Free;
end;

procedure TfrmSinkEvents.Button3Click(Sender: TObject);
begin
  BrowseOutputFolder;
end;

procedure TfrmSinkEvents.btnOkClick(Sender: TObject);
begin
  ImportSinkEvents;
end;

procedure TfrmSinkEvents.lbxTypeLibsDblClick(Sender: TObject);
begin
  btnOkClick (Sender);
end;

procedure TfrmSinkEvents.Button1Click(Sender: TObject);
begin
  BrowseLocalTypeLib;
end;

procedure TfrmSinkEvents.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmSinkEvents.Button4Click(Sender: TObject);
begin
  with TfrmAbout.Create (Self) do
  try
    ShowModal;
  finally
    Free;
  end;  { finally }
end;

procedure TfrmSinkEvents.UpdateTypeLibInfo;
begin
  lbxTypeLibs.ItemIndex := -1;
  LoadTypeLibraries;
  UpdateLibFilename;
  UpdateSinkInterfaces;
end;

procedure TfrmSinkEvents.Button5Click(Sender: TObject);
var
  eso: TEventSinkOptions;
  frm: TfrmOptions;
begin
  eso := TEventSinkOptions.Create;
  frm := TfrmOptions.Create (Self);
  try
    eso.LoadFromFile (GetOptionsFilename);
    if (frm.Execute (eso) = mrOk) then
      eso.SaveToFile (GetOptionsFilename);
  finally
    frm.Free;
    eso.Free;
  end;  { finally }
end;

procedure TfrmSinkEvents.lbxTypeLibsKeyPress(Sender: TObject;
  var Key: Char);
const
  cTypeAheadMaxTimeGap = 1500;  // 1.5 secs
var
  i: integer;
begin
  { handle type-ahead }

  { check time-out to clear type ahead text }
  if (integer (GetTickCount) - FTypeLibTypeAheadLastTime > cTypeAheadMaxTimeGap) or
     (Key in [Chr (VK_BACK), Chr (VK_ESCAPE)])
  then FTypeLibTypeAhead := '';
  FTypeLibTypeAhead := FTypeLibTypeAhead + Key;

  { locate }
  FTypeLibNames.Find (FTypeLibTypeAhead, i);
  if (i >= 0) and (i < FTypeLibNames.Count) then
  begin
    lbxTypeLibs.ItemIndex := integer (FTypeLibNames.Objects [i]);
    lbxTypeLibsClick (Self);
  end;  { if }

  { kill key }
  Key := #0;

  { mark last time type-ahead char was pressed }
  FTypeLibTypeAheadLastTime := GetTickCount;
end;

procedure TfrmSinkEvents.FormCreate(Sender: TObject);
begin
  HelpContext := HC_MAIN;
  Application.HelpFile := ChangeFileExt (Application.ExeName, '.chm');
  Application.OnHelp := OnHelp;

  FTypeLibNames := TStringList.Create;
  FTypeLibNames.Sorted := TRUE;
end;

procedure TfrmSinkEvents.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  { refresh on F5 }
  if (Key = VK_F5) and (Shift = []) then
  begin
    UpdateTypeLibInfo;
    ActiveControl := lbxTypeLibs;
  end;  { if }
end;

procedure TfrmSinkEvents.Button6Click(Sender: TObject);
begin
  Application.HelpContext (HC_MAIN);
end;

function TfrmSinkEvents.OnHelp(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
begin
  CallHelp := False;
  if FileExists (Application.HelpFile) then
  begin
    DoHelp (Command, Data);
    Result := True;
  end
  else
  begin
    MessageDlg ('Cannot locate help file: ' + Application.HelpFile, mtError,
      [mbOk], 0);
    Result := False;
  end;
end;

end.
