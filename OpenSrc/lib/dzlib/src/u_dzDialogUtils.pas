unit u_dzDialogUtils;

interface

uses
  Classes,
  Controls,
  u_dzTranslator;

type
  IdzFileFilterBuilder = interface ['{1EEE52D6-EA31-4C4D-8454-32B2C2BE1814}']
    ///<summary> Adds a new filter, the first one added is the default.
    ///          @param Description is the file type description e.g. 'Text file'. This descrition
    ///                             should be localized.
    ///          @param Mask is the file mask, e.g. '*.txt', it should not be localized.
    ///          @param AddMaskToDesc determines whether the mask is appended to the descripition as
    ///                               ' (*.bla)', defaults to true, e.g. 'Text file (*.txt)
    ///          @returns the interface itself, so chaining is possible like this:
    ///                   od.Filter := FileFilterHelper.AddFilter('bla', '*.bla').AddFilter('blub', '*.blu').Value;
    function Add(const _Description: string; const _Mask: string; _AddMaskToDesc: Boolean = True): IdzFileFilterBuilder;
    function AddFmt(const _DescriptionFmt: string; const _MaskFmt: string; const _Values: array of const): IdzFileFilterBuilder;
    function AddAvi: IdzFileFilterBuilder;
    function AddBmp: IdzFileFilterBuilder;
    function AddCsv: IdzFileFilterBuilder;
    function AddDbf: IdzFileFilterBuilder;
    function AddEmf: IdzFileFilterBuilder;
    function AddExe: IdzFileFilterBuilder;
    function AddGif: IdzFileFilterBuilder;
    function AddHtml: IdzFileFilterBuilder;
    function AddIni: IdzFileFilterBuilder;
    function AddJpg: IdzFileFilterBuilder;
    function AddLog: IdzFileFilterBuilder;
    function AddMdb: IdzFileFilterBuilder;
    function AddOdt: IdzFileFilterBuilder;
    function AddOds: IdzFileFilterBuilder;
    function AddPdf: IdzFileFilterBuilder;
    function AddPicture: IdzFileFilterBuilder;
    function AddRtf: IdzFileFilterBuilder;
    function AddTiff: IdzFileFilterBuilder;
    function AddTxt: IdzFileFilterBuilder;
    function AddXml: IdzFileFilterBuilder;
    function AddXls: IdzFileFilterBuilder;
    function Filter: string;
  end;

type
  TFileFilter = class
  private
    FDescription: string;
    FMask: string;
  public
    constructor Create(const _Description, _Mask: string; _AddMaskToDesc: Boolean);
    property Description: string read FDescription;
    property Mask: string read FMask;
  end;

{$DEFINE __DZ_OBJECT_LIST_TEMPLATE__}
type
  _LIST_ANCESTOR_ = TObject;
  _ITEM_TYPE_ = TFileFilter;
{$INCLUDE 't_dzObjectListTemplate.tpl'}

type
  {: List for storing TFileFilter items }
  TFileFilterList = class(_DZ_OBJECT_LIST_TEMPLATE_)

  end;

type
  TdzFileFilterBuilder = class(TInterfacedObject, IdzFileFilterBuilder)
  protected
    FFilters: TFileFilterList;
    FIncludeAllFiles: Boolean;
    FAllSupported: string;
    ///<summary>
    /// Adds an entry <description> (<mask>)|<mask> </summary>
    function Add(const _Description: string; const _Mask: string;
      _AddMaskToDesc: Boolean = True): IdzFileFilterBuilder;
    ///<summary>
    /// Adds an entry <descriptionfmt> (<maskfmt>)|<maskfmt>
    /// where both *fmts are passed through Format(*fmt, Values) </summary>
    function AddFmt(const _DescriptionFmt: string; const _MaskFmt: string;
      const _Values: array of const): IdzFileFilterBuilder;
    function AddAvi: IdzFileFilterBuilder;
    function AddBmp: IdzFileFilterBuilder;
    function AddCsv: IdzFileFilterBuilder;
    function AddDbf: IdzFileFilterBuilder;
    function AddEmf: IdzFileFilterBuilder;
    function AddExe: IdzFileFilterBuilder;
    function AddGif: IdzFileFilterBuilder;
    function AddHtml: IdzFileFilterBuilder;
    function AddIni: IdzFileFilterBuilder;
    function AddJpg: IdzFileFilterBuilder;
    function AddLog: IdzFileFilterBuilder;
    function AddMdb: IdzFileFilterBuilder;
    function AddOdt: IdzFileFilterBuilder;
    function AddOds: IdzFileFilterBuilder;
    function AddPdf: IdzFileFilterBuilder;
    function AddPicture: IdzFileFilterBuilder;
    function AddRtf: IdzFileFilterBuilder;
    function AddTiff: IdzFileFilterBuilder;
    function AddTxt: IdzFileFilterBuilder;
    function AddXml: IdzFileFilterBuilder;
    function AddXls: IdzFileFilterBuilder;
    function Filter: string;
  public
    constructor Create(_IncludeAllFiles: Boolean = True; const _AllSupported: string = '');
    destructor Destroy; override;
  end;

function FileFilterBuilder(_IncludeAllFiles: Boolean = True; const _AllSupported: string = ''): IdzFileFilterBuilder;

function TOpenDialog_Execute(_Owner: TWinControl; const _Title: string; const _Filter: string;
  var _fn: string): Boolean;

function TSaveDialog_Execute(_Owner: TWinControl; const _Title: string; const _Filter: string;
  var _fn: string): Boolean;

implementation

uses
  Dialogs,
  SysUtils;

{$INCLUDE 't_dzObjectListTemplate.tpl'}

function TOpenDialog_Execute(_Owner: TWinControl; const _Title: string; const _Filter: string;
  var _fn: string): Boolean;
var
  od: TOpenDialog;
begin
  od := TOpenDialog.Create(_Owner);
  try
    od.Name := '';
    od.Title := _Title;
    od.Filter := _Filter;
    od.Options := [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing];
    od.FileName := ExtractFileName(_fn);
    od.InitialDir := ExtractFileDir(_fn);
    od.DefaultExt := '*';
    Result := od.Execute(_Owner.Handle);
    if not Result then
      Exit;
    _fn := od.FileName;
  finally
    FreeAndNil(od);
  end;
end;

function TSaveDialog_Execute(_Owner: TWinControl; const _Title: string; const _Filter: string;
  var _fn: string): Boolean;
var
  sd: TSaveDialog;
begin
  sd := TSaveDialog.Create(_Owner);
  try
    sd.Name := '';
    sd.Options := [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing];
    sd.Title := _Title;
    sd.Filter := _Filter;
    sd.FileName := ExtractFileName(_fn);
    sd.InitialDir := ExtractFileDir(_fn);
    sd.DefaultExt := '*';
    Result := sd.Execute(_Owner.Handle);
    if not Result then
      Exit;
    _fn := sd.FileName;
  finally
    FreeAndNil(sd);
  end;
end;

function FileFilterBuilder(_IncludeAllFiles: Boolean = True; const _AllSupported: string = ''): IdzFileFilterBuilder;
begin
  Result := TdzFileFilterBuilder.Create(_IncludeAllFiles, _AllSupported);
end;

{ TdzFileFilterBuilder }

constructor TdzFileFilterBuilder.Create(_IncludeAllFiles: Boolean = True; const _AllSupported: string = '');
begin
  inherited Create;
  FFilters := TFileFilterList.Create;
  FIncludeAllFiles := _IncludeAllFiles;
  FAllSupported := _AllSupported;
end;

destructor TdzFileFilterBuilder.Destroy;
begin
  FFilters.Free;
  inherited;
end;

function TdzFileFilterBuilder.Add(const _Description: string; const _Mask: string;
  _AddMaskToDesc: Boolean = True): IdzFileFilterBuilder;
begin
  FFilters.Add(TFileFilter.Create(_Description, _Mask, _AddMaskToDesc));
  Result := Self;
end;

function TdzFileFilterBuilder.AddFmt(const _DescriptionFmt, _MaskFmt: string;
  const _Values: array of const): IdzFileFilterBuilder;
begin
  Result := Add(Format(_DescriptionFmt, _Values), Format(_MaskFmt, _Values));
end;

function TdzFileFilterBuilder.AddAvi: IdzFileFilterBuilder;
begin
  Result := Add(_('AVI files'), '*.AVI');
end;

function TdzFileFilterBuilder.AddBmp: IdzFileFilterBuilder;
begin
  Result := Add(_('Bitmap Files'), '*.BMP');
end;

function TdzFileFilterBuilder.AddCsv: IdzFileFilterBuilder;
begin
  Result := Add(_('Comma-separated values'), '*.CSV');
end;

function TdzFileFilterBuilder.AddDbf: IdzFileFilterBuilder;
begin
  Result := Add(_('DBase tables'), '*.DBF');
end;

function TdzFileFilterBuilder.AddEmf: IdzFileFilterBuilder;
begin
  Result := Add(_('Windows Enhanced Metafile'), '*.EMF');
end;

function TdzFileFilterBuilder.AddExe: IdzFileFilterBuilder;
begin
  Result := Add(_('Executable Files'), '*.EXE');
end;

function TdzFileFilterBuilder.AddGif: IdzFileFilterBuilder;
begin
  Result := Add(_('GIF Image'), '*.GIF');
end;

function TdzFileFilterBuilder.AddHtml: IdzFileFilterBuilder;
begin
  Result := Add(_('Hypertext Markup Language'), '*.html');
end;

function TdzFileFilterBuilder.AddIni: IdzFileFilterBuilder;
begin
  Result := Add(_('INI files'), '*.INI');
end;

function TdzFileFilterBuilder.AddJpg: IdzFileFilterBuilder;
begin
  Result := Add(_('JPEG Files'), '*.jpg;*.jpeg');
end;

function TdzFileFilterBuilder.AddLog: IdzFileFilterBuilder;
begin
  Result := Add(_('Log files'), '*.LOG');
end;

function TdzFileFilterBuilder.AddMdb: IdzFileFilterBuilder;
begin
  Result := Add(_('Microsoft Access Databases'), '*.mdb');
end;

function TdzFileFilterBuilder.AddOds: IdzFileFilterBuilder;
begin
  Result := Add(_('Open Document Spreadsheet'), '*.ODS');
end;

function TdzFileFilterBuilder.AddOdt: IdzFileFilterBuilder;
begin
  Result := Add(_('Open Document Text'), '*.ODT');
end;

function TdzFileFilterBuilder.AddPdf: IdzFileFilterBuilder;
begin
  Result := Add(_('Portable Document Format'), '*.PDF');
end;

function TdzFileFilterBuilder.AddPicture: IdzFileFilterBuilder;
begin
  Result := Add(_('Picture files'), '*.bmp;*.jpg;*.jpeg').AddBmp.AddJpg;
end;

function TdzFileFilterBuilder.AddRtf: IdzFileFilterBuilder;
begin
  Result := Add(_('Rich Text Format'), '*.RTF');
end;

function TdzFileFilterBuilder.AddTiff: IdzFileFilterBuilder;
begin
  Result := Add(_('Tagged Image File Format'), '*.TIF;*.TIFF');
end;

function TdzFileFilterBuilder.AddTxt: IdzFileFilterBuilder;
begin
  Result := Add(_('Text files'), '*.TXT');
end;

function TdzFileFilterBuilder.AddXls: IdzFileFilterBuilder;
begin
  Result := Add(_('Microsoft Excel File Format'), '*.XLS');
end;

function TdzFileFilterBuilder.AddXml: IdzFileFilterBuilder;
begin
  Result := Add(_('Extensible Markup Language'), '*.XML');
end;

function TdzFileFilterBuilder.Filter: string;

  procedure AddToResult(const _Description, _Mask: string); overload;
  begin
    if Result <> '' then
      Result := Result + '|';
    Result := Result + _Description + '|' + _Mask;
  end;

  procedure AddToResult(_Filter: TFileFilter); overload;
  begin
    AddToResult(_Filter.Description, _Filter.Mask);
  end;

var
  i: Integer;
  s: string;
begin
  Result := '';

  if FAllSupported <> '' then begin
    s := '';
    for i := 0 to FFilters.Count - 1 do begin
      if s <> '' then
        s := s + ';';
      s := s + FFilters[i].Mask;
    end;
    AddToResult(FAllSupported, s);
  end;

  for i := 0 to FFilters.Count - 1 do begin
    AddToResult(FFilters[i]);
  end;

  if FIncludeAllFiles then
    AddToResult(_('all files') + ' (*.*)', '*.*');
end;

{ TFileFilter }

constructor TFileFilter.Create(const _Description, _Mask: string; _AddMaskToDesc: Boolean);
begin
  inherited Create;
  FDescription := _Description;
  FMask := _Mask;
  if _AddMaskToDesc then
    FDescription := FDescription + ' (' + _Mask + ')';
end;

end.

