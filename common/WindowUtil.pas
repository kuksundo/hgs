unit WindowUtil;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  System.Win.Registry, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Winapi.ShellAPI;

function GetAssociation(const DocFileName: string): string;
procedure OpenPDF(AFullPathFileName: string; APageNo: integer = 1);

implementation

function GetAssociation(const DocFileName: string): string;
var
  FileClass: string;
  Reg: TRegistry;
begin
  Result:= '';
  Reg:= TRegistry.Create(KEY_EXECUTE);
  Reg.RootKey:= HKEY_CLASSES_ROOT;
  FileClass:= '';

  if Reg.OpenKeyReadOnly(ExtractFileExt(DocFileName)) then
  begin
    FileClass:= Reg.ReadString('');
    Reg.CloseKey;
  end;

  if FileClass <> '' then
  begin
    if Reg.OpenKeyReadOnly(FileClass + '\Shell\Open\Command') then
    begin
      Result:= Reg.ReadString('');
      Reg.CloseKey;
    end;
  end;

  Reg.Free;
end;

procedure OpenPDF(AFullPathFileName: string; APageNo: integer);
var
  sFile,
  sViewerDefault,
  sParameter: string;
begin
//  sFile := '"8.5H21_900_20130410.pdf"';//+' #page=2';

//  sParameter := '-reuse-instance ' +
//               '-named-dest ' +
//               sWhere;
//  sParameter := '/A page=3 ' + AFullPathFileName;
  sParameter := '/A page=' + IntToStr(APageNo) + ' ' + AFullPathFileName;
  try
    sViewerDefault := GetAssociation('.pdf');
    sViewerDefault := Copy(sViewerDefault, 1, Pos('.exe', sViewerDefault) + 4);

    // Open default PDF viewer
    ShellExecute(0,
                 'open',
                 PChar(sViewerDefault), //'C:\Program Files (x86)\Adobe\Reader 11.0\Reader\AcroRd32.exe',
                 PChar(sParameter),
                 nil,
                 sw_shownormal);
  except
    MessageDlg('PDF viewer is not accessible!',
               mtInformation,
               [mbOk],
               0);
  end;
end;

end.
