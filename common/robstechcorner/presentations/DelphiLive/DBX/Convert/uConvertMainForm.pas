unit uConvertMainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TForm3 = class(TForm)
    lstFilesToProcess: TListBox;
    Label1: TLabel;
    Button1: TButton;
    dlgOpen: TOpenDialog;
    ProgressBar1: TProgressBar;
    btnProcessFiles: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure btnProcessFilesClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure FileProcessing(FileName : String);
  end;

var
  Form3: TForm3;

implementation
uses uProcessFiles;
{$R *.dfm}

procedure TForm3.btnProcessFilesClick(Sender: TObject);
var
 P : TProcessFilesToConvert;
begin
 // Setup Progress Bar
 ProgressBar1.Min := 0;
 ProgressBar1.Max := lstFilesToProcess.Count-1;
 ProgressBar1.Position := 0;


 // Process Files
 P := TProcessFilesToConvert.Create;
 try
   P.OnProcessingFile := FileProcessing;
   P.FilesToProcess.Assign(lstFilesToProcess.Items);
   P.ProcessFiles;
 finally
   P.Free;
 end;

  //Let Them know it's Complete
  ShowMessage('Completed');
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
  if dlgOpen.Execute then
  begin
    lstFilesToProcess.Items.Assign(dlgOpen.Files);
  end;
end;

procedure TForm3.FileProcessing(FileName: String);
begin
  ProgressBar1.Position := lstFilesToProcess.Items.IndexOf(FileName);
  Application.ProcessMessages;
end;

end.
