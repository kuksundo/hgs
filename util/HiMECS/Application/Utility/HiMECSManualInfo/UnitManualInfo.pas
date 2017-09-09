unit UnitManualInfo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  HiMECSManualClass, CommonUtil, Vcl.StdCtrls, Vcl.Mask, JvExMask, JvToolEdit,
  Vcl.ComCtrls, Vcl.ExtCtrls, Word2010, Vcl.Menus, ActiveX,
  OtlTask, OtlCommon, OtlCollections, OtlParallel, OtlTaskControl,
  OtlEventMonitor, OtlComm;

const
  WM_FUTURE_RESULT = WM_USER + 1;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    JvDirectoryEdit1: TJvDirectoryEdit;
    Label1: TLabel;
    Button1: TButton;
    ListView1: TListView;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    PopupMenu1: TPopupMenu;
    ChangeManualFilePath1: TMenuItem;
    FileText1: TMenuItem;
    Label2: TLabel;
    JvDirectoryEdit2: TJvDirectoryEdit;
    CheckBox1: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ChangeManualFilePath1Click(Sender: TObject);
    procedure FileText1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    FHiMECSManualInfo: THiMECSManualInfo;
    FGetManualInfoFuture: IOmniFuture<Boolean>;
    wordApp : _Application;
    FCount: integer;

//    FOTLMonitor    : TOmniEventMonitor;
    FScanTask      : IOmniTaskControl;

    procedure OTLMonitorTaskMessage(const task: IOmniTaskControl; const msg: TOmniMessage);
    procedure OTLMonitorTaskTerminated(const task: IOmniTaskControl);
    procedure FutureResult(var msg: TOmniMessage); message WM_FUTURE_RESULT;

    function GetManualInfoFromFile(AFileName: string;
      AItem: THiMECSOpManualItem; AHeaderIndex: TOleEnum = wdHeaderFooterFirstPage;
      AIsSavePdf: Boolean=false; APdfFolderName: string=''): boolean;//wdHeaderFooterFirstPage
    function GetManualInfoFromFileName(AFileName: string; out ASecNo, ARevNo: string): string;
    procedure GetCategory(ADir: string);
    procedure GetManualInfo(const task: IOmniTask);
    procedure OnGetManualInfoCompleted(const task: IOmniTaskControl);
  public
    procedure ManualInfo2ListView(AManualInfo: THiMECSManualInfo);
    procedure AddManualItem2ListView(AManualItem: THiMECSOpManualItem);
  end;

var
  Form1: TForm1;

implementation

uses UnitFolderSelect;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
//  FGetManualInfoFuture := Parallel.Future<Boolean>(GetManualInfo,
//    Parallel.TaskConfig.OnTerminated(OnGetManualInfoCompleted));

  FScanTask := CreateTask(GetManualInfo, 'GetManualInfo')
//    .MonitorWith(FOTLMonitor)
    .SetParameter('FolderName', JvDirectoryEdit1.Text)
    .SetParameter('IsSavePDF', CheckBox1.Checked)
    .SetParameter('PdfFolderName', JvDirectoryEdit2.Text)
    .OnMessage(Self)
    .OnTerminated(OnGetManualInfoCompleted)
    .Run;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  LStr: string;
begin
  SetCurrentDir(ExtractFilePath(Application.ExeName));
  OpenDialog1.InitialDir := GetCurrentDir;

  if OpenDialog1.Execute() then
  begin
    LStr := OpenDialog1.FileName;
    FHiMECSManualInfo.Clear;
    ListView1.Clear;
    FHiMECSManualInfo.LoadFromJSONFile(LStr);
    ManualInfo2ListView(FHiMECSManualInfo);
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  wordApp : _Application;
  doc : WordDocument;
  LSections: Sections;
  LSection: Section;
  LHeaders: HeadersFooters;
  LHeader: HeaderFooter;
  LTable: Table;
  LCell: Cell;
  LFields: Fields;
  LField: Field;
  filename : OleVariant;
  i,j,k,m,n: integer;
  LStr,LStr2: string;
begin
  filename := '"E:\pjh\project\util\HiMECS\Application\Bin\Doc\Manual\H35DF 원본\LDF07-cooling water spec\G07100_1K_Cooling Water Treatment_Fresh water.doc"';
  try
    wordApp := CoWordApplication.Create;
    wordApp.visible := False;

    doc := wordApp.documents.open( filename, emptyparam,emptyparam,emptyparam,
      emptyparam,emptyparam,emptyparam,emptyparam,
      emptyparam,emptyparam,emptyparam,emptyparam,
      emptyparam,emptyparam,emptyparam,emptyparam );

    LSections := doc.Sections;
    for i := 1 to LSections.Count do
    begin
      LSection := LSections.Item(i);
      LHeaders := LSection.Headers;
      LHeader := LHeaders.Item(wdHeaderFooterFirstPage); //wdHeaderFooterFirstPage,wdHeaderFooterPrimary
      ShowMessage(LHeader.Range.Text);

//      LTable := LHeader.Range.Tables.Item(1);
//      LCell := LTable.Cell(3,1);
//      LStr := LCell.Range.Text;
//      LStr2 := strToken(LStr, #13);
//      ShowMessage(LStr2);
//      LCell := LTable.Cell(3,2);
//      LStr := LCell.Range.Text;
//      LStr2 := strToken(LStr, #13);
//      ShowMessage(LStr2);
//      LCell := LHeader.Range.Cells.Item(1);
//      ShowMessage(LCell.Range.Text);
//      ShowMessage(LHeader.Range.Text);

//      for j := 1 to LHeaders.Count do
//      begin
//        LHeader := LHeaders.Item(j);
//        ShowMessage(LHeader.Range.Text);
//        LFields := LHeader.Range.Fields;

//        for k := 1 to LFields.Count do
//        begin
//          LField := LFields.Item(k);
//          ShowMessage(IntToStr(LField.Index));
//        end;
//      end;
    end;
  finally
    wordApp.quit(EmptyParam, EmptyParam, EmptyParam);
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  LStr: string;
begin
  SetCurrentDir(ExtractFilePath(Application.ExeName));
  SaveDialog1.InitialDir := GetCurrentDir;

  if SaveDialog1.Execute() then
  begin
    LStr := SaveDialog1.FileName;

    FHiMECSManualInfo.SaveToJSONFile(LStr);
  end;
end;

procedure TForm1.ChangeManualFilePath1Click(Sender: TObject);
var
  LForm: TFolderSelectF;
  i: integer;
begin
  LForm := TFolderSelectF.Create(nil);
  try
    if LForm.ShowModal = mrOK then
    begin
      if LForm.JvDirectoryEdit1.Directory <> '' then
      begin
        ListView1.Items.BeginUpdate;
        try
          for i := 0 to ListView1.Items.Count - 1 do
          begin
            if ListView1.Items[i].Selected then
            begin
              if Assigned(ListView1.Items[i].Data) then
              begin
                THiMECSOpManualItem(ListView1.Items[i].Data).FilePath := LForm.JvDirectoryEdit1.Directory;
                ListView1.Items[i].SubItems[6] := LForm.JvDirectoryEdit1.Directory;
              end;
            end;
          end;
        finally
          ListView1.Items.EndUpdate;
        end;
      end;
    end;
  finally
    LForm.Free;
  end;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  Label2.Enabled := CheckBox1.Checked;
  JvDirectoryEdit2.Enabled := CheckBox1.Checked;
end;

procedure TForm1.FileText1Click(Sender: TObject);
var
  LHiMECSOpManualItem: THiMECSOpManualItem;
  filename : OleVariant;
begin
  filename := '"E:\pjh\project\util\HiMECS\Application\Bin\Doc\Manual\H35DF 원본\LDF01-engine design & data\G01500 1A_H35DF_Measuring record sheet.doc"';
//  filename := '"E:\pjh\project\util\HiMECS\Application\Bin\Doc\Manual\H35DF 원본\LDF06-lube oil spec\G06200_1B_H35DF_List of Lubricating Oil.doc"';

  LHiMECSOpManualItem := FHiMECSManualInfo.OpManual.Add;
  if not GetManualInfoFromFile(filename,LHiMECSOpManualItem) then
    GetManualInfoFromFile(filename,LHiMECSOpManualItem,wdHeaderFooterPrimary);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FHiMECSManualInfo := THiMECSManualInfo.Create(nil);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FHiMECSManualInfo.Free;
end;

procedure TForm1.FutureResult(var msg: TOmniMessage);
var
  LHiMECSOpManualItem: THiMECSOpManualItem;
begin
  LHiMECSOpManualItem := msg.MsgData.AsObject as THiMECSOpManualItem;
  AddManualItem2ListView(LHiMECSOpManualItem);
end;

procedure TForm1.GetCategory(ADir: string);
begin

end;

procedure TForm1.GetManualInfo(const task: IOmniTask);
var
  LHiMECSOpManualItem: THiMECSOpManualItem;
  LCategoryList, LManualFileList: TStringList;
  LStr, LFolderName, LPdfFolderName: string;
  i: integer;
  LIsSavePDF: boolean;

  procedure GetManualFileListFromDir(ADir: string);
  var j: integer;
  begin
    LManualFileList := GetFileListFromDir(ADir, '*.doc', False);
    try
      for j := 0 to LManualFileList.Count - 1 do
      begin
        if task.CancellationToken.IsSignalled then
          System.break;

        LStr := ExtractFileName(LManualFileList.Strings[j]);

        if Pos('~', LStr) > 0 then
        begin
          DeleteFile(LStr);
          Continue;
        end;

        if (Pos('G00000', LStr) < 1) then
        begin
          LHiMECSOpManualItem := FHiMECSManualInfo.OpManual.Add;
          LHiMECSOpManualItem.FileName := LStr;
          if LIsSavePDF then
            LHiMECSOpManualItem.FilePath := IncludeTrailingPathDelimiter(LPdfFolderName)
          else
            LHiMECSOpManualItem.FilePath := IncludeTrailingPathDelimiter(LPdfFolderName);//ExtractFilePath(LManualFileList.Strings[j]);

          if not GetManualInfoFromFile(LManualFileList.Strings[j],LHiMECSOpManualItem,wdHeaderFooterFirstPage,LIsSavePDF,LPdfFolderName) then
            GetManualInfoFromFile(LManualFileList.Strings[j],LHiMECSOpManualItem,wdHeaderFooterPrimary, LIsSavePDF,LPdfFolderName);

          inc(FCount);
          task.Comm.Send(WM_FUTURE_RESULT, LHiMECSOpManualItem);
//          task.Invoke(
//            procedure
//            begin
//              AddManualItem2ListView(LHiMECSOpManualItem);
//            end);
        end;
      end;
    finally
      LManualFileList.Free;
    end;
  end;
begin
  CoInitialize(nil);
//  wordApp := CoWordApplication.Create;
//  wordApp.visible := False;
  try
    FCount := 0;
    LFolderName := task.Param['FolderName'];
    LIsSavePDF := task.Param['IsSavePDF'];
    LPdfFolderName := task.Param['PdfFolderName'];
    //Category를 위해 폴더명만 가져옴
    LCategoryList := GetFileListFromDir(LFolderName, '*.*', false, faDirectory);

    if LCategoryList.Count > 0 then
    begin
      FHiMECSManualInfo.Clear;

      for i := 0 to LCategoryList.Count - 1 do
      begin
        GetManualFileListFromDir(LCategoryList.Strings[i]);
      end;

  //    task.Invoke(
  //      procedure
  //      begin
  //        ManualInfo2ListView(FHiMECSManualInfo);
  //      end);
    end;
  finally
//    wordApp.quit(EmptyParam, EmptyParam, EmptyParam);
    CoUnInitialize;
  end;
end;

function TForm1.GetManualInfoFromFile(AFileName: string;
  AItem: THiMECSOpManualItem; AHeaderIndex: TOleEnum;
  AIsSavePdf: Boolean; APdfFolderName: string):boolean;
var
//  wordApp : _Application;
  doc : WordDocument;
  LSections: Sections;
  LSection: Section;
  LHeaders: HeadersFooters;
  LHeader: HeaderFooter;
  LTable: Table;
  LCell: Cell;
//  LFields: Fields;
//  LField: Field;
  filename, LPdfFileName : OleVariant;
  i: integer;
  LStr: string;
  LSecNo, LRevNo: string;

  function GetSectionNo: string;
  begin
    LCell := LTable.Cell(2,3);
    LStr := LCell.Range.Text;
    Result := strToken(LStr, #13);

    if Pos('Section No.', Result) > 0 then
    begin
      strToken(LStr, #13);
      Result := Trim(strToken(LStr, #13));
    end;
  end;

  function GetRevNo: string;
  begin
    LCell := LTable.Cell(2,4);
    LStr := LCell.Range.Text;
    Result := strToken(LStr, #13);

    if Pos('Rev.', Result) > 0 then
    begin
      Result := strToken(LStr, #13);
      if Result <> '' then
        exit;

      Result := Trim(strToken(LStr, #13));
    end;
  end;

  function GetSystemDesc_Eng: string;
  begin
    LCell := LTable.Cell(2,1);
    Result := LCell.Range.Text;
    Result := strToken(Result, #13);
  end;

  function GetSystemDesc_Kor: string;
  begin
    LCell := LTable.Cell(3,1);
    LStr := LCell.Range.Text;
    Result := strToken(LStr, #13);
  end;

  function GetPartDesc_Eng: string;
  begin
    LCell := LTable.Cell(2,2);
    Result := LCell.Range.Text;
    Result := strToken(Result, #13);
  end;

  function GetPartDesc_Kor: string;
  begin
    LCell := LTable.Cell(3,2);
    LStr := LCell.Range.Text;
    Result := strToken(LStr, #13);
  end;

begin
  try
    Result := True;
    wordApp := CoWordApplication.Create;
    wordApp.visible := False;
    filename := AFileName;
    try
      doc := wordApp.documents.open( filename, emptyparam,emptyparam,emptyparam,
        emptyparam,emptyparam,emptyparam,emptyparam,
        emptyparam,emptyparam,emptyparam,emptyparam,
        emptyparam,emptyparam,emptyparam,emptyparam );

      LSections := doc.Sections;
      LSection := LSections.Item(1);

      if Pos('G06100',filename) > 0 then
      begin
//        ShowMessage(LSection.Range.Text);
      end;

      LPdfFileName := ChangeFileExt(ExtractFileName(filename), '.pdf');
      LPdfFileName := IncludeTrailingPathDelimiter(APdfFolderName) + LPdfFileName;
      LStr := ExtractFileName(filename);
      GetManualInfoFromFileName(LStr, LSecNo, LRevNo);

      LHeaders := LSection.Headers;
      LHeader := LHeaders.Item(AHeaderIndex); //wdHeaderFooterPrimary
      LTable := LHeader.Range.Tables.Item(1);
      AItem.SectionNo := GetSectionNo;

      if (LSecNo <> '') and (AItem.SectionNo <> LSecNo) then
      begin
        Result := False;
        exit;
      end;

//      if (Length(AItem.SectionNo) <> 6) then
      if Pos('.', AItem.SectionNo) > 0 then
      begin
        Result := False;
        exit;
      end;

      AItem.RevNo := GetRevNo;

      if (LRevNo <> '') and (AItem.RevNo <> LRevNo) then
      begin
        Result := False;
        exit;
      end;

      AItem.SystemDesc_Eng := GetSystemDesc_Eng;
      AItem.SystemDesc_Kor := GetSystemDesc_Kor;
      AItem.PartDesc_Eng := GetPartDesc_Eng;
      AItem.PartDesc_Kor := GetPartDesc_Kor;
    except
      Result := False;
    end;

    if AIsSavePdf then
      doc.SaveAs2(LPdfFileName, wdFormatPDF, emptyparam,emptyparam,emptyparam,
        emptyparam,emptyparam,emptyparam,emptyparam,
        emptyparam,emptyparam,emptyparam,emptyparam,
        emptyparam,emptyparam,emptyparam,emptyparam);
  finally
//    doc.Close(wdDoNotSaveChanges,wdFormatDocument,False);
//    doc.Close(wdDoNotSaveChanges,wdFormatDocument,False);
    wordApp.quit(wdDoNotSaveChanges, EmptyParam, EmptyParam);
  end;

end;

function TForm1.GetManualInfoFromFileName(AFileName: string; out ASecNo, ARevNo: string): string;
var
  LStr: string;
begin
  LStr := ExtractFileName(AFileName);
  ASecNo := strToken(LStr, '_');
  ARevNo := strToken(LStr, '_');
  Result := ASecNo + '_' + ARevNo;
end;

procedure TForm1.ManualInfo2ListView(AManualInfo: THiMECSManualInfo);
var
  LListItem: TListItem;
  i: integer;
begin
  for i := 0 to AManualInfo.OpManual.Count - 1 do
    AddManualItem2ListView(AManualInfo.OpManual.Items[i]);
end;

procedure TForm1.AddManualItem2ListView(AManualItem: THiMECSOpManualItem);
var
  LListItem: TListItem;
begin
  ListView1.Items.BeginUpdate;
  try
    LListItem:= ListView1.Items.Add;
    LListItem.Data := AManualItem;
    LListItem.Caption:= AManualItem.FileName;
    LListItem.SubItems.Add(AManualItem.SectionNo);
    LListItem.SubItems.Add(AManualItem.RevNo);
    LListItem.SubItems.Add(AManualItem.SystemDesc_Eng);
    LListItem.SubItems.Add(AManualItem.SystemDesc_Kor);
    LListItem.SubItems.Add(AManualItem.PartDesc_Eng);
    LListItem.SubItems.Add(AManualItem.PartDesc_Kor);
    LListItem.SubItems.Add(AManualItem.FilePath);
    LListItem.MakeVisible(False);
  finally
    ListView1.Items.EndUpdate;
  end;
end;

procedure TForm1.OnGetManualInfoCompleted(const task: IOmniTaskControl);
begin
  ShowMessage(IntToStr(FCount) + ' 건 작업완료');
end;

procedure TForm1.OTLMonitorTaskMessage(const task: IOmniTaskControl;
  const msg: TOmniMessage);
begin

end;

procedure TForm1.OTLMonitorTaskTerminated(const task: IOmniTaskControl);
begin

end;

end.
