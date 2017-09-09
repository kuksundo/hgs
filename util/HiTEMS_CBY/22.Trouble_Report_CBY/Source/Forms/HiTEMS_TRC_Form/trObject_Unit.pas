unit trObject_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  AdvOfficeStatusBar, Vcl.StdCtrls, Vcl.ImgList, Vcl.Grids, AdvObj, BaseGrid,
  AdvGrid, AdvOfficeTabSet;

type
  TtrObject_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    listGrid: TAdvStringGrid;
    Imglist16x16: TImageList;
    Panel1: TPanel;
    Button6: TButton;
    Button8: TButton;
    Panel2: TPanel;
    Button2: TButton;
    Button1: TButton;
    procedure Button2Click(Sender: TObject);
    procedure listGridDblClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure listGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure listGridGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure Button6Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
  private
    { Private declarations }
    FselctedType : Integer; //0:엔진문제, 1:장치문제, 2:장비문제, 3:기타
    FsRow : Integer;
    FselectedCode : String;
  public
    { Public declarations }
    procedure set_EngList;
    procedure set_EquipmentList;
    procedure Set_Header(aidx:Integer);

  end;

var
  trObject_Frm: TtrObject_Frm;
  function Create_trObject(aIdx:Integer):String;

implementation
uses
  HiTEMS_TRC_COMMON,
  equipment_Unit,
  himsenDesc_Unit,
  DataModule_Unit;

{$R *.dfm}

function Create_trObject(aIdx: Integer): String;
var
  lCode : String;
begin
  trObject_Frm := TtrObject_Frm.Create(nil);
  try
    with trObject_Frm do
    begin
      FselctedType := aIdx;
      Set_Header(FselctedType);
      with listGrid do
      begin
        if FselctedType <> 0 then
          set_EquipmentList
        else
          set_EngList;

        ShowModal;

        if ModalResult = mrOk then
        begin
          Result := FselectedCode;

        end;
      end;
    end;
  finally
    FreeAndNil(trObject_Frm);
  end;
end;

procedure TtrObject_Frm.Button1Click(Sender: TObject);
begin
  if FsRow <> 0 then
  begin
    FselectedCode := listGrid.Cells[1,FsRow]+';'+
                     listGrid.Cells[2,FsRow];

    ModalResult := mrOk;
  end;
end;

procedure TtrObject_Frm.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TtrObject_Frm.Button6Click(Sender: TObject);
begin
  if FselctedType <> 0 then
  begin
    if Create_equipment(FselctedType,'') then
    begin
      Set_Header(FselctedType);
      set_EquipmentList;
    end;
  end else
  begin
    if Create_himsenDesc('') then
    begin
      Set_Header(FselctedType);
      set_EngList;
    end;
  end;
end;

procedure TtrObject_Frm.Button8Click(Sender: TObject);
var
  lCode : String;
begin
  lCode := listGrid.Cells[1,FsRow];
  if lCode <> '' then
  begin
    if FselctedType <> 0 then
    begin
      if Create_equipment(FselctedType,lCode) then
      begin
        Set_Header(FselctedType);
        set_EquipmentList;
      end;
    end else
    begin
      if Create_himsenDesc(lCode) then
      begin
        Set_Header(FselctedType);
        set_EngList;
      end;
    end;
  end;
end;

procedure TtrObject_Frm.listGridDblClickCell(Sender: TObject; ARow,
  ACol: Integer);
begin
  if ARow <> 0 then
  begin
    FselectedCode := listGrid.Cells[1,ARow]+';'+
                     listGrid.Cells[2,ARow];

    ModalResult := mrOk;
  end;
end;

procedure TtrObject_Frm.listGridGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  if ARow <> 0 then
  begin
    if FselctedType = 0 then
    begin
      HAlign := taCenter;

    end else
    begin
      case ACol of
        0..1 : HAlign := taCenter;
        2 : HAlign := taLeftJustify;
        3 : HAlign := taCenter;
      end;
    end;

  end else
    HAlign := taCenter;

end;

procedure TtrObject_Frm.listGridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  CanSelect := True;
  FsRow := ARow;
end;

procedure TtrObject_Frm.set_EngList;
var
  li,
  lrow : Integer;
begin
  with listGrid do
  begin
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select PROJNO, ENGTYPE, MEASP from HiTEMS.HIMSEN_INFO ');
      SQL.Add('where STATUS = 0 ' );
      SQL.Add('order by ENGTYPE DESC ');
      Open;

      if RecordCount <> 0 then
      begin
        for li := 0 to RecordCount-1 do
        begin
          if li <> 0 then
            AddRow;

          lrow := RowCount-1;
          Cells[0,lrow] := IntToStr(lrow);
          Cells[1,lrow] := FieldByName('PROJNO').AsString;
          Cells[2,lrow] := FieldByName('ENGTYPE').AsString;
          NEXT;

        end;
      end;
    end;
  end;
end;

procedure TtrObject_Frm.set_EquipmentList;
var
  li,
  lrow : Integer;
begin
  with listGrid do
  begin
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT EQUIPNO, EQNAME FROM HITEMS_EQUIP_LIST ');
      SQL.Add('ORDER BY EQUIPNO ');
      Open;

      for li := 0 to RecordCount-1 do
      begin
        if li <> 0 then
          AddRow;

        lrow := RowCount-1;

        Cells[0,lrow] := IntToStr(lrow);
        Cells[1,lrow] := FieldByName('EQUIPNO').AsString;
        Cells[2,lrow] := FieldByName('EQNAME').AsString;
        NEXT;
      end;
    end;
  end;
end;

procedure TtrObject_Frm.Set_Header(aidx:Integer);
var
  li : Integer;
begin
  with listGrid do
  begin
    BeginUpdate;
    try
      ClearAll;

      ColCount := 3;
      FixedCols := 0;
      FixedColWidth := 23;

      while RowCount > 2 do
        RemoveRows(2,1);

      Cells[0,0] := '순';
      if aidx > 0 then
      begin
        Cells[1,0] := '관리코드';
        Cells[2,0] := '품명';
      end else
      begin
        Cells[1,0] := '공사번호';
        Cells[2,0] := '엔진타입';
      end;
    finally
      FixedRowAlways := True;
      EndUpdate;
    end;
  end;
end;

end.
