unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Calculator, StdCtrls, ExtCtrls, Contnrs;

type
  TMain = class(TForm)
    bCalculate: TButton;
    leInput: TLabeledEdit;
    Memo: TMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bCalculateClick(Sender: TObject);
  private
    FCalculator: TCalculator;
    FTickCount: Longword;
    FExpressionList: TStrings;
    FThreadList: TObjectList;
  public
    property Calculator: TCalculator read FCalculator write FCalculator;
    property ThreadList: TObjectList read FThreadList write FThreadList;
    property ExpressionList: TStrings read FExpressionList write FExpressionList;
    property TickCount: Longword read FTickCount write FTickCount;
  end;

  TParseThread = class(Classes.TThread)
  private
    FToIndex: Integer;
    FFromIndex: Integer;
  protected
    procedure Execute; override;
  public
    property FromIndex: Integer read FFromIndex write FFromIndex;
    property ToIndex: Integer read FToIndex write FToIndex;
  end;

var
  Main: TMain;
  Lock: TRTLCriticalSection;

implementation

uses
  ValueUtils;

{$R *.dfm}

{ TParseThread }

procedure TParseThread.Execute;
var
  I: Integer;
  Expression, Result: string;
begin
  inherited;
  I := FFromIndex;
  while not Terminated and Assigned(Main) and (I <= FToIndex) do
  begin
    Expression := Main.FExpressionList[I];

    {
      The following methods of TCalculator do not require synchronization:
        - AsValue
        - AsByte
        - AsShortint
        - AsWord
        - AsSmallint
        - AsLongword
        - AsInteger
        - AsInt64
        - AsSingle
        - AsDouble
        - AsExtended
        - AsBoolean
        - AsPointer
        - AsString
      All other methods require synchronization when being used within the thread.
    }

    Result := Main.FCalculator.AsString(Expression);

    // Write Result to the Main.ExpressionList:
    EnterCriticalSection(Lock);
    try
      Main.FExpressionList[I] := Expression + ' = ' + Result;
    finally
      LeaveCriticalSection(Lock);
    end;

    Inc(I);
  end;
end;

{ TMain }

procedure TMain.bCalculateClick(Sender: TObject);
var
  I: Integer;
  Thread: TParseThread;
begin
  // Disable the button:
  bCalculate.Enabled := False;
  try
    // Free all user-defined threads:
    FThreadList.Clear;

    // Empty ExpressionList, containing previously added expressions to calculate:
    FExpressionList.Clear;

    // Clear the memo:

    Memo.Clear;

    // Prepare the internal Parser for calculations (this is not really necessary -
    // Prepare method is called automatically, but this time it is called manually
    // beforehand to reach the maximum time measurement accuracy:

    FCalculator.Parser.Prepare;

    // Add expressions to calculate to the ExpressionList:

    for I := 0 to 5000 - 1 do
      ExpressionList.Add(leInput.Text + ' + ' + IntToStr(I));

    // Here we create and setup a user-defined Threads:

    // Thread 1:
    Thread := TParseThread.Create(True);
    FThreadList.Add(Thread);
    // Set a range of expressions in ExpressionList which thread will calculate:
    Thread.FromIndex := 0;
    Thread.ToIndex := 999;

    // Thread 2:
    Thread := TParseThread.Create(True);
    FThreadList.Add(Thread);
    Thread.FromIndex := 1000;
    Thread.ToIndex := 1999;
    // Thread 3:
    Thread := TParseThread.Create(True);
    FThreadList.Add(Thread);
    Thread.FromIndex := 2000;
    Thread.ToIndex := 2999;
    // Thread 4:
    Thread := TParseThread.Create(True);
    FThreadList.Add(Thread);
    Thread.FromIndex := 3000;
    Thread.ToIndex := 3999;
    // Thread 5:
    Thread := TParseThread.Create(True);
    FThreadList.Add(Thread);
    Thread.FromIndex := 4000;
    Thread.ToIndex := 4999;

    // All five threads are ready to calculate the ExpressionList. Now we just
    // need to run them:

    // Show message before run:
    ShowMessage('Starting...');

    // Obtain the start time:
    FTickCount := GetTickCount;

    // Here we start all the threads:
    for I := 0 to FThreadList.Count - 1 do
      TParseThread(FThreadList[I]).Resume;

    // Wait until all threads are done:
    for I := 0 to FThreadList.Count - 1 do
      TParseThread(FThreadList[I]).WaitFor;

    // Obtain the calculation time:
    FTickCount := GetTickCount - FTickCount;

    // Show the calculation time:
    Caption := Format('Calculation time: %d sec %d msec', [Trunc(FTickCount / 1000),
      FTickCount - Trunc(FTickCount / 1000) * 1000]);

    // Show the expressions and its results in Memo:
    Memo.Lines.BeginUpdate;
    try
      for I := 0 to FExpressionList.Count - 1 do
        Memo.Lines.Add( Format('%d) %s', [I + 1, FExpressionList[I]] ) );
    finally
      Memo.Lines.EndUpdate;
    end;
  finally
    // Enable the button:
    bCalculate.Enabled := True;
  end;
end;

procedure TMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Main := nil;
end;

procedure TMain.FormCreate(Sender: TObject);
begin
  FCalculator := TCalculator.Create(Self);
  FThreadList := TObjectList.Create;
  FExpressionList := TStringList.Create;
end;

procedure TMain.FormDestroy(Sender: TObject);
begin
  FThreadList.Free;
  FExpressionList.Free;
end;

initialization
  InitializeCriticalSection(Lock);

finalization
  DeleteCriticalSection(Lock);

end.
