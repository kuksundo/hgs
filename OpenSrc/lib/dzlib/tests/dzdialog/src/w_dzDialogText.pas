unit w_dzDialogText;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls;

type
  Tf_dzDialogTest = class(TForm)
    b_ShowException1: TButton;
    b_ShowException2: TButton;
    b_ShowException3: TButton;
    b_ShowMessage1: TButton;
    b_ShowMessage2: TButton;
    procedure b_ShowException1Click(Sender: TObject);
    procedure b_ShowException2Click(Sender: TObject);
    procedure b_ShowException3Click(Sender: TObject);
    procedure b_ShowMessage1Click(Sender: TObject);
    procedure b_ShowMessage2Click(Sender: TObject);
  private
  public
  end;

var
  f_dzDialogTest: Tf_dzDialogTest;

implementation

{$R *.dfm}

uses
  JclDebug,
  w_dzDialog;

type
  ETestException = class(Exception)

  end;

procedure Tf_dzDialogTest.b_ShowException1Click(Sender: TObject);
begin
  try
    raise ETestException.Create('This is a test.');
  except
    on e: Exception do begin
      Tf_dzDialog.ShowException(e, Sender as TButton);
    end;
  end;
end;

procedure Tf_dzDialogTest.b_ShowException2Click(Sender: TObject);
begin
  try
    raise ETestException.Create('This is a test.');
  except
    on e: Exception do begin
      Tf_dzDialog.ShowException(e, [dbeOK], '', Sender as TButton);
    end;
  end;
end;

procedure Tf_dzDialogTest.b_ShowException3Click(Sender: TObject);
begin
  try
    raise ETestException.Create('This is a test.');
  except
    on e: Exception do begin
      case Tf_dzDialog.ShowException(e, 'a test exception occurred', [dbeAbort, dbeRetry, dbeIgnore], '', Sender as TButton) of
        mrAbort: Tf_dzDialog.ShowMessage(mtInformation, 'User clicked Abort', [dbeOK], Sender as TButton);
        mrRetry: Tf_dzDialog.ShowMessage(mtInformation, 'User clicked Retry', [dbeOK], Sender as TButton);
        mrIgnore: Tf_dzDialog.ShowMessage(mtInformation, 'User clicked Ignore', [dbeOK], Sender as TButton);
      end;
    end;
  end;
end;

procedure Tf_dzDialogTest.b_ShowMessage1Click(Sender: TObject);
begin
  Tf_dzDialog.ShowMessage(mtInformation, 'Show Message 1', [dbeOK], Sender as TButton);
end;

procedure Tf_dzDialogTest.b_ShowMessage2Click(Sender: TObject);
begin
  Tf_dzDialog.ShowMessage(mtInformation, 'Show Message 1', [dbeOK, dbeCancel, dbeCustom, dbeCustom],
    ['Custom1', 'Custom2'], [-1, -2], Sender as TButton, 'Custom1: bla'#13#10'Custom2: blub');
end;

initialization
  JclStartExceptionTracking;
end.

