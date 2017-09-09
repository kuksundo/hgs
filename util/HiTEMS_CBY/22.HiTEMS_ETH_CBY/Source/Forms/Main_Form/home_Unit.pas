unit home_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, NxCollection,
  AdvSmoothListBox, GDIPPictureContainer, Vcl.StdCtrls, Vcl.Grids, AdvObj,
  BaseGrid, AdvGrid, JvBackgrounds, AdvSmoothPanel, Vcl.Imaging.pngimage,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc, JvSimpleXml,
  Vcl.ComCtrls, JvExControls, JvAnimatedImage, JvGIFCtrl, GradientLabel,
  PictureContainer, Data.DB, Datasnap.DBClient;

type
  Thome_Frm = class(TForm)
    JvBackground1: TJvBackground;
    Image2: TImage;
    AdvSmoothPanel1: TAdvSmoothPanel;
    IdHTTP1: TIdHTTP;
    JvSimpleXML1: TJvSimpleXML;
    Panel3: TPanel;
    NxHeaderPanel3: TNxHeaderPanel;
    Panel1: TPanel;
    GradientLabel1: TGradientLabel;
    partImage: TNxImage;
    changeGrid: TAdvStringGrid;
    PictureContainer1: TPictureContainer;
    procedure FormCreate(Sender: TObject);
    procedure changeGridGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure changeGridDblClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure lately_chaged_info;
    procedure Show_registered_image(aRow:Integer);
  end;

var
  home_Frm: Thome_Frm;

implementation
uses
  HiTEMS_ETH_COMMON,
  HiTEMS_ETH_CONST,
  DataModule_Unit;

{$R *.dfm}

procedure Thome_Frm.changeGridDblClickCell(Sender: TObject; ARow,
  ACol: Integer);
begin
  if ARow > 1 then
  begin
    Show_registered_image(ARow);
  end;
end;

procedure Thome_Frm.changeGridGetAlignment(Sender: TObject; ARow, ACol: Integer;
  var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  if ARow = 0 then
  begin
    HAlign := taCenter;
    VAlign := vaCenter;
  end;
end;

procedure Thome_Frm.FormCreate(Sender: TObject);
begin
  lately_chaged_info;//최근변경내용 가져오기


end;

procedure Thome_Frm.FormShow(Sender: TObject);
begin
  Caption := Caption+'-'+FUserInfo.UserName+'님의 방문을 환영합니다.';


end;

procedure Thome_Frm.lately_chaged_info;
var
  li : integer;
  lParent : Double;
  lDateTime : TDateTime;
begin
  with changeGrid do
  begin
    BeginUpdate;
    AutoSize := False;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from HIMSEN_PART_SPEC_V ');
        SQL.Add('order by Mounted Desc');
        Open;

        if not(RecordCount = 0) then
        begin
          //변경된 정보는 5건만 처리
          for li := 0 to 4 do
          begin
            Cells[1,li+1] := FieldByName('PROJNO').AsString;
            Cells[2,li+1] := FieldByName('ENGTYPE').AsString;
            Cells[3,li+1] := FieldByName('HIMSENPARTID').AsString;
            Cells[4,li+1] := FieldByName('ROOTNAME').AsString;
            Cells[5,li+1] := FieldByName('PCODENM').AsString;
            Cells[6,li+1] := FieldByName('MAKER').AsString;
            Cells[7,li+1] := FieldByName('TYPE').AsString;
            Cells[8,li+1] := FormatDateTime('yyyy-mm-dd HH:mm:ss',FieldByName('MOUNTED').AsDateTime);
            Cells[9,li+1] := FieldByName('ROOTNO').AsString;
            Cells[10,li+1] := FieldByName('PCODE').AsString;
            Next;
          end;
        end;
      end;
    finally
      AutoSize := True;
      ColWidths[9] := 0;
      ColWidths[10] := 0;
      EndUpdate;
    end;
  end;
end;

procedure Thome_Frm.Show_registered_image(aRow: Integer);
begin
  with changeGrid do
  begin
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from HIMSEN_PART_SPECIFICATIONS');
      SQL.Add('where ROOTNO = :param1 ');
      SQL.Add('and PCODE = :param2 ');
      SQL.Add('and Maker = :param3 ');
      SQL.Add('and Type = :param4 ');
      ParamByName('param1').AsFloat := StrToFloat(Cells[9,aRow]);
      ParamByName('param2').AsFloat := StrToFloat(Cells[10,aRow]);
      ParamByName('param3').AsString := Cells[6,aRow];
      ParamByName('param4').AsString := Cells[7,aRow];
      Open;

      if not(FieldByName('IMAGES').IsNull = True) then
      begin
        partImage.Picture.Assign(FieldByName('IMAGES'));
        partImage.Invalidate;
      end
      else
      begin
        partImage.Picture.Assign(nil);
        partImage.Invalidate;
      end;
    end;
  end;
end;

end.

{
var
  li : integer;
  lXML : String;
  lWeather : String;
  MS : TMemoryStream;
begin
  lXML := IdHTTP1.Get('http://www.kma.go.kr/wid/queryDFS.jsp?gridx=104&gridy=83');

  ClientDataSet1.CommandText := lXML;
{
  if not(lXML = '') then
  begin
    cDate.Caption := FormatDateTime('yyyy-mm-dd',Now);
    JvSimpleXML1.LoadFromString(lXML);
    ParseWeatherCondition(JvSimpleXML1.Root);

    if not(FWeatherIcon = '') then
    begin
      lWeather := FWeatherIcon;
      li := LastDelimiter('/',lWeather);
      lWeather := Copy(lWeather,li+1, Length(lWeather));
      lWeather := 'http://www.google.com/images/weather/'+lWeather;

      MS := TMemoryStream.Create;
      try
        IdHTTP1.Get(lWeather,MS);
        MS.Position := 0;
        JvGIFAnimator1.Image.LoadFromStream(MS);
      finally
        FreeAndNil(MS);
      end;
    end;
  end;

end;
}


