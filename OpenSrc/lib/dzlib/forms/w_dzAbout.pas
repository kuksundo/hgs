unit w_dzAbout;

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
  u_dzTranslator,
  ComCtrls,
  ExtCtrls;

type
  Tf_dzAbout = class(TForm)
    pa_Left: TPanel;
    l_ProductName: TLabel;
    l_Version: TLabel;
    l_Date: TLabel;
    l_Copyright: TLabel;
    p_Bottom: TPanel;
    b_OK: TButton;
    pc_Info: TPageControl;
    ts_ProgramInfo: TTabSheet;
    ts_Contact: TTabSheet;
    m_Contact: TMemo;
    ts_Credits: TTabSheet;
    lb_Credits: TListBox;
    p_Credits: TPanel;
    lv_ProgramInfo: TListView;
  public
    type
      ///<summary>
      /// change default behaviour:
      /// daoShowProductVersion -> show the product version rather than the file version
      /// daoShowOriginalFilename -> show the OriginalFilename rather than the product name </summary>
      TdzAboutOptions = (daoShowProductVersion, daoShowOriginalFilename);
      TdzAboutOptionSet = set of TdzAboutOptions;
  private
    procedure Init(const _Contact: string; _Options: TdzAboutOptionSet);
  public
    class procedure Execute(_Owner: TWinControl; const _Contact: string = ''; _Options: TdzAboutOptionSet = []); static;
    constructor Create(_Owner: TComponent); override;
  end;

implementation

{$R *.dfm}

uses
  u_dzVclUtils,
  u_dzVersionInfo,
  u_dzFileUtils;

function _(const _s: string): string;
begin
  Result := dzlibGetText(_s);
end;

class procedure Tf_dzAbout.Execute(_Owner: TWinControl;
  const _Contact: string = ''; _Options: TdzAboutOptionSet = []);
var
  frm: Tf_dzAbout;
begin
  frm := Tf_dzAbout.Create(_Owner);
  try
    TForm_CenterOn(frm, _Owner);
    frm.Init(_Contact, _Options);
    frm.ShowModal;
  finally
    FreeAndNil(frm);
  end;
end;

constructor Tf_dzAbout.Create(_Owner: TComponent);
begin
  inherited;

  TranslateComponent(Self, DZLIB_TRANSLATION_DOMAIN);
end;

procedure Tf_dzAbout.Init(const _Contact: string; _Options: TdzAboutOptionSet);

  procedure AddProgramInfo(const _Name, _Value: string);
  var
    li: TListItem;
  begin
    li := lv_ProgramInfo.Items.Add;
    li.Caption := _Name;
    li.SubItems.Add(_Value);
  end;

var
  fi: IFileInfo;
  ProgName: string;
  fir: TFileInfoRec;
  Version: string;
begin
  pc_Info.ActivePage := ts_ProgramInfo;
  if _Contact = '' then
    ts_Contact.TabVisible := False
  else
    m_Contact.Lines.Text := _Contact;

  // not yet implemented
  ts_Credits.TabVisible := False;

  fi := TApplicationInfo.Create;
  fi.AllowExceptions := False;
  if not fi.HasVersionInfo then begin
    ProgName := ChangeFileExt(ExtractFileName(Application.ExeName), '');
    Caption := Format(_('About %s'), [ProgName]);
    l_ProductName.Caption := ProgName;
    l_Version.Visible := False;
    fir := u_dzFileUtils.TFileSystem.GetFileInfo(Application.ExeName);
    l_Date.Caption := DateTimeToStr(fir.Timestamp);
    l_Copyright.Visible := False;
    lv_ProgramInfo.Columns.Add;
    AddProgramInfo(_('There is no version information available.'), '');
    TListView_Resize(lv_ProgramInfo, [lvrContent]);
    Exit;
  end;

  if daoShowOriginalFilename in _Options then
    ProgName := fi.OriginalFilename
  else
    ProgName := fi.ProductName;
  Caption := Format(_('About %s'), [ProgName]);
  l_ProductName.Caption := ProgName;
  l_ProductName.Canvas.Font := l_ProductName.Font;
  while l_ProductName.Canvas.TextWidth(ProgName) > l_ProductName.Width do begin
    l_ProductName.Font.Size := l_ProductName.Font.Size - 1;
    l_ProductName.Canvas.Font := l_ProductName.Font;
  end;

  if daoShowProductVersion in _Options then begin
    Version := fi.ProductVersion;
    fir := u_dzFileUtils.TFileSystem.GetFileInfo(Application.ExeName);
    l_Date.Caption := DateTimeToStr(fir.Timestamp);
  end else begin
    Version := fi.FileVersion;
    l_Date.Caption := fi.ProductVersion;
  end;
  l_Version.Caption := Format(_('Version %s'), [Version]);
  l_Copyright.Caption := Format(_('(c) %s'), [fi.LegalCopyRight]);

  lv_ProgramInfo.Columns.Add;
  lv_ProgramInfo.Columns.Add;
  AddProgramInfo(_('Product Name'), fi.ProductName);
  AddProgramInfo(_('Product Version'), fi.ProductVersion);
  AddProgramInfo(_('Company Name'), fi.CompanyName);
  AddProgramInfo(_('Copyright'), fi.LegalCopyRight);
  AddProgramInfo(_('Trademark'), fi.LegalTradeMarks);
  AddProgramInfo(_('Description'), fi.FileDescription);
  AddProgramInfo(_('Original Filename'), fi.OriginalFilename);
  AddProgramInfo(_('Internal Name'), fi.InternalName);
  AddProgramInfo(_('File Version'), fi.FileVersion);
  TListView_Resize(lv_ProgramInfo, [lvrContent]);
end;

end.

