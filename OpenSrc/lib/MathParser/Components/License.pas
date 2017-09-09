{ *********************************************************************** }
{                                                                         }
{ Parser                                                                  }
{                                                                         }
{ Copyright (c) 2010 Pisarev Yuriy (post@pisarev.net)                     }
{                                                                         }
{ *********************************************************************** }

unit License;

interface

uses
  Classes;

function GetLicense: TStrings;
function GetLicenseCount: Integer;

const
  LicenseError = 'Parser has reached the maximum user-defined function limit for the current license';

implementation

uses
  Cipher, IniFiles, SearchUtils, SysUtils;

type
  TLicense = record
    Guid: string;
    LicenseCount: Integer;
  end;

const
  LicenseFileMask = '*.license';

  LicenseSection = 'Data';
  KeyIdent = 'Key';
  LicenseIdent = 'License';

  ProductA = '{E28196C4-C104-4C54-B984-D227A135C46F}';
  ProductB = '{D56C470A-83F3-437C-8798-800C603DB031}';
  ProductC = '{FC87F3A5-2FE7-44CD-93E9-C18E0FF38F20}';
  ProductD = '{9527C354-8E78-490D-9196-863A7ED595D7}';
  ProductE = '{5B49F79F-AA4D-47BD-9E40-89F8AF3FF606}';
  ProductF = '{157FFEBC-57F0-467F-84F1-50B9A79364C4}';

  LicenseArray: array[0..4] of TLicense = ((Guid: ProductA; LicenseCount: 5),
    (Guid: ProductB; LicenseCount: 100), (Guid: ProductC; LicenseCount: 500),
    (Guid: ProductD; LicenseCount: 1000), (Guid: ProductE; LicenseCount: -1));

  DefaultLicenseCount = -1;

var
  ALicense: TStringList;
  LicenseCount: Integer = DefaultLicenseCount;
  FileList: TStringList;
  ACipher: TCipher;
  S: string;
  I, J, K: Integer;

function GetLicense: TStrings;
begin
  Result := ALicense;
end;

function GetLicenseCount: Integer;
begin
  Result := LicenseCount;
end;

function ReadLicenseCount(const Text: string; out Count: Integer): Boolean;
var
  I, J: Integer;
begin
  Count := 0;
  for I := Low(LicenseArray) to High(LicenseArray) do
    if Pos(LicenseArray[I].Guid, Text) > 0 then
    begin
      J := LicenseArray[I].LicenseCount;
      if (J < 0) or (Count < J) then
      begin
        Count := J;
        if Count < 0 then Break;
      end;
    end;
  Result := Count <> 0;
end;

initialization
  ALicense := TStringList.Create;
  try
    FileList := TStringList.Create;
    try
      if Search(ExtractFilePath(ParamStr(0)) + LicenseFileMask, FileList) then
      begin
        ACipher := TCipher.Create(nil);
        try
          for I := 0 to FileList.Count - 1 do
          begin
            with ACipher.Lines do
            begin
              LoadFromFile(FileList[I]);
              if Count > 1 then
              begin
                for J := Count - 1 downto 0 do
                begin
                  S := Trim(Strings[J]);
                  Delete(J);
                  if S <> '' then Break;
                end;
              end
              else S := '';
            end;
            if S <> '' then
            begin
              try
                ACipher.Decrypt(S);
              except
                Continue;
              end;
              if ReadLicenseCount(ACipher.Lines.Text, K) and ((K < 0) or (LicenseCount < K)) then
              begin
                ALicense.Assign(ACipher.Lines);
                LicenseCount := K;
                if LicenseCount < 0 then Break;
              end;
            end;
          end;
        finally
          ACipher.Free;
        end;
      end;
    finally
      FileList.Free;
    end;
  except
  end;

finalization
  ALicense.Free;

end.
