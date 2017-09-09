unit pjhPanel;

interface

uses
  Windows, Messages, SysUtils, Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Forms,
  frmDocInterface, AdvOfficePager, CustomLogic;

type
  TpjhPanel = class(TCustomLogicPanel, IbplDocInterface)
  private
    FOwner: TAdvOfficePage;
    FPageCaption: string;
    FIsDesignMode: Boolean;

    procedure Save;
    function SaveAs(AFileName: string): Boolean;
    function ICreateDocument(AOwner: TComponent; AFileName: string): TForm;
    function IGetDocument: TForm;
    procedure Modify;

    function GetMainForm: TForm;
    procedure SetMainForm(const Value: TForm);
    function GetFileName: String;
    procedure SetFileName(AValue: String);
    function GetFormCaption: String;
    procedure SetFormCaption(AValue: String);
    function GetModified: Boolean;
    procedure SetModified(AValue: Boolean);
    function GetIsDesignMode: Boolean;
    procedure SetIsDesignMode(AValue: Boolean);
    function GetOIForm: TForm;
    procedure SetOIForm(AValue: TForm);
  public
    constructor Create(AOwner: TComponent); override;

    property MainForm: TForm read GetMainForm write SetMainForm;
    property FileName: string read GetFileName write SetFileName;
    property FormCaption: string read GetFormCaption write SetFormCaption;
    property Modified: Boolean read GetModified write SetModified;
    property IsDesignMode: Boolean read GetIsDesignMode write SetIsDesignMode;
    property OIForm: TForm read GetOIForm write SetOIForm; //Create Document 시에 이 변수에 할당해 줘야 함

    property pjhOwner: TAdvOfficePage read FOwner write FOwner;
    property Canvas;
  published
    property PageCaption: string read FPageCaption write FPageCaption;
  end;

implementation

{ TpjhPanel }

constructor TpjhPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOwner := TAdvOfficePage(AOwner);
end;

function TpjhPanel.GetFileName: String;
begin

end;

function TpjhPanel.GetFormCaption: String;
begin

end;

function TpjhPanel.GetIsDesignMode: Boolean;
begin
  Result := FIsDesignMode;
end;

function TpjhPanel.GetMainForm: TForm;
begin

end;

function TpjhPanel.GetModified: Boolean;
begin

end;

function TpjhPanel.GetOIForm: TForm;
begin

end;

function TpjhPanel.ICreateDocument(AOwner: TComponent;
  AFileName: string): TForm;
begin

end;

function TpjhPanel.IGetDocument: TForm;
begin

end;

procedure TpjhPanel.Modify;
begin
  if PageCaption <> '' then
  begin
    pjhOwner.Caption := PageCaption;
  end;
end;

procedure TpjhPanel.Save;
begin

end;

function TpjhPanel.SaveAs(AFileName: string): Boolean;
begin

end;

procedure TpjhPanel.SetFileName(AValue: String);
begin

end;

procedure TpjhPanel.SetFormCaption(AValue: String);
begin

end;

procedure TpjhPanel.SetIsDesignMode(AValue: Boolean);
begin
  FIsDesignMode := AValue;
end;

procedure TpjhPanel.SetMainForm(const Value: TForm);
begin

end;

procedure TpjhPanel.SetModified(AValue: Boolean);
begin

end;

procedure TpjhPanel.SetOIForm(AValue: TForm);
begin

end;

end.
