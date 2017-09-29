unit FrmDisplayTaskInfo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FrameDisplayTaskInfo;

type
  TDisplayTaskInfoF = class(TForm)
    TDisplayTaskF1: TDisplayTaskF;
    procedure TDisplayTaskF1grid_ReqCellDblClick(Sender: TObject; ACol,
      ARow: Integer);
    procedure FormCreate(Sender: TObject);
    procedure TDisplayTaskF1btn_CloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    FSelectedRow: integer;
  end;

var
  DisplayTaskInfoF: TDisplayTaskInfoF;

implementation

{$R *.dfm}

procedure TDisplayTaskInfoF.FormCreate(Sender: TObject);
begin
  FSelectedRow := -1;
  TDisplayTaskF1.rg_periodClick(nil);
end;

procedure TDisplayTaskInfoF.TDisplayTaskF1btn_CloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  Close;
end;

procedure TDisplayTaskInfoF.TDisplayTaskF1grid_ReqCellDblClick(Sender: TObject;
  ACol, ARow: Integer);
begin
//  TDisplayTaskF1.grid_ReqCellDblClick(Sender, ACol, ARow);
  FSelectedRow := ARow;
  ModalResult := mrOK;
end;

end.
