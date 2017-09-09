unit uPreview;

{-------------------------------------------------------------------------------
POPTRAYU
Copyright (C) 2001-2005  Renier Crause
Copyright (C) 2012 Jessica Brown
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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, StrUtils, Menus, Printers, Tabs,
  ImgList, ToolWin, ActnMan, ActnCtrls, ActnList, XPStyleActnCtrls,
  IdBaseComponent, IdMessage, StdActns, BandActn, RichEdit,
  SHDocVw_TLB, ActiveX, OleCtrls, SHDocVw,
  IdAttachment, IdText, IdAttachmentFile,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnPopup, System.Actions,
  uAccounts, uMailItems, uWebBrowserTamed, IdComponent, PngImageList;

type
  TfrmPreview = class(TForm)
    panOK: TPanel;
    panPreviewFrom: TPanel;
    btnOK: TBitBtn;
    lblFrom: TLabel;
    edFrom: TEdit;
    tsMessageParts: TTabSet;
    lvAttachments: TListView;
    spltAttachemnts: TSplitter;
    imlAttachments: TImageList;
    toolbarPreview: TActionToolBar;
    ActionManagerPreview: TActionManager;
    actSave: TAction;
    imlActions: TImageList;
    actPrint: TAction;
    actReply: TAction;
    actDelete: TAction;
    panProgress: TPanel;
    btnStop: TSpeedButton;
    Progress: TProgressBar;
    lblProgress: TLabel;
    mnuPreviewToolbar: TPopupActionBar;
    Customize1: TMenuItem;
    Msg: TIdMessage;
    actAttachmentOpen: TAction;
    actAttachmentSave: TAction;
    actAttachmentSaveAll: TAction;
    mnuAttachments: TPopupMenu;
    Open2: TMenuItem;
    Save2: TMenuItem;
    N2: TMenuItem;
    SaveAllAttachments2: TMenuItem;
    mnuEdit: TPopupActionBar;
    actEditCut: TEditCut;
    actEditCopy: TEditCopy;
    actEditPaste: TEditPaste;
    actEditSelectAll: TEditSelectAll;
    actEditUndo: TEditUndo;
    actEditDelete: TEditDelete;
    Undo1: TMenuItem;
    N3: TMenuItem;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Delete1: TMenuItem;
    N4: TMenuItem;
    SelectAll1: TMenuItem;
    N5: TMenuItem;
    actEditFont: TFontEdit;
    SelectFont1: TMenuItem;
    actEditReadOnly: TAction;
    ReadOnly1: TMenuItem;
    actCustomize: TAction;
    panPreviewTo: TPanel;
    lblTo: TLabel;
    edTo: TEdit;
    panPreviewDate: TPanel;
    lblDate: TLabel;
    edDate: TEdit;
    panPreviewSubject: TPanel;
    lblSubject: TLabel;
    edSubject: TEdit;
    panPreviewXMailer: TPanel;
    lblXMailer: TLabel;
    edXMailer: TEdit;
    panPreviewCC: TPanel;
    lblCC: TLabel;
    edCC: TEdit;
    imgPreview: TImage;
    memMail: TRichEdit;
    actOpenMessage: TAction;
    WebBrowser1: TWebBrowser;
    actImageToggle: TAction;
    ShowImages1: TMenuItem;
    ShowImages2: TMenuItem;
    N1: TMenuItem;
    imlEditImages: TImageList;
    lblStatusText: TLabel;
    FindDialog1: TFindDialog;
    Find1: TMenuItem;
    ActMarkRead: TAction;
    ActMarkUnread: TAction;
    imlActionsPng: TPngImageList;
    actMark: TAction;
    actStar: TAction;
    actUnstar: TAction;
    actResetPreviewToolbar: TAction;
    mnuResetPreviewToolbar: TMenuItem;
    procedure panOKResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnStopClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure tsMessagePartsChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure actSaveExecute(Sender: TObject);
    procedure actPrintExecute(Sender: TObject);
    procedure actReplyExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actAttachmentSaveExecute(Sender: TObject);
    procedure lvAttachmentsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure actAttachmentOpenExecute(Sender: TObject);
    procedure actAttachmentSaveAllExecute(Sender: TObject);
    procedure lvAttachmentsDblClick(Sender: TObject);
    procedure actEditFontAccept(Sender: TObject);
    procedure actEditFontBeforeExecute(Sender: TObject);
    procedure actEditReadOnlyExecute(Sender: TObject);
    procedure actCustomizeExecute(Sender: TObject);
    procedure actShowImagesExecute(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edEnter(Sender: TObject);
    procedure edMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure actOpenMessageExecute(Sender: TObject);
    procedure LoadHtmlIntoBrowser(BrowserComponent: TWebBrowser;
      RawHtml: string);
    procedure tsMessagePartsDrawTab(Sender: TObject; TabCanvas: TCanvas;
      R: TRect; Index: Integer; Selected: Boolean);
    procedure WebBrowser1StatusTextChange(ASender: TObject;
      const Text: WideString);
    procedure WebBrowser1BeforeNavigate2(ASender: TObject;
      const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
    procedure WebBrowser1NewWindow3(ASender: TObject; var ppDisp: IDispatch;
      var Cancel: WordBool; dwFlags: Cardinal; const bstrUrlContext,
      bstrUrl: WideString);
    procedure Find1Click(Sender: TObject);
    procedure FindDialog1Find(Sender: TObject);
    procedure ActMarkReadExecute(Sender: TObject);
    procedure ActMarkUnreadExecute(Sender: TObject);
    procedure actMarkExecute(Sender: TObject);
    procedure actStarExecute(Sender: TObject);
    procedure actUnstarExecute(Sender: TObject);
    procedure mnuResetPreviewToolbarClick(Sender: TObject);
  protected
    procedure WndProc(var Message: TMessage); override;
  private
    { Private declarations }
    FFilesToDelete : TStringList;
    FToolbarFileName : string;
    FCustomized : boolean;
    FEnter : boolean;
    FMsg : TMailItem; //keep a reference to the mail item to make deleting it easier.
    FUID : string; //TODO: may no longer be needed?
    FReplyTo : string;
    FTab : integer;
    FBody : string;
    FHtml : string;
    FProtected : boolean;
    FDecoded : boolean;
    HtmlImagesEnabled : boolean;
    browserShowingHeaders : boolean;
    procedure DeleteTempFiles;
    procedure AddFileToDelete(FileName : string);
    procedure LoadActionManager;
    procedure SaveActionManager;
    procedure SaveDialogTypeChange(Sender:TObject);

  public
    { Public declarations }

    FStop : Boolean;
    FAccount : TAccount;
    FRawMsg : string;

    procedure LoadPreviewIni;
    procedure SavePreviewIni;
    procedure SaveINItoFile(const filename : String);
    procedure LoadPreviewIniFile(const filename : String);
    function AttachmentIcon(filename : string) : integer;
    procedure ShowMsg;
    procedure SelectSpamTab;
    procedure conditionallyEnableDeleteButton;
    procedure ProcessMessage(AMsg: TIdMessage; const AStream: TStream; AHeaderOnly: Boolean);
    procedure EnableImapOptions(enable : boolean);
    procedure LoadMailMessage(MailItem : TMailItem);
    procedure ShowProgressPanel();
  end;

const
  BODY_TAB = 0;
  HTML_TAB = 1;
  RAW_TAB = 2;
var
  frmPreview: TfrmPreview;

implementation

{$R *.DFM}

uses
  uRCUtils, uMain, uDM, uGlobal, uTranslate, System.UITypes,
  IniFiles, ShellAPI, CommCtrl, TypInfo, uHtmlDecoder, uIniSettings,
  RegularExpressions, EncdDecd, MSHTML, Variants, System.Types,
  IdAttachmentMemory, IdGlobal, IdGlobalProtocols, CommDlg, Dlgs,
  IdMessageClient, IdIMAP4, uIMAP4, IdExceptionCore;

const
  iconNone = 0;
  iconText = 1;
  iconHTML = 2;
  iconPic = 3;
  iconZip = 4;
  iconEXE = 5;
  iconWarning = 6;
  iconEMail = 7;
  iconMusic = 8;
  iconMovie = 9;



function Translate(english : string) : string;
begin
  Result := uTranslate.Translate(english);
end;


// enables the delete button if the message has a valid UID for safe deletion.
procedure TfrmPreview.conditionallyEnableDeleteButton();
begin
  if (FUID <> '') and (Copy(FUID,1,5) <> 'Error') and Options.SafeDelete then
  begin
    actDelete.Enabled := True;
    actDelete.Hint := Translate('Delete this message from server');
  end
  else begin
    actDelete.Enabled := False;
    actDelete.Hint := Translate('Delete Button only available when using Safe Delete option');
  end;
end;


procedure TfrmPreview.ProcessMessage(AMsg: TIdMessage; const AStream: TStream; AHeaderOnly: Boolean);
var
  MessageClient : TIdMessageClient;
  LIOHandler: TIdIOHandlerStreamMsg;
begin
  LIOHandler := TIdIOHandlerStreamMsg.Create(nil, AStream);
  try
    LIOHandler.FreeStreams := False;
    LIOHandler.MaxLineAction := TIdMaxLineAction.maSplit;

    MessageClient := TIdMessageClient.Create(Self);
    try
      MessageClient.OnWork := frmPopUMain.OnProcessWork;
      MessageClient.IOHandler := LIOHandler;

      try
        MessageClient.IOHandler.Open;
        MessageClient.ProcessMessage(AMsg, AHeaderOnly);
      finally
        MessageClient.IOHandler := nil;
      end;
    finally
      MessageClient.Free;
    end;
  finally
    LIOHandler.Free;
  end;
end;



procedure TfrmPreview.mnuResetPreviewToolbarClick(Sender: TObject);
var
   backupFilename : String;
begin
    if (ShowTranslatedDlg(Translate('Reset Toolbar?')+' '+#13#10#13#10+
                    Translate('All customizations to this toolbar will be erased.'),
                    mtConfirmation,[mbYes,mbCancel],0) = mrYes) then
    begin
      backupFilename := ChangeFileExt(FToolbarFileName, '.old');

      // remove previous backup
      if (FileExists(backupFilename)) then
        DeleteToRecycleBin(backupFilename, self.Handle);

      // if toolbar has been customized delete and backup customizations file
      if (FileExists(FToolbarFileName)) then begin
        if RenameFile(FToolbarFileName, backupFilename) then
          ShowMessage('Toolbar customizations backed up to'+' ' + backupFilename)
        else
          ShowMessage('Could not backup toolbar customizations.');
      end;

      // reset the toolbar to original state
      ActionManagerPreview.ResetActionBar(0);
      Perform(WM_SETTINGCHANGE, 0, 0);
    end;
end;

procedure TfrmPreview.WndProc(var Message: TMessage);
var
  p: TENLink;
  strURL: string;
begin
  if (Message.Msg = WM_NOTIFY) then
  begin
    if (PNMHDR(Message.lParam).code = EN_LINK) then
    begin
      p := TENLink(Pointer(TWMNotify(Message).NMHdr)^);
      if (p.Msg = WM_LBUTTONDOWN) then
      begin
        SendMessage(memMail.Handle, EM_EXSETSEL, 0, Longint(@(p.chrg)));
        strURL := memMail.SelText;
        memMail.SelLength := 0;
        ShellExecute(Handle, 'open', PChar(strURL), nil, nil, SW_SHOWNORMAL);
      end
    end
  end;
  try
    inherited;
  except on e: EAccessViolation
    do
    ShowMessage('EAccessViolation detected but prevented.#13#10This is an experimental bug fix.#13#10Technical Details: Error in inherited call in TfrmPreview.WndProc()');
  end;
end;

procedure TfrmPreview.DeleteTempFiles;
var
  i : integer;
begin
  // delete MSG temp files
  for i := 0 to Msg.MessageParts.Count - 1 do
  begin
    if Msg.MessageParts.Items[i] is TIdAttachment then
    begin
      DeleteFile((Msg.MessageParts.Items[i] as TIdAttachmentFile).StoredPathName);
    end;
  end;
  // delete execute temp files
  if Assigned(FFilesToDelete) then
  begin
    for i := 0 to FFilesToDelete.Count-1  do
    begin
      DeleteFile(FFilesToDelete[i]);
    end;
    FreeAndNil(FFilestoDelete);
  end;
end;

procedure TfrmPreview.AddFileToDelete(FileName: string);
begin
  if not Assigned(FFilesToDelete) then
    FFilesToDelete := TStringList.Create;
  FFilesToDelete.Add(FileName);
end;

procedure TfrmPreview.LoadActionManager;
var
  S: TFileStream;
  S2,S3 : TMemoryStream;
  st : string;
begin
  if FileExists(FToolbarFileName) then
  begin
    try
      S := TFileStream.Create(FToolbarFileName, fmOpenRead or fmShareDenyWrite);
      try
        S2 := TMemoryStream.Create;
        try
          ObjectBinaryToText(S,S2);
          S2.Position := 0;
          SetLength(st,S2.Size);
          S2.Read(st[1],S2.Size);
          st := AnsiReplaceStr(st,'frmPreviewInstance',Self.Name);
          S2.Clear;
          S2.Write(st[1],Length(st));
          S3 := TMemoryStream.Create;
          try
            S2.Position := 0;
            ObjectTextToBinary(S2,S3);
            S3.Position := 0;
              Try
                ActionManagerPreview.LoadFromStream(S3);
              Except on EAccessViolation do begin end;
              End;
          finally
            S3.Free;
          end;
        finally
          S2.Free;
        end;
      finally
        S.Free;
      end;
    Except on E : Exception do
      ShowTranslatedDlg(Translate('Error loading toolbar customizations. (PopTrayU error #418'), mtError, [mbOK], 0);
    end;
  end;
end;


procedure TfrmPreview.SaveActionManager;
var
  S2,S3 : TMemoryStream;
  st : string;
begin
  if FCustomized then
  begin
    S2 := TMemoryStream.Create;
    try
      ActionManagerPreview.SaveToStream(S2);
      S3 := TMemoryStream.Create;
      try
        S2.Position := 0;
        ObjectBinaryToText(S2,S3);
        S3.Position := 0;
        SetLength(st,S3.Size);
        S3.Read(st[1],S3.Size);
        st := AnsiReplaceStr(st,Self.Name,'frmPreviewInstance');
        S3.Clear;
        S3.Write(st[1],Length(st));
        S3.Position := 0;
        S2.Clear;
        ObjectTextToBinary(S3,S2);
        S2.Position := 0;
        S2.SaveToFile(FToolbarFileName);
      finally
        S3.Free;
      end;
    finally
      S2.Free;
    end;
  end;
end;

procedure TfrmPreview.LoadPreviewIni;
begin
  self.LoadPreviewIniFile(uIniSettings.IniName);
end;

procedure TfrmPreview.LoadPreviewIniFile(const filename : String);
var
  Ini : TIniFile;
  NewLeft,NewTop,cnt : integer;
  tabType : DefaultTabType;
begin
  // load toolbar
  LoadActionManager;
  // load from ini
  Ini := TIniFile.Create(filename);
  try
    // options
    memMail.ReadOnly := Ini.ReadBool('Preview','ReadOnly',True);
    actEditReadOnly.Checked := memMail.ReadOnly;
    HtmlImagesEnabled := Ini.ReadBool('Preview','ShowImages',True);
    actImageToggle.Checked := HtmlImagesEnabled;
    (WebBrowser1 as TWebBrowserTamed).ImagesOn := HtmlImagesEnabled;
    // pos/size
    Self.Width := Ini.ReadInteger('Preview','Width',Self.Width);
    Self.Height := Ini.ReadInteger('Preview','Height',Self.Height);
    if Ini.ReadBool('Preview','Maximized',false) then
      Self.WindowState := wsMaximized
    else
      Self.WindowState := wsNormal;
    NewLeft := Ini.ReadInteger('Preview','Left',Screen.WorkAreaWidth-Self.Width);
    NewTop := Ini.ReadInteger('Preview','Top',Screen.WorkAreaHeight-Self.Height);
    // make sure there isn't already a window at the spot
    cnt := 0;
    while WindowAt(Self,NewLeft,NewTop) do
    begin
      Inc(cnt);
      Inc(NewLeft,32);
      Inc(NewTop,32);
      // off screen?
      if NewTop + Self.Height > Screen.Height then
      begin
        NewTop := 0;
        Inc(NewLeft,40);
      end;
      if NewLeft + Self.Width > Screen.Width then
      begin
        NewLeft := 0;
        Inc(NewTop,40);
      end;
      // couldn't find a spot?
      if (cnt > 100) then
      begin
        NewLeft := 0;
        NewTop := 0;
        Break;
      end;
    end;
    Self.Left := NewLeft;
    Self.Top := NewTop;
    // font
    memMail.Font.Name := Ini.ReadString('Preview','FontName','Courier New');
    memMail.Font.Size := Ini.ReadInteger('Preview','FontSize',8);
    memMail.Font.Color := Ini.ReadInteger('Preview','FontColor',clWindowText);
    SetSetProp(memMail.Font,'Style',Ini.ReadString('Preview','FontStyle',''));
    memMail.Font.Charset := Ini.ReadInteger('Preview','FontCharset',DEFAULT_CHARSET);
    // tab
    tabType := DefaultTabType(Ini.ReadInteger('Preview','DefaultPreviewTab',Integer(TAB_HTML)));
    if (tabType = TAB_LAST_USED) then begin
      FTab := Ini.ReadInteger('Preview','Tab',HTML_TAB);
    end else begin
      case (tabType) of
        TAB_HTML:       FTab := HTML_TAB;
        TAB_PLAIN_TEXT: FTab := BODY_TAB;
        TAB_RAW:        FTab := RAW_TAB;
      end;
    end;

    // If HTML preview mode is disabled in options/inifile
    if (Options.DisableHtmlPreview) then begin
      // disable the HTML preview tab
      //tsMessageParts.Tabs[HTML_TAB].enabled := false;
      // and if the current tab is the html tab, change it to a non-disabled tab
      if (FTab = HTML_TAB) then FTab := BODY_TAB;
    end;

    if (FTab <> HTML_TAB) then WebBrowser1.Hide;
  finally
     Ini.Free;
  end;
end;

procedure TfrmPreview.SelectSpamTab;
var
  tabType : DefaultTabType;
begin
    tabType := Options.DefaultSpamTab;
    if (tabType <> TAB_LAST_USED) then
    begin
      case (tabType) of
        TAB_HTML:       FTab := HTML_TAB;
        TAB_PLAIN_TEXT: FTab := BODY_TAB;
        TAB_RAW:        FTab := RAW_TAB;
      end;
    end;
end;

procedure TfrmPreview.SavePreviewIni;
begin
  SaveINItoFile(uIniSettings.IniName);
end;

procedure TfrmPreview.SaveINItoFile(const filename : String);
var
  Ini : TIniFile;
begin
  // save toolbar
  SaveActionManager;
  // save to ini
  Ini := TIniFile.Create(filename);
  try
    // options
    Ini.WriteBool('Preview','ReadOnly',memMail.ReadOnly);
    Ini.WriteBool('Preview', 'ShowImages', HtmlImagesEnabled);
    // pos/size
    Ini.WriteInteger('Preview','Left',Self.Left);
    Ini.WriteInteger('Preview','Top',Self.Top);
    Ini.WriteBool('Preview','Maximized',Self.WindowState = wsMaximized);
    if Self.WindowState <> wsMaximized then
    begin
      Ini.WriteInteger('Preview','Width',Self.Width);
      Ini.WriteInteger('Preview','Height',Self.Height);
    end;
    // font
    Options.PreviewFont.Assign(memMail.Font);
    Ini.WriteString('Preview','FontName',memMail.Font.Name);
    Ini.WriteInteger('Preview','FontSize',memMail.Font.Size);
    Ini.WriteInteger('Preview','FontColor',memMail.Font.Color);
    Ini.WriteString('Preview','FontStyle',GetSetProp(memMail.Font,'Style'));
    Ini.WriteInteger('Preview','FontCharset',memMail.Font.Charset);
    // tab
    Ini.WriteInteger('Preview','Tab',tsMessageParts.TabIndex);
  finally
     Ini.Free;
  end;
end;

function TfrmPreview.AttachmentIcon(filename: string): integer;
var
  ext : string;
begin
  ext := LowerCase(ExtractFileExt(filename));
  if (filename = 'Body') or (filename = 'Text') or (ext = '.txt') then
    Result := iconText
  else if (ext = '.htm') or (ext = '.html') or (ext = '.url') then
    Result := iconHTML
  else if (ext = '.jpg') or (ext = '.gif') or (ext = '.bmp') or (ext = '.jpeg') or (ext = '.png') then
    Result := iconPic
  else if (ext = '.zip') or (ext = '.rar') or (ext = '.ace') or (ext = '.cab') then
    Result := iconZip
  else if (ext = '.exe') or (ext = '.com') then
    Result := iconEXE
  else if (ext = '.pif') or (ext = '.vbs') or (ext = '.bat') or (ext = '.cmd') or (ext = '.scr') or
          (ext = '.shs') or (ext = '.js') or (ext = '.dll') or (ext = '.lnk') or (ext = '.chm') then
    Result := iconWarning
  else if (ext = '.eml') or (ext = '.msg') then
    Result := iconEMail
  else if (ext = '.mp3') or (ext = '.wav') or (ext = '.wma') then
    Result := iconMusic
  else if (ext = '.avi') or (ext = '.mpg') or (ext = '.mpeg') or (ext = '.mov') or (ext = '.wmv') then
    Result := iconMovie
  else
    Result := iconNone;
end;


procedure TfrmPreview.ShowMsg;
////////////////////////////////////////////////////////////////////////////////
// Show the Message in the preview form
var
  i, strLen : integer;
  numMsgParts : integer;
  attachmentid, toReplace, encodedAttachment, attachmentcontent, aname, mimetype: string;
  cidnum, msgpart : integer;
  cids: TMatchCollection;
  //cid: TMatch;
  stream: TMemoryStream;
  attachment: TIdAttachment;
  attachmentStream: TStream;
begin
  numMsgParts := 0;
  try
    // fixed headers
    edFrom.Text := Msg.From.Text;
    if Msg.ReplyTo.Count>0 then
      FReplyTo := (Msg.ReplyTo[0].Address)
    else
      FReplyTo := (Msg.From.Address);
    edTo.Text := (Msg.Recipients.EMailAddresses);
    edSubject.Text := Msg.Subject;//decodedSubject;
    if (Msg.Date < 1 ) then
      edDate.Text := ''
    else
      edDate.Text := DateTimeToStr(Msg.Date);
    // optional headers
    if Msg.CCList.EMailAddresses <> '' then
    begin
      panPreviewCC.Visible := True;
      edCC.Text := Msg.CCList.EMailAddresses;
    end;
    if Options.ShowXMailer and (Msg.Headers.Values['X-Mailer'] <> '') then
    begin
      panPreviewXMailer.Visible := True;
      edXMailer.Text := Msg.Headers.Values['X-Mailer'];
    end;
    Application.ProcessMessages;
    // body
    FBody := '';
    if Msg.MessageParts.Count > 1 then // Multi-part message
    begin
      // with attachments
      if Msg.MessageParts.Items[0] is TidText then
      begin
          FBody := FBody + TidText(Msg.MessageParts.Items[0]).Body.Text;
          Inc(numMsgParts);
      end
      else if Msg.MessageParts.Items[0] is TIdAttachment then
        FBody := FBody + #13#10+uTranslate.Translate('Attachment:')+' '+
                         TidAttachment(Msg.MessageParts.Items[0]).ContentType;

      if Msg.MessageParts.Items[1] is TidText then
      begin
        // This CAN be HTML part that came after a plain-text part here...
        // but it also could be plain-text after an attachment or something.
        // HTML part after plain-text part should be ignored in plain-text view

        //if numMsgParts > 0 then
          //FBody := FBody + '--- Next Message Part ---'+#13#10;

        if AnsiStartsStr('text/html',Msg.MessageParts.Items[1].ContentType) then begin
          if numMsgParts = 0 then
            FBody := FBody +
              ConvertHtmlToPlaintext(TidText(Msg.MessageParts.Items[1]).Body.Text);
            //FHtml := TidText(Msg.MessageParts.Items[1]).Body.Text;
        end
        else begin
          FBody := FBody + TidText(Msg.MessageParts.Items[1]).Body.Text;
        end;
      end;

      lvAttachments.Show;
      spltAttachemnts.Show;
      // attachments
      for i := 0 to Msg.MessageParts.Count-1 do
      begin
        strLen := Pos(';',Msg.MessageParts.Items[i].ContentType) - 1;
        if strLen < 0 then
          strLen := Length(Msg.MessageParts.Items[i].ContentType);
        mimetype := LowerCase(Copy(Msg.MessageParts.Items[i].ContentType,1,strLen));
        { Bug-fix: Some emails do not have a semicolon after the content-type
          because they do not specify the charset in the Content-Type header.
          Previously this would cause the attachment to be treated as plaintext
          even if it was not. An example of the variation in the MIME section
          headers that cause this would be the second of the following two
          examples. The first is the typical case, the second is the erroneous
          case.

          Content-Type: text/html; charset=utf-8
          Content-Transfer-Encoding: quoted-printable

          Content-Transfer-Encoding: 8bit
          Content-Type: text/html
        }


        if mimetype <> 'multipart/alternative' then
        begin
          if (Msg.MessageParts.Items[i] is TIdAttachment) then
            aname := TIdAttachment(Msg.MessageParts.Items[i]).FileName
          else begin
            if i = 0 then aname := 'Body' else aname := 'Text';
            if mimetype = 'text/html' then
            begin
              aname := 'Message.htm';  //@TODO this should probably be the "real" attachment name?
              FHtml := TidText(Msg.MessageParts.Items[i]).Body.Text;

              // put image directly into the html as base64 so it'll show up in IE
              // 7/7/2014 - Took out @ sign in regular expression to make Sprint MMS pictures work that
              // use malformed format <img src="cid:CAM009241.jpg" type="image/jpeg">
              if (TRegEx.IsMatch(FHtml,'cid:(.*?)[\w.]*')) then begin
                // has embedded image(s)
                cids := TRegEx.Matches(FHtml, 'cid:(?P<contentident>(.*?)[\w.]*)'); //eg: cid:image001.png@01CE6143.C41AB1F0
                for cidnum := 0 to cids.Count-1 do begin
                  // the part of FHtml that we will replace with the image data
                  toReplace := cids[cidnum].Value;
                  // the content id string we are looking for in the Indy ContentID field
                  attachmentid := '<'+cids[cidnum].Groups['contentident'].Value+'>'; //eg: <image001.png@01CE6143.C41AB1F0>

                  // find the attachment with the matching cid
                  for msgpart := 0 to Msg.MessageParts.Count - 1 do begin
                    if (Msg.MessageParts.Items[msgpart] is TIdAttachment) and
                       (Msg.MessageParts.Items[msgpart].ContentID = attachmentid) then
                    begin
                      // convert attachment file to base64 string
                      stream := TMemoryStream.Create;
                      try
                        TidAttachmentFile(Msg.MessageParts.Items[msgpart]).SaveToStream(stream);
                        encodedAttachment := string(EncodeBase64(stream.Memory, stream.Size)); //encode returns an ansi string
                      finally
                        stream.Free;
                      end;

                      // this is what goes in the SRC tag in the HTML
                      attachmentcontent := 'data:'+Msg.MessageParts.Items[msgpart].ContentType+
                        ';base64,' + encodedAttachment;

                      //replace CID with actual image data
                      FHtml := StringReplace(FHtml, toReplace, attachmentcontent, []);
                      break; // cid has been found and replaced, now skip to next image tag
                    end;
                  end;
                end;
              end;
            end;
          end;
          with lvAttachments.Items.Add do
          begin
            Caption := aname;
            ImageIndex := AttachmentIcon(aname);
            StateIndex := i;
            //Hint := mimetype;
          end;
        end;
      end;
      FDecoded := True;
    end
    else begin //Single-part messsage
      if Msg.NoDecode then // MessageParts property is empty
        begin
          FBody := Msg.Body.Text;
          FHtml := '';//'<pre>' + Msg.Body.Text + '</pre>';
        end
      else begin
        try
          FBody := FBody + Msg.Body.Text;
          if (Msg.MessageParts.Count>0) then
          begin
            if (Msg.MessageParts.Items[0] is TidText) then
            begin
              FHtml := TidText(Msg.MessageParts.Items[0]).Body.Text;
              if TidText(Msg.MessageParts.Items[0]).Body <> Msg.Body then
              begin
                // This case happens both for plain text and html messages with
                // only one part and no attachments
                FBody := FBody + TidText(Msg.MessageParts.Items[0]).Body.Text;

                if (NOT AnsiContainsStr(Msg. ContentType, 'text/html')) then
                  if (NOT AnsiContainsStr(Msg. ContentType, 'multipart/mixed')) and (NOT AnsiContainsStr(Msg. ContentType, 'multipart/alternative')) then //fixes bug - some html email showing as plain text
                    FHtml := '' //empty string = show plain-text view on HTML pane
                else begin
                  //HTML only message, convert to plaintext
                  FBody := ConvertHtmlToPlaintext(FBody);

                end;
              end;
            end
            else
            begin  // single part message, but the message part is an attachment not text
              FBody := FBody + uTranslate.Translate('Attachment:')+' ['+
                                TidAttachment(Msg.MessageParts.Items[0]).FileName+']';

              if mimetype <> 'multipart/mixed' then
              begin
                // only message part is a text attachment.
                if ( TidAttachment(Msg.MessageParts.Items[0]).ContentType = 'text/plain' ) then
                begin
                  //TODO: refactor...roughly like so:
                  //FBody := FBody + GetTextAttachment(TidAttachment(Msg.MessageParts.Items[0]));

                  attachment := TIdAttachment(Msg.MessageParts.Items[0]);
                  attachmentStream := attachment.OpenLoadStream;
                  try
                    FBody := FBody + #13#10#13#10 + ReadStringFromStream(attachmentStream, -1, CharsetToEncoding(attachment.Charset));
                  finally
                    attachment.CloseLoadStream;
                  end;
                end else begin
                  //only message part is a non-text attachment.

                end;

                lvAttachments.Show;
                spltAttachemnts.Show;
                with lvAttachments.Items.Add do
                begin
                  Caption := TIdAttachment(Msg.MessageParts.Items[0]).FileName;
                  ImageIndex := AttachmentIcon(aname);
                  StateIndex := lvAttachments.Items.Count; //used to be i, but i makes no sense.
                  //Hint := mimetype;
                end;
              end;

              FHtml := Msg.Body.Text;
            end;
          end
          else begin
            // This case has been seen to happen when there is a html only
            // email with no additional mime sections.
            FBody := Msg.Body.Text;

            {parse out mime type for message}
            strLen := Pos(';',Msg.ContentType) - 1;
            if (strLen < 0) then
            begin
              strLen := Length(Msg.ContentType);
            end;
            mimetype := LowerCase(Copy(Msg.ContentType,1,strLen));

            if (mimetype = 'text/plain') then
            begin
              {Message only has plain text, no HTML, treat as pre-formatted}
              FHtml := '';//'<pre>' + Msg.Body.Text + '</pre>';
            end
            else begin
              {otherwise, presume it's HTML, leave as is}
              FHtml := Msg.Body.Text;
              FBody := '-- Converted from html by PopTrayU --' + #13#10 +
                RemoveAllTags(Msg.Body.Text);
              //FBody := ConvertHtmlToPlaintext(Msg.Body.Text);  //leaves all kinds of CSS everywhere
            end;
          end;
        except
          FBody := Msg.Body.Text;
        end;
      end;
      // top x lines
      if Options.TopLines>0 then
        FBody := StrAfter(FRawMsg,#13#10#13#10);
      lvAttachments.Hide;
      spltAttachemnts.Hide;
      FDecoded := False;
    end;
    memMail.Lines.Clear;
    if FTab = BODY_TAB then
    begin
      memMail.Lines.Add(FBody)
    end
    else if (FTab < tsMessageParts.Tabs.Count) then
      tsMessageParts.TabIndex := FTab;
    panProgress.Visible := False;
    Screen.Cursor := crDefault;
    FAccount.Prot.Disconnect;
  finally
    btnOK.Enabled := True;
    btnOK.SetFocus;
  end;
end;


// -----------------------------------------------------------------------------
// ----------------------------------------------------------------- Events ----
// -----------------------------------------------------------------------------

procedure TfrmPreview.FormCreate(Sender: TObject);
var
  mask: Word;
  i : integer;
  labelHeight : integer;
  //vMargin : integer;
begin
  // rich edit with URLs
  mask := SendMessage(Handle, EM_GETEVENTMASK, 0, 0);
  SendMessage(memMail.Handle, EM_SETEVENTMASK, 0, mask or ENM_LINK);
  SendMessage(memMail.Handle, EM_AUTOURLDETECT, Integer(True), 0);
  // clear edit boxes
  edTo.Text := '';
  edFrom.Text := '';
  edSubject.Text := '';
  edDate.Text := '';
  edCC.Text := '';
  edXMailer.Text := '';
  panPreviewCC.Visible := False;
  panPreviewXMailer.Visible := False;

  TranslateComponentFromEnglish(self);
  // translate tab names
  for i := 0 to tsMessageParts.Tabs.Count-1 do
    tsMessageParts.Tabs[i] := Translate(tsMessageParts.Tabs[i]);
  // action manager
  FToolbarFileName := uIniSettings.IniPath +'Preview.customize';
  FCustomized := False;

  edFrom.AutoSize := true;

  self.Font := Options.GlobalFont;
  tsMessageParts.Font := Options.GlobalFont;
  lblFrom.Font := Options.GlobalFont;
  lblProgress.Font := Options.GlobalFont;
  lblTo.Font := Options.GlobalFont;
  lblDate.Font := Options.GlobalFont;
  lblSubject.Font := Options.GlobalFont;
  lblCC.Font := Options.GlobalFont;
  lblStatusText.Font := Options.GlobalFont;
  lblXMailer.Font := Options.GlobalFont;

  memMail.Font := Options.PreviewFont;
  memMail.Color := Options.PreviewBgColor;
  lvAttachments.Font := Options.PreviewFont;
  lvAttachments.Color := Options.PreviewBgColor;

  edFrom.Font := Options.GlobalFont;
  edTo.Font := Options.GlobalFont;

  with lblFrom.Font do Style := Style + [fsBold];
  with lblTo.Font do Style := Style + [fsBold];
  with lblDate.Font do Style := Style + [fsBold];
  with lblSubject.Font do Style := Style + [fsBold];
  with lblCC.Font do Style := Style + [fsBold];
  with lblProgress.Font do Style := Style + [fsBold];
  with lblStatusText.Font do Style := Style + [fsBold];
  with lblXMailer.Font do Style := Style + [fsBold];


  labelHeight := - Options.GlobalFont.Height + lblFrom.Margins.Top + lblFrom.Margins.Bottom;  //height returned is negative when align with margins is false.


  panPreviewFrom.Height := labelHeight;
  lblFrom.Height := labelHeight;
  edFrom.Height := labelHeight;

  panPreviewTo.Top := panPreviewFrom.Top + panPreviewFrom.Height;
  panPreviewTo.Height := labelHeight;
  lblTo.Height := labelHeight;
  edTo.Height := labelHeight;

  panPreviewCC.Top := panPreviewTo.Top + panPreviewTo.Height;
  panPreviewCC.Height := labelHeight;
  lblCC.Height := labelHeight;
  edCC.Height := labelHeight;

  panPreviewDate.Top := panPreviewCC.Top + panPreviewCC.Height;
  panPreviewDate.Height := labelHeight;
  lblDate.Height := labelHeight;
  edDate.Height := labelHeight;

  panPreviewSubject.Top := panPreviewDate.Top + panPreviewDate.Height;
  panPreviewSubject.Height := labelHeight;
  lblSubject.Height := labelHeight;
  edSubject.Height := labelHeight;

  panPreviewXMailer.Top := panPreviewSubject.Top + panPreviewSubject.Height;
  panPreviewXMailer.Height := labelHeight;
  lblXMailer.Height := labelHeight;
  edXMailer.Height := labelHeight;

  //if (Options.ToolbarColorScheme = schemeDark) then
  //  toolbarPreview.ActionManager.images := imlActionsDark
  //else
  //  toolbarPreview.ActionManager.Images := imlActionsPng;

  //Replace TWebBrowser with extended TWebBrowser that disables images
  //TODO: destructor this created object
  WebBrowser1 := TWebBrowserTamed.Create(self);
  TControl(WebBrowser1).Parent := Self;
  WebBrowser1.Align := alClient;
  WebBrowser1.OnBeforeNavigate2 := WebBrowser1BeforeNavigate2;
  WebBrowser1.OnNewWindow3 := WebBrowser1NewWindow3;
  WebBrowser1.OnStatusTextChange := WebBrowser1StatusTextChange;

end;

procedure TfrmPreview.Find1Click(Sender: TObject);
begin
  FindDialog1.Position :=
    Point(memMail.Left + memMail.Width, memMail.Top);
  FindDialog1.Execute;
end;

procedure TfrmPreview.FindDialog1Find(Sender: TObject);
var
  FoundAt: LongInt;
  StartPos, ToEnd: Integer;
  mySearchTypes : TSearchTypes;
  //myFindOptions : TFindOptions;
begin
  mySearchTypes := [];
  with memMail do
  begin
    if frMatchCase in FindDialog1.Options then
       mySearchTypes := mySearchTypes + [stMatchCase];
    if frWholeWord in FindDialog1.Options then
       mySearchTypes := mySearchTypes + [stWholeWord];
    { Begin the search after the current selection, if there is one. }
    { Otherwise, begin at the start of the text. }
    if SelLength <> 0 then
      StartPos := SelStart + SelLength
    else
      StartPos := 0;
    { ToEnd is the length from StartPos through the end of the
      text in the rich edit control. }
    ToEnd := Length(Text) - StartPos;
    FoundAt :=
      FindText(FindDialog1.FindText, StartPos, ToEnd, mySearchTypes);
    if FoundAt <> -1 then
    begin
      SetFocus;
      SelStart := FoundAt;
      SelLength := Length(FindDialog1.FindText);
    end
    else Beep;
  end;
end;

procedure TfrmPreview.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SavePreviewIni;
  DeleteTempFiles;
  Action := caFree;
end;

procedure TfrmPreview.panOKResize(Sender: TObject);
begin
  btnOK.Left := (panOK.Width div 2) - (btnOK.Width div 2);
end;

procedure TfrmPreview.btnStopClick(Sender: TObject);
begin
  FStop := True;
  btnOK.Enabled := True;
end;

procedure TfrmPreview.btnOKClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPreview.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := btnOK.Enabled;
end;

procedure TfrmPreview.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #27) then
  begin
    if panProgress.Visible then
      btnStop.Click
    else
      Self.Close;
  end;
end;

procedure TfrmPreview.tsMessagePartsChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
begin
  if NewTab = RAW_TAB then
  begin
    if (btnOK.Enabled) then btnOK.SetFocus;
    memMail.Visible := True;
    memMail.Lines.Clear;
    memMail.Lines.Add(FRawMsg);
    lvAttachments.Hide;
    spltAttachemnts.Hide;
    WebBrowser1.Hide;
  end
  else if NewTab = HTML_TAB then
  begin
    if (Options.DisableHtmlPreview) then begin
      AllowChange := false;
      WebBrowser1.Hide;
      Exit;
    end;

    if (btnOK.Enabled) then btnOK.SetFocus;
    if (FHtml = '') then
    begin
      //email is not HTML, so display email as text on HTML tab
      if (btnOK.Enabled) then btnOK.SetFocus;
      WebBrowser1.Hide;
      memMail.Visible := True;
      memMail.Lines.Clear;
      memMail.Lines.Add(FBody);
      if lvAttachments.Items.Count > 0 then
      begin
        lvAttachments.Show;
        spltAttachemnts.Show;
      end;
    end
    else begin
      // display email as HTML
      memMail.Visible := False; //hide plain-text message component
      spltAttachemnts.Hide;
      WebBrowser1.Show;
      LoadHtmlIntoBrowser(WebBrowser1, FHtml);

      //show attachments, if any (treat 2 as a special case, no attachments
      //because most emails show up with text and HTML as two sections)
      if (lvAttachments.Items.Count <> 2) AND (lvAttachments.Items.Count > 0) then begin
        lvAttachments.Show;
        spltAttachemnts.Show;
      end
      else begin
        lvAttachments.Hide;
        spltAttachemnts.Hide;
      end;
    end;
  end
  else if NewTab = BODY_TAB then
  begin
    if (btnOK.Enabled) then btnOK.SetFocus;
    memMail.Visible := True;
    memMail.Lines.Clear;
    memMail.Lines.Add(FBody);
    if lvAttachments.Items.Count > 0 then
    begin
      lvAttachments.Show;
      spltAttachemnts.Show;
    end;
    WebBrowser1.Hide;
  end;
  FTab := NewTab;
end;

{ In order to make the HTML tab appear disabled, the style for the TTabSet must
  be set to Owner Draw, and we have to have this method to decide when to draw
  the tab disabled and when to draw the label enabled}
procedure TfrmPreview.tsMessagePartsDrawTab(Sender: TObject; TabCanvas: TCanvas;
  R: TRect; Index: Integer; Selected: Boolean);
var
  S : String;
begin
  TabCanvas.Font.Color := clWindowText;
  if (Options.DisableHtmlPreview) AND (Index = HTML_TAB) then
    TabCanvas.Font.Color := clGrayText;
  S := ' ' + tsMessageParts.Tabs.Strings[Index] + ' ';
  TabCanvas.TextRect(R, S, [tfCenter, tfVerticalCenter, tfSingleLine]);

end;

procedure TfrmPreview.LoadHtmlIntoBrowser(BrowserComponent: TWebBrowser; RawHtml: string);
////////////////////////////////////////////////////////////////////////////////
// Loads static HTML into a web browser component.
//const
  //imgTag = '(?i)<img[^>]+>';//'(?i)<img[^>]+/(img)?>';
  //mapTag = '(?i)</img[^>]+>';
var
  sl: TStringList;
  ms: TMemoryStream;
begin
  BrowserComponent.Navigate('about:blank') ;
  BrowserComponent.Offline := true;
  while BrowserComponent.ReadyState < READYSTATE_INTERACTIVE do
    Application.ProcessMessages;

  if Assigned(BrowserComponent.Document) then
  begin
    sl := TStringList.Create;
    try
      ms := TMemoryStream.Create;
      try

        if (NOT HtmlImagesEnabled) then
          begin
            SantitizeHtml(RawHtml, ms);
        end
        else begin
          ms.WriteBuffer(Pointer(rawHtml)^, Length(rawHtml)* SizeOf(Char));
        end;

        ms.Seek(0, 0);
        (BrowserComponent.Document as IPersistStreamInit).Load(TStreamAdapter.Create(ms)) ;
      finally
        ms.Free;
      end;
    finally
      sl.Free;
    end;
  end;
  browserShowingHeaders := false;
end;


procedure TfrmPreview.SaveDialogTypeChange(Sender:TObject);
var
  buf: array [0..MAX_PATH] of char;
  filename: string;
  dlg: TSaveDialog;
  handle: THandle;
begin
  dlg := (Sender as TSaveDialog);                           // get a pointer to the open dialog
  handle := GetParent(dlg.Handle);                          // Send the message to the dialogs parent so it can handle it the normal way
  SendMessage(handle, CDM_GETSPEC, MAX_PATH,integer(@buf)); // get the currently entered filename
  filename := buf;

  // change the extension to the correct one
  case dlg.FilterIndex of
    1:
      filename := ChangeFileExt(filename,'.eml');
    2:
      filename := ChangeFileExt(filename,'.txt');
    3:
      filename := ChangeFileExt(filename,'.msg');
    4:
      filename := ChangeFileExt(filename,'.mht');
    5:
      filename := ChangeFileExt(filename,'');
  end;
  // finally, change the currently selected filename in the dialog
  SendMessage(handle,CDM_SETCONTROLTEXT,edt1,integer(PChar(filename)));
end;


procedure TfrmPreview.actSaveExecute(Sender: TObject);
////////////////////////////////////////////////////////////////////////////////
// Save Message
var
  MsgLines : TStringList;
  SaveDialog : TSaveDialog;
begin
  SaveDialog := TSaveDialog.Create(nil);
  try
    // prepare save dialog
    SaveDialog.DefaultExt := 'eml|txt|msg|mht';
    SaveDialog.Filter := 'Outlook Express (*.eml)|*.eml|Text File (*.txt)|*.txt|E-Mail Message (*.msg)|*.msg|MHTML Document (*.mht)|*.mht|All Files (*.*)|*.*';
    SaveDialog.Options := [ofOverwritePrompt];
    SaveDialog.FileName := Copy(edSubject.Text,LastDelimiter(':',edSubject.Text)+1,
                                Length(edSubject.Text)-LastDelimiter(':',edSubject.Text));
    SaveDialog.FileName := SanitizeFileName(SaveDialog.FileName);
    SaveDialog.OnTypeChange := SaveDialogTypeChange;
    // run it
    if SaveDialog.Execute then
    begin
      if Uppercase(ExtractFileExt(SaveDialog.FileName)) = '.TXT' then
      begin
        MsgLines := TStringlist.Create;
        try
          MsgLines.Add('From: '+edFrom.Text);
          MsgLines.Add('To: '+edTo.Text);
          MsgLines.Add('Subject: '+edSubject.Text);
          MsgLines.Add(StringOfChar('-',70)+#13#10);
          MsgLines.Add(memMail.Lines.Text);
          MsgLines.SaveToFile(SaveDialog.FileName, TEncoding.UTF8); //TODO should we have an option to make this current code page vs utf8?
        finally
          MsgLines.Free;
        end;
      end
      else begin
        MsgLines := TStringlist.Create;
        try
          MsgLines.Add(FRawMsg);
          MsgLines.SaveToFile(SaveDialog.FileName, TEncoding.UTF8); //TODO should we have an option to make this current code page vs utf8?
        finally
          MsgLines.Free;
        end;
      end;
    end;
  finally
    SaveDialog.Free;
  end;
end;


function BasicHTMLEncode(const Data: string): string;
var
  i: Integer;
begin

  result := '';
  for i := 1 to length(Data) do
    case Data[i] of
      '<': result := result + '&lt;';
      '>': result := result + '&gt;';
      '&': result := result + '&amp;';
      '"': result := result + '&quot;';
    else
      result := result + Data[i];
    end;

end;

procedure TfrmPreview.actPrintExecute(Sender: TObject);
////////////////////////////////////////////////////////////////////////////////
// Print
var
  i,h : Integer;
  vaIn, vaOut: OleVariant;
  printDialog: TPrintDialog;
  Range: IHTMLTxtRange;
begin
  if (FTab = HTML_TAB) and (FHtml <> '') then begin
    // Add message headers to beginning of HTML document so they print too
    if (browserShowingHeaders = false) then begin
      Range := ((WebBrowser1.Document AS IHTMLDocument2).body AS IHTMLBodyElement).createTextRange;
      Range.Collapse(True); //Set insert position to beginning of document
      Range.PasteHTML('<b>'+Translate('From')+'</b>:  '+BasicHTMLEncode(edFrom.Text)+'<br>'+
        '<b>'+Translate('To')+'</b>:  '+BasicHTMLEncode(edTo.Text)+'<br>'+
        '<b>'+Translate('Date')+'</b>:  '+BasicHTMLEncode(edDate.Text)+'<br>'+
        '<b>'+Translate('Subject')+'</b>:  '+BasicHTMLEncode(edSubject.Text)+'<hr>') ;
      browserShowingHeaders := true;
    end;

    vaIn := VarArrayCreate([0,1], varOleStr);
    vaIn[0] := VarAsType('header', VarOleStr); //header
    vaIn[1] := VarAsType('footer', VarOleStr); //footer


    // Show print-preview dialog allowing user to print
    WebBrowser1.ControlInterface.ExecWB(OLECMDID_PRINTPREVIEW,
      OLECMDEXECOPT_DONTPROMPTUSER, vaIn, vaOut);

    exit; //Skip Non-HTML print
  end;

  // Create a printer selection dialog
  printDialog := TPrintDialog.Create(Self);

  // Set up print dialog options
  printDialog.MinPage := 1;     // First allowed page number
  printDialog.MaxPage := 1;     // Highest allowed page number
  printDialog.ToPage  := 1;     // 1 to ToPage page range allowed
  printDialog.Options := [poPageNums];    // Allow page range selection

  // if the user has selected a printer (or default), then print!
  if printDialog.Execute then
  begin

    with Printer do
    begin
      BeginDoc;

      Canvas.Font.Name := 'Courier New';
      Canvas.Font.Size := 11;
      // from
      Canvas.Font.Style := [fsBold];
      Canvas.TextOut(100,100,Translate('From')+':  ');
      Canvas.Font.Style := [];
      Canvas.TextOut(100+Canvas.TextWidth(Translate('From')+':  '),100,edFrom.Text);
      h := Canvas.TextHeight(Translate('From')+':  '+edFrom.Text);
      // to
      Canvas.Font.Style := [fsBold];
      Canvas.TextOut(100,100+h,Translate('To')+':  ');
      Canvas.Font.Style := [];
      Canvas.TextOut(100+Canvas.TextWidth(Translate('To')+':  '),100+h,edTo.Text);
      h := h + Canvas.TextHeight(Translate('To')+':  '+edTo.Text);
      // date
      Canvas.Font.Style := [fsBold];
      Canvas.TextOut(100,100+h,Translate('Date')+':  ');
      Canvas.Font.Style := [];
      Canvas.TextOut(100+Canvas.TextWidth(Translate('Date')+':  '),100+h,edDate.Text);
      h := h + Canvas.TextHeight(Translate('Date')+':  '+edDate.Text);
      // subject
      Canvas.Font.Style := [fsBold];
      Canvas.TextOut(100,100+h,Translate('Subject')+':  ');
      Canvas.Font.Style := [];
      Canvas.TextOut(100+Canvas.TextWidth(Translate('Subject')+':  '),100+h,edSubject.Text);
      h := h + Canvas.TextHeight(Translate('Subject')+':  '+edSubject.Text);
      // line
      h := h + 15;
      Canvas.Brush.Color := clBlack;
      Canvas.Rectangle(100,100+h,(Pagewidth - 100),100+h+5);
      h := h + 30;
      Canvas.Brush.Color := clWhite;
      // body
      Canvas.Font.Size := 9;
      for i := 0 to memMail.Lines.Count do
        Canvas.TextOut(100,100+h + (i * Canvas.TextHeight(memMail.Lines.Strings[i])),
                       memMail.Lines.Strings[i]);

      EndDoc;
    end;

  end;
end;


procedure TfrmPreview.actReplyExecute(Sender: TObject);
var
  email,subject,body : string;
begin
  // get headers
  email := FReplyTo;
  subject := edSubject.Text;
  if (Uppercase(Copy(subject,1,3)) <> 'RE:') and (Uppercase(Copy(subject,1,3)) <> 'RE[') then
    subject := 'Re: '+subject;
  if memMail.SelLength > 1 then
    body := memMail.SelText
  else
    body := FBody;//memMail.Text; - Changed so replying to HTML emails will work
  body := #13#10'> ' + AnsiReplaceStr(body,#13#10,#13#10'> ');
  // send it
  frmPopUMain.SendMail(email,subject,body);
end;


procedure TfrmPreview.actDeleteExecute(Sender: TObject);
begin
  if not(Options.DeleteConfirm) or
     (ShowTranslatedDlg(Translate('Delete Message from Server?'),
      mtConfirmation,[mbYes,mbNo],0) = mrYes) then
  begin
    // ask again for protected messages
    if Options.DeleteConfirmProtected then
    begin
      if FProtected then
      begin
        if ShowTranslatedDlg(Translate('You are trying to delete protected messages.') +#13#10#13#10+
                                   Translate('Are you sure?'),
                                   mtConfirmation,[mbYes,mbNo],0) = mrNo then
        begin
          Exit;
        end;
      end;
    end;
    // Only hide, not delete as first pass so FAccount isn't deleted before
    // deleting.
    Self.Hide;
    // delete it
    frmPopUMain.DeleteOneMailItem(FAccount,FMsg);
    // now close (and free) window
    Self.Close; //Saw a memory access error here in the debugger.
  end;

end;


procedure TfrmPreview.lvAttachmentsSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
var
  SomethingSelected : boolean;
begin
  SomethingSelected := not (lvAttachments.Selected = nil);
  actAttachmentOpen.Enabled := SomethingSelected;
  actAttachmentSave.Enabled := SomethingSelected;
end;

procedure TfrmPreview.actAttachmentSaveExecute(Sender: TObject);
////////////////////////////////////////////////////////////////////////////////
// Save Attachment
var
  SaveDialog : TSaveDialog;
begin
  if lvAttachments.Selected = nil then Exit;
  SaveDialog := TSaveDialog.Create(nil);
  try
    SaveDialog.Options := [ofOverwritePrompt];
    SaveDialog.FileName := lvAttachments.Selected.Caption;
    if SaveDialog.Execute then
    begin
      if Msg.MessageParts[lvAttachments.Selected.StateIndex] is
        {$IFDEF INDY9} TIdAttachment {$ELSE} TIdAttachmentFile {$ENDIF} then
      begin
        if not CopyFile(pchar((Msg.MessageParts[lvAttachments.Selected.StateIndex]
          as {$IFDEF INDY9} TIdAttachment{$ELSE} TIdAttachmentFile{$ENDIF}).StoredPathName),
          pchar(SaveDialog.FileName),false) then
        begin
          MessageDlg(uTranslate.Translate('Failed to Save Attachment.')+#13#10#13#10+
                     SaveDialog.FileName, mtError, [mbOK], 0);
        end;
      end
      else begin
        if Msg.MessageParts[lvAttachments.Selected.StateIndex] is TIdText then
        begin
          (Msg.MessageParts[lvAttachments.Selected.StateIndex] as TIdText).Body.SaveToFile(SaveDialog.FileName); //TODO - should this be unicode overloaded?
        end
        else
          MessageDlg(uTranslate.Translate('Unknown Attachment Type.'), mtError, [mbOK], 0);
      end;
    end;
  finally
    SaveDialog.Free;
  end;
end;

procedure TfrmPreview.actAttachmentOpenExecute(Sender: TObject);
////////////////////////////////////////////////////////////////////////////////
// Open Attachment
var
  OldName,NewName : string;
begin
  if lvAttachments.Selected = nil then Exit;
  // check for malicious filetype
  if lvAttachments.Selected.ImageIndex in [iconEXE,iconWarning] then
  begin
    MessageDlg(uTranslate.Translate('Because of the Security Risk, PopTrayU doesn''t allow the opening of Executable files.'), mtError, [mbOK], 0);
  end
  else begin
    if Msg.MessageParts[lvAttachments.Selected.StateIndex] is TIdAttachment then
    begin
      // rename temp file
      {$IFDEF INDY9}
      OldName := (Msg.MessageParts[lvAttachments.Selected.StateIndex] as TIdAttachment).StoredPathName; //Indy9
      {$ELSE}
      OldName := (Msg.MessageParts[lvAttachments.Selected.StateIndex] as TIdAttachmentFile).StoredPathName; //Indy10
      {$ENDIF}
      NewName := TempFileName(lvAttachments.Selected.Caption);
      if CopyFile(PChar(OldName), PChar(NewName), true) then
      begin
        // run it
        AddFileToDelete(NewName);
        ExecuteFile(NewName,'','',SW_NORMAL);
      end
      else
        MessageDlg(uTranslate.Translate('Unable to Copy file.'), mtError, [mbOK], 0);
    end
    else begin
      if Msg.MessageParts[lvAttachments.Selected.StateIndex] is TIdText then
      begin
        if LowerCase(ExtractFileExt(lvAttachments.Selected.Caption)) = '.htm' then
        begin
          NewName := TempFileName(lvAttachments.Selected.Caption);
          // run it
          AddFileToDelete(NewName);
          ExecuteFile(NewName,'','',SW_NORMAL);
        end
        else begin
          // show text in memo
          memMail.Lines.Assign((Msg.MessageParts[lvAttachments.Selected.StateIndex] as TIdText).Body);
        end;
      end
      else
        MessageDlg(uTranslate.Translate('Unknown Attachment Type.'), mtError, [mbOK], 0);
    end;
  end;
end;

procedure TfrmPreview.actAttachmentSaveAllExecute(Sender: TObject);
var
  i : integer;
begin
  for i := 0 to lvAttachments.Items.Count-1 do
  begin
    lvAttachments.Items[i].Selected := True;
    actAttachmentSave.Execute;
  end;
end;

procedure TfrmPreview.lvAttachmentsDblClick(Sender: TObject);
begin
  actAttachmentOpen.Execute;
end;

procedure TfrmPreview.actEditFontAccept(Sender: TObject);
begin
  memMail.Font := actEditFont.Dialog.Font;
end;

procedure TfrmPreview.actEditFontBeforeExecute(Sender: TObject);
begin
  actEditFont.Dialog.Font := memMail.Font;
  {actEditFont.Dialog.Font.Name := memMail.Font.Name;
  actEditFont.Dialog.Font.Size := memMail.Font.Size;
  actEditFont.Dialog.Font.Color := memMail.Font.Color;
  actEditFont.Dialog.Font.Style := memMail.Font.Style;
  actEditFont.Dialog.Font.Charset := memMail.Font.Charset;}
end;

procedure TfrmPreview.actEditReadOnlyExecute(Sender: TObject);
begin
  memMail.ReadOnly := actEditReadOnly.Checked;
end;

procedure TfrmPreview.actMarkExecute(Sender: TObject);
begin
  //Todo: show submenu?
end;

procedure TfrmPreview.ActMarkReadExecute(Sender: TObject);
begin
  if FAccount.IsImap then begin
    FAccount.ConnectIfNeeded();
    FAccount.Prot.MakeRead(FUID, true);
  end;
end;

procedure TfrmPreview.ActMarkUnreadExecute(Sender: TObject);
begin
  if FAccount.IsImap then begin
    FAccount.ConnectIfNeeded();
    FAccount.Prot.MakeRead(FUID, false);
  end;
end;


procedure TfrmPreview.actShowImagesExecute(Sender: TObject);
begin
  HtmlImagesEnabled := actImageToggle.Checked;
  (WebBrowser1 as TWebBrowserTamed).ImagesOn := HtmlImagesEnabled;

  if (FTab = HTML_TAB) then begin
    WebBrowser1.Visible := true;
    LoadHtmlIntoBrowser(WebBrowser1, FHtml);
  end;

end;

procedure TfrmPreview.actStarExecute(Sender: TObject);
begin
  if FAccount.IsImap then begin
    try
      FAccount.ConnectIfNeeded();
      (FAccount.Prot as TProtocolIMAP4).SetImportantFlag(FUID, true);
    except
      on e1 : EIdReadTimeout do begin
        FAccount.Prot.Disconnect;
        // TODO: smarter determination of whether to use star or important terminology
        ShowTranslatedDlg('Server Timeout: Unable to Add Star/Important Flag', mtError,[mbOK],0);
      end;
      on e2 : Exception do begin
        FAccount.Prot.Disconnect;
          ShowTranslatedDlg(Translate('Error Adding Star/Important Flag')+#13#10+e2.Message, mtError,[mbOK],0);
      end;
    end;
  end;
end;

procedure TfrmPreview.actUnstarExecute(Sender: TObject);
begin
  if FAccount.IsImap then begin
    FAccount.ConnectIfNeeded();
    (FAccount.Prot as TProtocolIMAP4).SetImportantFlag(FUID, false);
  end;
end;

procedure TfrmPreview.actCustomizeExecute(Sender: TObject);
begin
  FCustomized := True;
  dm.ShowCustomizeDlg(ActionManagerPreview,False);
end;

procedure TfrmPreview.FormResize(Sender: TObject);
begin
  panProgress.Left := (memMail.Width div 2) - (panProgress.Width div 2);
  panProgress.Top := memMail.Top + (memMail.Height div 2) - (panProgress.Height div 2);

  lblStatusText.Top := panOK.Height - lblStatusText.Height;
end;

procedure TfrmPreview.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssCtrl in Shift) and ((Key = VK_F6) or (Key = VK_TAB)) then
  begin
    if tsMessageParts.TabIndex=0 then
      tsMessageParts.TabIndex := 1
    else
      tsMessageParts.TabIndex := 0;
  end;
end;

procedure TfrmPreview.edEnter(Sender: TObject);
begin
  (Sender as TEdit).SelectAll;
  FEnter := True;
end;

procedure TfrmPreview.edMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if FEnter then
  begin
   (Sender as TEdit).SelectAll;
   FEnter := False;
  end;
end;
              
procedure TfrmPreview.actOpenMessageExecute(Sender: TObject);
////////////////////////////////////////////////////////////////////////////////
// Save and execute
var
  fname : string;
  MsgLines : TStringList;
begin
  MsgLines := TStringlist.Create;
  try
    MsgLines.Add(FRawMsg);
    fName := uIniSettings.IniPath+Options.TempEmailFilename;
    MsgLines.SaveToFile(fname); //TODO: should this be unicode?
    ExecuteFile(fname,'','',SW_NORMAL);
  finally
    MsgLines.Free;
  end;
end;

procedure TfrmPreview.WebBrowser1BeforeNavigate2(ASender: TObject;
  const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
begin
  if (AnsiStartsStr('http://', URL) or AnsiStartsStr('https://', URL)) then begin
    // Open link in default browser instead of this window
    Cancel := True;
    WebBrowser1.Stop;
    ShellExecute(0, nil, PChar(String(Url)), nil, nil, SW_SHOWNORMAL);
  end;
end;

procedure TfrmPreview.WebBrowser1NewWindow3(ASender: TObject;
  var ppDisp: IDispatch; var Cancel: WordBool; dwFlags: Cardinal;
  const bstrUrlContext, bstrUrl: WideString);
begin
    Cancel := True;
    WebBrowser1.Stop;
    ShellExecute(0, nil, PChar(String(bstrUrl)), nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmPreview.WebBrowser1StatusTextChange(ASender: TObject;
  const Text: WideString);
begin
  if (Text = 'Done') then
    lblStatusText.Caption := ''
  else
    lblStatusText.Caption := Text;
end;

procedure TfrmPreview.EnableImapOptions(enable : boolean);
begin
  ActMarkRead.Enabled := enable;
  ActMarkUnread.Enabled := enable;
  ActMark.Enabled := enable;
end;

procedure TfrmPreview.LoadMailMessage(MailItem : TMailItem);
begin
  FMsg := MailItem;  //keep a reference to the mail item to make deleting it easier.
  FProtected := MailItem.Protect;
  FUID := MailItem.UID; // used to enable/disable delete AND for adding/removing flags
  FDecoded := False;

  conditionallyEnableDeleteButton(); //based on whether or not a UID is valid (and Options.SafeDelete)
  btnOK.Enabled := False;

  // force tab to plaintext for spam msgs
  if (MailItem.Spam) then
    frmPreview.SelectSpamTab;

end;

procedure TFrmPreview.ShowProgressPanel();
begin
  panProgress.Visible := True;
  panProgress.BringToFront;
  Progress.Position := 0;
end;

end.
