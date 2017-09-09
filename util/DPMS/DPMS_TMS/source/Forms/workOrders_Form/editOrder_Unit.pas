unit editOrder_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AeroButtons, Vcl.ImgList,
  Vcl.ComCtrls, JvExControls, JvLabel, Vcl.Imaging.jpeg, Vcl.ExtCtrls;

type
  TeditOrder_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    JvLabel3: TJvLabel;
    JvLabel1: TJvLabel;
    et_Name: TEdit;
    dt_Perform: TDateTimePicker;
    ImageList16x16: TImageList;
    AeroButton1: TAeroButton;
    AeroButton2: TAeroButton;
    ImageList32x32: TImageList;
    Panel1: TPanel;
    JvLabel2: TJvLabel;
    AeroButton3: TAeroButton;
    procedure AeroButton1Click(Sender: TObject);
    procedure AeroButton2Click(Sender: TObject);
    procedure AeroButton3Click(Sender: TObject);
  private
    { Private declarations }
    FPerform,
    FPlanNo : String;
  public
    { Public declarations }
  end;

var
  editOrder_Frm: TeditOrder_Frm;
  function Create_editOrder_Frm(aPlanNo,aPlanName,aPerform:String):Boolean;

implementation
uses
  DataModule_Unit;

{$R *.dfm}
function Create_editOrder_Frm(aPlanNo,aPlanName,aPerform:String):Boolean;
begin
  Result := False;
  editOrder_Frm := TeditOrder_Frm.Create(nil);
  try
    with editOrder_Frm do
    begin
      FPerform := aPerform;
      FPlanNo  := aPlanNo;

      et_Name.Text := aPlanName;
      dt_Perform.Date := StrToDateTime(aPerform);

      ShowModal;

      if ModalResult = mrOk then
        Result := True;

    end;
  finally
    FreeAndNil(editOrder_Frm);
  end;
end;

procedure TeditOrder_Frm.AeroButton1Click(Sender: TObject);
begin
  if MessageDlg('삭제 하시겠습니까? 삭제된 정보는 복구할 수 없습니다.', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('DELETE FROM DPMS_TMS_WORK_ORDERS ' +
              'WHERE PLAN_NO = :param1 ' +
              'AND PERFORM = :param2 ');

      ParamByName('param1').AsString := FPlanNo;
      ParamByName('param2').AsDate   := StrToDateTime(FPerform);
      ExecSQL;
    end;
    ShowMessage('삭제완료!');
    ModalResult := mrOk;
  end;
end;

procedure TeditOrder_Frm.AeroButton2Click(Sender: TObject);
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('UPDATE DPMS_TMS_WORK_ORDERS SET ' +
            'PERFORM = :PERFORM ' +
            'WHERE PLAN_NO LIKE :param1 ' +
            'AND PERFORM = :param2 ');
    ParamByName('param1').AsString := FPlanNo;
    ParamByName('param2').AsDate   := StrToDate(FPerform);
    ParamByName('PERFORM').AsDate  := dt_Perform.Date;
    ExecSQL;

    ShowMessage('변경완료!');
    ModalResult := mrOk;
  end;
end;

procedure TeditOrder_Frm.AeroButton3Click(Sender: TObject);
begin
  Close;
end;

end.
