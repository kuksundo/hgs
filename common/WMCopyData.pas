unit WMCopyData;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes;

procedure SendStreamCopyData(FromHandle, ToHandle: integer; AStream: TMemoryStream);

implementation

procedure SendStreamCopyData(FromHandle, ToHandle: integer; AStream: TMemoryStream);
var
//  ms: TMemoryStream;
  MyCopyDataStruct: TCopyDataStruct;
  hTargetWnd: HWND;
begin
//  ms := TMemoryStream.Create;
//  try
//   image1.Picture.Bitmap.SaveToStream(ms);
   with MyCopyDataStruct do
   begin
     dwData := FromHandle;
     cbData := AStream.Size;
     lpData := AStream.Memory;
   end;

   SendMessage(ToHandle, WM_COPYDATA, 0, LongInt(@MyCopyDataStruct));

//  finally
//   ms.Free;
//  end;
end;

//procedure SendRecordCopyData(ToHandle: integer;
//  AEP: TEngineParameterItemRecord);
//var
//  cd : TCopyDataStruct;
//begin
//  with cd do
//  begin
//    dwData := Handle;
//    cbData := sizeof(AEP);
//    lpData := @AEP;
//  end;//with
//
//  SendMessage(ToHandle, WM_COPYDATA, 0, LongInt(@cd));
//end;

end.
