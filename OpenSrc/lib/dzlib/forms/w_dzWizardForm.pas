{.GXFormatter.config=twm}
unit w_dzWizardForm;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Contnrs,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  u_dzTranslator,
  wf_dzWizardFrame;

const
  ///<summary> Sent as NewPageId if the old page is the first/last page in that direction </summary>
  NO_MORE_PAGES = -1;

type
  EdzWizard = class(Exception);
  ECantGoBack = class(EdzWizard);
  EInvalidPageId = class(EdzWizard);

type
  TPageList = class;

  Tf_dzWizardForm = class;

  TOnFinished = procedure(_Sender: TObject; var _CanClose: boolean) of object;

  Tf_dzWizardForm = class(TForm)
    p_Client: TPanel;
    p_Buttons: TPanel;
    b_Next: TButton;
    b_Cancel: TButton;
    b_Prev: TButton;
    p_WizardSpace: TPanel;
    Bevel1: TBevel;
    p_Description: TPanel;
    l_Description: TLabel;
    p_MergeIn: TPanel;
    p_SeparatorLeft: TPanel;
    p_SeparatorRight: TPanel;
    p_Picture: TPanel;
    im_Image: TImage;
    procedure b_NextClick(Sender: TObject);
    procedure b_PrevClick(Sender: TObject);
    procedure b_CancelClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FDescLabelHeight: integer;
    FCurrentPageNo: integer;
    FCurrentPage: Tfr_dzWizardFrame;
    FMinWizardPageHeight: integer;
    FMinWizardPageWidth: integer;

    FBeforePageChange: TBeforePageChange;
    FAfterPageChange: TAfterPageChange;
    FOnFinished: TOnFinished;
    FCancelButtonCaption: string;
    FFinishedButtonCaption: string;
    FNextButtonCaption: string;
    FPrevButtonCaption: string;
    FTrail: TStack;
    procedure SetCurrentPageNo(_CurrentPageNo: integer);
    procedure SetNewPage(_NextPage: Tfr_dzWizardFrame);
    procedure SetCancelButtonCaption(const _Caption: string);
    procedure SetFinishedButtonCaption(const _Caption: string);
    procedure SetNextButtonCaption(const _Caption: string);
    procedure SetPrevButtonCaption(const _Caption: string);
    function GetPicture: TPicture;
    procedure SetPicture(const _Picture: TPicture);
  protected
    FPages: TPageList;
    procedure DoShow; override;
    ///<summary> called before the new page is displayed
    ///          @param Direction gives the direction of the page change
    ///          @param OldPageId is the ID of the page we are about to leave
    ///          @param NewPageId is the ID of the page we are about to enter
    ///          @param OldPageData is the Data parameter of the page we are about to leave
    ///          @param NewPageData is the Data parameter of the page we are about to enter
    ///          @returns true if the page change is allowed
    ///          Note: This is also called on the last page when the user presses the
    ///          Finish button. </summary>
    function DoBeforePageChange(_Direction: TPrevNext;
      _OldPageId: integer; var _NewPageId: integer;
      _OldPageData, _NewPageData: pointer): boolean; virtual;
    ///<summary> called after the new page has been displayed
    ///          @param Direction gives the direction of the page change
    ///          @param OldPageId is the ID of the page we just left
    ///          @param NewPageId is the ID of the page we just entered
    ///          @param OldPageData is the Data parameter of the page we just left
    ///          @param NewPageData is the Data parameter of the page we just entered
    ///          Note: Is not called after the last page! </summary>
    procedure DoAfterPageChange(_Direction: TPrevNext;
      _OldPageId, _NewPageId: integer;
      _OldPageData, _NewPageData: pointer); virtual;
    ///<summary> called after DoBeforePageChanged when the user presses the finish button
    ///          @returns true, if the dialog is done </summary>
    function DoOnFinished: boolean; virtual;
    ///<summary> Called when the user presses the cancel button.
    ///          @returns true, if canceling the dialog is allowed, false otherwise </summary>
    function DoOnCancel: boolean; virtual;
    procedure PageAdded(_PageFrame: Tfr_dzWizardFrame); virtual;
  public
    constructor Create(_Owner: TComponent); override;
    destructor Destroy; override;
    function GoForward: integer; virtual;
    function GoBack: integer; virtual;
    function GetEnabledButtons: TWizardButtonSet;
    procedure SetEnabledButtons(const _Buttons: TWizardButtonSet; _Enabled: boolean);
    procedure UpdateButtonState;
    property Pages: TPageList read FPages;
    property Picture: TPicture read GetPicture write SetPicture;
    property CurrentPageNo: integer read FCurrentPageNo write SetCurrentPageNo;
    property BeforePageChange: TBeforePageChange read FBeforePageChange write FBeforePageChange;
    property AfterPageChange: TAfterPageChange read FAfterPageChange write FAfterPageChange;
    property OnFinished: TOnFinished read FOnFinished write FOnFinished;
    property CancelButtonCaption: string read FCancelButtonCaption write SetCancelButtonCaption;
    property PrevButtonCaption: string read FPrevButtonCaption write SetPrevButtonCaption;
    property NextButtonCaption: string read FNextButtonCaption write SetNextButtonCaption;
    property FinishedButtonCaption: string read FFinishedButtonCaption write SetFinishedButtonCaption;
  end;

  TPageList = class
  protected
    FNextId: integer;
    FList: TList;
    FWizard: Tf_dzWizardForm;
    function GetPages(_Idx: integer): Tfr_dzWizardFrame;
    function PageById(_PageId: integer): Tfr_dzWizardFrame;
  public
    constructor Create(_Wizard: Tf_dzWizardForm);
    destructor Destroy; override;
    function AddPage(_Frame: Tfr_dzWizardFrame; const _Description: string; _Data: pointer = nil): integer;
    function PageCount: integer;
    property Pages[_Idx: integer]: Tfr_dzWizardFrame read GetPages; default;
  end;

implementation

{$R *.DFM}

uses
  u_dzVclUtils;

function _(const _s: string): string; inline;
begin
  Result := dzDGetText(_s, 'dzlib');
end;

{ TPageList }

constructor TPageList.Create(_Wizard: Tf_dzWizardForm);
begin
  inherited Create;
  FList := TList.Create;
  fWizard := _Wizard;
end;

destructor TPageList.Destroy;
begin
  FList.Free;
  inherited;
end;

function TPageList.AddPage(_Frame: Tfr_dzWizardFrame; const _Description: string; _Data: pointer = nil): integer;
var
  PrevPage: Tfr_dzWizardFrame;
  PrevIdx: integer;
begin
  PrevIdx := FList.Count - 1;
  Result := FNextId;
  Inc(FNextId);
  _Frame.Description := _Description;
  _Frame.Data := _Data;
  FList.Add(_Frame);
  FWizard.PageAdded(_Frame);
  _Frame.PageId := Result;
  if PrevIdx >= 0 then begin
    PrevPage := FList[PrevIdx];
    PrevPage.NextPageId := Result
  end;
end;

function TPageList.PageById(_PageId: integer): Tfr_dzWizardFrame;
var
  i: integer;
  Page: Tfr_dzWizardFrame;
begin
  for i := 0 to FList.Count - 1 do begin
    Page := FList[i];
    if Page.PageId = _PageId then begin
      Result := Page;
      exit;
    end;
  end;
  Result := nil;
end;

function TPageList.GetPages(_Idx: integer): Tfr_dzWizardFrame;
begin
  Result := FList[_Idx];
end;

function TPageList.PageCount: integer;
begin
  Result := FList.Count;
end;

{ Tf_dzWizardForm }

constructor Tf_dzWizardForm.Create(_Owner: TComponent);
begin
  inherited;
  FPages := TPageList.Create(self);
  FTrail := TStack.Create;
  PrevButtonCaption := _('< &Previous');
  CancelButtonCaption := _('Cancel');
  FNextButtonCaption := _('&Next >');
  FFinishedButtonCaption := _('&Finish');
  FDescLabelHeight := l_Description.Height;
  p_MergeIn.BorderStyle := bsNone;
  p_MergeIn.Caption := '';
  FMinWizardPageHeight := p_MergeIn.Height;
  FMinWizardPageWidth := p_MergeIn.Width;
end;

destructor Tf_dzWizardForm.Destroy;
begin
  FTrail.Free;
  FPages.Free;
  inherited;
end;

function Tf_dzWizardForm.DoBeforePageChange(_Direction: TPrevNext; _OldPageId: integer;
  var _NewPageId: integer; _OldPageData, _NewPageData: pointer): boolean;
begin
  Result := true;
  if Assigned(FBeforePageChange) then
    FBeforePageChange(self, _Direction, _OldPageId, _NewPageId, _OldPageData, _NewPageData, Result);
  if Result then
    Result := FPages.PageById(_OldPageId).Exiting(_Direction, _NewPageId, _NewPageData);
end;

procedure Tf_dzWizardForm.DoAfterPageChange(_Direction: TPrevNext; _OldPageId,
  _NewPageId: integer; _OldPageData, _NewPageData: pointer);
begin
  if Assigned(FAfterPageChange) then
    FAfterPageChange(self, _Direction, _OldPageId, _NewPageId, _OldPageData, _NewPageData);
  FPages.PageById(_NewPageId).Entered(_Direction, _OldPageId, _OldPageData);
end;

procedure Tf_dzWizardForm.DoShow;

  function AdjustExtend(_Current, _MergeIn, _Needed: integer): integer;
  begin
    if _Needed > _MergeIn then
      Result := _Current + _Needed - _MergeIn
    else
      Result := _Current;
  end;

var
  PgCount: integer;
  FirstPage: Tfr_dzWizardFrame;
begin
  inherited;

  Width := AdjustExtend(Width, p_MergeIn.ClientWidth, FMinWizardPageWidth);
  Height := AdjustExtend(Height, p_MergeIn.ClientHeight, FMinWizardPageHeight);
  Constraints.MinHeight := Height;
  Constraints.MinWidth := Width;

  PgCount := FPages.FList.Count;
  if PgCount > 0 then begin
    b_Next.Enabled := true;
    FirstPage := FPages.FList[0];
    SetNewPage(FirstPage);
    CurrentPageNo := 0;
  end;
end;

function Tf_dzWizardForm.DoOnFinished: boolean;
begin
  Result := true;
  if Assigned(FOnFinished) then
    FOnFinished(Self, Result);
end;

function Tf_dzWizardForm.GoForward: integer;
var
  CurPage: Tfr_dzWizardFrame;
  NextPage: Tfr_dzWizardFrame;
  NextPageId: integer;
  NewPageId: integer;
  OnLastPage: boolean;
begin
  CurPage := FPages.FList[FCurrentPageNo];
  OnLastPage := FCurrentPageNo = FPages.FList.Count - 1;
  if OnLastPage then begin
    NextPageId := NO_MORE_PAGES;
    NextPage := nil;
  end else begin
    NextPageId := CurPage.NextPageId;
    NextPage := FPages.PageById(NextPageId);
  end;
  Result := CurPage.PageId;
  NewPageId := NextPageId;
  if not DoBeforePageChange(pnNext, CurPage.PageId, NewPageId, CurPage.Data, NextPage) then
    exit;
  if NewPageId <> NextPageId then begin
    NextPageId := NewPageId;
    OnLastPage := false;
    NextPage := FPages.PageById(NextPageId);
  end;
  if OnLastPage then begin
    if DoOnFinished then begin
      Result := NO_MORE_PAGES;
      ModalResult := mrOk;
      if not (fsModal in FFormState) then
        Close;
    end;
  end else begin
    FTrail.Push(Pointer(CurPage.PageId));
    SetNewPage(NextPage);
    Result := NextPageId;
    DoAfterPageChange(pnNext, CurPage.PageId, NextPage.PageId, CurPage, NextPage);
  end;
end;

procedure Tf_dzWizardForm.b_NextClick(Sender: TObject);
begin
  GoForward;
end;

procedure Tf_dzWizardForm.SetCurrentPageNo(_CurrentPageNo: integer);
begin
  FCurrentPageNo := _CurrentPageNo;
  if FCurrentPageNo = FPages.FList.Count - 1 then
    b_Next.Caption := FFinishedButtonCaption
  else
    b_Next.Caption := FNextButtonCaption;
  b_Prev.Enabled := FCurrentPageNo > 0;
end;

function Tf_dzWizardForm.GoBack: integer;
var
  CurPage: Tfr_dzWizardFrame;
  NextPage: Tfr_dzWizardFrame;
  NextPageId: integer;
  NewPageId: integer;
begin
  if FTrail.Count = 0 then
    raise ECantGoBack.Create('Already on first page.');

  CurPage := FPages.FList[FCurrentPageNo];
  NextPageId := Integer(FTrail.Peek);
  NextPage := FPages.PageById(NextPageId);
  NewPageId := NextPageId;
  if not DoBeforePageChange(pnPrevious, CurPage.PageId, NewPageId, CurPage, NextPage) then begin
    Result := CurPage.PageId;
    exit;
  end;
  FTrail.Pop;
  if NextPageId <> NewPageId then begin
    NextPageId := NewPageId;
    NextPage := FPages.PageById(NextPageId);
  end;
  SetNewPage(NextPage);
  Result := NextPageId;
  DoAfterPageChange(pnNext, CurPage.PageId, NextPageId, CurPage, NextPage);
end;

procedure Tf_dzWizardForm.b_PrevClick(Sender: TObject);
begin
  GoBack;
end;

procedure Tf_dzWizardForm.SetNewPage(_NextPage: Tfr_dzWizardFrame);
var
  h: integer;
  s: string;
begin
  if Assigned(FCurrentPage) then
    FCurrentPage.PageDeactivate;
  FCurrentPage := _NextPage;
  CurrentPageNo := FPages.FList.IndexOf(_NextPage);
  FCurrentPage.PageActivate;
  s := _NextPage.Description;
  if s = '' then
    p_Description.Visible := false
  else begin
    h := CalcTextHeight(l_Description, s);
    if h < FDescLabelHeight then
      h := FDescLabelHeight;
    l_Description.Height := h;
    p_Description.Height := h + 16;
    l_Description.Caption := s;
    p_Description.Visible := true;
  end;
end;

procedure Tf_dzWizardForm.b_CancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  if not (fsModal in FFormState) then
    Close;
end;

procedure Tf_dzWizardForm.PageAdded(_PageFrame: Tfr_dzWizardFrame);
begin
  _PageFrame.Parent := p_WizardSpace;
  _PageFrame.Visible := false;
  if _PageFrame.Height > FMinWizardPageHeight then
    FMinWizardPageHeight := _PageFrame.Height;
  if _PageFrame.Width > FMinWizardPageWidth then
    FMinWizardPageWidth := _PageFrame.Width;
end;

function Tf_dzWizardForm.DoOnCancel: boolean;
var
  i: Integer;
begin
  Result := true;
  for i := 0 to FPages.PageCount - 1 do
    FPages[i].CancelPressed(Result);
  if Result then
    for i := 0 to FPages.PageCount - 1 do
      FPages[i].Cancelling;
end;

procedure Tf_dzWizardForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if ModalResult <> mrOK then
    CanClose := DoOnCancel;
end;

procedure Tf_dzWizardForm.SetCancelButtonCaption(const _Caption: string);
begin
  FCancelButtonCaption := _Caption;
  b_Cancel.Caption := _Caption;
end;

procedure Tf_dzWizardForm.SetFinishedButtonCaption(const _Caption: string);
begin
  FFinishedButtonCaption := _Caption;
end;

procedure Tf_dzWizardForm.SetNextButtonCaption(const _Caption: string);
begin
  FNextButtonCaption := _Caption;
  b_Next.Caption := _Caption;
end;

procedure Tf_dzWizardForm.SetPicture(const _Picture: TPicture);
begin
  im_Image.Picture := _Picture;
  if Assigned(_Picture) then
    p_Picture.Visible := true;
end;

procedure Tf_dzWizardForm.SetPrevButtonCaption(const _Caption: string);
begin
  FPrevButtonCaption := _Caption;
  b_Prev.Caption := _Caption;
end;

procedure Tf_dzWizardForm.UpdateButtonState;
var
  Buttons: TWizardButtonSet;

  procedure CheckButton(_Button: TWizardButtons; _Default: boolean);
  var
    Allowed: boolean;
  begin
    Allowed := _Default;
    FCurrentPage.ButtonAllowed(_Button, Allowed);
    if Allowed then
      Include(Buttons, _Button)
    else
      Exclude(Buttons, _Button);
  end;

begin
  Buttons := GetEnabledButtons;
  if Assigned(FCurrentPage) then begin
    if FCurrentPageNo > 0 then
      CheckButton(wbPrev, true);
    CheckButton(wbNext, true);
    CheckButton(wbCancel, true);
  end;
  SetEnabledButtons(Buttons, true);
  SetEnabledButtons([wbPrev, wbNext, wbCancel] - Buttons, false);
end;

function Tf_dzWizardForm.GetEnabledButtons: TWizardButtonSet;
begin
  Result := [];
  if b_Prev.Enabled then
    Include(Result, wbPrev);
  if b_Next.Enabled then
    Include(Result, wbNext);
  if b_Cancel.Enabled then
    Include(Result, wbCancel);
end;

function Tf_dzWizardForm.GetPicture: TPicture;
begin
  Result := im_Image.Picture;
end;

procedure Tf_dzWizardForm.SetEnabledButtons(const _Buttons: TWizardButtonSet; _Enabled: boolean);
begin
  if wbPrev in _Buttons then
    b_Prev.Enabled := _Enabled;
  if wbNext in _Buttons then
    b_Next.Enabled := _Enabled;
  if wbCancel in _Buttons then
    b_Cancel.Enabled := _Enabled;
end;

end.

