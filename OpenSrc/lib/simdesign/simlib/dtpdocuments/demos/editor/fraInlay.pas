{
  unit fraInlay

  Base class for effect inlays

}
unit fraInlay;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, dtpEffectShape, StdCtrls;

type
  TfrInlay = class(TFrame)
    pnlEffectName: TPanel;
    lbEnabled: TLabel;
  private
    FEffect: TdtpEffect;
    procedure SetEffect(const Value: TdtpEffect);
    function GetDocument: TObject;
  protected
    FUpdating: boolean;
    procedure BeginUpdate;
    procedure EffectToFrame; virtual;
    procedure EndUpdate;
  public
    // Pointer to the parent TdtpDocument (cast as Object)
    property Document: TObject read GetDocument;
    property Effect: TdtpEffect read FEffect write SetEffect;
  end;

  TfrInlayClass = class of TfrInlay;

implementation

uses
  dtpDocument;

{$R *.DFM}

{ TfrInlay }

procedure TfrInlay.BeginUpdate;
begin
  if FUpdating or not assigned(Effect) or not assigned(Document) then exit;
  TdtpDocument(Document).BeginUndo;
  TdtpDocument(Document).BeginUpdate;
end;

procedure TfrInlay.EffectToFrame;
begin
  // Override this method in descendant frames
  if assigned(Effect) then begin
    if Effect.Enabled then
      lbEnabled.Caption := 'Enabled'
    else
      lbEnabled.Caption := 'Disabled';
  end else
    lbEnabled.Caption := '';
end;

procedure TfrInlay.EndUpdate;
begin
  if FUpdating or not assigned(Effect) or not assigned(Document) then exit;
  TdtpDocument(Document).EndUndo;
  TdtpDocument(Document).EndUpdate;
end;

function TfrInlay.GetDocument: TObject;
begin
  Result := nil;
  if assigned(FEffect) and assigned(FEffect.Parent) then
    Result := FEffect.Parent.Document;
end;

procedure TfrInlay.SetEffect(const Value: TdtpEffect);
begin
  FEffect := Value;
  FUpdating := True;
  try
    EffectToFrame;
  finally
    FUpdating := False;
  end;
end;

end.
