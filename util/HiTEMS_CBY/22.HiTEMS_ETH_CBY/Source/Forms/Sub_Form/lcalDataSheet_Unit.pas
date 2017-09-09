unit lcalDataSheet_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, AdvObj, BaseGrid, AdvGrid,
  Vcl.ImgList, Vcl.StdCtrls, Vcl.ExtCtrls, AdvOfficeStatusBar;

type
  TlocalDataSheet_Frm = class(TForm)
    ldsGrid: TAdvStringGrid;
    AdvOfficeStatusBar1: TAdvOfficeStatusBar;
    Panel1: TPanel;
    Button1: TButton;
    ImageList1: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure ldsGridGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure Load_data_of_condition(aTestNo,aInDate:String);
  public
    { Public declarations }
    procedure make_sheet_format;
  end;

var
  localDataSheet_Frm: TlocalDataSheet_Frm;
  procedure Create_ldsDataSheet(aPurpose,aTestNo,aInDate:String);

implementation
uses
  DataModule_Unit;


{$R *.dfm}

{ TForm1 }
procedure Create_ldsDataSheet(aPurpose,aTestNo,aInDate:String);
begin
  with TlocalDataSheet_Frm.Create(Application) do
  begin
    Caption := 'Purpose of Test : '+aPurpose;
    Load_data_of_condition(aTestNo,aInDate);
    Show;

  end;
end;

procedure TlocalDataSheet_Frm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TlocalDataSheet_Frm.FormCreate(Sender: TObject);
begin
  make_sheet_format;
end;

procedure TlocalDataSheet_Frm.ldsGridGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  HAlign := taCenter;
  VAlign := vtaCenter;
end;

procedure TlocalDataSheet_Frm.Load_data_of_condition(aTestNo, aInDate: String);
var
  li : integer;
  lsCol, leCol : Integer;
  lDate : TDateTime;
begin
  with ldsGrid do
  begin
    BeginUpdate;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from HIMSEN_ETH_LDS where TEST_NO = '+aTestNo);
        if not(aInDate = '') then
          SQL.Add(' and Indate = '''+aInDate+''' ');

        Open;

        if not(RecordCount = 0) then
        begin
          lsCol := 2;

//          lDateTime := FieldbyName('INDATE').AsDateTime;

//          Cells[lsCol,0] := FormatDateTime(



          for li := 0 to RecordCount-1 do
          begin
            if li > 0 then
              lsCol := lsCol+2;







          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TlocalDataSheet_Frm.make_sheet_format;
begin
  with ldsGrid do
  begin
    BeginUpdate;
    try
      ColWidths[0] := 105;
      ColWidths[1] := 85;

      Cells[0,0] := 'Test Date :';
      Cells[0,1] := 'Load Point';
      Cells[0,2] := 'Test Started Time';
      Cells[0,3] := 'LBX panel 운전시간';
      Cells[0,4] := 'Engine RPM';
      Cells[0,5] := 'Gen Power(kw)';
      Cells[0,6] := 'Voltage(V)';
      Cells[1,6] := 'Current(A)';
      Cells[0,7] := 'Turbo charger RPM "A"';
      Cells[0,8] := 'Turbo charger RPM "B"';
      Cells[0,9] := 'Amb.';
      Cells[1,9] := 'Temp(℃)';
      Cells[1,10] := 'Press(mmHg)';
      Cells[1,11] := 'Hygro(%)';
      Cells[0,12] := 'Fuel';
      Cells[1,12] := 'Time(min)';
      Cells[1,13] := 'Weight(kg)';
      Cells[0,14] := 'Gov';
      Cells[1,14] := 'Load'+#13#10+'Indicator';
      Cells[0,15] := 'Fuel Index' +#13#10+'/'+#13#10+'Pmax(PMI)';
      Cells[1,15] := 'Cyl1';
      Cells[1,16] := 'Cyl2';
      Cells[1,17] := 'Cyl3';
      Cells[1,18] := 'Cyl4';
      Cells[1,19] := 'Cyl5';
      Cells[1,20] := 'Cyl6';
      Cells[1,21] := 'Cyl7';
      Cells[1,22] := 'Cyl8';
      Cells[1,23] := 'Cyl9';
      Cells[1,24] := 'Cyl10';
      Cells[0,25] := 'Tscav(RTD/Local)';
      Cells[0,26] := 'L.O Eng. Inlet Temp.';
      Cells[0,27] := 'F.O Eng. Inlet Temp.';
      Cells[0,28] := 'L.T Outlet(L.O.C Out)';
      Cells[0,29] := 'L.T CAC Inlet/Outlet(Spare)Temp.';
      Cells[0,30] := 'H.T Cyl Inlet/Outlet Temp.';
      Cells[0,31] := 'L.T Inlet Eng. Press';
      Cells[0,32] := 'H.T Inlet Eng. Press';
      Cells[0,32] := 'F.O Eng. Inlet / Filter Press.';
      Cells[0,33] := 'L.O Inlet TC Press.';
      Cells[0,34] := 'L.O Inlet Eng./Filter Press.';
      Cells[0,35] := 'Charger Air Press.(LOCAL)';
      Cells[0,36] := 'U-Tube';
      Cells[0,37] := 'T/C Compressor Outlet + aCAC';
      Cells[0,38] := 'T/C Compressor Inlet + Pamb.';
      Cells[0,39] := 'Air Box bCAC + aCAC';
      Cells[0,40] := 'Air Flow Meter Inlet + Pamb.';
      Cells[0,41] := 'T/C Turbine Outlet + Pamb.';
      Cells[0,42] := 'Chamber Press. + Pamb.';
      Cells[0,43] := 'Turb. Inlet Temp'+#13#10+'@Thermocouple';
      Cells[1,43] := 'Port1';
      Cells[1,44] := 'Port2';
      Cells[0,45] := 'Turbo Charger';
      Cells[1,45] := 'T Comp. Out';
      Cells[1,46] := 'T Turb. Out';
      Cells[0,47] := 'Exh.Gas Temp.'+#13#10+'/'+'Thermocouple'+#13#10+'Gauge';
      Cells[1,47] := 'Cyl1';
      Cells[1,48] := 'Cyl2';
      Cells[1,49] := 'Cyl3';
      Cells[1,50] := 'Cyl4';
      Cells[1,51] := 'Cyl5';
      Cells[1,52] := 'Cyl6';
      Cells[1,53] := 'Cyl7';
      Cells[1,54] := 'Cyl8';
      Cells[1,55] := 'Cyl9';
      Cells[1,56] := 'Cyl10';
      Cells[0,57] := 'Main Bearing'+#13#10+'Temp.';
      Cells[1,57] := 'JOU.1';
      Cells[1,58] := 'JOU.2';
      Cells[1,59] := 'JOU.3';
      Cells[1,60] := 'JOU.4';
      Cells[1,61] := 'JOU.5';
      Cells[1,62] := 'JOU.6';
      Cells[1,63] := 'JOU.7';
      Cells[1,64] := 'JOU.8';
      Cells[1,65] := 'JOU.9';
      Cells[1,66] := 'JOU.10';
      Cells[1,67] := 'JOU.11';

      MergeCells(0,0,2,1);
      MergeCells(0,1,2,1);
      MergeCells(0,2,2,1);
      MergeCells(0,3,2,1);
      MergeCells(0,4,2,1);
      MergeCells(0,5,2,1);
      MergeCells(0,6,2,1);
      MergeCells(0,7,2,1);
      MergeCells(0,8,2,1);
      MergeCells(0,9,1,3);
      MergeCells(0,12,1,2);
//      MergeCells(0,14,2,1);
      MergeCells(0,15,1,10);
      MergeCells(0,25,2,1);
      MergeCells(0,26,2,1);
      MergeCells(0,27,2,1);
      MergeCells(0,28,2,1);
      MergeCells(0,29,2,1);
      MergeCells(0,30,2,1);
      MergeCells(0,31,2,1);
      MergeCells(0,32,2,1);
      MergeCells(0,33,2,1);
      MergeCells(0,34,2,1);
      MergeCells(0,35,2,1);
      MergeCells(0,36,2,1);
      MergeCells(0,37,2,1);
      MergeCells(0,38,2,1);
      MergeCells(0,39,2,1);
      MergeCells(0,40,2,1);
      MergeCells(0,41,2,1);
      MergeCells(0,42,2,1);
      MergeCells(0,43,1,2);
      MergeCells(0,45,1,2);
      MergeCells(0,47,1,10);
      MergeCells(0,57,1,11);

    finally
      EndUpdate;
    end;
  end;
end;

end.

