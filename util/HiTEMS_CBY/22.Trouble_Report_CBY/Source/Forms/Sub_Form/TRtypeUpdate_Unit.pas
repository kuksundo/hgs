unit TRtypeUpdate_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, AdvObj,
  BaseGrid, AdvGrid, DBAdvGrid, Data.DB, MemDS, DBAccess, Ora;

type
  TTRtypeUpdate_Frm = class(TForm)
    TSession1: TOraSession;
    TQuery1: TOraQuery;
    ESession1: TOraSession;
    EQuery1: TOraQuery;
    DBAdvGrid1: TDBAdvGrid;
    Button1: TButton;
    Button2: TButton;
    DataSource1: TDataSource;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    FKind : Integer;
  public
    { Public declarations }
  end;

var
  TRtypeUpdate_Frm: TTRtypeUpdate_Frm;

implementation

{$R *.dfm}

procedure TTRtypeUpdate_Frm.Button1Click(Sender: TObject);
begin
  FKind := 0;
  with EQuery1 do
  begin
    Active := False;
    SQL.Clear;
    SQL.Add('select * from TS_TROUBLEROOT order by CODE');
    Open;
    Active := True;
  end;
end;

procedure TTRtypeUpdate_Frm.Button2Click(Sender: TObject);
begin
  FKind := 1;
  with EQuery1 do
  begin
    Active := False;
    SQL.Clear;
    SQL.Add('select * from TS_TROUBLETYPE order by CODE');
    Open;
    Active := True;
  end;
end;

procedure TTRtypeUpdate_Frm.Button3Click(Sender: TObject);
var
  FSQL : String;
  li : integer;
begin
  case FKind of
    0 : FSQL := 'insert into Trouble_Root Values(:code, :lvl, :pcode, :data, :active)';
    1 : FSQL := 'insert into Trouble_Type Values(:code, :lvl, :pcode, :data, :active)';
  end;

  EQuery1.First;
  for li := 0 to EQuery1.RecordCount-1 do
  begin
    with TQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add(FSQL);
      with DbaDvGrid1 do
      begin
        parambyname('code').AsString   := EQuery1.FieldByName('code').AsString;
        parambyname('lvl').AsString    := EQuery1.FieldByName('lvl').AsString;
        parambyname('pcode').AsString  := EQuery1.FieldByName('pcode').AsString;
        parambyname('data').AsString   := EQuery1.FieldByName('data').AsString;
        parambyname('active').AsString := EQuery1.FieldByName('active').AsString;
        ExecSQL;
        EQuery1.Next;
      end;
    end;
  end;
end;

end.
