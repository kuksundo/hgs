unit w_dzWizard deprecated; // use w_dzWizardForm / w_dzWizardFrame instead

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  u_dzTranslator;

const
  {: Sent as NewPageId if the old page is the first/last page in that direction }
  NO_MORE_PAGES = -1;

type
  EdzWizard = class(Exception);
  ECantGoBack = class(EdzWizard);
  EInvalidPageId = class(EdzWizard);

type
  TdzPicture = class;

  TPageList = class;

  TPrevNext = (pnPrevious, pnNext);

  TBeforePageChange = procedure(_Sender: TObject; _Direction: TPrevNext;
    _OldPageId: integer; var _NewPageId: integer;
    _OldPageData, _NewPageData: pointer;
    var _CanChange: boolean) of object;

  TAfterPageChange = procedure(_Sender: TObject; _Direction: TPrevNext;
    _OldPageId, _NewPageId: integer;
    _OldPageData, _NewPageData: pointer) of object;

  TOnFinished = procedure(_Sender: TObject; var _CanClose: boolean) of object;

  TWizardButtons = (wbPrev, wbNext, wbCancel);
  TWizardButtonSet = set of TWizardButtons;

  Tf_dzWizard = class(TForm)
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
    fDescLabelHeight: integer;
    fPicture: TdzPicture;
    fCurrentPageNo: integer;
    fCurrentPage: TForm;
    fMinWizardPageHeight: integer;
    fMinWizardPageWidth: integer;

    fBeforePageChange: TBeforePageChange;
    fAfterPageChange: TAfterPageChange;
    fOnFinished: TOnFinished;
    fCancelButtonCaption: string;
    fFinishedButtonCaption: string;
    fNextButtonCaption: string;
    fPrevButtonCaption: string;
    procedure PictureChanged;
    procedure SetCurrentPageNo(_CurrentPageNo: integer);
    procedure SetNewPage(_NextPage: pointer);
    function GetBeforePageExit(_PageId: integer): TBeforePageChange;
    procedure SetBeforePageExit(_PageId: integer; const _BeforePageExit: TBeforePageChange);
    function GetAfterPageEnter(_PageId: integer): TAfterPageChange;
    procedure SetAfterPageEnter(_PageId: integer; const _AfterPageEnter: TAfterPageChange);
    procedure SetCancelButtonCaption(const _Caption: string);
    procedure SetFinishedButtonCaption(const _Caption: string);
    procedure SetNextButtonCaption(const _Caption: string);
    procedure SetPrevButtonCaption(const _Caption: string);
  protected
    fPages: TPageList;
    procedure DoShow; override;
    {: called before the new page is displayed
       @param Direction gives the direction of the page change
       @param OldPageId is the ID of the page we are about to leave
       @param NewPageId is the ID of the page we are about to enter
       @param OldPageData is the Data parameter of the page we are about to leave
       @param NewPageData is the Data parameter of the page we are about to enter
       @returns true if the page change is allowed
       Note: This is also called on the last page when the user presses the
       Finish button. }
    function DoBeforePageChange(_Direction: TPrevNext;
      _OldPageId: integer; var _NewPageId: integer;
      _OldPageData, _NewPageData: pointer): boolean; virtual;
    {: called after the new page has been displayed
       @param Direction gives the direction of the page change
       @param OldPageId is the ID of the page we just left
       @param NewPageId is the ID of the page we just entered
       @param OldPageData is the Data parameter of the page we just left
       @param NewPageData is the Data parameter of the page we just entered
       Note: Is not called after the last page! }
    procedure DoAfterPageChange(_Direction: TPrevNext;
      _OldPageId, _NewPageId: integer;
      _OldPageData, _NewPageData: pointer); virtual;
    {: called after DoBeforePageChanged when the user presses the finish button
       @returns true, if the dialog is done }
    function DoOnFinished: boolean; virtual;
    {: Called when the user presses the cancel button.
       @returns true, if canceling the dialog is allowed, false otherwise }
    function DoOnCancel: boolean; virtual;
    procedure PageAdded(_PageForm: TForm); virtual;
  public
    constructor Create(_Owner: TComponent); override;
    destructor Destroy; override;
    function GoForward: integer; virtual;
    function GoBack: integer; virtual;
    function GetEnabledButtons: TWizardButtonSet;
    procedure SetEnabledButtons(const _Buttons: TWizardButtonSet; _Enabled: boolean);
    property Picture: TdzPicture read fPicture;
    property Pages: TPageList read fPages;
    property CurrentPageNo: integer read fCurrentPageNo write SetCurrentPageNo;
    property BeforePageChange: TBeforePageChange read fBeforePageChange write fBeforePageChange;
    property AfterPageChange: TAfterPageChange read fAfterPageChange write fAfterPageChange;
    property OnFinished: TOnFinished read fOnFinished write fOnFinished;
    property BeforePageExit[_PageId: integer]: TBeforePageChange read GetBeforePageExit write SetBeforePageExit;
    property AfterPageEnter[_PageId: integer]: TAfterPageChange read GetAfterPageEnter write SetAfterPageEnter;
    property CancelButtonCaption: string read fCancelButtonCaption write SetCancelButtonCaption;
    property PrevButtonCaption: string read fPrevButtonCaption write SetPrevButtonCaption;
    property NextButtonCaption: string read fNextButtonCaption write SetNextButtonCaption;
    property FinishedButtonCaption: string read fFinishedButtonCaption write SetFinishedButtonCaption;
  end;

  TdzPicture = class(TPicture)
  protected
    fWizard: Tf_dzWizard;
    procedure Changed(_Sender: TObject); override;
  public
  end;

  TPageList = class
  protected
    fNextId: integer;
    fList: TList;
    fWizard: Tf_dzWizard;
    function GetPage(_Idx: integer): pointer;
    function PageById(_PageId: integer): pointer;
  public
    constructor Create(_Wizard: Tf_dzWizard);
    destructor Destroy; override;
    function InsertPage(_Position: integer; _Form: TForm;
      const _Description: string; _Data: pointer = nil): integer;
    function AddPage(_Form: TForm; const _Description: string; _Data: pointer = nil): integer;
    procedure DelPage(_PageId: integer);
    function PageCount: integer;
  end;

var
  f_dzWizard: Tf_dzWizard;

implementation

{$R *.DFM}

uses
  u_dzVclUtils;

type
  TWizardPage = class
  protected
    fForm: TForm;
    fDescription: string;
    fId: integer;
    fData: pointer;
    fBeforeExit: TBeforePageChange;
    fAfterEnter: TAfterPageChange;
  public
    constructor Create(_Form: TForm; const _Description: string; _Id: integer; _Data: pointer);
    function DoBeforeExit(_Direction: TPrevNext; var _NewPageId: integer; _NewPageData: pointer): boolean;
    procedure DoAfterEnter(_Direction: TPrevNext; _OldPageId: integer; _OldPageData: pointer);
    property BeforeExit: TBeforePageChange read fBeforeExit write fBeforeExit;
    property AfterEnter: TAfterPageChange read fAfterEnter write fAfterEnter;
  end;

{ TWizardPage }

function _(const _s: string): string; inline;
begin
  Result := dzDGetText(_s, 'dzlib');
end;

constructor TWizardPage.Create(_Form: TForm; const _Description: string;
  _Id: integer; _Data: pointer);
begin
  inherited Create;
  fForm := _Form;
  fDescription := _Description;
  fId := _Id;
  fData := _Data;
end;

function TWizardPage.DoBeforeExit(_Direction: TPrevNext;
  var _NewPageId: integer; _NewPageData: pointer): boolean;
begin
  Result := true;
  if Assigned(fBeforeExit) then
    fBeforeExit(fForm, _Direction, fId, _NewPageId, fData, _NewPageData, Result)
end;

procedure TWizardPage.DoAfterEnter(_Direction: TPrevNext;
  _OldPageId: integer; _OldPageData: pointer);
begin
  if Assigned(fAfterEnter) then
    fAfterEnter(fForm, _Direction, _OldPageId, fId, _OldPageData, fData);
end;

{ TdzPicture }

procedure TdzPicture.Changed(_Sender: TObject);
begin
  inherited;
  fWizard.PictureChanged;
end;

{ TPageList }

constructor TPageList.Create(_Wizard: Tf_dzWizard);
begin
  inherited Create;
  fList := TList.Create;
  fWizard := _Wizard;
end;

destructor TPageList.Destroy;
var
  i: integer;
begin
  if Assigned(fList) then begin
    for i := 0 to fList.Count - 1 do
      TWizardPage(fList[i]).Free;
  end;
  inherited;
end;

function TPageList.AddPage(_Form: TForm; const _Description: string; _Data: pointer = nil): integer;
begin
  Result := fNextId;
  Inc(fNextId);
  fList.Add(TWizardPage.Create(_Form, _Description, Result, _Data));
  fWizard.PageAdded(_Form);
end;

procedure TPageList.DelPage(_PageId: integer);
var
  i: integer;
  Page: TWizardPage;
begin
  for i := 0 to fList.Count - 1 do begin
    Page := TWizardPage(fList[i]);
    if Page.fId = _PageId then begin
      fList.Delete(i);
      Page.Free;
      Exit;
    end;
  end;
end;

function TPageList.PageById(_PageId: integer): pointer;
var
  i: integer;
  Page: TWizardPage;
begin
  for i := 0 to fList.Count - 1 do begin
    Page := TWizardPage(fList[i]);
    if Page.fId = _PageId then begin
      Result := Page;
      exit;
    end;
  end;
  Result := nil;
end;

//function TPageList.PageNoById(_PageId: integer): integer;
//var
//  i: integer;
//  Page: TWizardPage;
//begin
//  for i := 0 to fList.Count - 1 do
//    begin
//      Page := TWizardPage(fList[i]);
//      if Page.fId = _PageId then
//        begin
//          Result := i;
//          exit;
//        end;
//    end;
//  Result := -1;
//end;

function TPageList.InsertPage(_Position: integer; _Form: TForm;
  const _Description: string; _Data: pointer = nil): integer;
begin
  Result := fNextId;
  Inc(fNextId);
  fList.Insert(_Position, TWizardPage.Create(_Form, _Description, Result, _Data));
  fWizard.PageAdded(_Form);
end;

function TPageList.GetPage(_Idx: integer): pointer;
begin
  Result := fList[_Idx];
end;

function TPageList.PageCount: integer;
begin
  Result := fList.Count;
end;

{ Tf_dzWizard }

constructor Tf_dzWizard.Create(_Owner: TComponent);
begin
  inherited;
  fPicture := TdzPicture.Create;
  fPicture.fWizard := self;
  fPages := TPageList.Create(self);
  PrevButtonCaption := _('< &Previous');
  CancelButtonCaption := _('Cancel');
  fNextButtonCaption := _('&Next >');
  fFinishedButtonCaption := _('&Finish');
  fDescLabelHeight := l_Description.Height;
  p_MergeIn.BorderStyle := bsNone;
  p_MergeIn.Caption := '';
  fMinWizardPageHeight := p_MergeIn.Height;
  fMinWizardPageWidth := p_MergeIn.Width;
end;

destructor Tf_dzWizard.Destroy;
begin
  fPages.Free;
  fPicture.Free;
  inherited;
end;

function Tf_dzWizard.DoBeforePageChange(_Direction: TPrevNext; _OldPageId: integer;
  var _NewPageId: integer; _OldPageData, _NewPageData: pointer): boolean;
begin
  Result := true;
  if Assigned(fBeforePageChange) then
    fBeforePageChange(self, _Direction, _OldPageId, _NewPageId, _OldPageData,
      _NewPageData, Result);
  if Result then
    Result := TWizardPage(fPages.PageById(_OldPageId)).DoBeforeExit(_Direction, _NewPageId, _NewPageData);
end;

procedure Tf_dzWizard.DoAfterPageChange(_Direction: TPrevNext; _OldPageId,
  _NewPageId: integer; _OldPageData, _NewPageData: pointer);
begin
  if Assigned(fAfterPageChange) then
    fAfterPageChange(self, _Direction, _OldPageId, _NewPageId, _OldPageData,
      _NewPageData);
  TWizardPage(fPages.PageById(_NewPageId)).DoAfterEnter(_Direction, _OldPageId, _OldPageData);
end;

procedure Tf_dzWizard.PictureChanged;
begin
  im_Image.Picture := fPicture;
  p_Picture.Visible := true;
end;

procedure Tf_dzWizard.DoShow;
var
  PgCount: integer;
  FirstPage: TWizardPage;
begin
  inherited;
  if fMinWizardPageWidth > p_MergeIn.ClientWidth then
    Width := Width + fMinWizardPageWidth - p_MergeIn.ClientWidth;
  if fMinWizardPageHeight > p_MergeIn.ClientHeight then
    Height := Height + fMinWizardPageHeight - p_MergeIn.ClientHeight;
  Constraints.MinHeight := Height;
  Constraints.MinWidth := Width;

  PgCount := fPages.fList.Count;
  if PgCount > 0 then begin
    b_Next.Enabled := true;
    FirstPage := fPages.fList[0];
    SetNewPage(FirstPage);
    CurrentPageNo := 0;
  end;
end;

function Tf_dzWizard.DoOnFinished: boolean;
begin
  Result := true;
  if Assigned(fOnFinished) then
    fOnFinished(Self, Result);
end;

function Tf_dzWizard.GoForward: integer;
var
  CurPage: TWizardPage;
  NextPage: TWizardPage;
  NextPageId: integer;
  NewPageId: integer;
  NextPageData: pointer;
  OnLastPage: boolean;
begin
  CurPage := fPages.fList[fCurrentPageNo];
  OnLastPage := fCurrentPageNo = fPages.fList.Count - 1;
  if OnLastPage then begin
    NextPageId := NO_MORE_PAGES;
    NextPageData := nil;
    NextPage := nil;
  end else begin
    NextPage := fPages.fList[fCurrentPageNo + 1];
    NextPageId := NextPage.fId;
    NextPageData := NextPage.fData;
  end;
  Result := CurPage.fId;
  NewPageId := NextPageId;
  if not DoBeforePageChange(pnNext, CurPage.fId, NewPageId, CurPage.fData, NextPageData) then
    exit;
  if NewPageId <> NextPageId then begin
    NextPageId := NewPageId;
    OnLastPage := false;
    NextPage := fPages.PageById(NextPageId);
  end;
  if OnLastPage then begin
    if DoOnFinished then begin
      Result := NO_MORE_PAGES;
      ModalResult := mrOk;
      if not (fsModal in FFormState) then
        Close;
    end;
  end else begin
    SetNewPage(NextPage);
    Result := NextPageId;
    DoAfterPageChange(pnNext, CurPage.fId, NextPage.fId, CurPage.fData, NextPage.fData);
  end;
end;

procedure Tf_dzWizard.b_NextClick(Sender: TObject);
begin
  GoForward;
end;

procedure Tf_dzWizard.SetCurrentPageNo(_CurrentPageNo: integer);
begin
  fCurrentPageNo := _CurrentPageNo;
  if fCurrentPageNo = fPages.fList.Count - 1 then
    b_Next.Caption := fFinishedButtonCaption
  else
    b_Next.Caption := fNextButtonCaption;
  b_Prev.Enabled := fCurrentPageNo > 0;
end;

function Tf_dzWizard.GoBack: integer;
var
  CurPage: TWizardPage;
  NextPage: TWizardPage;
  NextPageId: integer;
  NewPageId: integer;
begin
  if fCurrentPageNo <= 0 then
    raise ECantGoBack.Create(_('Already on first page.'));

  CurPage := fPages.fList[fCurrentPageNo];
  NextPage := fPages.fList[fCurrentPageNo - 1];

  NextPageId := NextPage.fId;
  NewPageId := NextPageId;
  if not DoBeforePageChange(pnPrevious, CurPage.fId, NewPageId, CurPage.fData, NextPage.fData) then begin
    Result := CurPage.fId;
    exit;
  end;

  if NextPageId <> NewPageId then begin
    NextPageId := NewPageId;
    NextPage := fPages.PageById(NextPageId);
  end;
  SetNewPage(NextPage);
  Result := NextPageId;
  DoAfterPageChange(pnNext, CurPage.fId, NextPageId, CurPage.fData, NextPage.fData);
end;

procedure Tf_dzWizard.b_PrevClick(Sender: TObject);
begin
  GoBack;
end;

procedure Tf_dzWizard.SetNewPage(_NextPage: pointer);
var
  NextPage: TWizardPage;
  h: integer;
  s: string;
begin
  NextPage := _NextPage;
  if Assigned(fCurrentPage) then
    UnMergeForm(fCurrentPage);
  MergeForm(p_MergeIn, NextPage.fForm as TForm, alClient, true);
  fCurrentPage := NextPage.fForm;
  s := NextPage.fDescription;
  if s = '' then
    p_Description.Visible := false
  else begin
    h := CalcTextHeight(l_Description, s);
    if h < fDescLabelHeight then
      h := fDescLabelHeight;
    l_Description.Height := h;
    p_Description.Height := h + 16;
    l_Description.Caption := s;
    p_Description.Visible := true;
  end;
  CurrentPageNo := fPages.fList.IndexOf(NextPage);
end;

procedure Tf_dzWizard.b_CancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  if not (fsModal in FFormState) then
    Close;
end;

procedure Tf_dzWizard.PageAdded(_PageForm: TForm);
begin
  if _PageForm.Height > fMinWizardPageHeight then
    fMinWizardPageHeight := _PageForm.Height;
  if _PageForm.Width > fMinWizardPageWidth then
    fMinWizardPageWidth := _PageForm.Width;
end;

function Tf_dzWizard.GetAfterPageEnter(_PageId: integer): TAfterPageChange;
begin
  Result := TWizardPage(fPages.PageById(_PageId)).fAfterEnter;
end;

function Tf_dzWizard.GetBeforePageExit(_PageId: integer): TBeforePageChange;
begin
  Result := TWizardPage(fPages.PageById(_PageId)).fBeforeExit;
end;

procedure Tf_dzWizard.SetAfterPageEnter(_PageId: integer;
  const _AfterPageEnter: TAfterPageChange);
begin
  TWizardPage(fPages.PageById(_PageId)).fAfterEnter := _AfterPageEnter;
end;

procedure Tf_dzWizard.SetBeforePageExit(_PageId: integer;
  const _BeforePageExit: TBeforePageChange);
begin
  TWizardPage(fPages.PageById(_PageId)).fBeforeExit := _BeforePageExit;
end;

function Tf_dzWizard.DoOnCancel: boolean;
begin
  Result := true;
end;

procedure Tf_dzWizard.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if ModalResult <> mrOK then
    CanClose := DoOnCancel;
end;

procedure Tf_dzWizard.SetCancelButtonCaption(const _Caption: string);
begin
  fCancelButtonCaption := _Caption;
  b_Cancel.Caption := _Caption;
end;

procedure Tf_dzWizard.SetFinishedButtonCaption(const _Caption: string);
begin
  fFinishedButtonCaption := _Caption;
end;

procedure Tf_dzWizard.SetNextButtonCaption(const _Caption: string);
begin
  fNextButtonCaption := _Caption;
  b_Next.Caption := _Caption;
end;

procedure Tf_dzWizard.SetPrevButtonCaption(const _Caption: string);
begin
  fPrevButtonCaption := _Caption;
  b_Prev.Caption := _Caption;
end;

function Tf_dzWizard.GetEnabledButtons: TWizardButtonSet;
begin
  Result := [];
  if b_Prev.Enabled then
    Include(Result, wbPrev);
  if b_Next.Enabled then
    Include(Result, wbNext);
  if b_Cancel.Enabled then
    Include(Result, wbCancel);
end;

procedure Tf_dzWizard.SetEnabledButtons(const _Buttons: TWizardButtonSet; _Enabled: boolean);
begin
  if wbPrev in _Buttons then
    b_Prev.Enabled := _Enabled;
  if wbNext in _Buttons then
    b_Next.Enabled := _Enabled;
  if wbCancel in _Buttons then
    b_Cancel.Enabled := _Enabled;
end;

end.

