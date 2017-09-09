//Written with Delphi XE3 Pro
//Created Nov 24, 2012 by Darian Miller
//For demonstrating use of DelphiVault.Windows.ServiceManager
unit DelphiVault.Examples.Windows.ServiceManager.MainForm;
interface

uses
  System.SysUtils,
  System.Classes,
  Winapi.Windows,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Grids, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Menus, System.Actions, Vcl.ActnList,
  DelphiVault.Windows.ServiceManager;

type
  TfrmServiceManagerExample = class(TForm)
    Panel1: TPanel;
    butRefreshList: TButton;
    gridServices: TStringGrid;
    popServiceActions: TPopupMenu;
    Start1: TMenuItem;
    Stop1: TMenuItem;
    Pause1: TMenuItem;
    Resume1: TMenuItem;
    Restart1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure butRefreshListClick(Sender: TObject);
    procedure gridServicesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StartExecute(Sender: TObject);
    procedure StopExecute(Sender: TObject);
    procedure PauseExecute(Sender: TObject);
    procedure RestartExecute(Sender: TObject);
  private const
    ROW_HEADER = 0;
    COL_OBJ = 0;
    COL_SERVICENAME = 0;
    COL_CURRENTSTATUS = 1;
    COL_STARTTYPE = 2;
    COL_USERNAME = 3;
  private
    fSCM:TServiceManager;
    procedure PopulateGrid();
    function GetSelectedServiceInfo:TServiceInfo;
  protected
    procedure ChangeState(const pNewState:TServiceState);
    property SCM:TServiceManager Read fSCM Write fSCM;
  end;

var
  frmServiceManagerExample: TfrmServiceManagerExample;

implementation
uses
  TypInfo,
  DelphiVault.Windows.Menus,
  DelphiVault.StringGrid.Helper;

{$R *.dfm}

procedure TfrmServiceManagerExample.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := True;

  fSCM := TServiceManager.Create();
  SCM.Active := True;
  SCM.SortByDisplayName();
  PopulateGrid();
end;

procedure TfrmServiceManagerExample.FormDestroy(Sender: TObject);
begin
  fSCM.Free();
end;

procedure TfrmServiceManagerExample.butRefreshListClick(Sender: TObject);
begin
  SCM.RebuildServicesList();
  SCM.SortByDisplayName();
  PopulateGrid();
end;

procedure TfrmServiceManagerExample.gridServicesMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  vRow, vCol:Integer;
  vServiceInfo:TServiceInfo;
  vCurrentState:TServiceState;
begin
  if gridServices.Row > ROW_HEADER then
  begin
    if Button = mbRight then
    begin
      gridServices.MouseToCell(X, Y, vCol, vRow);
      gridServices.Row := vRow;
      vServiceInfo := GetSelectedServiceInfo();
      if Assigned(vServiceInfo) then
      begin
        vCurrentState := vServiceInfo.State;
        Start1.Enabled := vCurrentState in [ssStopped];
        Stop1.Enabled := vCurrentState in [ssRunning, ssPaused];
        Pause1.Enabled := vCurrentState in [ssRunning];
        Resume1.Enabled := vCurrentState in [ssPaused];
        Restart1.Enabled := vCurrentState in [ssRunning];
        PopMenuAtCursor(popServiceActions);
      end;
    end;
  end;
end;

procedure TfrmServiceManagerExample.PopulateGrid();
var
  i:integer;
  vServiceInfo:TServiceInfo;
  vRowNumber:Integer;
begin
  gridServices.ClearValues;
  gridServices.RowCount := 2;
  gridServices.FixedRows := 1;
  gridServices.Cells[COL_SERVICENAME, ROW_HEADER] := 'Service Name';
  gridServices.Cells[COL_CURRENTSTATUS, ROW_HEADER] := 'Current Status';
  gridServices.Cells[COL_STARTTYPE, ROW_HEADER] := 'Startup Type';
  gridServices.Cells[COL_USERNAME, ROW_HEADER] := 'Username';
  gridServices.ColWidths[COL_SERVICENAME] := 300;
  gridServices.ColWidths[COL_CURRENTSTATUS] := 150;
  gridServices.ColWidths[COL_STARTTYPE] := 150;
  gridServices.ColWidths[COL_USERNAME] := 250;


  if fSCM.ServiceCount > 0 then
  begin
    gridServices.RowCount := fSCM.ServiceCount+1;
  end;

  vRowNumber := 1;
  for i := 0 to fSCM.ServiceCount-1 do
  begin
    vServiceInfo := fSCM.Services[i];
    gridServices.Objects[COL_OBJ, vRowNumber] := vServiceInfo;
    gridServices.Cells[COL_SERVICENAME, vRowNumber] := vServiceInfo.DisplayName;
    gridServices.Cells[COL_CURRENTSTATUS, vRowNumber] := GetEnumName(TypeInfo(TServiceState), Ord(vServiceInfo.State));
    gridServices.Cells[COL_STARTTYPE, vRowNumber] := GetEnumName(TypeInfo(TServiceStartup), Ord(vServiceInfo.StartType));
    gridServices.Cells[COL_USERNAME, vRowNumber] := vServiceInfo.UserName;
    Inc(vRowNumber);
  end;
end;


procedure TfrmServiceManagerExample.ChangeState(const pNewState:TServiceState);
var
  vServiceInfo:TServiceInfo;
  vCursor:TCursor;
begin
  vServiceInfo := GetSelectedServiceInfo();
  if Assigned(vServiceInfo) then
  begin
    vCursor := Screen.Cursor;
    Screen.Cursor := crHourGlass;
    try
      vServiceInfo.State := pNewState;
      gridServices.Cells[COL_CURRENTSTATUS, gridServices.Row] := GetEnumName(TypeInfo(TServiceState), Ord(vServiceInfo.State));
    finally
      Screen.Cursor := vCursor;
    end;
  end;
end;

procedure TfrmServiceManagerExample.PauseExecute(Sender: TObject);
begin
  ChangeState(ssPaused);
end;

procedure TfrmServiceManagerExample.RestartExecute(Sender: TObject);
begin
  ChangeState(ssStopped);
  ChangeState(ssRunning);
end;

procedure TfrmServiceManagerExample.StartExecute(Sender: TObject);
begin
  ChangeState(ssRunning);
end;

procedure TfrmServiceManagerExample.StopExecute(Sender: TObject);
begin
  ChangeState(ssStopped);
end;

function TfrmServiceManagerExample.GetSelectedServiceInfo:TServiceInfo;
begin
  Result := TServiceInfo(gridServices.Objects[gridServices.Col, gridServices.Row]);
end;


end.
