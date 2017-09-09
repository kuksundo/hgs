unit uDM;

{-------------------------------------------------------------------------------
POPTRAY
Copyright (C) 2001-2005  Renier Crause
All Rights Reserved.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

The GNU GPL can be found at:
  http://www.gnu.org/copyleft/gpl.html
-------------------------------------------------------------------------------}

interface

uses
  Windows, SysUtils, Classes, ImgList, Controls, Menus,
  CustomizeDlg, Graphics, ExtCtrls, Forms, ActnMan, Dialogs,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnPopup, PngImageList;

const
  // imlPop
  popClosed = 0;
  popOpen = 1;
  popDisabled = 2;
  popError = 3;
  popBusy = 4;
  popTrash = 5;
  popBusy1 = 6;
  popBusy2 = 7;
  popBusy3 = 8;
  popNew = 9;
  popSleeping = 10;
  // imlListView
  mNoListImg = -1;
  mHigh = 0;
  mHigh2 = 1;
  mNormal = 2;
  mLow = 3;
  mLow2 = 4;
  mIgnored = 5;
  mAttachment = 6;
  mNew = 7;
  mToDelete = 8;
  mImportant = 9;
  mSpam = 10;
  mNewAttach = 11;
  mProtect = 12;
  mProtectNew = 13;
  mProtectAttach = 14;
  mProtectNewAttach = 15;
  mSortDesc = 16;
  mSortAsc = 17;

type
  TMyCustomizeDlg = class(TCustomizeDlg)
  public
    procedure SetupDlg; override;
  end;

  Tdm = class(TDataModule)
    imlActions: TImageList;
    imlOptions: TImageList;
    mnuToolbar: TPopupActionBar;
    Customize1: TMenuItem;
    mnuMail: TPopupActionBar;
    Preview1: TMenuItem;
    Delete1: TMenuItem;
    Reply1: TMenuItem;
    N6: TMenuItem;
    mnuRuleFromDelete: TMenuItem;
    mnuTray: TPopupActionBar;
    ShowMessages2: TMenuItem;
    Check1: TMenuItem;
    New1: TMenuItem;
    N4: TMenuItem;
    mnuStartProgram: TMenuItem;
    N5: TMenuItem;
    mnuAutoCheck: TMenuItem;
    Options2: TMenuItem;
    About2: TMenuItem;
    Help2: TMenuItem;
    N8: TMenuItem;
    Quit2: TMenuItem;
    imlPopTrueColor: TImageList;
    imlTray: TImageList;
    imlTabs: TImageList;
    imlListView: TImageList;
    Timer: TTimer;
    imlPop16: TImageList;
    Rules1: TMenuItem;
    AddsendertoWhiteList1: TMenuItem;
    AddsendertoBlackList1: TMenuItem;
    MarkasSpam1: TMenuItem;
    mnuRuleFromSpam: TMenuItem;
    Lists1: TMenuItem;
    Spam1: TMenuItem;
    UnmarkasSpam1: TMenuItem;
    N1: TMenuItem;
    SelectSpamMessages1: TMenuItem;
    mnuSuspendSound: TMenuItem;
    mnuColumns: TPopupActionBar;
    mnuColFrom: TMenuItem;
    mnuColTo: TMenuItem;
    mnuColSubject: TMenuItem;
    mnuColDate: TMenuItem;
    mnuColSize: TMenuItem;
    N3: TMenuItem;
    Sort1: TMenuItem;
    mnuSortMessageStatus: TMenuItem;
    mnuSortFrom: TMenuItem;
    mnuSortTo: TMenuItem;
    mnuSortSubject: TMenuItem;
    mnuSortDate: TMenuItem;
    mnuSortSize: TMenuItem;
    N9: TMenuItem;
    mnuSortNoSort: TMenuItem;
    StopChecking1: TMenuItem;
    mnuSpamLast: TMenuItem;
    Undelete1: TMenuItem;
    AddruleformailfromSender1: TMenuItem;
    AddRuleformailwithSubject1: TMenuItem;
    mnuRuleSubjectDelete: TMenuItem;
    mnuRuleSubjectSpam: TMenuItem;
    imlLtDk16: TImageList;
    imlActionsDisabled: TImageList;
    mnuShowInGroups: TMenuItem;
    N2: TMenuItem;
    imlActionsLarge: TPngImageList;
    AddsendertoBlackList2: TMenuItem;
    MarkasRead1: TMenuItem;
    MarkasUnread1: TMenuItem;
    N7: TMenuItem;
    MarkasImportant1: TMenuItem;
    MarkasNotImportant1: TMenuItem;
    procedure mnuColumnsClick(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure mnuSortClick(Sender: TObject);
    procedure mnuSpamLastClick(Sender: TObject);
    procedure mnuShowInGroupsClick(Sender: TObject);
  private
    { Private declarations }
    FBitmap : TBitmap;
  public
    { Public declarations }
    imlPop : TImageList;
    CustomizeDlg: TMyCustomizeDlg;
    function GetBitmap(ImgList : TImageList; Index : integer) : TBitmap;
    procedure ReplaceBitmap(DstImgList : TImageList; DstIndex : integer;
                            SrcImgList : TImageList; SrcIndex : integer);
    procedure AddBitmap(DstImgList : TImageList; SrcImgList : TImageList; SrcIndex : integer);
    procedure Draw(TheCanvas : TCanvas; ImgList : TImageList; Index : integer);
    procedure ShowCustomizeDlg(ActionManager : TActionManager; SetPosition : boolean);
  end;

var
  dm: Tdm;

implementation

uses uMain, uPreview, uGlobal, StdCtrls, uTranslate;

{$R *.dfm}

{ TMyCustomizeDlg }

procedure TMyCustomizeDlg.SetupDlg;
begin
  inherited;
  // just to make it public
end;

{ Tdm }

// Called when the right-click menu for columns is clicked. this will either
// show or hide a column.
// when a column is un-hidden, the width is restored from prior to hiding from
// the Tag field of the column.
procedure Tdm.mnuColumnsClick(Sender: TObject);
var
  col : integer;
begin
  with frmPopUMain do
  begin
    col := SortTypeToColumnNum(TSortType((Sender as TMenuItem).Tag));
    if not(Sender as TMenuItem).Checked then
    begin
      lvMail.Columns[col].MinWidth := 10;
      lvMail.Columns[col].Width := lvMail.Columns[col].Tag;
      if lvMail.Columns[col].Width = 0 then
        lvMail.Columns[col].Width := 50;
    end
    else begin
      lvMail.Columns[col].Tag := lvMail.Columns[col].Width;
      lvMail.Columns[col].MinWidth := 0;
      lvMail.Columns[col].Width := 0;
    end;
  end;
  //Abort;
end;

function Tdm.GetBitmap(ImgList: TImageList; Index: integer): TBitmap;
begin
  ImgList.ImageType := itImage;
  ImgList.GetBitmap(Index,FBitmap);
  Result := FBitmap;
end;

procedure Tdm.ReplaceBitmap(DstImgList : TImageList; DstIndex : integer;
                            SrcImgList : TImageList; SrcIndex : integer);
var
  Mask : TBitmap;
begin
  Mask := TBitmap.Create;
  try
    SrcImgList.ImageType := itMask;
    SrcImgList.GetBitmap(SrcIndex,Mask);
    DstImgList.Replace(DstIndex,GetBitmap(SrcImgList,SrcIndex),Mask);
  finally
    Mask.Free;
  end;
end;

procedure Tdm.AddBitmap(DstImgList: TImageList; SrcImgList: TImageList; SrcIndex: integer);
var
  Mask : TBitmap;
begin
  Mask := TBitmap.Create;
  try
    SrcImgList.ImageType := itMask;
    SrcImgList.GetBitmap(SrcIndex,Mask);
    DstImgList.Add(GetBitmap(SrcImgList,SrcIndex),Mask);
  finally
    Mask.Free;
  end;
end;

procedure Tdm.Draw(TheCanvas: TCanvas; ImgList: TImageList; Index: integer);
var
  Bitmap,Mask : TBitmap;
begin
  Bitmap := TBitmap.Create;
  Mask := TBitmap.Create;
  try
    ImgList.ImageType := itImage;
    ImgList.GetBitmap(Index,Bitmap);
    ImgList.ImageType := itMask;
    ImgList.GetBitmap(Index,Mask);
    ImgList.Draw(TheCanvas,0,0,Index);
  finally
    Bitmap.Free;
    Mask.Free;
  end;
end;

procedure Tdm.ShowCustomizeDlg(ActionManager: TActionManager; SetPosition: boolean);
var
  i,old : integer;
begin
  // create and setup
  if CustomizeDlg = nil then
    CustomizeDlg := TMyCustomizeDlg.Create(self);
  CustomizeDlg.ActionManager := ActionManager;
  CustomizeDlg.StayOnTop := True;
  CustomizeDlg.SetupDlg;
  // customize the customize dialog
  with CustomizeDlg.CustomizeForm do
  begin
    // position
    if SetPosition then
    begin
      Position := poDesigned;
      Left := frmPopUMain.Left - Width;
      Top := frmPopUMain.Top;
      if Left < 0 then
        Left := 0;
      if Top+Height > Screen.Height then
        Top := Screen.Height - Height;
    end
    else begin
      Position := poScreenCenter;
    end;
    // hide unused stuff
    ApplyToAllChk.Hide;
    RecentlyUsedChk.Hide;
    PersonalizeLbl.Hide;
    ResetUsageBtn.Hide;
    Label1.Hide;
    MenuAnimationStyles.Hide;
    // translate
    TranslateForm(CustomizeDlg.CustomizeForm);
    Caption := Translate(Caption);
    // translate dropdown
    old := CaptionOptionsCombo.ItemIndex;
    for i := 0 to CaptionOptionsCombo.Items.Count-1 do
      CaptionOptionsCombo.Items[i] := Translate(CaptionOptionsCombo.Items[i]);
    CaptionOptionsCombo.ItemIndex := old;
    // move some labels
//    Label2.Left := ActionBarList.Left + ActionBarList.Width - Label2.Width;
    ShowTipsChk.Width := 280;
    ShortCutTipsChk.Width := 280;
    // show
    CustomizeDlg.Show;
    // catlist
    CatList.ItemIndex := 0;
    CatListClick(nil);
    for i := 0 to CatList.Count-1 do
      CatList.Items[i] := Translate(CatList.Items[i]);
  end;
end;

// -----------------------------------------------------------------------------
// ----------------------------------------------------------------- Events ----
// -----------------------------------------------------------------------------

procedure Tdm.DataModuleCreate(Sender: TObject);
begin
  FBitmap := TBitmap.Create;
  CustomizeDlg := nil;
  // TrueColor tray icons for WinXP+
  if (Win32Platform  = VER_PLATFORM_WIN32_NT) and
     (((Win32MajorVersion = 5) and (Win32MinorVersion >= 1)) or
      (Win32MajorVersion > 5)) then
    imlPop := imlPopTrueColor
  else
    imlPop := imlPop16;
  imlTray.Assign(imlPop);
end;

procedure Tdm.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(FBitmap);
end;

procedure Tdm.TimerTimer(Sender: TObject);
////////////////////////////////////////////////////////////////////////////////
// Check mail on timer event
begin
  if frmPopUMain.AllowAutoCheck then
    frmPopUMain.CheckAllMail;
end;

procedure Tdm.mnuShowInGroupsClick(Sender: TObject);
begin
  //todo
end;

procedure Tdm.mnuSortClick(Sender: TObject);
begin
  frmPopUMain.SetSortType(TSortType((Sender as TMenuItem).Tag));
end;

procedure Tdm.mnuSpamLastClick(Sender: TObject);
begin
  mnuSpamLast.Checked := not mnuSpamLast.Checked;
  frmPopUMain.lvMail.AlphaSort;
end;

end.
