unit u_dzCallbackThread;

{$INCLUDE 'jedi.inc'}

interface

uses
  SysUtils,
  Classes,
  u_dzNamedThread;

type
  ///<summary>
  /// A thread that calls the given callback method, catches exceptions and allows to check
  /// whether it has finished. </summary>
  TdzCallbackThread = class(TNamedThread)
  private
    FCallback: TNotifyEvent;
    FExceptionClass: TClass;
    FErrorMessage: string;
    FHasFinished: Boolean;
  protected
    ///<summary>
    /// Calls inherited to set the thread name and then the callback method given in
    /// the constructor. Any Exceptions are caught and their  Message stored in ErrorMessage.
    /// After the callback has finished the HasFinished property is set to true. </summary>
    procedure Execute; override;
  public
    ///<summary>
    /// @param CreateSuspended (see TThread.Create)
    /// @param Callback is TNotifyEvent that will be executed inside the thread
    /// @param Name is the name to set for this thread for the debugger to display </summary>
    constructor Create(_CreateSuspended: boolean; _Callback: TNotifyEvent; const _Name: string);
    ///<summary>
    /// Is true, when the thread has finished executing </summary>
    property HasFinished: Boolean read FHasFinished;
    ///<summary>
    /// If an unhandled exception occurred in the callback, its message is stored in ErrorMessage.
    /// Only valid after the thread has finished executing (that is HasFinished = true) </summary>
    property ErrorMessage: string read FErrorMessage;
	///<summary>
	/// Class of exception whose message was stored in ErrorMessage </summary>
    property ExceptionClass: TClass read FExceptionClass;
  end;

implementation

{ TdzCallbackThread }

constructor TdzCallbackThread.Create(_CreateSuspended: boolean; _Callback: TNotifyEvent; const _Name: string);
begin
  Assert(Assigned(_Callback), 'Callback must be assigned');
  FCallback := _Callback;
  inherited Create(_CreateSuspended, _Name);
end;

procedure TdzCallbackThread.Execute;
begin
  try
    try
      inherited;
      FCallback(Self);
    except
      on e: Exception do begin
        FExceptionClass := e.ClassType;
        FErrorMessage := e.Message;
        UniqueString(FErrorMessage);
      end;
    end;
  finally
    FHasFinished := True;
  end;
end;

end.

