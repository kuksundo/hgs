unit DownLoad_;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls, ComCtrls, Trouble_Unit, DB, ShellAPI,
  jpeg, ImgList;

type
  TDownLoadF = class(TForm)
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Image1: TImage;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    SaveDialog1: TSaveDialog;
    Image2: TImage;
    Imglist16x16: TImageList;
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    FOwner : TTrouble_Frm;

    FDownOwner : String;

    procedure TroubleRP_File_Open;
    procedure TroubleRP_File_Save;

  end;

var
  DownLoadF: TDownLoadF;

implementation
uses
  CommonUtil_Unit, DataModule_Unit;

{$R *.dfm}

procedure TDownLoadF.SpeedButton3Click(Sender: TObject);
begin
  Close;
end;


procedure TDownLoadF.TroubleRP_File_Open;
var
  longType : int64;
  TS : TStream;
  MS : TMemoryStream;
  FileName : String;
begin
  Try
    with DM1.TQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from TROUBLE_ATTFILES');
      SQL.Add(' where CODEID = :Param1 And LCFileName = :param2');

      ParamByName('Param1').AsString := FOwner.CodeId.Text;
      ParamByName('Param2').AsString := Label5.Caption;
      Open;

      TS := TStream.Create;
      MS := TMemoryStream.Create;
      if Not(RecordCount = 0) then
      begin

        TS := createblobstream(fieldbyname('Files'), bmread) ;
        MS.LoadFromStream(TS);

        if not DirectoryExists('c:\temp') then
          if not CreateDir('C:\temp') then
          raise Exception.Create('Cannot create c:\temp');

        longType := DateTimeToMilliseconds(Now);
        FileName := IntToStr(LongType)+'.'+FieldByName('FILEEXT').AsString;
        FileName := 'C:\temp\'+ FileName;
        MS.SaveToFile(FileName);
        shellExecute(self.Handle, 'open', PChar(filename), '', '', SW_SHOWNORMAL);

      end;//if
    end;//with
  finally
    TS.Free;
    MS.Free;
    close;
  end;
end;

procedure TDownLoadF.TroubleRP_File_Save;
var
  TS : TStream;
  MS : TMemoryStream;
begin
  Try
    SaveDialog1.FileName := Label5.Caption;
    if SaveDialog1.Execute then
    begin
      with DM1.TQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from TROUBLE_ATTFILES');
        SQL.Add(' where CODEID = :Param1 And LCFileName = :param2');

        ParamByName('Param1').AsString := FOwner.CodeId.Text;
        ParamByName('Param2').AsString := Label5.Caption;
        Open;

        TS := TStream.Create;
        MS := TMemoryStream.Create;
        if Not(RecordCount = 0) then
        begin
          TS := createblobstream(fieldbyname('Files'), bmread) ;
          MS.LoadFromStream(TS);
          Ms.SaveToFile(SaveDialog1.FileName);
        end;//if
      end;//with
    end;//if
  finally
    TS.Free;
    MS.Free;
    Close;
  end;
end;

procedure TDownLoadF.SpeedButton1Click(Sender: TObject);
begin
  if FDownOwner = 'Trouble' then
    TroubleRP_File_Open;

end;

procedure TDownLoadF.SpeedButton2Click(Sender: TObject);
begin
  if FDownOwner = 'Trouble' then
    TroubleRP_File_Save;
end;

end.


