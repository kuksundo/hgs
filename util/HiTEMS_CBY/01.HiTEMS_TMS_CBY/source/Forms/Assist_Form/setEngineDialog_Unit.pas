unit setEngineDialog_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.ImgList, Vcl.StdCtrls;

type
  TsetEngineDialog_Frm = class(TForm)
    Panel5: TPanel;
    Image1: TImage;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Button1: TButton;
    ImageList32x32: TImageList;
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1DropDown(Sender: TObject);
  private
    { Private declarations }
    FSelectedEngine : String;
  public
    { Public declarations }
    procedure SetEngineType(aType:String);
    property EngineType : String read FSelectedEngine write SetEngineType;
  end;

var
  setEngineDialog_Frm: TsetEngineDialog_Frm;
  function Create_EngineDialog_Frm : String;
implementation

uses
  DataModule_Unit;

{$R *.dfm}

function Create_EngineDialog_Frm : String;
begin
  setEngineDialog_Frm := TsetEngineDialog_Frm.Create(nil);
  try
    with setEngineDialog_Frm do
    begin
      SetEngineType('');

      ShowModal;

      if ModalResult = mrOk then
        Result := EngineType;


    end;
  finally
    FreeAndNil(setEngineDialog_Frm);
  end;
end;

{ TsetEngineDialog_Frm }

procedure TsetEngineDialog_Frm.Button1Click(Sender: TObject);
begin
  SetEngineType(ComboBox1.Text);
  ModalResult := mrOk;
end;

procedure TsetEngineDialog_Frm.ComboBox1DropDown(Sender: TObject);
begin
  with ComboBox1.Items do
  begin
    BeginUpdate;
    try
      Clear;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT PROJNO, ENGTYPE FROM HIMSEN_INFO ' +
                'WHERE STATUS = 0 ' +
                'ORDER BY PROJNO, ENGTYPE ');
        Open;

        Add('');
        if RecordCount <> 0 then
        begin
          while not eof do
          begin
            Add(FieldByName('PROJNO').AsString+'-'+FieldByName('ENGTYPE').AsString);
            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TsetEngineDialog_Frm.SetEngineType(aType: String);
begin
  FSelectedEngine := aType;
end;

end.
