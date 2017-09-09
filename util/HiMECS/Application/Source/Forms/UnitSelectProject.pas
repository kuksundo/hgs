unit UnitSelectProject;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvSmoothPanel, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons, JvDialogs, Vcl.Menus, ProjectFileClass,
  UnitConfigProjectFile, JvBaseDlg, JvSelectDirectory;

type
  TSelectProjectForm = class(TForm)
    Panel1: TPanel;
    projectLV: TListView;
    StatusBar1: TStatusBar;
    Panel2: TPanel;
    Panel3: TPanel;
    Splitter1: TSplitter;
    GroupBox1: TGroupBox;
    DescriptMemo: TMemo;
    Label1: TLabel;
    Image1: TImage;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    CreateBtn: TBitBtn;
    JvSaveDialog1: TJvSaveDialog;
    PopupMenu1: TPopupMenu;
    ProjectPropertyView1: TMenuItem;
    JvSelectDirectory1: TJvSelectDirectory;
    procedure CreateBtnClick(Sender: TObject);
    procedure projectLVDblClick(Sender: TObject);
    procedure projectLVSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ProjectPropertyView1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
  private
    { Private declarations }
  public
    FExecFromHiMECS: Boolean;//HiMECS에서 실행하면 True, HiMECSProject.exe에서 실행하면 False

    procedure ListData2LV(AFileMask: string);
    procedure ConfigProjectFile(AFileName: string = '';
                      AIsEncrypt: Boolean = True; AEditable: Boolean = False);
  end;

var
  SelectProjectForm: TSelectProjectForm;

implementation

uses CommonUtil, jclNTFS;

{$R *.dfm}

{ TSelectProjectForm }

procedure TSelectProjectForm.CreateBtnClick(Sender: TObject);
begin
  ConfigProjectFile;
end;

procedure TSelectProjectForm.BitBtn3Click(Sender: TObject);
begin
  JvSelectDirectory1.InitialDir := 'E:\pjh\project\util\HiMECS\Application\Bin\Projects';
  if JvSelectDirectory1.Execute then
    ListData2LV('.himecs');
end;

procedure TSelectProjectForm.ConfigProjectFile(AFileName: string = '';
                    AIsEncrypt: Boolean = True; AEditable: Boolean = False);
var
  LConfigProjectFileForm: TConfigProjectFileForm;
  LProjectFile: TProjectFile;
  LFileName: string;
  F : TextFile;
  LFS: TJclFileSummary;
  LFSI: TJclFileSummaryInformation;
begin
  LConfigProjectFileForm := TConfigProjectFileForm.Create(Self);
  LProjectFile := TProjectFile.Create(nil);
  try
    //if AFileName = '' then

    with LConfigProjectFileForm do
    begin
      FExecFromHiMECS := Self.FExecFromHiMECS;

      SetCurrentDir(ExtractFilePath(Application.ExeName));
      OptionFilenameEdit.InitialDir := '.\config';
      UserFilenameEdit.InitialDir := '.\config';

      if AEditable then
      begin
        LProjectFile.LoadFromJSONFile(AFileName, ExtractFileName(AFileName), AIsEncrypt);
        ConfigData2Form(LProjectFile,-1);
        BitBtn1.Caption := 'Save';
        BitBtn6.Visible := True;
      end;

      if ShowModal = mrOK then
      begin
        FormData2ItemVar(FProjectFile, ProjectItemLV.Selected.Index,'E:\pjh\project\util\HiMECS\Application\Bin\');

        LProjectFile.Assign(FProjectFile);

        if AEditable then
        begin
          if FSaveAs then
          begin
            JvSaveDialog1.InitialDir := ExtractFilePath(Application.ExeName);
            JvSaveDialog1.Filter :=  '*.himecs';

            if JvSaveDialog1.Execute then
            begin
              LFileName := JvSaveDialog1.FileName;
              LFileName := ChangeFileExt(LFileName, '.himecs');

              if FileExists(LFileName) then
              begin
                if MessageDlg('File is already exist. Are you overwrite? if No press, then save is cancelled.',
                mtConfirmation, [mbYes, mbNo], 0)= mrNo then
                  //FEngineInfoCollect.LoadFromFile(LFileName, ExtractFileName(LFileName), False)
                else
                begin
                  AssignFile(F, LFileName);
                  Rewrite(F);
                  CloseFile(F);
                  AFileName := LFileName;
                end;
              end
              else
                AFileName := LFileName;
            end;
          end;

          LProjectFile.ProjectFileName := AFileName;
          LProjectFile.SaveToJSONFile(AFileName,
                  ExtractFileName(AFileName), True);
          LFileName := AFileName;
        end
        else
        begin
          JvSaveDialog1.InitialDir := ExtractFilePath(Application.ExeName);
          JvSaveDialog1.Filter :=  '*.himecs';

          if JvSaveDialog1.Execute then
          begin
            LFileName := JvSaveDialog1.FileName;
            LFileName := ChangeFileExt(LFileName, '.himecs');

            if FileExists(LFileName) then
            begin
              if MessageDlg('File is already exist. Are you overwrite? if No press, then save is cancelled.',
              mtConfirmation, [mbYes, mbNo], 0)= mrNo then
                //FEngineInfoCollect.LoadFromFile(LFileName, ExtractFileName(LFileName), False)
              else
              begin
                AssignFile(F, LFileName);
                Rewrite(F);
                CloseFile(F);
              end;
            end;
          end;
          LProjectFile.ProjectFileName := LFileName;
          LProjectFile.SaveToJSONFile(LFileName,
                  ExtractFileName(LFileName), True);
        end;

        projectLV.Items.Clear;
        //SetCurrentDir(ExtractFilePath(Application.ExeName)+'.\project');
        SetCurrentDir('E:\pjh\project\util\HiMECS\Application\Bin\projects');
        ListData2LV('.himecs');

        if LProjectFile.ProjectDescript <> '' then
        begin
          LFS:= TJclFileSummary.Create(LFileName, fsaReadWrite, fssDenyAll);
          try
            LFS.GetPropertySet(TJclFileSummaryInformation, LFSI);
            if Assigned(LFSI) then
            begin
              LFSI.Comments := LProjectFile.ProjectDescript;
              LFSI.AppName := Application.ExeName;
              LFSI.LastAuthor := LProjectFile.ProjectFileCollect.Items[0].UserFileName;
            end;
          finally
            FreeAndNil(LFSI);
            LFS.Free;
          end;
        end;
      end;
    end;//with
  finally
    LConfigProjectFileForm.Free;
    LProjectFile.Free;
  end;//try
end;

procedure TSelectProjectForm.ListData2LV(AFileMask: string);
var
  LStrList: TStringList;
  i: integer;
  LItem: TListItem;
begin
  LStrList := TStringList.Create;
  projectLV.Clear;
  try
    GetFiles(LStrList, AFileMask);//AFileMask = '.himecs' //project list

    for i := 0 to LStrList.Count - 1 do
    begin
      LItem := projectLV.Items.Add;
      LItem.Caption := ExtractFileName(LStrList.Strings[i]);
      LItem.SubItems.Add(ExtractFilePath(LStrList.Strings[i]));
    end;
  finally
    LStrList.Free;
  end;
end;

procedure TSelectProjectForm.projectLVDblClick(Sender: TObject);
begin
  BitBtn1.Click;
end;

procedure TSelectProjectForm.projectLVSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
var
  LStr: string;
  LFS: TJclFileSummary;
  LFSI: TJclFileSummaryInformation;
begin
//  if Selected then
//  begin
//    DescriptMemo.Clear;
//    LStr := Item.SubItems.Strings[0]+ Item.Caption;
//    LFS:= TJclFileSummary.Create(LStr, fsaRead, fssDenyAll);
//    try
//      LFS.GetPropertySet(TJclFileSummaryInformation, LFSI);
//      if Assigned(LFSI) then
//      begin
//        DescriptMemo.Text := LFSI.Comments;
//      end;
//    finally
//      FreeAndNil(LFSI);
//      LFS.Free;
//    end;
//  end
end;

procedure TSelectProjectForm.ProjectPropertyView1Click(Sender: TObject);
var
  LItem: TListItem;
  LStr: string;
begin
  if projectLV.SelCount > 0 then
  begin
    LItem := projectLV.Selected;
    LStr := LItem.SubItems.Strings[0]+ LItem.Caption;

    ConfigProjectFile(LStr, True, True);
  end;
end;

end.
