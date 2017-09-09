unit StartButton_1_1_2;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, StdCtrls, Menus, SerialCommLogic;

type
  TpjhStartButton = class(TButton)
  private
    FStateMachine: TpjhLogicPanel;
    FSingleStep: Boolean;
    FAutoReset: Boolean;//로직 실행이 완료 된후 자동으로 초기 상태로 감
  protected
    function GetAction: TBasicAction;
    function GetAnchors: TAnchors;
    function GetBidiMode: TBidiMode;
    function GetCancel: Boolean;
    function GetCursor: TCursor;
    function GetDefault: Boolean;
    function GetDragCursor: TCursor;
    function GetDragKind: TDragKind;
    function GetDragMode: TDragMode;
    function GetEnabled: Boolean;
    function GetHeight: Integer;
    function GetHelpContext: THelpContext;
    function GetHelpKeyWord: String;
    function GetHelpType: THelpType;
    function GetLeft: Integer;
    function GetModalResult: TModalResult;
    function GetParentBidiMode: Boolean;
    function GetParentFont: Boolean;
    function GetParentShowHint: Boolean;
    function GetPopupMenu: TPopupMenu;
    function GetTabOrder: TTabOrder;
    function GetTabStop: Boolean;
    function GetTag: Longint;
    function GetTop: Integer;
    function GetVisible: Boolean;
    function GetWidth: Integer;

    procedure Click; override;
    procedure SetSingleStep(Value: Boolean);
  public
    constructor create(AOwner: TComponent); override;
  published
    property Action: TBasicAction read GetAction;
    property Anchors: TAnchors read GetAnchors;
    property BidiMode: TBidiMode read GetBiDiMode;
    property Cancel: Boolean read GetCancel;
    property Cursor: TCursor read GetCursor;
    property Default: Boolean read GetDefault;
    property DragCursor: TCursor read GetDragCursor;
    property DragKind: TDragKind read GetDragKind;
    property DragMode: TDragMode read GetDragMode;
    property Enabled: Boolean read GetEnabled;
    //property Height: Integer read GetHeight;
    property HelpContext: THelpContext read GetHelpContext;
    property HelpKeyWord: String read GetHelpKeyWord;
    property HelpType: THelpType read GetHelpType;
    //property Left: Integer read GetLeft;
    property ModalResult: TModalResult read GetModalResult;
    property ParentBidiMode: Boolean read GetParentBidiMode;
    property ParentFont: Boolean read GetParentFont;
    property ParentShowHint: Boolean read GetParentShowHint;
    property PopupMenu: TPopupMenu read GetPopupMenu;
    property TabOrder: TTabOrder read GetTabOrder;
    property TabStop: Boolean read GetTabStop;
    property Tag: Longint read GetTag;
    //property Top: Integer read GetTop;
    property Visible: Boolean read GetVisible;
    //property Width: Integer read GetWidth;

    property LogicControl: TpjhLogicPanel read FStateMachine write FStateMachine;
    property SingleStep: Boolean read FSingleStep write SetSingleStep;
    property AutoReset: Boolean read FAutoReset write FAutoReset;
  end;

implementation

uses CommLogic;

{ TpjhStartButton }

procedure TpjhStartButton.Click;
begin
  if AutoReset then
    LogicControl.Reset := AutoReset;

  if Assigned(LogicControl) then
    LogicControl.Execute;

  inherited;
end;

constructor TpjhStartButton.create(AOwner: TComponent);
var i: integer;
begin
  inherited;
  
  LogicControl := nil;

  for i := 0 to AOwner.ComponentCount - 1 do
  begin
    if AOwner.Components[i].ClassType = TpjhLogicPanel then
    begin
      LogicControl := TpjhLogicPanel(AOwner.Components[i]);
      break;
    end;
  end;
end;

function TpjhStartButton.GetAction: TBasicAction;
begin
  Result := inherited Action;
end;

function TpjhStartButton.GetAnchors: TAnchors;
begin
  Result := inherited Anchors;
end;

function TpjhStartButton.GetBidiMode: TBidiMode;
begin
  Result := inherited BidiMode;
end;

function TpjhStartButton.GetCancel: Boolean;
begin
  Result := inherited Cancel;
end;

function TpjhStartButton.GetCursor: TCursor;
begin
  Result := inherited Cursor;
end;

function TpjhStartButton.GetDefault: Boolean;
begin
  Result := inherited Default;
end;

function TpjhStartButton.GetDragCursor: TCursor;
begin
  Result := inherited DragCursor;
end;

function TpjhStartButton.GetDragKind: TDragKind;
begin
  Result := inherited DragKind;
end;

function TpjhStartButton.GetDragMode: TDragMode;
begin
  Result := inherited DragMode;
end;

function TpjhStartButton.GetEnabled: Boolean;
begin
  Result := inherited Enabled;
end;

function TpjhStartButton.GetHeight: Integer;
begin
  Result := inherited Height;
end;

function TpjhStartButton.GetHelpContext: THelpContext;
begin
  Result := inherited HelpContext;
end;

function TpjhStartButton.GetHelpKeyWord: String;
begin
  Result := inherited HelpKeyWord;
end;

function TpjhStartButton.GetHelpType: THelpType;
begin
  Result := inherited HelpType;
end;

function TpjhStartButton.GetLeft: Integer;
begin
  Result := inherited Left;
end;

function TpjhStartButton.GetModalResult: TModalResult;
begin
  Result := inherited ModalResult;
end;

function TpjhStartButton.GetParentBidiMode: Boolean;
begin
  Result := inherited ParentBidiMode;
end;

function TpjhStartButton.GetParentFont: Boolean;
begin
  Result := inherited ParentFont;
end;

function TpjhStartButton.GetParentShowHint: Boolean;
begin
  Result := inherited ParentShowHint;
end;

function TpjhStartButton.GetPopupMenu: TPopupMenu;
begin
  Result := inherited PopupMenu;
end;

function TpjhStartButton.GetTabOrder: TTabOrder;
begin
  Result := inherited TabOrder;
end;

function TpjhStartButton.GetTabStop: Boolean;
begin
  Result := inherited TabStop;
end;

function TpjhStartButton.GetTag: Longint;
begin
  Result := inherited Tag;
end;

function TpjhStartButton.GetTop: Integer;
begin
  Result := inherited Top;
end;

function TpjhStartButton.GetVisible: Boolean;
begin
  Result := inherited Visible;
end;

function TpjhStartButton.GetWidth: Integer;
begin
  Result := inherited Width;
end;

procedure TpjhStartButton.SetSingleStep(Value: Boolean);
begin
  if FSingleStep <> Value then
  begin
    FSingleStep := Value;
    
    if Assigned(LogicControl) then
      if Value then
        LogicControl.Options := LogicControl.Options + [soSingleStep]
      else
        LogicControl.Options := LogicControl.Options - [soSingleStep];
  end;
end;

end.
