unit HitemsAddGroup_Unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  THitemsAddGroup_Frm = class(TForm)
    Panel7: TPanel;
    Button1: TButton;
    Button2: TButton;
    Panel8: TPanel;
    Panel9: TPanel;
    pCdGrpNm: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    cdGrp: TEdit;
    Panel3: TPanel;
    Panel4: TPanel;
    cdGrpNm: TEdit;
    Panel5: TPanel;
    Panel6: TPanel;
    cdGrpDesc: TEdit;
    pCdGrpCd: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FUSERID : String;
    FCdGrpLv : Integer;
    function Check_Code_Group(aGrpName : String;var aMsg:String) : Boolean;
    procedure Add_New_Code_Group;
  end;

var
  HitemsAddGroup_Frm: THitemsAddGroup_Frm;

implementation
uses
  DataModule_Unit;

{$R *.dfm}

{ TaddGrp_Frm }

procedure THitemsAddGroup_Frm.Add_New_Code_Group;
begin
  try
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('insert into HITEMS_CODE_ROOT ');
      SQL.Add('values(:CDGRP, :PCDGRP, :CDGRPNAME, :CDGRPLV, ' +
              ':CDGRPDESC, :REGID, :REGDATE, :MODID, :MODDATE)');

      parambyname('CDGRP').AsFloat     := StrToFloat(CDGRP.Text);
      parambyname('PCDGRP').AsFloat   := StrToFloat(pCdGrpCd.Text);
      parambyname('CDGRPNAME').AsString  := cdGrpNm.Text;
      parambyname('CDGRPLV').AsInteger := FCdGrpLv;
      parambyname('CDGRPDESC').AsString := CDGRPDESC.Text;
      parambyname('REGID').AsString    := FUSERID;
      parambyname('REGDATE').AsDateTime := Now;
      ExecSQL;
      ShowMessage('그룹추가 성공!!');
    end;
  except
    ShowMessage('DB 저장 실패!! 다시 시도하여 주십시오,'+#10#13+
                '문제가 지속되면 관리자에게 문의하십시오.');

  end;
end;

procedure THitemsAddGroup_Frm.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure THitemsAddGroup_Frm.Button2Click(Sender: TObject);
var
  lMsg : String;
begin
  if Check_Code_Group(cdGrpNm.Text,lMsg) = True then
    Add_New_Code_Group
  else
    ShowMessage(lMsg);
end;


function THitemsAddGroup_Frm.Check_Code_Group(aGrpName: String;
  var aMsg: String): Boolean;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select cdGrpName from HITEMS_CODE_ROOT');
    SQL.Add('where cdGrpName = :param1');
    parambyname('param1').AsString := aGrpName;
    Open;

    if RecordCount > 0 then
    begin
      Result := False;
      aMsg := '같은 그룹명이 존재 합니다.'+#13#10+'그룹명을 변경 하십시오.';
    end
    else
      Result := True;
  end;
end;

end.
