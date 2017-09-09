unit LocalSheet_Unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, NxCollection, AdvOfficeStatusBar, Grids, AdvObj, BaseGrid, AdvGrid,
  ImgList, StdCtrls, ExtCtrls, NxEdit, ComCtrls, AdvDateTimePicker;

type
  TLocalSheet_Frm = class(TForm)
    AdvOfficeStatusBar1: TAdvOfficeStatusBar;
    NxHeaderPanel1: TNxHeaderPanel;
    ImageList1: TImageList;
    Panel2: TPanel;
    AGrid: TAdvStringGrid;
    Panel3: TPanel;
    Panel4: TPanel;
    BGRID: TAdvStringGrid;
    Panel5: TPanel;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Panel6: TPanel;
    mTime: TAdvDateTimePicker;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel11: TPanel;
    Panel16: TPanel;
    runTime: TNxNumberEdit;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel18: TPanel;
    Panel21: TPanel;
    ambTemp: TNxNumberEdit;
    Panel19: TPanel;
    Panel22: TPanel;
    ambPress: TNxNumberEdit;
    ambHum: TPanel;
    Panel23: TPanel;
    ambHumidity: TNxNumberEdit;
    Panel15: TPanel;
    Panel17: TPanel;
    Panel24: TPanel;
    Panel25: TPanel;
    Panel28: TPanel;
    Panel29: TPanel;
    compPress: TNxNumberEdit;
    Panel30: TPanel;
    Panel31: TPanel;
    compTemp: TNxNumberEdit;
    Panel32: TPanel;
    Panel33: TPanel;
    Panel26: TPanel;
    Panel27: TPanel;
    seaWater: TNxNumberEdit;
    Panel34: TPanel;
    Panel37: TPanel;
    Panel38: TPanel;
    Panel39: TPanel;
    Panel40: TPanel;
    Panel41: TPanel;
    inlet: TNxNumberEdit;
    Panel42: TPanel;
    Panel43: TPanel;
    mChamber: TNxNumberEdit;
    Panel44: TPanel;
    Panel45: TPanel;
    pChamber: TNxNumberEdit;
    Panel46: TPanel;
    Panel48: TPanel;
    Panel49: TPanel;
    Panel50: TPanel;
    Panel51: TPanel;
    gVolume: TNxNumberEdit;
    Panel52: TPanel;
    Panel53: TPanel;
    gDuration: TNxNumberEdit;
    Panel54: TPanel;
    Panel55: TPanel;
    Panel56: TPanel;
    Panel57: TPanel;
    chamberIn: TNxNumberEdit;
    Panel10: TPanel;
    Panel35: TPanel;
    loLevel: TNxNumberEdit;
    Panel47: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    StayOnTopCB: TCheckBox;
    procedure AGridGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure BGRIDGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure AGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure AGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure BGRIDKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BGRIDSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure AGridCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure BGRIDCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure StayOnTopCBClick(Sender: TObject);
  private
    { Private declarations }
    FxCol : integer;
  public
    { Public declarations }
    FLocalValue : Array[0..32] of String;

    procedure Initialize_for_LocalSheet_Unit;
  end;

var
  LocalSheet_Frm: TLocalSheet_Frm;

implementation

uses HiMECS_WatchSave;

{$R *.dfm}

procedure TLocalSheet_Frm.AGridCanEditCell(Sender: TObject; ARow, ACol: Integer;
  var CanEdit: Boolean);
begin
  if ARow = 1 then
    CanEdit := True
  else
    CanEdit := False;
end;

procedure TLocalSheet_Frm.AGridGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  if ARow = 0 then
  begin
    HAlign := taCenter;
    VAlign := vtaCenter;
  end;
end;

procedure TLocalSheet_Frm.AGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  lc,lr : integer;
begin
  lc := FxCol;
  if (key = 13) then
  begin
    with AGrid do
    begin
      if not(lc >= ColCount-1) then
        lc := lc+1
      else
        lc := 0;
      SelectRange(lc,lc,1,1);
    end;
  end;
end;

procedure TLocalSheet_Frm.AGridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  FxCol := ACol;
end;

procedure TLocalSheet_Frm.BGRIDCanEditCell(Sender: TObject; ARow, ACol: Integer;
  var CanEdit: Boolean);
begin
  if ARow = 1 then
    CanEdit := True
  else
    CanEdit := False;
end;

procedure TLocalSheet_Frm.BGRIDGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  if ARow = 0 then
  begin
    HAlign := taCenter;
    VAlign := vtaCenter;
  end;
end;

procedure TLocalSheet_Frm.BGRIDKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  lc,lr : integer;
begin
  lc := FxCol;
  if (key = 13) then
  begin
    with BGrid do
    begin
      if not(lc >= ColCount-1) then
        lc := lc+1
      else
        lc := 0;

      SelectRange(lc,lc,1,1);
    end;
  end;
end;

procedure TLocalSheet_Frm.BGRIDSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  FxCol := ACol;
end;

procedure TLocalSheet_Frm.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TLocalSheet_Frm.Button2Click(Sender: TObject);
var
  li : integer;
begin
  FillChar(FLocalValue,length(FLocalValue),#0);

  FLocalValue[0]  := FormatDateTime('HH:mm',mTime.DateTime);
  FLocalValue[1]  := runTime.Text;
  FLocalValue[2]  := ambTemp.Text;
  FLocalValue[3]  := ambPress.Text;
  FLocalValue[4]  := ambHumidity.Text;

  FLocalValue[5]  := compPress.Text;
  FLocalValue[6]  := compTemp.Text;
  FLocalValue[7]  := seaWater.Text;
  FLocalValue[8]  := inlet.Text;
  FLocalValue[9]  := mChamber.Text;

  FLocalValue[10] := pChamber.Text;
  FLocalValue[11] := gVolume.Text;
  FLocalValue[12] := gDuration.Text;
  FLocalValue[13] := ChamberIn.Text;
  FLocalValue[14] := loLevel.Text;

  for li := 0 to 8 do
    with AGrid do
      FLocalValue[15+li] := Cells[li,1];

  for li := 0 to 8 do
    with BGrid do
      FLocalValue[24+li] := Cells[li,1];

  WatchSaveF.LoadLocalDataFromSheet;
end;

procedure TLocalSheet_Frm.Button3Click(Sender: TObject);
begin
  Initialize_for_LocalSheet_Unit;
end;

procedure TLocalSheet_Frm.FormCreate(Sender: TObject);
begin
  Initialize_for_LocalSheet_Unit;
  StayOnTopCB.Checked := True;
end;

procedure TLocalSheet_Frm.Initialize_for_LocalSheet_Unit;
begin
  mTime.DateTime := Now;
  runTime.Clear;
  ambTemp.Clear;
  ambPress.Clear;
  ambHumidity.Clear;

  compPress.Clear;
  compTemp.Clear;
  seaWater.Clear;
  inlet.Clear;
  mChamber.Clear;

  pChamber.Clear;
  gVolume.Clear;
  gDuration.Clear;
  ChamberIn.Clear;
  loLevel.Clear;

  AGrid.ClearRows(1,1);
  BGrid.ClearRows(1,1);

  FillChar(FLocalValue,length(FLocalValue),#0);

end;

procedure TLocalSheet_Frm.StayOnTopCBClick(Sender: TObject);
begin
  if StayOnTopCB.Checked then
    FormStyle := fsStayOnTop
  else
    FormStyle := fsNormal;
end;

end.
