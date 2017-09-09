unit UintUserManage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, NxColumns, NxColumnClasses, ImgList, NxEdit, ComCtrls,
  ToolWin, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid,
  ExtCtrls, Menus, NxClasses, HiMECSConst, HiMECSUserClass, Buttons,
  NxVirtualColumn, Vcl.Mask, JvExMask, JvToolEdit;

type
  TFrmUserManage = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel1: TPanel;
    Button1: TButton;
    Panel2: TPanel;
    Panel3: TPanel;
    PageControl2: TPageControl;
    TabSheet3: TTabSheet;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    btnLeftAlignment: TToolButton;
    btnCenterAlignment: TToolButton;
    btnRightAlignment: TToolButton;
    ToolButton6: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton7: TToolButton;
    btnAddRow: TToolButton;
    btnAddCol: TToolButton;
    ToolButton10: TToolButton;
    ToolButton13: TToolButton;
    ToolButton12: TToolButton;
    ToolButton14: TToolButton;
    ToolButton16: TToolButton;
    ToolButton15: TToolButton;
    ToolButton8: TToolButton;
    ToolButton17: TToolButton;
    ToolButton20: TToolButton;
    ToolButton18: TToolButton;
    ToolButton19: TToolButton;
    ToolButton9: TToolButton;
    ToolButton21: TToolButton;
    ToolButton22: TToolButton;
    ToolButton1: TToolButton;
    btnBold: TToolButton;
    btnItalic: TToolButton;
    btnUnderline: TToolButton;
    ToolButton2: TToolButton;
    ColorPickerEditor1: TNxColorPicker;
    ToolButton11: TToolButton;
    Panel4: TPanel;
    NextGrid1: TNextGrid;
    Button2: TButton;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    N1: TMenuItem;
    SystemClose1: TMenuItem;
    ImageList1: TImageList;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Button3: TButton;
    BitBtn1: TBitBtn;
    UserID: TNxTextColumn;
    Password: TNxTextColumn;
    NxName: TNxTextColumn;
    FamilyName: TNxTextColumn;
    email: TNxTextColumn;
    Authentication: TNxTextColumn;
    Country: TNxTextColumn;
    UserLevel: TNxComboBoxColumn;
    UserCategory: TNxComboBoxColumn;
    RegisterDate: TNxDateColumn;
    ExpireDate: TNxDateColumn;
    Button4: TButton;
    EncryptCB: TCheckBox;
    Menufilename: TNxButtonColumn;
    Button5: TButton;
    Button6: TButton;
    Label22: TLabel;
    AutoUpdateFilenameEdit: TJvFilenameEdit;
    UpdateCB: TCheckBox;
    procedure btnLeftAlignmentClick(Sender: TObject);
    procedure btnCenterAlignmentClick(Sender: TObject);
    procedure btnRightAlignmentClick(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure btnAddRowClick(Sender: TObject);
    procedure ToolButton13Click(Sender: TObject);
    procedure ToolButton14Click(Sender: TObject);
    procedure ToolButton16Click(Sender: TObject);
    procedure ToolButton8Click(Sender: TObject);
    procedure ToolButton17Click(Sender: TObject);
    procedure ToolButton18Click(Sender: TObject);
    procedure ToolButton19Click(Sender: TObject);
    procedure btnBoldClick(Sender: TObject);
    procedure btnItalicClick(Sender: TObject);
    procedure btnUnderlineClick(Sender: TObject);
    procedure ColorPickerEditor1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure MenufilenameButtonClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    FHiMECSUser: THiMECSUser;

  public

  end;

var
  FrmUserManage: TFrmUserManage;

implementation

{$R *.dfm}

procedure TFrmUserManage.btnLeftAlignmentClick(Sender: TObject);
begin
  NextGrid1.Columns[NextGrid1.SelectedColumn].Alignment := taLeftJustify;
end;

procedure TFrmUserManage.btnCenterAlignmentClick(Sender: TObject);
begin
  NextGrid1.Columns[NextGrid1.SelectedColumn].Alignment := taCenter;
end;

procedure TFrmUserManage.btnRightAlignmentClick(Sender: TObject);
begin
  NextGrid1.Columns[NextGrid1.SelectedColumn].Alignment := taRightJustify;
end;

procedure TFrmUserManage.ToolButton3Click(Sender: TObject);
begin
  NextGrid1.Columns[NextGrid1.SelectedColumn].VerticalAlignment := taAlignTop;
end;

procedure TFrmUserManage.ToolButton4Click(Sender: TObject);
begin
  NextGrid1.Columns[NextGrid1.SelectedColumn].VerticalAlignment := taVerticalCenter;
end;

procedure TFrmUserManage.ToolButton5Click(Sender: TObject);
begin
  NextGrid1.Columns[NextGrid1.SelectedColumn].VerticalAlignment := taAlignBottom;
end;

procedure TFrmUserManage.btnAddRowClick(Sender: TObject);
begin
  NextGrid1.AddRow;
  NextGrid1.SelectLastRow;
end;

procedure TFrmUserManage.ToolButton13Click(Sender: TObject);
var
  Li: integer;
  LRow: integer;
begin
  LRow := NextGrid1.AddRow;

  for Li := 0 to 8 do
    NextGrid1.Cells[Li, LRow] := NextGrid1.Cells[Li, NextGrid1.SelectedRow];

  NextGrid1.SelectLastRow;
end;

procedure TFrmUserManage.ToolButton14Click(Sender: TObject);
begin
  NextGrid1.DeleteRow(NextGrid1.SelectedRow);
end;

procedure TFrmUserManage.ToolButton16Click(Sender: TObject);
begin
  NextGrid1.Columns.Delete(NextGrid1.SelectedColumn);
end;

procedure TFrmUserManage.ToolButton8Click(Sender: TObject);
begin
  NextGrid1.MoveRow(NextGrid1.SelectedRow, NextGrid1.SelectedRow - 1);
  NextGrid1.SelectedRow := NextGrid1.SelectedRow - 1;
end;

procedure TFrmUserManage.ToolButton17Click(Sender: TObject);
begin
  NextGrid1.MoveRow(NextGrid1.SelectedRow, NextGrid1.SelectedRow + 1);
  NextGrid1.SelectedRow := NextGrid1.SelectedRow + 1;
end;

procedure TFrmUserManage.ToolButton18Click(Sender: TObject);
var
  o, n: Integer;
begin
  o := NextGrid1.Columns[NextGrid1.SelectedColumn].Position;
  if o = 0 then Exit;
  n := o - 1;
  NextGrid1.Columns.ChangePosition(o, n);
end;

procedure TFrmUserManage.ToolButton19Click(Sender: TObject);
var
  o, n: Integer;
begin
  o := NextGrid1.Columns[NextGrid1.SelectedColumn].Position;
  n := o + 1;
  NextGrid1.Columns.ChangePosition(o, n);
end;

procedure TFrmUserManage.btnBoldClick(Sender: TObject);
begin
  with NextGrid1 do
    if CellBounds(SelectedColumn, SelectedRow) then
      if TToolButton(Sender).Down
        then Cell[SelectedColumn, SelectedRow].FontStyle := Cell[SelectedColumn, SelectedRow].FontStyle + [fsBold]
        else Cell[SelectedColumn, SelectedRow].FontStyle := Cell[SelectedColumn, SelectedRow].FontStyle - [fsBold];
end;

procedure TFrmUserManage.btnItalicClick(Sender: TObject);
begin
  with NextGrid1 do
    if CellBounds(SelectedColumn, SelectedRow) then
      if TToolButton(Sender).Down
        then Cell[SelectedColumn, SelectedRow].FontStyle := Cell[SelectedColumn, SelectedRow].FontStyle + [fsItalic]
        else Cell[SelectedColumn, SelectedRow].FontStyle := Cell[SelectedColumn, SelectedRow].FontStyle - [fsItalic];
end;

procedure TFrmUserManage.btnUnderlineClick(Sender: TObject);
begin
  with NextGrid1 do
    if CellBounds(SelectedColumn, SelectedRow) then
      if TToolButton(Sender).Down
        then Cell[SelectedColumn, SelectedRow].FontStyle := Cell[SelectedColumn, SelectedRow].FontStyle + [fsUnderline]
        else Cell[SelectedColumn, SelectedRow].FontStyle := Cell[SelectedColumn, SelectedRow].FontStyle - [fsUnderline];
end;

procedure TFrmUserManage.Button1Click(Sender: TObject);
var
  i,ls : integer;
  sFileName, LStr, LStr2 : string;
  F : TextFile;
begin
  SaveDialog1.Filter := 'User File|*.user';

  if SaveDialog1.Execute then
  begin
    sFileName := SaveDialog1.FileName;

    if NextGrid1.RowCount <= 0 then
    begin
      messagedlg('만들자료(그리드)가 존재하지 않습니다', mtConfirmation, [mbok], 0);
      Exit;
    end;

    try
      if NextGrid1.RowCount > 0 then
        FHiMECSUser.HiMECSUserCollect.Clear;

      if FileExists(sFileName) then
      begin

        if MessageDlg('이전에 작업한자료가 있습니다. 덮어쓰시겠습니까? No를 누르면 기존자료에 추가됨.',
        mtConfirmation, [mbYes, mbNo], 0)=mrNo then
          FHiMECSUser.LoadFromFile(sFileName, ExtractFileName(sFileName),EncryptCB.Checked)
        //Append(F)
        else
        begin
          AssignFile(F, sFileName);
          Rewrite(F);
          CloseFile(F);
        end;
      end;

      FHiMECSUser.AutoUpdateFileName := AutoUpdateFilenameEdit.Text;
      FHiMECSUser.UpdateWhenStart := UpdateCB.Checked;

      with NextGrid1 do
      begin
        for i := 0 to RowCount-1 do
        begin
          with FHiMECSUser.HiMECSUserCollect.Add do
          begin
            Name := CellByName['NxName', i].AsString;
            SurName := CellByName['FamilyName', i].AsString;
            eMail := CellByName['email', i].AsString;
            UserID := CellByName['UserID', i].AsString;
            Password := CellByName['Password', i].AsString;
            Authentication := CellByName['Authentication', i].AsString;
            Country := CellByName['Country', i].AsString;

            UserLevel := String2UserLevel(CellByName['UserLevel', i].AsString);
            UserCategory := String2UserCategory(CellByName['UserCategory', i].AsString);

            RegisterDate := CellByName['RegisterDate', i].AsDateTime;
            ExpirationDate := CellByName['ExpireDate', i].AsDateTime;
            MenuFileName := CellByName['MenuFileName', i].AsString;
          end;//with
        end;//for
      end;//with

    finally
      FHiMECSUser.SaveToFile(sFileName, ExtractFileName(sFileName),EncryptCB.Checked);
      //CloseFile(F);
    end;
  end;

end;

procedure TFrmUserManage.Button2Click(Sender: TObject);
begin
  NextGrid1.DeleteRow(NextGrid1.SelectedRow);
end;

procedure TFrmUserManage.Button3Click(Sender: TObject);
begin
  NextGrid1.AddRow;
  NextGrid1.SelectLastRow;
end;

procedure TFrmUserManage.Button4Click(Sender: TObject);
var
  i: integer;
begin
  OpenDialog1.Filter := 'HiMECS User(*.user)|*.user|All Files(*.*)|*.*';
  OpenDialog1.InitialDir := 'E:\pjh\project\util\HiMECS\Application\Bin\Config';

  if OpenDialog1.Execute then
  begin
    FHiMECSUser.HiMECSUserCollect.Clear;

    if OpenDialog1.FileName <> '' then
    begin

      FHiMECSUser.LoadFromFile(OpenDialog1.FileName,
                  ExtractFileName(OpenDialog1.FileName),EncryptCB.Checked);

      if FHiMECSUser.HiMECSUserCollect.Count > 0 then
        NextGrid1.ClearRows;

      AutoUpdateFilenameEdit.Text := FHiMECSUser.AutoUpdateFileName;
      UpdateCB.Checked := FHiMECSUser.UpdateWhenStart;

      with NextGrid1, FHiMECSUser do
      begin
        for i := 0 to HiMECSUserCollect.Count - 1 do
        begin
          AddRow();

          CellByName['NxName', i].AsString := HiMECSUserCollect.Items[i].Name;
          CellByName['FamilyName', i].AsString := HiMECSUserCollect.Items[i].SurName;
          CellByName['email', i].AsString := HiMECSUserCollect.Items[i].email;
          CellByName['UserID', i].AsString := HiMECSUserCollect.Items[i].UserID;
          CellByName['Password', i].AsString := HiMECSUserCollect.Items[i].Password;
          CellByName['Authentication', i].AsString := HiMECSUserCollect.Items[i].Authentication;
          CellByName['Country', i].AsString := HiMECSUserCollect.Items[i].Country;
          CellByName['UserLevel', i].AsString := UserLevel2String(HiMECSUserCollect.Items[i].UserLevel);
          CellByName['UserCategory', i].AsString := UserCategory2String(HiMECSUserCollect.Items[i].UserCategory);
          CellByName['RegisterDate', i].AsDateTime := HiMECSUserCollect.Items[i].RegisterDate;
          CellByName['ExpireDate', i].AsDateTime := HiMECSUserCollect.Items[i].ExpirationDate;
          CellByName['MenuFileName', i].AsString := HiMECSUserCollect.Items[i].MenuFileName;
        end;//for
      end;//with
    end;
  end;
end;

procedure TFrmUserManage.Button5Click(Sender: TObject);
var
  i,ls : integer;
  sFileName, LStr, LStr2 : string;
  F : TextFile;
begin
  SaveDialog1.Filter := 'User File|*.user';

  if SaveDialog1.Execute then
  begin
    sFileName := SaveDialog1.FileName;

    if NextGrid1.RowCount <= 0 then
    begin
      messagedlg('만들자료(그리드)가 존재하지 않습니다', mtConfirmation, [mbok], 0);
      Exit;
    end;

    try
      if NextGrid1.RowCount > 0 then
        FHiMECSUser.HiMECSUserCollect.Clear;

      if FileExists(sFileName) then
      begin

        if MessageDlg('이전에 작업한자료가 있습니다. 덮어쓰시겠습니까? No를 누르면 기존자료에 추가됨.',
        mtConfirmation, [mbYes, mbNo], 0)=mrNo then
          FHiMECSUser.LoadFromFile(sFileName, ExtractFileName(sFileName),EncryptCB.Checked)
        //Append(F)
        else
        begin
          AssignFile(F, sFileName);
          Rewrite(F);
          CloseFile(F);
        end;
      end;

      FHiMECSUser.AutoUpdateFileName := AutoUpdateFilenameEdit.Text;
      FHiMECSUser.UpdateWhenStart := UpdateCB.Checked;

      with NextGrid1 do
      begin
        for i := 0 to RowCount-1 do
        begin
          with FHiMECSUser.HiMECSUserCollect.Add do
          begin
            Name := CellByName['NxName', i].AsString;
            SurName := CellByName['FamilyName', i].AsString;
            eMail := CellByName['email', i].AsString;
            UserID := CellByName['UserID', i].AsString;
            Password := CellByName['Password', i].AsString;
            Authentication := CellByName['Authentication', i].AsString;
            Country := CellByName['Country', i].AsString;

            UserLevel := String2UserLevel(CellByName['UserLevel', i].AsString);
            UserCategory := String2UserCategory(CellByName['UserCategory', i].AsString);

            RegisterDate := CellByName['RegisterDate', i].AsDateTime;
            ExpirationDate := CellByName['ExpireDate', i].AsDateTime;
            MenuFileName := CellByName['MenuFileName', i].AsString;
          end;//with
        end;//for
      end;//with

    finally
      FHiMECSUser.SaveToJSONFile(sFileName, ExtractFileName(sFileName),EncryptCB.Checked);
      //CloseFile(F);
    end;
  end;
end;

procedure TFrmUserManage.Button6Click(Sender: TObject);
var
  i: integer;
begin
  OpenDialog1.Filter := 'HiMECS User(*.user)|*.user|All Files(*.*)|*.*';
  OpenDialog1.InitialDir := 'E:\pjh\project\util\HiMECS\Application\Bin\Config';

  if OpenDialog1.Execute then
  begin
    FHiMECSUser.HiMECSUserCollect.Clear;

    if OpenDialog1.FileName <> '' then
    begin

      FHiMECSUser.LoadFromJSONFile(OpenDialog1.FileName,
                  ExtractFileName(OpenDialog1.FileName),EncryptCB.Checked);

      if FHiMECSUser.HiMECSUserCollect.Count > 0 then
        NextGrid1.ClearRows;



      AutoUpdateFilenameEdit.Text := FHiMECSUser.AutoUpdateFileName;
      UpdateCB.Checked := FHiMECSUser.UpdateWhenStart;

      with NextGrid1, FHiMECSUser do
      begin
        for i := 0 to HiMECSUserCollect.Count - 1 do
        begin
          AddRow();

          CellByName['NxName', i].AsString := HiMECSUserCollect.Items[i].Name;
          CellByName['FamilyName', i].AsString := HiMECSUserCollect.Items[i].SurName;
          CellByName['email', i].AsString := HiMECSUserCollect.Items[i].email;
          CellByName['UserID', i].AsString := HiMECSUserCollect.Items[i].UserID;
          CellByName['Password', i].AsString := HiMECSUserCollect.Items[i].Password;
          CellByName['Authentication', i].AsString := HiMECSUserCollect.Items[i].Authentication;
          CellByName['Country', i].AsString := HiMECSUserCollect.Items[i].Country;
          CellByName['UserLevel', i].AsString := UserLevel2String(HiMECSUserCollect.Items[i].UserLevel);
          CellByName['UserCategory', i].AsString := UserCategory2String(HiMECSUserCollect.Items[i].UserCategory);
          CellByName['RegisterDate', i].AsDateTime := HiMECSUserCollect.Items[i].RegisterDate;
          CellByName['ExpireDate', i].AsDateTime := HiMECSUserCollect.Items[i].ExpirationDate;
          CellByName['MenuFileName', i].AsString := HiMECSUserCollect.Items[i].MenuFileName;
        end;//for
      end;//with
    end;
  end;
end;

procedure TFrmUserManage.ColorPickerEditor1Change(Sender: TObject);
begin
  with NextGrid1 do
    if CellBounds(SelectedColumn, SelectedRow) then
    begin
      if ColorPickerEditor1.SelectedColor = clNone
        then Cell[SelectedColumn, SelectedRow].Color := Color
        else Cell[SelectedColumn, SelectedRow].Color := ColorPickerEditor1.SelectedColor;
    end;
end;

procedure TFrmUserManage.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FHiMECSUser.Free;
end;

procedure TFrmUserManage.FormCreate(Sender: TObject);
begin
  FHiMECSUser := THiMECSUser.Create(Self);

  UserLevel.Items.Clear;
  UserLevel2Strings(UserLevel.Items);

  UserCategory.Items.Clear;
  UserCatetory2Strings(UserCategory.Items);
end;

procedure TFrmUserManage.MenufilenameButtonClick(Sender: TObject);
begin
  OpenDialog1.Filter := 'Menu File|*.menu';
  if OpenDialog1.Execute then
    NextGrid1.Columns[NextGrid1.SelectedColumn].Editor.AsString := '.\config\'+
                                          ExtractFileName(OpenDialog1.FileName);
end;

end.

