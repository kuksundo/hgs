{ unit TipOfDays

  Tip of the day popup

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit guiTipOfDay;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, ActnList, ImgList, sdAbcVars;

const

  cTipsFile = 'tipofday.txt';

type
  TfrmTipOfDay = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    lblTip: TLabel;
    btnClose: TBitBtn;
    btnNext: TBitBtn;
    chbShowOnStartup: TCheckBox;
    procedure btnNextClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    procedure ShowNextTip;
  end;

var
  frmTipOfDay: TfrmTipOfDay;  

procedure ShowTipOfDay;

implementation

{$R *.DFM}

uses
  guiMain;

procedure TfrmTipOfDay.ShowNextTip;
var
  i: integer;
  S: TStringList;
  Tip: string;
begin
  S := TStringList.Create;
  try
    try
      S.LoadFromFile(FAppFolder + cTipsFile);
      // Read tip, skip 1 empty line if neccesary (for readability in the tip file)
      Tip := S[FTipOfDayNumber mod S.Count];
      if length(Tip)=0 then
      begin
        inc(FTipOfDayNumber);
        Tip := S[FTipOfDayNumber mod S.Count];
      end;
      // Replace ~ with CR
      for i := 1 to Length(Tip) do
        if Tip[i] = '~' then Tip[i] := #13;
      // Empty?
      if length(Tip) = 0 then
        Tip := 'If I want to get relaxed I always listen to Pink Floyd';
      // Show tip
      lblTip.Caption := Tip;
      // Prepare for next tip
      inc(FTipOfDayNumber);
    except
      lblTip.Caption := 'ABC-View could not find the tips file, sorry.';
    end;
  finally
    S.Free;
  end;
end;

procedure ShowTipOfDay;
begin
  if not FTipOfDay then exit;
  if not assigned(frmTipOfDay) then
    frmTipOfDay := TfrmTipOfDay.Create(frmMain);

  with frmTipOfDay do begin
    // Load the current tip
    ShowNextTip;
    // show the form
    Show;
  end;
end;

procedure TfrmTipOfDay.btnNextClick(Sender: TObject);
begin
  ShowNextTip;
end;

procedure TfrmTipOfDay.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmTipOfDay.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FTipOfDay := chbShowOnStartup.Checked;
end;

end.
