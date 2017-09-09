unit wf_dzWizardFrame;

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
  Dialogs;

type
  TPrevNext = (pnPrevious, pnNext);

  Tfr_dzWizardFrame = class;

  TBeforePageChange = procedure(_Sender: TObject; _Direction: TPrevNext;
    _OldPageId: integer; var _NewPageId: integer;
    _OldPageData, _NewPageData: Pointer;
    var _CanChange: boolean) of object;

  TAfterPageChange = procedure(_Sender: TObject; _Direction: TPrevNext;
    _OldPageId, _NewPageId: integer;
    _OldPageData, _NewPageData: Pointer) of object;

  TWizardButtons = (wbPrev, wbNext, wbCancel);
  TWizardButtonSet = set of TWizardButtons;

  Tfr_dzWizardFrame = class(TFrame)
  private
    FPageId: integer;
    FNextPageId: integer;
    FDescription: string;
    FData: pointer;
    FBeforeExit: TBeforePageChange;
    FAfterEnter: TAfterPageChange;
  protected
    function GetNextPageId: integer; virtual;
    procedure SetNextPageId(const _Value: integer); virtual;
    procedure doUpdateButtonState;
  public
    constructor Create(_Owner: TComponent); override;
    procedure ButtonAllowed(_Button: TWizardButtons; var _Allowed: boolean); virtual;
    procedure PageActivate; virtual;
    procedure PageDeactivate; virtual;
    function Exiting(_Direction: TPrevNext; var _NewPageId: integer; _NewPage: Tfr_dzWizardFrame): boolean; virtual;
    procedure Entered(_Direction: TPrevNext; _OldPageId: integer; _OldPage: Tfr_dzWizardFrame); virtual;
    ///<summary> Called for all pages when the user presses the Cancel button, set Allow to false to prevent
    ///          the wizard from closing </summary>
    procedure CancelPressed(var _Allow: boolean); virtual;
    ///<summary> Called for all pages when calls to CancelPressed all returned true, just before closing
    ///          the wizard </summary>
    procedure Cancelling; virtual;
    property PageId: integer read FPageId write FPageId;
    property NextPageId: integer read GetNextPageId write SetNextPageId;
    property Description: string read FDescription write FDescription;
    property Data: pointer read FData write FData;
    property BeforeExit: TBeforePageChange read FBeforeExit write FBeforeExit;
    property AfterEnter: TAfterPageChange read FAfterEnter write FAfterEnter;
  end;

implementation

{$R *.dfm}

uses
  w_dzWizardForm;

{ Tfr_dzWizardFrame }

constructor Tfr_dzWizardFrame.Create(_Owner: TComponent);
begin
  inherited;
  FPageId := -1;
  FNextPageId := -1;
end;

procedure Tfr_dzWizardFrame.Cancelling;
begin
  // do nothing
end;

procedure Tfr_dzWizardFrame.CancelPressed(var _Allow: boolean);
begin
  // do nothing
end;

procedure Tfr_dzWizardFrame.doUpdateButtonState;
begin
  (Owner as Tf_dzWizardForm).UpdateButtonState;
end;

procedure Tfr_dzWizardFrame.ButtonAllowed(_Button: TWizardButtons; var _Allowed: boolean);
begin
  // do nothing
end;

procedure Tfr_dzWizardFrame.Entered(_Direction: TPrevNext; _OldPageId: integer; _OldPage: Tfr_dzWizardFrame);
begin
  if Assigned(FAfterEnter) then
    FAfterEnter(Self, _Direction, _OldPageId, PageId, _OldPage.Data, Data);
end;

function Tfr_dzWizardFrame.Exiting(_Direction: TPrevNext;
  var _NewPageId: integer; _NewPage: Tfr_dzWizardFrame): boolean;
var
  NewPageData: pointer;
begin
  Result := True;
  if Assigned(FBeforeExit) then begin
    if Assigned(_NewPage) then
      NewPageData := _NewPage.Data
    else
      NewPageData := nil;
    FBeforeExit(Self, _Direction, PageId, _NewPageId, Data, NewPageData, Result);
  end;
end;

function Tfr_dzWizardFrame.GetNextPageId: integer;
begin
  Result := FNextPageId;
end;

procedure Tfr_dzWizardFrame.PageActivate;
begin
  Align := alClient;
  Visible := true;
  doUpdateButtonState;
end;

procedure Tfr_dzWizardFrame.PageDeactivate;
begin
  Visible := false;
end;

procedure Tfr_dzWizardFrame.SetNextPageId(const _Value: integer);
begin
  FNextPageId := _Value;
end;

end.

