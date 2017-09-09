unit pjhXMLSerializer;
{
  1. 2012.1.12
  Generic XML Serializer를 이용한  Collect 생성
}
interface

uses
 XmlDoc,
 Classes,
 XmlSerial;

type
  TpjhXmlSerializer<T:class> = class(TXmlSerializer<T>)
  public
    function LoadFromFile(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False): T;
    function SaveToFile(AFileName: string; APassPhrase: string=''; AIsEncrypt: Boolean=False): integer;
  end;

implementation

{ TpjhBase2<T> }

function TpjhXmlSerializer<T>.LoadFromFile(AFileName, APassPhrase: string;
  AIsEncrypt: Boolean): T;
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

function TpjhXmlSerializer<T>.SaveToFile(AFileName, APassPhrase: string;
  AIsEncrypt: Boolean): integer;
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
      lSerialize.Serialize(lDoc,Self);
      lDoc.SaveToFile(AFileName);
    finally
      lSerialize.Free;
    end;
  finally
    lOwner.Free;
  end;
end;

end.
