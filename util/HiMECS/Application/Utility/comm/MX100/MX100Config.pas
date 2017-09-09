unit MX100Config;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IniFiles, Vcl.ExtCtrls,
  Vcl.Imaging.jpeg, Vcl.Imaging.pngimage;

type
  TMX100ConfigForm = class(TForm)
    GroupBox1: TGroupBox;
    edtIP1: TEdit;
    GroupBox3: TGroupBox;
    edtInterval: TEdit;
    edtIP2: TEdit;
    edtIP3: TEdit;
    imgBackGround: TImage;
    Label1: TLabel;
    imgSave: TImage;
    imgClose: TImage;
    procedure FormShow(Sender: TObject);
    procedure CompInit();
    procedure imgCloseClick(Sender: TObject);
    procedure imgSaveClick(Sender: TObject);
    function IsValisIPAddress(strIP: String): Boolean;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MX100ConfigForm: TMX100ConfigForm;
  AppPath, IniName : string;
implementation

{$R *.dfm}



procedure TMX100ConfigForm.FormShow(Sender: TObject);
var
  tmpPath : string;
  tmpIni : TIniFile;
begin
  AppPath := ExtractFileDir(Application.ExeName);
  IniName := '\Config.ini';
  CompInit();
  tmpPath := AppPath + IniName;
  if FileExists(tmpPath) then
    begin
      tmpIni := TIniFile.Create(tmpPath);
      edtIP1.Text := tmpIni.ReadString('MX100','IPADDRESS1','0');
      edtIP2.Text := tmpIni.ReadString('MX100','IPADDRESS2','0');
      edtIP3.Text := tmpIni.ReadString('MX100','IPADDRESS3','0');
      edtInterval.Text := tmpIni.ReadString('MX100','INTERVAL','0');
    end;
end;
procedure TMX100ConfigForm.imgCloseClick(Sender: TObject);
begin
  MX100ConfigForm.Close;
end;

procedure TMX100ConfigForm.imgSaveClick(Sender: TObject);
var
  tmpPath : string;
  tmpIni : TIniFile;
begin
  tmpPath := AppPath + IniName;
  if FileExists(tmpPath) then
    begin
      tmpIni := TIniFile.Create(tmpPath);
        if (edtIP1.Text <> '') and IsValisIPAddress(edtIP1.Text) then
          begin
            tmpIni.WriteString('MX100','IPADDRESS1',edtIP1.Text);
          end
        else
          begin
            edtIP1.SetFocus;
            ShowMessage('IP ADDRESS 설정 값이 올바르지 않습니다. 다시 설정해 주세요');

          end;
        if (edtIP2.Text <> '') and IsValisIPAddress(edtIP2.Text) then
          begin
            tmpIni.WriteString('MX100','IPADDRESS2',edtIP2.Text);
          end
        else
          begin
            edtIP2.SetFocus;
            ShowMessage('IP ADDRESS 설정 값이 올바르지 않습니다. 다시 설정해 주세요');
          end;
        if (edtIP3.Text <> '') and IsValisIPAddress(edtIP3.Text) then
          begin
            tmpIni.WriteString('MX100','IPADDRESS3',edtIP3.Text);
          end
        else
          begin
            edtIP3.SetFocus;
            ShowMessage('IP ADDRESS 설정 값이 올바르지 않습니다. 다시 설정해 주세요');
          end;
        if (edtInterval.Text <> '') then
          begin
            tmpIni.WriteString('MX100','INTERVAL',edtInterval.Text);
          end;
    end;

end;

procedure TMX100ConfigForm.CompInit();
begin
  edtIP1.Text := '';
  edtIP2.Text := '';
  edtIP3.Text := '';
  edtInterval.Text := '';
end;
function TMX100ConfigForm.IsValisIPAddress(strIP: String): Boolean;
var
  TempList: TStringList;
  i: Integer;
  nTemp: Integer;
begin
  Result := False;
  TempList := TStringList.Create;

  ExtractStrings(['.'], [], PWideChar(strIP), TempList);
  if TempList.Count = 4 then
    begin
      for i := 0 to 3 do
        begin
          nTemp := StrToIntDef(TempList[i], -1);
          if (nTemp < 0) or (nTemp > 255) then
            begin
              break;
            end;
        end;
      Result := True;
    end;
  TempList.Free;
end;
end.
