unit RunOne;
(* 주의사항
 .dpr 파일의 uses절에 RunOne을 제일 먼저(이게 중요함) 선언한 후
 아래 변수를 적당한 값을 주어야 함.
  Author = 'Silhwan Hyun';  // 저자명 : 실행여부를 검사하기 위한 검색어를 구성함.
  RunProgram = 'TClock';    // 프로그램명 :             "

*)
interface

uses WinTypes, SysUtils, Forms;

function DoIExist2: Bool;

var
  Author: string = 'HiTEMS_Start';      // 저자명 : 실행여부를 검사하기 위한 검색어를 구성함.
  RunProgram: string = 'HiTEMS_Start'; // 프로그램명 :             "

implementation

var
  AtomText: array[0..63] of Char;
  AtomSaved : boolean = false;

  MyClassName    : array[0..255] of Char;
  FoundPrevInst  : boolean = false;
  PrevInstHandle : HWnd = 0;
  FoundAtom      : TAtom;

  NewAtom : TAtom;
  MyPopup : HWnd;

function LookAtAllWindows(Handle: HWnd; Temp: Longint): BOOL; stdcall;
var
  ClassName : array[0..255] of Char;
begin
  LookAtAllWindows := true;

  if GetClassName(Handle, ClassName, SizeOf(ClassName)) > 0 then
  begin
    if StrComp(ClassName, MyClassName) = 0 then // 동일 window class ?
    begin
    // 중복실행여부를 조사하기 위한 검색어 생성
       StrPCopy(AtomText, Author + RunProgram + IntToStr(Handle));
    // 검색어가 Global Atom Table에 등록되어 있는지 확인
       FoundAtom := GlobalFindAtom(AtomText);
       if FoundAtom <> 0 then  // Global Atom Table에 등록되어 있으면
       begin
          FoundPrevInst  := true;    // 이미 실행 중인 것으로 표시
          PrevInstHandle := Handle;  // 실행 중인 어플리케이션 윈도우 핸들
          LookAtAllWindows := false; // enumeration 함수를 종료시킨다
       end;
    end;

  end;
end;

function DoIExist2: Bool;
begin
 // 프로그램의 클래스명을 알아낸다.
  GetClassName(Application.Handle, MyClassName, SizeOf(MyClassName));
 // 윈도우를 검색하여 중복실행이 아닌지 확인한다
  EnumWindows(@LookAtAllWindows, 0);
  if FoundPrevInst then   // 이미 실행 중이면
  begin
    Result := True;
     MyPopup := GetLastActivePopup(PrevInstHandle);
     BringWindowToTop(PrevInstHandle);
     if IsIconic(MyPopup) then
     begin
        ShowWindow(MyPopup, SW_RESTORE);  // 최소화 상태이면 원래 크기로
     end else
        BringWindowToTop(MyPopup);        // 최상위 윈도우로

     SetForegroundWindow(MyPopup);

     Halt(0);  // 새로 실행한 프로그램은 강제로 종료시킨다
  end else
  begin
    Result := False;
   // 실행중이 아니면 검색어를 Global Atom Table에 등록한다
     StrPCopy(AtomText, Author + RunProgram + IntToStr(Application.Handle));
     NewAtom := GlobalAddAtom(AtomText);
     if NewAtom <> 0 then   // Global Atom Table에 등록성공이면
        AtomSaved := true;
  end;
end;

initialization
  DoIExist2;
  
finalization
  // 프로그램 종료시는 Global Atom Table에 등록해 둔 검색어를 해제한다.
  if AtomSaved then
  begin
     FoundAtom := GlobalFindAtom(AtomText);
     if FoundAtom <> 0 then
        GlobalDeleteAtom(FoundAtom);
  end;

end.
 