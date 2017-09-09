unit devNo_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, Vcl.Imaging.jpeg, Vcl.ExtCtrls, NxColumnClasses,
  NxColumns, AdvGlowButton, Vcl.ImgList, AdvSplitter, Vcl.StdCtrls, NxEdit;

type
  TdevNo_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    devGrid: TNextGrid;
    Panel1: TPanel;
    NxIncrementColumn1: TNxIncrementColumn;
    NxCheckBoxColumn1: TNxCheckBoxColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    Panel2: TPanel;
    AdvSplitter1: TAdvSplitter;
    ImageList16x16: TImageList;
    AdvGlowButton6: TAdvGlowButton;
    Label2: TLabel;
    devNo: TNxEdit;
    Label1: TLabel;
    devName: TNxEdit;
    regBtn: TButton;
    delBtn: TButton;
    Button1: TButton;
    procedure devGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure AdvGlowButton6Click(Sender: TObject);
    procedure delBtnClick(Sender: TObject);
    procedure regBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure devGridAfterEdit(Sender: TObject; ACol, ARow: Integer;
      Value: WideString);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Get_HiTEMS_FUEL_DEVNO;
    procedure Insert_Into_HiTEMS_FUEL_DEVNO;
    procedure Update_HiTEMS_FUEL_DEVNO;
    procedure Delete_HiTEMS_FUEL_DEVNO(aDevNo:String);
  end;

var
  devNo_Frm : TdevNo_Frm;

implementation
uses
  CommonUtil_Unit,
  DataModule_Unit;

{$R *.dfm}

{ TdevNo_Frm }

procedure TdevNo_Frm.AdvGlowButton6Click(Sender: TObject);
begin
  Close;
end;

procedure TdevNo_Frm.Button1Click(Sender: TObject);
begin
  devNo.Clear;
  devName.Clear;
  delBtn.Enabled := False;
  regBtn.Caption := '과제등록';
end;

procedure TdevNo_Frm.delBtnClick(Sender: TObject);
begin
  if MessageDlg('삭제 하시겠습니까? 삭제된 정보는 복구할 수 없습니다.',
                mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if devNo.Text <> '' then
    begin
      Delete_HiTEMS_FUEL_DEVNO(devNo.Text);
      Get_HiTEMS_FUEL_DEVNO;
      Button1Click(Sender);
    end;
  end;
end;

procedure TdevNo_Frm.Delete_HiTEMS_FUEL_DEVNO(aDevNo: String);
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Delete From FUEL_DEVNO ' +
            'where DEVNO LIKE :param1 ');
    ParamByName('param1').AsString := aDevNo;
    ExecSQL;
    ShowMessage(Format('%s 성공!',[DelBtn.Caption]));
  end;
end;

procedure TdevNo_Frm.devGridAfterEdit(Sender: TObject; ACol, ARow: Integer;
  Value: WideString);
begin
  if ACol = 1 then
  begin
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Update FUEL_DEVNO Set ' +
              'USED = :param1 ' +
              'where DEVNO LIKE :param2 ');

      if devGrid.Cell[1,ARow].AsBoolean = True then
        ParamByName('param1').AsInteger := 0
      else
        ParamByName('param1').AsInteger := 1;

      ParamByName('param2').AsString := devGrid.Cells[2,ARow];

      ExecSQL;
    end;
    Get_HiTEMS_FUEL_DEVNO;
  end;
end;

procedure TdevNo_Frm.devGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
begin
  devNo.Text    := devGrid.Cells[2,ARow];
  devName.Text  := devGrid.Cells[3,ARow];
  regBtn.Caption := '과제수정';
  delBtn.Enabled := True;

end;

procedure TdevNo_Frm.FormCreate(Sender: TObject);
begin
  Get_HiTEMS_FUEL_DEVNO;
end;

procedure TdevNo_Frm.Get_HiTEMS_FUEL_DEVNO;
var
  lrow : Integer;
begin
  with devGrid do
  begin
    BeginUpdate;
    try
      ClearRows;

      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from FUEL_DEVNO ' +
                'order by devIndate Desc ');
        Open;

        while not eof do
        begin
          lrow := AddRow;
          case FieldByName('USED').AsInteger of
            0 : Cell[1,lrow].AsBoolean := True;
            1 : Cell[1,lrow].AsBoolean := False;
          end;

          Cells[2,lrow] := FieldByName('DEVNO').AsString;
          Cells[3,lrow] := FieldByName('DEVNAME').AsString;

          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TdevNo_Frm.Insert_Into_HiTEMS_FUEL_DEVNO;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Insert Into FUEL_DEVNO ' +
            'Values(:DEVNO, :DEVNAME, :USED, :DEVINDATE)');
    ParamByName('DEVNO').AsString := devNo.Text;
    ParamByName('DEVNAME').AsString := devName.Text;
    ParamByName('USED').AsInteger := 0;
    ParamByName('DEVINDATE').AsDateTime := Now;
    ExecSQL;

  end;
end;

procedure TdevNo_Frm.regBtnClick(Sender: TObject);
begin
  if DevNo.Text = '' then
  begin
    devNo.SetFocus;
    raise Exception.Create('과제번호를 입력하여 주십시오!');
  end;

  if DevName.Text = '' then
  begin
    devName.SetFocus;
    raise Exception.Create('과제명을 입력하여 주십시오!');
  end;

  if regBtn.Caption = '과제등록' then
  begin
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from FUEL_DEVNO ' +
              'where DEVNO LIKE :param1 ');
      ParamByName('param1').AsString := devNo.Text;
      Open;

      if RecordCount > 0 then
        raise Exception.Create('등록된 과제번호 입니다!')
      else
        Insert_Into_HiTEMS_FUEL_DEVNO;

    end;
  end
  else
    Update_HiTEMS_FUEL_DEVNO;

  Get_HiTEMS_FUEL_DEVNO;
end;

procedure TdevNo_Frm.Update_HiTEMS_FUEL_DEVNO;
var
  lDevNo : String;
begin
  lDevno := devGrid.Cells[2,devGrid.SelectedRow];
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Update FUEL_DEVNO Set ' +
            'DEVNO = :DEVNO, DEVNAME = :DEVNAME ' +
            'where DEVNO LIKE :param1 ');
    ParamByName('param1').AsString := lDevNo;

    ParamByName('DEVNO').AsString := devNo.Text;
    ParamByName('DEVNAME').AsString := devName.Text;
    ExecSQL;

  end;
end;

end.
