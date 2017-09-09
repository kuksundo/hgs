unit UnitPdfView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, PdfiumCore, Vcl.ExtCtrls, Vcl.StdCtrls, PdfiumCtrl,
  Vcl.Samples.Spin, CopyData;

type
  TPDFViewF = class(TForm)
    btnPrev: TButton;
    btnNext: TButton;
    btnCopy: TButton;
    btnScale: TButton;
    chkLCDOptimize: TCheckBox;
    chkSmoothScroll: TCheckBox;
    edtZoom: TSpinEdit;
    btnPrint: TButton;
    PrintDialog1: TPrintDialog;
    OpenDialog1: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnScaleClick(Sender: TObject);
    procedure chkLCDOptimizeClick(Sender: TObject);
    procedure chkSmoothScrollClick(Sender: TObject);
    procedure edtZoomChange(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FCtrl: TPdfControl;
    FPdfFileName: string;

    procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;
    procedure WebLinkClick(Sender: TObject; Url: string);
  public
    procedure SetArguments(const AJson: string);
  end;

var
  PDFViewF: TPDFViewF;

implementation

uses
  System.TypInfo, Vcl.Printers, SynCommons;

{$R *.dfm}

procedure TPDFViewF.FormCreate(Sender: TObject);
begin
//  {$IFDEF CPUX64}
//  PDFiumDllDir := ExtractFilePath(ParamStr(0)) + 'x64';
//  {$ELSE}
//  PDFiumDllDir := ExtractFilePath(ParamStr(0));// + 'x86';
//  {$ENDIF CPUX64}

  FCtrl := TPdfControl.Create(Self);
  FCtrl.Align := alClient;
  FCtrl.Parent := Self;
  FCtrl.SendToBack; // put the control behind the buttons
  FCtrl.Color := clGray;
  FCtrl.ScaleMode := smFitWidth;
//  FCtrl.PageColor := RGB(255, 255, 200);
  FCtrl.OnWebLinkClick := WebLinkClick;

  edtZoom.Value := FCtrl.ZoomPercentage;

//  if OpenDialog1.Execute(Handle) then
//    FCtrl.LoadFromFile(OpenDialog1.FileName)
//  else
//  begin
//    Application.ShowMainForm := False;
//    Application.Terminate;
//  end;
end;

procedure TPDFViewF.FormDestroy(Sender: TObject);
begin
  FCtrl.Free;
end;

procedure TPDFViewF.SetArguments(const AJson: string);
var
  i: integer;
  LObj: Variant;
//  LUtf8: RawUTF8;
begin
  LObj := VariantLoadJSON(StringToUTF8(AJson));
  FPdfFileName := LObj[0];
end;

procedure TPDFViewF.btnPrevClick(Sender: TObject);
begin
  FCtrl.GotoPrevPage;
end;

procedure TPDFViewF.btnNextClick(Sender: TObject);
begin
  FCtrl.GotoNextPage;
end;

procedure TPDFViewF.btnCopyClick(Sender: TObject);
begin
  FCtrl.HightlightText('Delphi 2010', False, False);
end;

procedure TPDFViewF.btnScaleClick(Sender: TObject);
begin
  if FCtrl.ScaleMode = High(FCtrl.ScaleMode) then
    FCtrl.ScaleMode := Low(FCtrl.ScaleMode)
  else
    FCtrl.ScaleMode := Succ(FCtrl.ScaleMode);
  Caption := System.TypInfo.GetEnumName(TypeInfo(TPdfControlScaleMode), Ord(FCtrl.ScaleMode));
end;

procedure TPDFViewF.WebLinkClick(Sender: TObject; Url: string);
begin
  ShowMessage(Url);
end;

procedure TPDFViewF.WMCopyData(var Msg: TMessage);
var
  LStr, LFileName: string;
  LObj: variant;
begin
  case Msg.WParam of
    WParam_DISPLAYMSG: begin
      LStr := PRecToPass(PCopyDataStruct(Msg.LParam)^.lpData)^.StrMsg;
      TDocVariant.New(LObj);
      LObj := _JSON(StringToUTF8(LStr));
      LFileName := ChangeFileExt(LObj.FileName, '.pdf');
      if FileExists(LFileName) then
      begin
        FCtrl.LoadFromFile(LFileName);
      end
      else
        ShowMessage(LFileName + ' file is not exist.');
    end;
  end;
end;

procedure TPDFViewF.chkLCDOptimizeClick(Sender: TObject);
begin
  if chkLCDOptimize.Checked then
    FCtrl.DrawOptions := FCtrl.DrawOptions + [proLCDOptimized]
  else
    FCtrl.DrawOptions := FCtrl.DrawOptions - [proLCDOptimized];
end;

procedure TPDFViewF.chkSmoothScrollClick(Sender: TObject);
begin
  FCtrl.SmoothScroll := chkSmoothScroll.Checked;
end;

procedure TPDFViewF.edtZoomChange(Sender: TObject);
begin
  FCtrl.ZoomPercentage := edtZoom.Value;
end;

procedure TPDFViewF.btnPrintClick(Sender: TObject);
begin
//  FCtrl.PageIndex := 1;
  if PrintDialog1.Execute(Handle) then
  begin
    Printer.BeginDoc;
    try
      FCtrl.CurrentPage.Draw(Printer.Canvas.Handle, 0, 0, Printer.PageWidth, Printer.PageHeight, prNormal, [proAnnotations, proPrinting]);
    finally
      Printer.EndDoc;
    end;
  end;
end;

end.
