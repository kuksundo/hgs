unit uProcessFiles;

interface

uses SysUtils, Classes;

type
  TFileEvent = procedure (FileName : String) of Object;

  TProcessFilesToConvert = class(TObject)
  private
    FFilesToProcess: TStrings;
    FOnProcessingFile: TFileEvent;
    procedure SetFilesToProcess(const Value: TStrings);
    procedure ProcessFile(aFileName : String);
  protected
  public
    Constructor Create;
    Destructor Destroy; override;
    procedure ProcessFiles;
    property FilesToProcess : TStrings read FFilesToProcess write SetFilesToProcess;
    property OnProcessingFile : TFileEvent read FOnProcessingFile write FOnProcessingFile;
end;


implementation
uses uFileProcess;

{ TProcessFilesToConvert }

constructor TProcessFilesToConvert.Create;
begin
  FFilesToProcess := TStringList.Create;
end;

destructor TProcessFilesToConvert.Destroy;
begin
  FreeAndNil(FFilesToProcess);
  inherited;
end;

procedure TProcessFilesToConvert.ProcessFile(aFileName: String);
var
 P : TFileProcessor;
begin
 P := TFileProcessor.create;
 try
   p.ProcessFile(aFileName);
 finally
   p.Free;
 end;
end;

procedure TProcessFilesToConvert.ProcessFiles;
var
 FN : String;
begin
 for FN in FFilesToProcess do
 begin
   if Assigned(FOnProcessingFile) then
      FOnProcessingFile(FN);
   ProcessFile(FN);
 end;

end;

procedure TProcessFilesToConvert.SetFilesToProcess(const Value: TStrings);
begin
  FFilesToProcess.Assign(Value);
end;



end.
