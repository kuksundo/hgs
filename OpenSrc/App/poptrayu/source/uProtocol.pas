unit uProtocol;

interface

uses
  System.Generics.Collections, IdMailBox, IdMessage, System.Classes, IdLogFile;

type
  TAuthType = (autoAuth = 0, password = 1, apop = 2, sasl = 3);
  TsslVer = (sslAuto = 0, sslv2 = 1, sslv3 = 2, tlsv1 = 3, tlsv11 = 4, tlsv12 = 5 );
  TPluginWorkEvent = procedure(const AWorkCount: Integer) of object;
  TProtocolType = (protPOP3 = 0, protIMAP4 = 1, protOTHER = 2);

type

  TProtocol = class(TObject)
  public
    class var sslLoaded : boolean;
    class var sslInitDone : boolean;
    class var sslVersionString : string;
    Name : string;
    //ProtocolType : TProtocolType;
    OnWork : TPluginWorkEvent;
    class procedure InitOpenSSL();
    procedure Connect(Server : String; Port : integer; UserName,Password : String; TimeOut : integer); virtual; abstract;
    procedure Disconnect; virtual; abstract;
    procedure DisconnectWithQuit; virtual; abstract;
    function Connected : boolean;  virtual; abstract;
    function RetrieveHeader(const MsgNum : integer; var pHeader : PChar) : boolean; virtual; abstract;
    function RetrieveRaw(const MsgNum : integer; var pRawMsg : PChar) : boolean; virtual; abstract;
    function RetrieveTop(const MsgNum,LineCount: integer; var pDest: PChar) : boolean; virtual; abstract;
    function RetrieveMsgSize(const MsgNum : integer) : integer; virtual;  abstract;

    // maxUIDs may not be supported by all prototcols.  -1 means "no limit".
    function UIDL(var UIDLs : TStringList; const MsgNum : integer = -1; const maxUIDs : integer = -1) : boolean; virtual; abstract;

    function Delete(const MsgNum : integer) : boolean; virtual; abstract;
    procedure SetOnWork(const OnWorkProc : TPluginWorkEvent); virtual; abstract;
    function LastErrorMsg : String; virtual; abstract;
    procedure SetSSLOptions(const useSSLorTLS : boolean; const authType: TAuthType = password;
      const sslVersion : TsslVer = sslAuto; const startTLS : boolean = false); virtual; abstract;
    function SupportsSSL(): boolean; virtual; abstract; //Should return true if SSL plugin is installed correctly.
    function SupportsAPOP(): boolean; virtual; abstract;
    function SupportsSASL(): boolean; virtual; abstract;
    function SupportsUIDL(): boolean; virtual; abstract;
    function CountMessages(): LongInt; virtual; abstract;
    function MakeRead(const uid : string; isRead : boolean): boolean; virtual; abstract;

    //TODO: this should be eliminated if we can weed out enough of the no longer needed PChar's
    procedure FreePChar(var p : PChar);
    procedure EnableLogging(LogFilePath: String; LogFileName : String);
  protected
    procedure SetLogger(LogFile : TIdLogFile); virtual; abstract;
  private
    class constructor Create;
  end;

////////////////////////////////////////////////////////////////////////////////
///                                                                          ///
///                      Begin Implementation Section                        ///
///                                                                          ///
////////////////////////////////////////////////////////////////////////////////
implementation


uses
  SysUtils, Windows, IdSSLOpenSSL, uGlobal, Vcl.Dialogs;

class constructor TProtocol.Create;
begin
  sslLoaded := false;
  sslInitDone := false;
  sslVersionString := '';
end;

class procedure TProtocol.InitOpenSSL();
type
  PLandCodepage = ^TLandCodepage;
  TLandCodepage = record
    wLanguage,
    wCodePage: word;
  end;
var
  DLL1, DLL2 : THandle;

  // for DLL version
  dummy, len: cardinal;
  buf, pntr: pointer;
  lang : string;
begin
  if not sslInitDone then begin
    DLL1 := LoadLibrary('libeay32.dll');
    if DLL1 = 0 then begin
      //MessageDlg('OpenSSL library libeay32.dll Not Found. SSL/TLS will be unavailable.', mtError, [mbOK], 0);
      sslLoaded := false;
    end
    else begin
      DLL2 := LoadLibrary('ssleay32.dll');
      if DLL2 = 0 then begin
        //MessageDlg('OpenSSL library ssleay32.dll Not Found. SSL/TLS will be unavailable.', mtError, [mbOK], 0);
        sslLoaded := false;
      end else begin
        sslLoaded := true;
        try
            len := GetFileVersionInfoSize(PChar('libeay32.dll'), dummy);
            if len = 0 then
              RaiseLastOSError;
            GetMem(buf, len);
            try
              if GetFileVersionInfo(PChar('libeay32.dll'), 0, len, buf) then begin
                //lang := Format('%.4x%.4x', [PLandCodepage(pntr)^.wLanguage, PLandCodepage(pntr)^.wCodePage]);
                if VerQueryValue(buf, PChar('\StringFileInfo\040904b0\FileVersion'), pntr, len){ and (@len <> nil)} then
                  sslVersionString := PChar(pntr)
                else sslVersionString := '???';
              end;
            finally
              FreeMem(buf);
            end;
        except
           sslVersionString := '???';
        end;
      end;
    end;
    sslInitDone := true;
    if not sslLoaded then
      sslVersionString := 'not loaded';
  end;
end;


procedure TProtocol.FreePChar(var p : PChar);
begin
  StrDispose(p);
  p := nil;
end;

// LogFileName should be the filename for this protocol's log, not including the directory.
procedure TProtocol.EnableLogging(LogFilePath : String; LogFileName : String);
var
  DebugLogger : TIdLogFile;
begin
  if (DebugOptions.ProtocolLogging) then
  begin
    try
      if not DirectoryExists(LogFilePath) then
        CreateDir(LogFilePath);

      if DirectoryExists(LogFilePath) then begin
        DebugLogger := TIdLogFile.Create(Nil);
        DebugLogger.Filename:= LogFilePath + LogFileName;
        DebugLogger.Active:= True;
        self.SetLogger(DebugLogger);
      end;
    except
      on E : Exception do begin
        ShowMessage('Error creating protocol logging file: ' + #13#10+
          LogFilePath + LogFileName + #13#10 +
          'Error Type: '+ E.ClassName + #13#10 +
          'Error Details: ' + E.Message); //TODO: internationalize.
      end;
    end;
  end;
end;

end.
