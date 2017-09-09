unit no_twice;

interface

uses  wintypes,SysUtils, Classes;

function DoIExist(lpszName,lpszClassName,lpszTitle: LPSTR):Bool;

implementation

// 세마포어 이름 = lpszName, 윈도우 이름 =  TApplication,윈도우 켑션=lpszTitle
//이미 실행 중이면 True를 반환한다.
//ex) DoIExist('hhwang_semaphore','TApplication',PChar(Application.Title))
function DoIExist(lpszName,lpszClassName,lpszTitle: LPSTR):Bool;
var
    hSem: THANDLE;
    hWndMy: HWND;
begin

    hSem := CreateSemaphore(nil, 0, 1, lpszName);
    // 보호속성 = NULL, 초기 카운트 = 0, 최대 카운트 = 1,
    // 세마포어 이름 = lpszName

    if (hSem <> 0) and (GetLastError() = ERROR_ALREADY_EXISTS) then
    begin
        // 이미 세마포어가  만들어져 있는 경우에 윈도우를 찾아서
        // 프로그램을 전환한다.

        CloseHandle(hSem);

        if lpszClassName = '' then
          lpszClassName := 'TApplication';

        hWndMy := FindWindow(lpszClassName, lpszTitle);
        if hWndMy <> 0 then
        begin
          BringWindowToTop(hWndMy);
          ShowWindow(hWndMy,SW_SHOWNORMAL);
        end;
            //SetForegroundWindow(hWndMy);
        DoIExist := TRUE;
        exit;
    end;
    // 첫번째로 세마포어를 만든 경우다.
    DoIExist :=  FALSE;
end;

end.
