unit UnitEncrypt;

interface

uses SysUtils, classes, DCPcrypt2, DCPmd5, DCPrijndael;

    procedure EncryptStream(ASourceStream, ADestStream: TStream; APassphrase: string);
    procedure DecryptStream(ASourceStream, ADestStream: TStream; APassphrase: string);

implementation

function Min(a, b: integer): integer;
begin
  if (a < b) then
    Result := a
  else
    Result := b;
end;

procedure DecryptStream(ASourceStream,
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

procedure EncryptStream(ASourceStream,
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

end.
