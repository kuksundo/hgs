unit w_dzUsage;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  ComCtrls,
  u_dzTranslator;

type
  Tf_dzUsage = class(TForm)
    p_Error: TPanel;
    l_ErrorMessage: TLabel;
    l_CalledAs: TLabel;
    ed_CalledAs: TEdit;
    pc_Main: TPageControl;
    ts_Usage: TTabSheet;
    ts_Examples: TTabSheet;
    ed_Usage: TEdit;
    l_Parameters: TLabel;
    m_Parameters: TMemo;
    l_Options: TLabel;
    m_Options: TMemo;
    m_Examples: TMemo;
    p_Bottom: TPanel;
    b_Close: TButton;
    procedure b_CloseClick(Sender: TObject);
  private
    procedure SetData(const _Caption: string; const _Error: string;
      const _CalledAs: string; const _Usage: string;
      const _Parameters: string; const _Options: string; const _Examples: string);
  public
    class procedure Execute(_Owner: TWinControl; const _Caption: string; const _Error: string;
      const _CalledAs: string; const _Usage: string;
      const _Parameters: string; const _Options: string; const _Examples: string); static;
    constructor Create(_Owner: TComponent); override;
  end;

implementation

{$R *.dfm}

uses
  u_dzVclUtils;

{ Tf_dzUsage }

class procedure Tf_dzUsage.Execute(_Owner: TWinControl; const _Caption, _Error, _CalledAs, _Usage,
  _Parameters, _Options, _Examples: string);
var
  frm: Tf_dzUsage;
begin
  frm := Tf_dzUsage.Create(_Owner);
  try
    TForm_CenterOn(frm, _Owner);
    TControl_SetMinConstraints(frm);
    frm.SetData(_Caption, _Error, _CalledAs, _Usage, _Parameters, _Options, _Examples);
    frm.ShowModal;
  finally
    FreeAndNil(frm);
  end;
end;

constructor Tf_dzUsage.Create(_Owner: TComponent);
begin
  inherited;

  TranslateComponent(Self, DZLIB_TRANSLATION_DOMAIN);

  p_Error.BevelOuter := bvNone;
  p_Bottom.BevelOuter := bvNone;
  pc_Main.ActivePage := ts_Usage;
end;

procedure Tf_dzUsage.SetData(const _Caption, _Error, _CalledAs, _Usage, _Parameters, _Options,
  _Examples: string);
begin
  Caption := _Caption;
  if _Error <> '' then begin
    l_ErrorMessage.Caption := _Error;
    ed_CalledAs.Text := _CalledAs;
  end else
    p_Error.Visible := False;
  ed_Usage.Text := _Usage;
  if _Parameters = '' then begin
    l_Parameters.Visible := False;
    m_Parameters.Visible := False;
    l_Options.Top := l_Parameters.Top;
    m_Options.Height := m_Options.Height + m_Options.Top - m_Parameters.Top;
    m_Options.Top := m_Parameters.Top;
  end else
    m_Parameters.Lines.Text := _Parameters;
  if _Options = '' then begin
    l_Options.Visible := False;
    m_Options.Visible := False;
    m_Parameters.Height := m_Options.Height + m_Options.Top - m_Parameters.Top;
  end else
    m_Options.Lines.Text := _Options;
  if _Examples <> '' then begin
    m_Examples.Lines.Text := _Examples
  end else
    ts_Examples.TabVisible := False;
end;

procedure Tf_dzUsage.b_CloseClick(Sender: TObject);
begin
  Close;
end;

end.

