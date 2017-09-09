unit newMounted_Unit;

interface

uses
  System.SysUtils, Forms, NxColumnClasses, Vcl.StdCtrls, Vcl.ExtCtrls,
  NxCollection, JvExStdCtrls, JvEdit, NxColumns, NxScrollControl,
  NxCustomGridControl, NxCustomGrid, NxGrid,
  Vcl.Controls, Vcl.ComCtrls, AdvDateTimePicker, NxEdit, AdvSmoothTileList,
  GradientLabel, AeroButtons, JvExControls, JvLabel, Vcl.Imaging.jpeg,
  Vcl.Dialogs, Vcl.ExtDlgs, AdvSmoothTileListImageVisualizer,
  AdvSmoothTileListHTMLVisualizer, System.Classes, Vcl.ImgList, StrUtils,
  AdvGlowButton;

type
  TnewMounted_Frm = class(TForm)
    ImageList16x16: TImageList;
    AdvSmoothTileListHTMLVisualizer1: TAdvSmoothTileListHTMLVisualizer;
    OpenPictureDialog1: TOpenPictureDialog;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    ImageList32x32: TImageList;
    Panel8: TPanel;
    Image1: TImage;
    Panel1: TPanel;
    JvLabel1: TJvLabel;
    btn_Close: TAeroButton;
    NxHeaderPanel1: TNxHeaderPanel;
    GradientLabel2: TGradientLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label5: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    ImgList: TAdvSmoothTileList;
    Button4: TButton;
    Button7: TButton;
    maker: TNxComboBox;
    ptype: TNxComboBox;
    pser: TNxEdit;
    runhour: TNxNumberEdit;
    mdate: TAdvDateTimePicker;
    aDraw: TNxEdit;
    bDraw: TNxEdit;
    winfo: TListBox;
    reason: TMemo;
    delBtn: TButton;
    Button1: TButton;
    Button2: TButton;
    NxHeaderPanel2: TNxHeaderPanel;
    NxSplitter1: TNxSplitter;
    NxSplitter2: TNxSplitter;
    NxHeaderPanel3: TNxHeaderPanel;
    JvLabel4: TJvLabel;
    et_EngType: TEdit;
    grid_MS: TNextGrid;
    NxTreeColumn1: TNxTreeColumn;
    NxTextColumn11: TNxTextColumn;
    NxTextColumn13: TNxTextColumn;
    grid_Part: TNextGrid;
    NxIncrementColumn2: TNxIncrementColumn;
    NxTextColumn5: TNxTextColumn;
    NxTextColumn6: TNxTextColumn;
    NxTextColumn7: TNxTextColumn;
    NxTextColumn9: TNxTextColumn;
    NxTextColumn8: TNxTextColumn;
    NxTextColumn10: TNxTextColumn;
    NxTextColumn12: TNxTextColumn;
    NxTextColumn14: TNxTextColumn;
    NxTextColumn15: TNxTextColumn;
    NxTextColumn16: TNxTextColumn;
    Label4: TLabel;
    fileGrid: TNextGrid;
    NxIncrementColumn3: TNxIncrementColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn17: TNxTextColumn;
    AdvGlowButton5: TAdvGlowButton;
    AdvGlowButton6: TAdvGlowButton;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure grid_MSSelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
    FOrder_No:String;
  public
    { Public declarations }
    procedure Get_MS_Number;
    procedure Get_Info_Selected_Part(aMS,aProjNo:String);
    procedure Init_;


  end;

  // FillChar(FnewDataInfo,SizeOf(FnewDataInfo),'');

var
  newMounted_Frm: TnewMounted_Frm;
  procedure Create_newMounted_Frm(aOrderNo,aEngType:String);

implementation

uses
  CommonUtil_Unit,
  DataModule_Unit;

{$R *.dfm}
{ TnewMounted_Frm }

procedure Create_newMounted_Frm(aOrderNo,aEngType:String);
begin
  newMounted_Frm := TnewMounted_Frm.Create(nil);
  try
    with newMounted_Frm do
    begin
      FOrder_No := aOrderNo;
      et_EngType.Text := aEngType;

      ShowModal;

    end;
  finally
    FreeAndNil(newMounted_Frm);
  end;
end;

procedure TnewMounted_Frm.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TnewMounted_Frm.Button2Click(Sender: TObject);
var
  i : Integer;
begin
  maker.Items.Clear;
  maker.Clear;

  ptype.Items.Clear;
  ptype.Clear;

  pser.Clear;
  mdate.DateTime := Now;
  runhour.Value := 0;
  aDraw.Clear;
  bDraw.Clear;

  winfo.Items.Clear;
  reason.Clear;
  ImgList.Tiles.Clear;
  fileGrid.ClearRows;

  GradientLabel2.Caption := '신규정보 입력';
  Button1.Caption := '탑재정보등록';
  delBtn.Enabled := False;
end;

procedure TnewMounted_Frm.Button4Click(Sender: TObject);
var
  i : Integer;
  LTile : TAdvSmoothTile;
begin
  with ImgList do
  begin
    BeginUpdate;
    try
      if OpenPictureDialog1.Execute then
      begin
        for i := 0 to OpenPictureDialog1.Files.Count-1 do
        begin
          LTile := Tiles.Add;

          with LTile do
          begin
            Content.Hint := OpenPictureDialog1.Files.Strings[i];
            Content.Image.LoadFromFile(Content.Hint);
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TnewMounted_Frm.FormCreate(Sender: TObject);
begin

  ImgList.Tiles.Clear;

  Get_MS_Number;

end;

procedure TnewMounted_Frm.Get_Info_Selected_Part(aMS, aProjNo: String);
var
  i : Integer;
begin
  with grid_Part do
  begin
    BeginUpdate;
    try
      ClearRows;

      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM HIMSEN_MS_MOUNTED ' +
                'WHERE MSNO LIKE :param1 ' +
                'AND PROJNO LIKE :param2 ');

        ParamByName('param1').AsString := aMS;
        ParamByName('param2').AsString := aProjNo;
        Open;

        if RecordCount <> 0 then
        begin
          while not eof do
          begin
            AddRow;

            Cells[1,LastAddedRow] := FieldByName('MOUNTNO').AsString;
            Cells[2,LastAddedRow] := FieldByName('PROJNO').AsString;
            Cells[3,LastAddedRow] := FieldByName('MSNO').AsString;
            Cells[4,LastAddedRow] := FormatDateTime('YYYY-MM-DD HH:mm',FieldByName('MOUNTED').AsDateTime);
            Cells[5,LastAddedRow] := FieldByName('MAKER').AsString;
            Cells[6,LastAddedRow] := FieldByName('TYPE_').AsString;
            Cells[7,LastAddedRow] := FieldByName('SERIALNO').AsString;
            Cells[8,LastAddedRow] := FieldByName('REASON').AsString;
            Cells[9,LastAddedRow] := FieldByName('BDRAWNO').AsString;
            Cells[10,LastAddedRow] := FieldByName('ADRAWNO').AsString;

            Next;

          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TnewMounted_Frm.Get_MS_Number;
var
  i,
  LRow : Integer;

begin
  with grid_MS do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM HIMSEN_MS_NUMBER  ' +
                'START WITH PRTMSNO IS NULL ' +
                'CONNECT BY PRIOR MSNO = PRTMSNO ' +
                'ORDER SIBLINGS BY MSNO ');
        Open;

        while not eof do
        begin
          if RowCount = 0 then
            LRow := AddRow(1)
          else
          begin
            if FieldByName('PRTMSNO').AsString <> '' then
            begin
              for i := 0 to RowCount-1 do
              begin
                if Cells[0,i] = FieldByName('PRTMSNO').AsString then
                begin
                  AddChildRow(i,crLast);
                  LRow := LastAddedRow;
                  Break;
                end;
              end;
            end else
              LRow := AddRow(1);

          end;

          Cells[0,lrow] := FieldByName('MSNAME').AsString;
          Cells[1,lrow] := FieldByName('MSNO').AsString;
          Cells[2,lrow] := FieldByName('PRTMSNO').AsString;

          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TnewMounted_Frm.grid_MSSelectCell(Sender: TObject; ACol,
  ARow: Integer);
begin
  if ARow = -1 then
    Exit;

  with grid_MS do
  begin
    Get_Info_Selected_Part(Cells[1,ARow],LeftStr(et_EngType.Text,6));
  end;
end;

procedure TnewMounted_Frm.Init_;
begin
  ImgList.Tiles.Clear;
  fileGrid.DoubleBuffered := False;

  maker.Items.Clear;
  maker.Clear;

  ptype.Items.Clear;
  ptype.Clear;

  pser.Clear;
  mdate.DateTime := Now;
  runhour.Value := 0;
  aDraw.Clear;
  bDraw.Clear;

  winfo.Items.Clear;
  reason.Clear;
  ImgList.Tiles.Clear;
  delBtn.Enabled := False;
end;

end.
