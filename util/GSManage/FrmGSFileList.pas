unit FrmGSFileList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Winapi.Activex, WinApi.ShellAPI,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvGlowButton, Vcl.ExtCtrls,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, JvExControls, JvLabel, Vcl.ImgList, FrmFileSelect,
  DragDropInternet,DropSource,DragDropFile,DragDropFormats, DragDrop, DropTarget,
  mORMot, SynCommons, SynSqlite3Static, UnitGSFileRecord, FrameGSFileList;

type
  TGSFileListF = class(TForm)
  private
    procedure LoadGSFileRecsFromJSONToGrid;
  public
    FGSFileRecsJson: string;
  end;

function CreateGSFileListFormFromJSON(var AGSFileRecsJson: string): integer;

var
  GSFileListF: TGSFileListF;

implementation

uses UnitGSFileData;

{$R *.dfm}

//AGSFileRecsJson은 UnitVariantJsonUtil.MakeGSFileRecs2JSON함수를 이용하여 만들어짐.
//AGSFileRecsJson은 = {"Files": [{...},{...}]} 형식임
function CreateGSFileListFormFromJSON(var AGSFileRecsJson: string): integer;
var
  LGSFileListF: TGSFileListF;
begin
  Result := -1;

  LGSFileListF := TGSFileListF.Create(nil);
  try
    LGSFileListF.FGSFileRecsJson := AGSFileRecsJson;
    LGSFileListF.LoadGSFileRecsFromJSONToGrid;

    if LGSFileListF.ShowModal = mrOK then
    begin
      LGSFileListF.GSFileListFrame.DeleteFileFromGrid2DB();
      AGSFileRecsJson := MakeGSFileRecs2JSON(LGSFileListF.GSFileListFrame.FGSFiles_.Files);
      Result := High(LGSFileListF.GSFileListFrame.FGSFiles_.Files) + 1;
    end;
  finally
    LGSFileListF.Free;
  end;
end;

{ TGSFileListF }

procedure TGSFileListF.LoadGSFileRecsFromJSONToGrid;
var
  LSQLGSFileRec: TSQLGSFileRec;
  LDocData: TDocVariantData;
  LVar: variant;
  LUtf8: RawUTF8;
  i: integer;
begin
  //FGSFileRecsJson = [] 형식의 배열 임
  LDocData.InitJSON(FGSFileRecsJson);

  with GSFileListFrame do
  begin
    fileGrid.ClearRows;

    if not Assigned(FGSFiles_) then
      FGSFiles_ := TSQLGSFile.Create;

    for i := 0 to LDocData.Count - 1 do
    begin
      LVar := _JSON(LDocData.Value[i]);
      LUtf8 := LVar;
      RecordLoadJson(LSQLGSFileRec, LUtf8, TypeInfo(TSQLGSFileRec)); 
//      RecordLoadJson(LSQLGSFileRec, @LUtf8[1], TypeInfo(TSQLGSFileRec)); 
//      LoadGSFileRecFromVariant(LSQLGSFileRec, LVar);

      if (LSQLGSFileRec.fFilename <> '') and (LSQLGSFileRec.fData <> '') then
      begin
        AddGSFileRec2GSFiles(LSQLGSFileRec);
        GSFileRec2Grid(LSQLGSFileRec, i, fileGrid);
      end;
    end;
  end;
end;

end.
