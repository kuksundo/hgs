unit Unit6;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;//, SynSQLite3;

type
  TForm6 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    Button3: TButton;
    Button4: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

uses UnitFGSSTagRecord, UnitFGSSKMTagRecord, UnitFGSSKMTagConst, UnitFGSSManualRecord,
  UnitMakeFGSSDBFromXls;

{$R *.dfm}

procedure TForm6.Button1Click(Sender: TObject);
begin
  InitFGSSTagClient('FGSS_Tag_SHIS919.sqlite');

  if OpenDialog1.Execute then
    ImportKMTagFromXlsFile(OpenDialog1.FileName);
end;

procedure TForm6.Button2Click(Sender: TObject);
begin
  InitFGSSKMTag1Record('FGSS_KM_Tag1.sqlite');
  InitFGSSKMTag2Record('FGSS_KM_Tag2.sqlite');
  InitFGSSKMTag4Record('FGSS_KM_Tag4.sqlite');
  InitFGSSKMBlockGrpRecord('FGSS_KM_BlockGrp.sqlite');
end;

procedure TForm6.Button3Click(Sender: TObject);
begin
  InitFGSSKMTerminalInfo('FGSS_KMTerminalInfo_SHIS919.sqlite');

  if OpenDialog1.Execute then
    ImportKMTerminalInfoFromXlsFile(OpenDialog1.FileName);
end;

procedure TForm6.Button4Click(Sender: TObject);
begin
  InitFGSSManualContentsClient('FGSS_Manual_Contents.sqlite');
end;

//initialization
//  sqlite3 := TSQLite3LibraryDynamic.Create();
//
//finalization
//  sqlite3.Free;

end.
