unit adxtoys2ol_IMPL;

interface

uses
  ComObj, ComServ, Controls, SysUtils, ActiveX, Variants, adxAddIn, adxtoys2ol_TLB,
  Classes, Forms, Windows, Outlook2000, MAPIDefs, MAPITags, MAPIUtil;

type
  TadxToysOLAddIn = class(TadxAddin, IadxToysOLAddIn)
  end;

  TAddInModule = class(TadxCOMAddInModule)
    CmdBar: TadxOlExplorerCommandbar;
    procedure DoButtonClick(Sender: TObject);
    procedure adxCOMAddInModuleAddInInitialize(Sender: TObject);
    procedure adxCOMAddInModuleAddInFinalize(Sender: TObject);
  private
    FExplorers: TExplorers;
    FExplList: TList;
    procedure DoSelectionChange(Sender: TObject);
    procedure DoNewExplorer(ASender: TObject; const Explorer: _Explorer);
    procedure DoCloseExplorer(Sender: TObject);
    procedure ShowAbout;
    procedure ShowHeaders;
    procedure ShowBody;
  protected
  public
  end;

const
  adxToysVersion = '2.0';

implementation

{$R *.dfm}

uses adxtAboutFrm, adxtHeadersFrm, adxtBodyFrm;

procedure TAddInModule.adxCOMAddInModuleAddInInitialize(Sender: TObject);
begin
  FExplList := TList.Create;
  FExplorers := TExplorers.Create(nil);
  FExplorers.ConnectTo(OutlookApp.Explorers);
  FExplorers.OnNewExplorer := DoNewExplorer;
  if OutlookApp.Explorers.Count > 0 then
    DoNewExplorer(nil, OutlookApp.ActiveExplorer);

  // Handle
  Application.Handle := GetActiveWindow;

  if StartMode = smFirstStart then begin
    cmdBar.Position := adxMsoBarFloating;
    ShowAbout;
  end;
end;

procedure TAddInModule.DoSelectionChange(Sender: TObject);
var
  Expl: TExplorer;
  VIntf: OLEVariant;
  adxButton: TadxCommandBarButton;
  IHEnabled, CEnabled: boolean;
begin
  CEnabled := false;
  IHEnabled := false;
  Expl := Sender as TExplorer;
  VIntf := Expl.Selection;
  if VIntf.Count > 0 then begin
    VIntf := VIntf.Item(1);
    CEnabled := (VIntf.Class = olMail);
    IHEnabled := CEnabled or (VIntf.Class = olRemote);
  end;
  // Refresh buttons state

  adxButton := CmdBar.ControlByTag(20).AsButton;
  adxButton.Enabled := IHEnabled;

  adxButton := CmdBar.ControlByTag(30).AsButton;
  adxButton.Enabled := CEnabled;
end;

procedure TAddInModule.DoCloseExplorer(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to FExplList.Count - 1 do
    if Sender = FExplList.Items[i] then begin
      TExplorer(FExplList.Items[i]).Free;
      FExplList.Delete(i);
      Break;
    end;
end;

procedure TAddInModule.ShowAbout;
begin
  adxtAboutDlg('Microsoft'#174' Outlook', adxToysVersion, adxVersion);
end;


procedure TAddInModule.DoButtonClick(Sender: TObject);
begin
  case TadxCommandBarButton(Sender).Tag of
    10: ShowAbout;
    20: ShowHeaders;
    30: ShowBody;
  end;
end;

procedure TAddInModule.ShowHeaders;
var
  VIntf: OLEVariant;
  Intf: IUnknown;
  IMessage: MAPIDefs.IMessage;
  PropValue: PSPropValue;
  f: TfrmIHeaders;
  s: string;
begin
  s := '';
  // Get selection
  VIntf := OutlookApp.ActiveExplorer.Selection.Item(1);
  if (VIntf.Class = olMail) or (VIntf.Class = olRemote) then begin
    // Get internet headers
    Intf := VIntf.MAPIObject;
    Intf.QueryInterface(MapiDefs.IMessage, IMessage);
    if Assigned(IMessage) then
      try
        PropValue := nil;
        if HrGetOneProp(IMessage, PR_TRANSPORT_MESSAGE_HEADERS, PropValue) = S_OK then
          s := PropValue^.Value.lpszA;
      finally
        MAPIFreeBuffer(PropValue);
        IMessage := nil;
      end;
    // Show form
    f := TfrmIHeaders.CreateEx(Self, adxToysVersion);
    try
      f.memHeaders.Text := s;
      if f.ShowModal = mrYes then
        VIntf.Display(False);
    finally
      f.Free;
      Intf := nil;
    end;
  end;
end;

procedure TAddInModule.ShowBody;
const
  PR_BODY_HTML = $1013001E;
  PR_HTML = $10130102;
var
  VIntf: OLEVariant;
  Intf: IUnknown;
  IMessage: MAPIDefs.IMessage;
  PropValue: PSPropValue;
  f: TfrmContent;
  s: string;
begin
  VIntf := OutlookApp.ActiveExplorer.Selection.Item(1);
  if VIntf.Class = olMail then begin
    Intf := VIntf.MAPIObject;
    Intf.QueryInterface(MapiDefs.IMessage, IMessage);
    if Assigned(IMessage) then
      try
        PropValue := nil;
        try
          if HrGetOneProp(IMessage, PR_BODY, PropValue) = S_OK then
            s := PropValue^.Value.lpszA;
        finally
          MAPIFreeBuffer(PropValue);
        end;
        if s = '' then
          try
            if HrGetOneProp(IMessage, PR_BODY_HTML, PropValue) = S_OK then
              s := PropValue^.Value.lpszA;
          finally
            MAPIFreeBuffer(PropValue);
          end;
        if s = '' then
          try
            if HrGetOneProp(IMessage, PR_HTML, PropValue) = S_OK then
              s := PropValue^.Value.lpszA;
          finally
            MAPIFreeBuffer(PropValue);
          end;  
      finally
        IMessage := nil;
      end;
    // Show form
    f := TfrmContent.CreateEx(Self, AdxToysVersion);
    try
      f.memBody.Text := s;
      if f.ShowModal = mrYes then
        VIntf.Display(False);
    finally
      f.Free;
      Intf := nil;
    end;
  end;
end;

procedure TAddInModule.adxCOMAddInModuleAddInFinalize(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to FExplList.Count - 1 do begin
    TExplorer(FExplList.Items[i]).Free;
    FExplList.Delete(i);
  end;
  FreeAndNil(FExplList);
  FreeAndNil(FExplorers);
  Application.Handle := 0;
end;

procedure TAddInModule.DoNewExplorer(ASender: TObject;
  const Explorer: _Explorer);
var
  Expl: TExplorer;
begin
  Expl := TExplorer.Create(nil);
  Expl.ConnectTo(Explorer);
  Expl.OnSelectionChange := DoSelectionChange;
  Expl.OnFolderSwitch := DoSelectionChange;
  Expl.OnClose := DoCloseExplorer;
  FExplList.Add(Expl);
end;

initialization
  TadxFactory.Create(ComServer, TadxToysOLAddIn, CLASS_adxToysOLAddIn, TAddInModule);

end.
