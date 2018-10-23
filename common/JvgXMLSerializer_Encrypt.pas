{-----------------------------------------------------------------------------
The Original Code is: JvgXMLSerializer.PAS, released on 2003-01-15.
Description:
  Interface:
  Limitations: Encrypt algorithm is used rijndael and MD5
  Preconditions: Use DCPCrypt Component
  Extra:
Known Issues: replace the JvgXMLSerializer.StrPosExt to StrPos
-----------------------------------------------------------------------------}
unit JvgXMLSerializer_Encrypt;

interface

uses SysUtils, classes,
  JvgXMLSerializer_pjh;

type
  TJvgXMLSerializer_Encrypt = class(TJvgXMLSerializer)
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SaveToXMLFile(AComponent: TObject; AFileName: string;
                  APassphrase: string = ''; AIsEncrypt: Boolean = false);
    procedure LoadFromXMLFile(AComponent: TObject; AFileName: string;
                  APassphrase: string = ''; AIsEncrypt: Boolean = false);

    procedure Serialize_Encrypt(Component: TObject; Stream: TStream; APassphrase: string);
    procedure DeSerialize_Encrypt(Component: TObject; Stream: TStream; APassphrase: string);
  end;

implementation

uses UnitEncrypt;

{ TJvgXMLSerializer_Encrypt }

constructor TJvgXMLSerializer_Encrypt.Create(AOwner: TComponent);
begin
  inherited;
  //inherited Create(AOwner);
end;

procedure TJvgXMLSerializer_Encrypt.DeSerialize_Encrypt(Component: TObject;
  Stream: TStream; APassphrase: string);
var
  LMemStream: TMemoryStream;
begin
  LMemStream := TMemoryStream.Create;
  try
    DecryptStream(Stream, LMemStream, APassphrase);
    LMemStream.Position := 0;
    DeSerialize(Component, LMemStream);
  finally
    LMemStream.Free;
  end;
end;

destructor TJvgXMLSerializer_Encrypt.Destroy;
begin
  inherited;
end;

//AComponent: save data to AComponent
//AFilename: XML FileName
//APassphrase: Using in hash algorithm
//IsEncrypt:
procedure TJvgXMLSerializer_Encrypt.LoadFromXMLFile(AComponent: TObject;
  AFileName, APassphrase: string; AIsEncrypt: Boolean);
var
  Fs: TFileStream;
begin
  Fs := TFileStream.Create(AFileName, fmOpenRead);
  try
    if AIsEncrypt then
      DeSerialize_Encrypt(AComponent, FS, '_'+APassphrase+'@')
    else
      DeSerialize(AComponent, Fs);
  finally
    Fs.Free;
  end;
end;

procedure TJvgXMLSerializer_Encrypt.SaveToXMLFile(AComponent: TObject; AFileName: string;
                  APassphrase: string = ''; AIsEncrypt: Boolean = false);
var
  Fs: TFileStream;
begin
  Fs := TFileStream.Create(AFileName, fmCreate);
  try
    if AIsEncrypt then
      Serialize_Encrypt(AComponent, FS, '_'+APassphrase+'@')
    else
      Serialize(AComponent, Fs);
  finally
    Fs.Free;
  end;
end;

procedure TJvgXMLSerializer_Encrypt.Serialize_Encrypt(Component: TObject;
  Stream: TStream; APassphrase: string);
var
  LMemStream: TMemoryStream;
begin
  LMemStream := TMemoryStream.Create;
  try
    Serialize(Component, LMemStream);
    LMemStream.Position := 0;
    EncryptStream(LMemStream, Stream, APassphrase);
  finally
    LMemStream.Free;
  end;
end;

end.

