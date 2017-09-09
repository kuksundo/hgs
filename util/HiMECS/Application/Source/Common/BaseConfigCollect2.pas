unit BaseConfigCollect2;

interface

uses AsyncCalls, AsyncCallsHelper, classes, SysUtils, Forms, XmlDoc, XmlSerial;

type
  TpjhBase2 = class(TPersistent)
  public
    function LoadFromFile<T>(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False): T;
    function SaveToFile<T>(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer;
    procedure LoadFromFile_Thread(AApplication: TApplication; AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False);
    procedure SaveToFile_Thread(AApplication: TApplication; AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False);
  end;

implementation

uses JvgXMLSerializer_Encrypt;

function TpjhBase2.LoadFromFile<T>(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False): T;
var
  lSerialize : TXmlSerializer<T>;
  lOwner : TComponent;
  lDoc   : TxmlDocument;
begin
  lOwner := TComponent.Create(nil);  // Required to make TXmlDocument work!
  try
    lDoc := TXmlDocument.Create(lOwner);  // will be freed with lOwner.Free
    lDoc.LoadFromFile(AFileName);
    lSerialize := TXmlSerializer<T>.Create;
    try
      result := lSerialize.Deserialize(lDoc);
    finally
      lSerialize.Free;
    end;
  finally
    lOwner.Free;
  end;
end;

procedure TpjhBase2.LoadFromFile_Thread(AApplication: TApplication; AFileName, APassPhrase: string;
  AIsEncrypt: Boolean);
begin
{  AsyncHelper.MaxThreads := 2 * System.CPUCount;
  AsyncHelper.AddTask(TAsyncCalls.Invoke<string, string, Boolean>(LoadFromFile, AFileName, APassPhrase, AIsEncrypt));
  while NOT AsyncHelper.AllFinished do AApplication.ProcessMessages;
  }
end;

function TpjhBase2.SaveToFile<T>(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer;
var
  lSerialize : TXmlSerializer<T>;
  lOwner : TComponent;
  lDoc   : TxmlDocument;
begin
  lOwner := TComponent.Create(nil);  // Required to make TXmlDocument work!
  try
    lDoc := TXmlDocument.Create(lOwner);  // will be freed with lOwner.Free
    lSerialize := TXmlSerializer<T>.Create;
    try
      lSerialize.Serialize(lDoc, Self);
      lDoc.SaveToFile(AFileName);
    finally
      lSerialize.Free;
    end;
  finally
    lOwner.Free;
  end;
end;

procedure TpjhBase2.SaveToFile_Thread(AApplication: TApplication; AFileName,
  APassPhrase: string; AIsEncrypt: Boolean);
begin
{  AsyncHelper.MaxThreads := 2 * System.CPUCount;
  AsyncHelper.AddTask(TAsyncCalls.Invoke<string, string, Boolean>(SaveToFile, AFileName, APassPhrase, AIsEncrypt));
  while NOT AsyncHelper.AllFinished do AApplication.ProcessMessages;
  }
end;

end.
