program BackUpGSFile;

uses
  Vcl.Forms,
  FrmBackUpMain in 'FrmBackUpMain.pas' {BackUpGSFile},
  FrameGSFileList in '..\..\..\common\Frames\FrameGSFileList.pas' {GSFileListFrame: TFrame},
  FrameDragDropOutlook in '..\..\..\common\Frames\FrameDragDropOutlook.pas' {DragOutlookFrame: TFrame},
  FrmFileList in 'FrmFileList.pas' {FileListF},
  UnitFileListRecord in 'UnitFileListRecord.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TBackUpGSFile, BackUpGSFile);
  Application.CreateForm(TFileListF, FileListF);
  Application.Run;
end.
