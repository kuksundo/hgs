unit addRoot_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, NxEdit, Vcl.ComCtrls,
  Vcl.ExtCtrls, Vcl.ImgList;

type
  TaddRoot_Frm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    topNode: TNxEdit;
    newNode: TNxEdit;
    ImageList1: TImageList;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
  private
    { Private declarations }
    procedure add_New_Root(aParent:String);
  public
    { Public declarations }

  end;

var
  addRoot_Frm: TaddRoot_Frm;
  function Create_Node(aNode:TTreeNode) : Boolean;

implementation
uses
  HiTEMS_ETH_COMMON,
  HiTEMS_ETH_CONST,
  CommonUtil_Unit,
  DataModule_Unit;

{$R *.dfm}

function Create_Node(aNode:TTreeNode) : Boolean;
var
  li : integer;
  lParent : String;
begin
  with TaddRoot_Frm.Create(Application) do
  begin
    try
      if aNode = nil then
      begin
        topNode.Enabled := False;
        lParent := '';
      end
      else
      begin
        topNode.Enabled := False;
        li := Pos(';',aNode.Text);
        topNode.Text := copy(aNode.Text,0,li-1);
        lParent := copy(aNode.Text,li+1,length(aNode.Text));

      end;
      if ShowModal = mrOk then
      begin
        add_New_Root(lParent);
        Result := True;
      end;
    finally
      Free;
    end;
  end;
end;
{ TaddRoot_Frm }

{ TaddRoot_Frm }

procedure TaddRoot_Frm.add_New_Root(aParent: String);
var
  lv : Integer;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HIMSEN_PART_GROUP ' +
            'where ROOTNO = '''+aParent+''' ');
    Open;

    if RecordCount > 0 then
      lv := RecordCount +1
    else
      lv := 1;
  end;

  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Insert into HIMSEN_PART_ROOT ');
    SQL.Add('values(:ROOTNO, :PRTROOT, :ROOTNAME, :FLAG, :MSNO, :LV,'+
            ' :REGID, :REGDATE, :MODID, :MODDATE)');

    if not(aParent = '') then
    begin
      ParamByName('ROOTNO').AsFloat := DateTimeToMilliseconds(Now);
      ParamByName('PRTROOT').AsFloat := StrToFloat(aParent);
      ParamByName('ROOTNAME').AsString := newNode.Text;
      ParamByName('MSNO').AsString := '';
      ParamByName('LV').AsInteger := lv;

      ParamByName('REGID').AsString := CurrentUsers;
      ParamByName('REGDATE').AsDateTime := now;
//      ParamByName('MODID').AsString := newNode.Text;
//      ParamByName('MODDATE').AsDateTime := newNode.Text;

    end
    else
    begin
      ParamByName('ROOTNO').AsFloat := DateTimeToMilliseconds(Now);
//      ParamByName('PRTROOT').AsFloat := StrToFloat(aParent);
      ParamByName('ROOTNAME').AsString := newNode.Text;
      ParamByName('MSNO').AsString := '';
      ParamByName('LV').AsInteger := lv;

      ParamByName('REGID').AsString := CurrentUsers;
      ParamByName('REGDATE').AsDateTime := now;
//      ParamByName('MODID').AsString := newNode.Text;
//      ParamByName('MODDATE').AsDateTime := newNode.Text;
    end;

    ExecSQL;
  end;
end;

end.
