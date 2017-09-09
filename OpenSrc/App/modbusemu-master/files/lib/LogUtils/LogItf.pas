unit LogItf;

{$mode objfpc}{$H+}

interface

uses LogConst, LogTypes;

type
  TLogProc = procedure (const EventTime : TDateTime; const msgType:  TMsgType;
                      const msgLine1: String = ''; const msgLine2: String = '';
                      const msgLine3: String = '') of object;

  ILog = interface
  ['{0F576A83-AF46-45F3-8216-B29CB9E15475}']
   function  Write (const msgType:  TMsgType; const msgCode:  Cardinal; const msgLine1: String = '';
                    const msgLine2: String = ''; const msgLine3: String = ''): Integer;
  end;

  // интерфейс внешнего объекта для отображения лога
  ILogForm = interface
  ['{001FB79F-A69F-42F1-A26D-7B9FA5460FF2}']
   procedure LogEvent(const EventTime : TDateTime; const msgType:  TMsgType;
                      const msgLine1: String = ''; const msgLine2: String = '';
                      const msgLine3: String = '');
  end;

implementation

end.
