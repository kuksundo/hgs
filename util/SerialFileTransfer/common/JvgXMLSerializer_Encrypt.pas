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
  JvgXMLSerializer, DCPcrypt2, DCPmd5, DCPrijndael;

type
  TJvgXMLSerializer_Encrypt = class(TJvgXMLSerializer)
  public
    FDCP_md5: TDCP_md5;
    FDCP_rijndael: TDCP_rijndael;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SaveToXMLFile(AComponent: TObject; AFileName: string;
                  APassphrase: string = ''; AIsEncrypt: Boolean = false);
    procedure LoadFromXMLFile(AComponent: TObject; AFileName: string;
                  APassphrase: string = ''; AIsEncrypt: Boolean = false);

    procedure Serialize_Encrypt(Component: TObject; Stream: TStream; APassphrase: string);
    procedure DeSerialize_Encrypt(Component: TObject; Stream: TStream; APassphrase: string);
    procedure EncryptStream(ASourceStream, ADestStream: TStream; APassphrase: string);
    procedure DecryptStream(ASourceStream, ADestStream: TStream; APassphrase: string);
  end;

implementation

{ TJvgXMLSerializer_Encrypt }

function Min(a, b: integer): integer;
begin
  if (a < b) then
    Result := a
  else
    Result := b;
end;

constructor TJvgXMLSerializer_Encrypt.Create(AOwner: TComponent);
begin
  inherited;
  //inherited Create(AOwner);

  FDCP_md5 := TDCP_md5.Create(nil);
  FDCP_rijndael := TDCP_rijndael.Create(nil);
end;

procedure TJvgXMLSerializer_Encrypt.DecryptStream(ASourceStream,
  ADestStream: TStream; APassphrase: string);
var
  Cipher: TDCP_cipher;         // the cipher to use
  CipherIV: array of byte;     // the initialisation vector (for chaining modes)
  Hash: TDCP_hash;             // the hash to use
  HashDigest: array of byte;   // the result of hashing the passphrase with the salt
  Salt: array[0..7] of byte;   // a random salt to help prevent precomputated attacks
begin
  Hash := TDCP_hash(TDCP_md5.Create(nil));
  try
    SetLength(HashDigest,Hash.HashSize div 8);
    ASourceStream.ReadBuffer(Salt[0],Sizeof(Salt));  // read the salt in from the file
    Hash.Init;
    Hash.Update(Salt[0],Sizeof(Salt));   // hash the salt
    Hash.UpdateStr(APassphrase);  // and the passphrase
    Hash.Final(HashDigest[0]);           // store the hash in HashDigest

    Cipher := TDCP_cipher(TDCP_rijndael.Create(nil));
    try
      if (Cipher is TDCP_blockcipher) then            // if it is a block cipher we need the IV
      begin
        SetLength(CipherIV,TDCP_blockcipher(Cipher).BlockSize div 8);
        ASourceStream.ReadBuffer(CipherIV[0],Length(CipherIV));       // read the initialisation vector from the file
        Cipher.Init(HashDigest[0],Min(Cipher.MaxKeySize,Hash.HashSize),CipherIV);  // initialise the cipher
        TDCP_blockcipher(Cipher).CipherMode := cmCBC;
      end
      else
        Cipher.Init(HashDigest[0],Min(Cipher.MaxKeySize,Hash.HashSize),nil);  // initialise the cipher

      Cipher.DecryptStream(ASourceStream,ADestStream,ASourceStream.Size - ASourceStream.Position); // decrypt!
      Cipher.Burn;
    finally
      Cipher.Free;
    end;
  finally
    Hash.Free;
  end;
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
  FDCP_rijndael.Free;
  FDCP_md5.Free;

  inherited;
end;

procedure TJvgXMLSerializer_Encrypt.EncryptStream(ASourceStream,
  ADestStream: TStream; APassphrase: string);
var
  Cipher: TDCP_cipher;         // the cipher to use
  CipherIV: array of byte;     // the initialisation vector (for chaining modes)
  Hash: TDCP_hash;             // the hash to use
  HashDigest: array of byte;   // the result of hashing the passphrase with the salt
  Salt: array[0..7] of byte;   // a random salt to help prevent precomputated attacks
  i: integer;
begin
  Hash := TDCP_hash(TDCP_md5.Create(nil));
  try
    SetLength(HashDigest,Hash.HashSize div 8);
    for i := 0 to 7 do
      Salt[i] := Random(256);  // just fill the salt with random values (crypto secure PRNG would be better but not _really_ necessary)
    ADestStream.WriteBuffer(Salt,Sizeof(Salt));  // write out the salt so we can decrypt!
    Hash.Init;
    Hash.Update(Salt[0],Sizeof(Salt));   // hash the salt
    Hash.UpdateStr(APassphrase);  // and the passphrase
    Hash.Final(HashDigest[0]);           // store the output in HashDigest

    Cipher := TDCP_cipher(TDCP_rijndael.Create(nil));
    try
      if (Cipher is TDCP_blockcipher) then      // if the cipher is a block cipher we need an initialisation vector
      begin
        SetLength(CipherIV,TDCP_blockcipher(Cipher).BlockSize div 8);
        for i := 0 to (Length(CipherIV) - 1) do
          CipherIV[i] := Random(256);           // again just random values for the IV
        ADestStream.WriteBuffer(CipherIV[0],Length(CipherIV));  // write out the IV so we can decrypt!
        Cipher.Init(HashDigest[0],Min(Cipher.MaxKeySize,Hash.HashSize),CipherIV);  // initialise the cipher with the hash as key
        TDCP_blockcipher(Cipher).CipherMode := cmCBC;   // use CBC chaining when encrypting
      end
      else
        Cipher.Init(HashDigest[0],Min(Cipher.MaxKeySize,Hash.HashSize),nil); // initialise the cipher with the hash as key

      Cipher.EncryptStream(ASourceStream,ADestStream,ASourceStream.Size); // encrypt the entire file
      Cipher.Burn;   // important! get rid of keying information
    finally
      Cipher.Free;
    end;
  finally
    Hash.Free;
  end;
end;

//AComponent: save date to AComponent
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
      DeSerialize_Encrypt(AComponent, FS, APassphrase)
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
      Serialize_Encrypt(AComponent, FS, APassphrase)
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
