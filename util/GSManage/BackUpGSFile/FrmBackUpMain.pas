unit FrmBackUpMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxColumnClasses, NxColumns,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid,
  FrameDragDropOutlook, Vcl.ExtCtrls;

type
  TBackUpGSFile = class(TForm)
    Panel1: TPanel;
    DOFrame: TDragOutlookFrame;
    fileGrid: TNextGrid;
    NxIncrementColumn3: TNxIncrementColumn;
    FileSize: TNxTextColumn;
    FilePath: TNxTextColumn;
    DocType: TNxTextColumn;
    Files: TNxButtonColumn;
    procedure FilesButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure ShowFileListFormFromGrid(ARow: integer);
  end;

var
  BackUpGSFile: TBackUpGSFile;

implementation

{$R *.dfm}

procedure TBackUpGSFile.FilesButtonClick(Sender: TObject);
begin
  ShowFileListFormFromGrid(fileGrid.SelectedRow);
end;

procedure TBackUpGSFile.ShowFileListFormFromGrid(ARow: integer);
begin
  if ARow = -1 then
    exit;

end;

end.
