unit Value_Unit;

interface

uses
  LocalData_Unit, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxCollection, Vcl.ExtCtrls, AdvPanel,
  AdvSmoothStepControl, Vcl.StdCtrls;

type
  TValue_Frm = class(TForm)
    AdvPanel1: TAdvPanel;
    AdvSmoothStepControl1: TAdvSmoothStepControl;
    Panel1: TPanel;
    indate: TEdit;
    procedure AdvSmoothStepControl1StepClick(Sender: TObject;
      StepIndex: Integer; StepMode: TStepMode);
  private
    { Private declarations }
  public
    { Public declarations }
    FOwner : TLocalData_Frm;

    procedure ISCreateForm(aClass: TFormClass; aName ,aCaption : String);
    procedure ChildFormClose(Sender: TObject; var Action: TCloseAction);
  end;

var
  Value_Frm: TValue_Frm;

implementation
uses
  DataModule_Unit,
  CommonUtil_Unit,
  Speed_Unit;

{$R *.dfm}

procedure TValue_Frm.AdvSmoothStepControl1StepClick(Sender: TObject;
  StepIndex: Integer; StepMode: TStepMode);
var
  li : integer;
  indatestr : string;
begin
  indatestr := indate.Text;

  with DM1.OraQuery3 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HEMMS_LDS WHERE TO_CHAR(INDATE, ''YYYY-MM-DD HH24:MI:SS'') = '''+indatestr+''' ');
    Open;

    if(RecordCount > 0) then
    begin
      if StepIndex = 0 then
      begin
        Speed_Frm := TSpeed_Frm.Create(Self);
        Speed_Frm.DATA_1.Text := FieldByName('DATA_1').AsString;
        Speed_Frm.DATA_2.Text := FieldByName('DATA_2').AsString;
        Speed_Frm.DATA_3.Text := FieldByName('DATA_3').AsString;

        Speed_Frm.Parent := Panel1;
        Speed_Frm.Show;
      end;
    end;
  end;
end;

procedure TValue_Frm.ISCreateForm(aClass: TFormClass; aName,
  aCaption: String);
var
  aForm : TForm;
  i : Integer;
begin
  aForm := nil;
  try
    LockMDIChild(True);
    for i:=(Value_Frm.MDIChildCount - 1) DownTo 0 Do
    begin
      if SameText(Value_Frm.MDIChildren[I].Name,aName) then
      begin
        aForm := Value_Frm.MDIChildren[I];
        Break;
      end;
    end;

    if aForm = nil Then
    begin
      aForm := aClass.Create(Application);
      with aForm do
      begin
        Caption := aCaption;
        OnClose := ChildFormClose;
      end;
      //AdvToolBar1.AddMDIChildMenu(aForm);
//      AdvOfficeMDITabSet1.AddTab(aForm);
    end;

    if aForm.WindowState = wsMinimized then
      aForm.WindowState := wsNormal;

    aForm.Show;
  finally
    LockMDIChild(False);
  end;
end;

procedure TValue_Frm.ChildFormClose(Sender: TObject; var Action: TCloseAction);
begin
  //AdvToolBar1.RemoveMDIChildMenu(TForm(Sender));
  Action   := caFree;
end;

end.
