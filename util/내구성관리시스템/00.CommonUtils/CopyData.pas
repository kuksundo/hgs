unit CopyData;

interface

uses Windows, Messages, SysUtils;
type
  PCopyDataStruct = ^TCopyDataStruct;
  TCopyDataStruct = record
    dwData: LongInt;
    cbData: LongInt;
    lpData: Pointer;
  end;

type
  PRecToPass = ^TRecToPass;
  TRecToPass = record
    StrMsg : array[0..255] of char;
    StrSrcFormName : array[0..255] of char;
    iHandle : integer;
  end;

  procedure SendCopyData(FromFormName, ToFormName, Msg: string; SrcHandle: integer);

var
  FormName: string;   //메세지를 수신할 폼 이름
  msgHandle: THandle; //메세지를 보낼 폼 핸들

implementation

//메세지 디스플레이에 필요한 폼 이름과 핸들을 할당한다.
//본 Unit을 사용하는 Unit애서 한번은 꼭 시행해야 함
//FormName: 메세지를 받을 Form Name
//msgHandle: 메세지를 보내는 놈의 Form Handle(통상 0로 함)
procedure DAOutStruct_UnitInit(_FormName: string; _msgHandle: THandle);
begin
  FormName := _FormName;
  msgHandle := _msgHandle;
end;

//FromFormName: 메세지를 보내는 폼의 이름, 널값 가능
//ToFormName: 메세지를 받는 폼의 이름, 널값 불가
//Msg: 보내고자 하는 메세지
//SrcHandle:메세지를 보내는 폼의 핸들,Form1.Handle
procedure SendCopyData(FromFormName, ToFormName, Msg: string; SrcHandle: integer);
var
  h : THandle;
  fname:array[0..255] of char;
  pfName: PChar;
  cd : TCopyDataStruct;
  rec : TRecToPass;
begin
  if ToFormName = '' then
    exit;
  pfName := @fname[0];
  StrPCopy(pfName,ToFormName);
  h := FindWindow(nil, pfName);
  if h <> 0 then
  begin
    with rec, cd do
    begin
      StrPCopy(StrMsg,Msg);
      StrPCopy(StrSrcFormName,FromFormName);
      iHandle := SrcHandle;
      dwData := 3232;
      cbData := sizeof(rec);
      lpData := @rec;
    end;//with

    SendMessage(h, WM_COPYDATA, SrcHandle, LongInt(@cd));
  end;//if
end;

end.
