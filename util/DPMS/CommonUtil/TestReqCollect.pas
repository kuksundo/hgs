unit TestReqCollect;

interface

uses classes, SysUtils, ExtCtrls, Vcl.Graphics, DateUtils, dbxjson;

type
  TFileLoaction = (flDB, flDisk);
  TFileAction = (faInsert, faUpdate, faDelete);

  TTestPartCollect = class;
  TTestPartItem = class;
  TTestPartSerialCollect = class;
  TTestPartSerialItem = class;
  TTestPartSerialFileCollect = class;
  TTestPartSerialFileItem = class;

  TTestReqList = class(TObject)
  private
    FTestPartCollect: TTestPartCollect;
    FTestPartSerialCollect: TTestPartSerialCollect;
    FTestPartSerialFileCollect: TTestPartSerialFileCollect;

    FReq_No,
    FREQ_DEPT_NAME,
    FREQ_DEPT,
    FTEST_ENGINE,
    FENGTYPE,
    FLOC_CODE_NAME,
    FLOC_CODE,
    FREQ_ID_NAME,
    FREQ_ID,
    FTEST_NAME,
    FTEST_PURPOSE,
    FTEST_METHOD: string;
    FTEST_BEGIN,
    FTEST_END: TDateTime;
    FIsFetchSerialFileFromDB: Boolean;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    procedure Assign(Source: TTestReqList);
    procedure Clear;

    procedure DeletePart(ARowNo: integer);
    procedure DeleteSerialFile(APartRowNo, ASerialFileRowno: integer);
    procedure AddSerialFile(APartRowNo, ASerialFileRowNo: integer;
        AFileName, AFilePath, AFileSize, AReqNo, APartNo, ASerialNo, AOwnerId: string);
    procedure GetSerialFileInfo(ARowNo: integer; var AReqNo, APartNo, ASerialNo: string); overload;
    procedure GetSerialFileInfo(AID: TDateTime; var AReqNo, APartNo, ASerialNo: string); overload;
    procedure GetSerialFiles(AReqNo, APartNo, ASerialNo: string; out AFiles: TJSONArray); overload;
    procedure GetSerialFiles(ARowNo: integer; out AFiles: TJSONArray); overload;
    function IsExistSerialFileFromList(AReqNo, APartNo, ASerialNo, AFileName: string): Boolean;

    function GetID(ARowNo: integer): TDateTime;
    function GetBankPos(ARowNo: integer): string;
    procedure SetBankPos(ARowNo: integer; ABank: string);
    function GetCylNo(ARowNo: integer): string;
    procedure SetCylNo(ARowNo: integer; ACylNo: string);
    function GetExh_Intake(ARowNo: integer): string;
    procedure SetExh_Intake(ARowNo: integer; ACycle: string);
    function GetSide(ARowNo: integer): string;
    procedure SetSide(ARowNo: integer; ASide: string);
    function GetSerialNo(ARowNo: integer): string;
    procedure SetSerialNo(ARowNo: integer; ASerial: string);
  published
    property TestPartCollect: TTestPartCollect read FTestPartCollect write FTestPartCollect;
    property TestPartSerialCollect: TTestPartSerialCollect read FTestPartSerialCollect write FTestPartSerialCollect;
    property TestPartSerialFileCollect: TTestPartSerialFileCollect read FTestPartSerialFileCollect write FTestPartSerialFileCollect;

    property Req_No: string read FReq_No write FReq_No;
    property REQ_DEPT_NAME: string read FREQ_DEPT_NAME write FREQ_DEPT_NAME;
    property REQ_DEPT: string read FREQ_DEPT write FREQ_DEPT;
    property TEST_ENGINE: string read FTEST_ENGINE write FTEST_ENGINE;
    property ENGTYPE: string read FENGTYPE write FENGTYPE;
    property LOC_CODE_NAME: string read FLOC_CODE_NAME write FLOC_CODE_NAME;
    property LOC_CODE: string read FLOC_CODE write FLOC_CODE;
    property REQ_ID_NAME: string read FREQ_ID_NAME write FREQ_ID_NAME;
    property REQ_ID: string read FREQ_ID write FREQ_ID;
    property TEST_NAME: string read FTEST_NAME write FTEST_NAME;
    property TEST_PURPOSE: string read FTEST_PURPOSE write FTEST_PURPOSE;
    property TEST_METHOD: string read FTEST_METHOD write FTEST_METHOD;
    property TEST_BEGIN: TDateTime read FTEST_BEGIN write FTEST_BEGIN;
    property TEST_END: TDateTime read FTEST_END write FTEST_END;
    property IsFetchSerialFileFromDB: Boolean read FIsFetchSerialFileFromDB write FIsFetchSerialFileFromDB;
  end;

  PTestPartItem = ^TTestPartItem;
  TTestPartItem = class(TCollectionItem)
  private
    FID: TDateTime;
    FFL: TFileLoaction;
    FFA: TFileAction;
    FRowNo: integer;
    FReq_No,
    FPART_NO,
    FSEQ_NO,
    FMS_NO,
    FPARTNAME,
    FMAKER,
    FPARTTYPE,
    FPARTSPEC,
    FSTATUS: string;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property ID: TDateTime read FID write FID;
    property FileLocation: TFileLoaction read FFL write FFL;
    property FileAction: TFileAction read FFA write FFA;
    property RowNo: integer read FRowNo write FRowNo;
    property Req_No: string read FReq_No write FReq_No;
    property PART_NO: string read FPART_NO write FPART_NO;
    property SEQ_NO: string read FSEQ_NO write FSEQ_NO;
    property MS_NO: string read FMS_NO write FMS_NO;
    property PARTNAME: string read FPARTNAME write FPARTNAME;
    property MAKER: string read FMAKER write FMAKER;
    property PARTTYPE: string read FPARTTYPE write FPARTTYPE;
    property PARTSPEC: string read FPARTSPEC write FPARTSPEC;
    property STATUS: string read FSTATUS write FSTATUS;
  end;

  TTestPartCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TTestPartItem;
    procedure SetItem(Index: Integer; const Value: TTestPartItem);
  public
    function  Add: TTestPartItem;
    function Insert(Index: Integer): TTestPartItem;
    property Items[Index: Integer]: TTestPartItem read GetItem  write SetItem; default;
  end;

  PTestPartSerialItem = ^TTestPartSerialItem;
  TTestPartSerialItem = class(TCollectionItem)
  private
    FID: TDateTime;
    FFL: TFileLoaction;
    FFA: TFileAction;
    FBANK,
    FCYL_NO,
    FEXH_INTAKE,
    FEXH_CAMSIDE,
    FSERIAL_NO: string;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property ID: TDateTime read FID write FID;
    property FileLocation: TFileLoaction read FFL write FFL;
    property FileAction: TFileAction read FFA write FFA;
    property BANK: string read FBANK write FBANK;
    property CYL_NO: string read FCYL_NO write FCYL_NO;
    property EXH_INTAKE: string read FEXH_INTAKE write FEXH_INTAKE;
    property EXH_CAMSIDE: string read FEXH_CAMSIDE write FEXH_CAMSIDE;
    property SERIAL_NO: string read FSERIAL_NO write FSERIAL_NO;
  end;

  TTestPartSerialCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TTestPartSerialItem;
    procedure SetItem(Index: Integer; const Value: TTestPartSerialItem);
  public
    function  Add: TTestPartSerialItem;
    function Insert(Index: Integer): TTestPartSerialItem;
    property Items[Index: Integer]: TTestPartSerialItem read GetItem  write SetItem; default;
  end;

  PTestPartSerialFileItem = ^TTestPartSerialFileItem;
  TTestPartSerialFileItem = class(TCollectionItem)
  private
    FRowNo: integer;//TestPartItem의 RowNo와는 다름.
    FID: TDateTime;
    FFL: TFileLoaction;
    FFA: TFileAction;
    FFileName,
    FFilePath,
    FReqNo,
    FPartNo,
    FSerialNo,
    FOwnerId: string;
    FFileSize: integer;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property ID: TDateTime read FID write FID;
    property FileLocation: TFileLoaction read FFL write FFL;
    property FileAction: TFileAction read FFA write FFA;
    property RowNo: integer read FRowNo write FRowNo;
    property ReqNo: string read FReqNo write FReqNo;
    property PartNo: string read FPartNo write FPartNo;
    property SerialNo: string read FSerialNo write FSerialNo;
    property OwnerId: string read FOwnerId write FOwnerId;
    property FileName: string read FFileName write FFileName;
    property FilePath: string read FFilePath write FFilePath;
    property FileSize: integer read FFileSize write FFileSize;
  end;

  TTestPartSerialFileCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TTestPartSerialFileItem;
    procedure SetItem(Index: Integer; const Value: TTestPartSerialFileItem);
  public
    function  Add: TTestPartSerialFileItem;
    function Insert(Index: Integer): TTestPartSerialFileItem;
    property Items[Index: Integer]: TTestPartSerialFileItem read GetItem  write SetItem; default;
  end;

implementation

procedure TTestReqList.AddSerialFile(APartRowNo, ASerialFileRowNo: integer;
  AFileName, AFilePath, AFileSize, AReqNo, APartNo, ASerialNo, AOwnerId: string);
var
  i,j,k: integer;
  LFileExist: Boolean;
begin
  for i := 0 to FTestPartCollect.Count - 1 do
  begin
    if FTestPartCollect.Items[i].RowNo = APartRowNo then
    begin
      LFileExist := False;

      for j := 0 to FTestPartSerialFileCollect.Count - 1 do
      begin
        if FTestPartCollect.Items[i].ID = FTestPartSerialFileCollect.Items[j].ID then
        begin
          if FTestPartSerialFileCollect.Items[j].RowNo = ASerialFileRowno then
          begin
            if FTestPartSerialFileCollect.Items[j].FileName = AFileName then
            begin
              LFileExist := True;
              break;
            end;
          end;
        end;
      end;

      if (AReqNo = '') or (APartNo = '') or (ASerialNo = '') then
      begin
        for k := 0 to FTestPartSerialCollect.Count - 1 do
        begin
          if FTestPartCollect.Items[i].ID = FTestPartSerialCollect.Items[k].ID then
          begin
            if AReqNo = '' then
              AReqNo := FTestPartCollect.Items[k].Req_No;

            if APartNo = '' then
              APartNo := FTestPartCollect.Items[k].PART_NO;

            if ASerialNo = '' then
              ASerialNo := FTestPartSerialCollect.Items[k].SERIAL_NO;
          end;
        end;
      end;

      if not LFileExist then
      begin
        with FTestPartSerialFileCollect.Add do
        begin
          ID := FTestPartCollect.Items[i].ID;
          RowNo := ASerialFileRowno;
          FileAction := faInsert;
          FileLocation := flDisk;
          FileName := AFileName;
          FilePath := AFilePath;
          FileSize := StrToIntDef(AFileSize,0);
          ReqNo := AReqNo;
          PartNo := APartNo;
          SerialNo := ASerialNo;
          OwnerId := AOwnerId;
        end;
      end;

      break;
    end;
  end;
end;

procedure TTestReqList.Assign(Source: TTestReqList);
var
  i: integer;
begin
  Clear;
  FTestPartCollect.Clear;
  FTestPartSerialCollect.Clear;
  FTestPartSerialFileCollect.Clear;

  IsFetchSerialFileFromDB := Source.IsFetchSerialFileFromDB;

  for i := 0 to Source.TestPartCollect.Count - 1 do
  begin
    FTestPartCollect.Add.Assign(Source.TestPartCollect.Items[i]);
  end;

  for i := 0 to Source.TestPartSerialCollect.Count - 1 do
  begin
    FTestPartSerialCollect.Add.Assign(Source.TestPartSerialCollect.Items[i]);
  end;

  for i := 0 to Source.TestPartSerialFileCollect.Count - 1 do
  begin
    FTestPartSerialFileCollect.Add.Assign(Source.TestPartSerialFileCollect.Items[i]);
  end;
end;

procedure TTestReqList.Clear;
begin
  FTestPartCollect.Clear;
  FTestPartSerialCollect.Clear;
  FTestPartSerialFileCollect.Clear;
end;

constructor TTestReqList.Create(AOwner: TComponent);
begin
  FTestPartCollect := TTestPartCollect.Create(TTestPartItem);
  FTestPartSerialCollect := TTestPartSerialCollect.Create(TTestPartSerialItem);
  FTestPartSerialFileCollect := TTestPartSerialFileCollect.Create(TTestPartSerialFileItem);
end;

//1개씩 삭제 할 것
procedure TTestReqList.DeletePart(ARowNo: integer);
var
  i,j: integer;
  LDeleted: Boolean;
begin
  LDeleted := False;

  for i := 0 to FTestPartCollect.Count - 1 do
  begin
    if FTestPartCollect.Items[i].RowNo = ARowNo then
    begin
      FTestPartCollect.Items[i].RowNo := -1;
      FTestPartCollect.Items[i].FFA := faDelete;
      LDeleted := True;

      for j := 0 to FTestPartSerialCollect.Count - 1 do
        if FTestPartCollect.Items[i].FID = FTestPartSerialCollect.Items[j].ID then
          FTestPartSerialCollect.Items[j].FFA := faDelete;

      for j := 0 to FTestPartSerialFileCollect.Count - 1 do
      begin
        if FTestPartCollect.Items[i].FID = FTestPartSerialFileCollect.Items[j].ID then
        begin
          FTestPartSerialFileCollect.Items[j].RowNo := -1;
          FTestPartSerialFileCollect.Items[j].FFA := faDelete;
        end;
      end;

      break;
    end;
  end;

  if LDeleted then
    for i := 0 to FTestPartCollect.Count - 1 do
      if FTestPartCollect.Items[i].RowNo > ARowNo then
        FTestPartCollect.Items[i].RowNo := FTestPartCollect.Items[i].RowNo - 1;
end;

//1개씩 삭제 할 것
procedure TTestReqList.DeleteSerialFile(APartRowNo, ASerialFileRowno: integer);
var
  i,j: integer;
  LDeleted: Boolean;
begin
  for i := 0 to FTestPartCollect.Count - 1 do
  begin
    if FTestPartCollect.Items[i].RowNo = APartRowNo then
    begin
      LDeleted := False;

      for j := 0 to FTestPartSerialFileCollect.Count - 1 do
      begin
        if FTestPartCollect.Items[i].FID = FTestPartSerialFileCollect.Items[j].ID then
        begin
          if FTestPartSerialFileCollect.Items[j].RowNo = ASerialFileRowno then
          begin
            FTestPartSerialFileCollect.Items[j].RowNo := -1;
            FTestPartSerialFileCollect.Items[j].FFA := faDelete;
            LDeleted := True;
            break;
          end;
        end;
      end;

      //1개씩 삭제해야 하는 이유: RowNo 변경이 1개씩 수행 됨.
      if LDeleted then
        for j := 0 to FTestPartSerialFileCollect.Count - 1 do
          if FTestPartCollect.Items[i].FID = FTestPartSerialFileCollect.Items[j].ID then
            if FTestPartSerialFileCollect.Items[j].RowNo > ASerialFileRowno then
              FTestPartSerialFileCollect.Items[j].RowNo := FTestPartSerialFileCollect.Items[j].RowNo - 1;

      break;
    end;
  end;
end;

destructor TTestReqList.Destroy;
begin
  inherited Destroy;
  FTestPartCollect.Free;
  FTestPartSerialCollect.Free;
  FTestPartSerialFileCollect.Free;
end;

function TTestReqList.GetBankPos(ARowNo: integer): string;
var
  i,j: integer;
begin
  Result := '';

  for i := 0 to FTestPartCollect.Count - 1 do
  begin
    if FTestPartCollect.Items[i].RowNo = ARowNo then
    begin
      for j := 0 to FTestPartSerialCollect.Count - 1 do
      begin
        if FTestPartCollect.Items[i].FID = FTestPartSerialCollect.Items[j].ID then
        begin
          Result := FTestPartSerialCollect.Items[j].BANK;
          break;
        end;
      end;

      break;
    end;
  end;
end;

function TTestReqList.GetExh_Intake(ARowNo: integer): string;
var
  i,j: integer;
begin
  Result := '';

  for i := 0 to FTestPartCollect.Count - 1 do
  begin
    if FTestPartCollect.Items[i].RowNo = ARowNo then
    begin
      for j := 0 to FTestPartSerialCollect.Count - 1 do
      begin
        if FTestPartCollect.Items[i].FID = FTestPartSerialCollect.Items[j].ID then
        begin
          Result := FTestPartSerialCollect.Items[j].FEXH_INTAKE;
          break;
        end;
      end;

      break;
    end;
  end;
end;

function TTestReqList.GetID(ARowNo: integer): TDateTime;
var
  i,j: integer;
begin
  Result := 0;

  for i := 0 to FTestPartCollect.Count - 1 do
  begin
    if FTestPartCollect.Items[i].RowNo = ARowNo then
    begin
      Result := FTestPartCollect.Items[i].FID;
      break;
    end;
  end;
end;

function TTestReqList.GetCylNo(ARowNo: integer): string;
var
  i,j: integer;
begin
  Result := '';

  for i := 0 to FTestPartCollect.Count - 1 do
  begin
    if FTestPartCollect.Items[i].RowNo = ARowNo then
    begin
      for j := 0 to FTestPartSerialCollect.Count - 1 do
      begin
        if FTestPartCollect.Items[i].FID = FTestPartSerialCollect.Items[j].ID then
        begin
          Result := FTestPartSerialCollect.Items[j].CYL_NO;
          break;
        end;
      end;

      break;
    end;
  end;
end;

procedure TTestReqList.GetSerialFileInfo(ARowNo: integer; var AReqNo, APartNo,
  ASerialNo: string);
var
  i,j: integer;
begin
  for i := 0 to FTestPartCollect.Count - 1 do
  begin
    if FTestPartCollect.Items[i].RowNo = ARowNo then
    begin
      AReqNo := FTestPartCollect.Items[i].Req_No;
      APartNo := FTestPartCollect.Items[i].PART_NO;

      for j := 0 to FTestPartSerialCollect.Count - 1 do
      begin
        if FTestPartCollect.Items[i].FID = FTestPartSerialCollect.Items[j].ID then
        begin
          ASerialNo := FTestPartSerialCollect.Items[j].SERIAL_NO;
          break;
        end;
      end;

      break;
    end;
  end;
end;

procedure TTestReqList.GetSerialFileInfo(AID: TDateTime; var AReqNo, APartNo,
  ASerialNo: string);
var
  i,j: integer;
begin
  for i := 0 to FTestPartCollect.Count - 1 do
  begin
    if FTestPartCollect.Items[i].ID = AID then
    begin
      AReqNo := FTestPartCollect.Items[i].Req_No;
      APartNo := FTestPartCollect.Items[i].PART_NO;

      for j := 0 to FTestPartSerialCollect.Count - 1 do
      begin
        if FTestPartCollect.Items[i].ID = FTestPartSerialCollect.Items[j].ID then
        begin
          ASerialNo := FTestPartSerialCollect.Items[j].SERIAL_NO;
          break;
        end;
      end;

      break;
    end;
  end;
end;

procedure TTestReqList.GetSerialFiles(ARowNo: integer; out AFiles: TJSONArray);
var
  i,j: integer;
  Ljo: TJSONObject;
begin
  for i := 0 to FTestPartCollect.Count - 1 do
  begin
    if FTestPartCollect.Items[i].RowNo = ARowNo then
    begin
      for j := 0 to FTestPartSerialFileCollect.Count - 1 do
      begin
        //삭제된 파일은 RowNo가 -1 임
        if FTestPartSerialFileCollect.Items[j].RowNo = -1 then
          continue;

        if FTestPartCollect.Items[i].FID = FTestPartSerialFileCollect.Items[j].ID then
        begin
          try
            Ljo := TJSONObject.Create;
            Ljo.AddPair(TJSONPair.Create('ReqNo', FTestPartSerialFileCollect.Items[j].ReqNo));
            Ljo.AddPair(TJSONPair.Create('PartNo', FTestPartSerialFileCollect.Items[j].PartNo));
            Ljo.AddPair(TJSONPair.Create('SerialNo', FTestPartSerialFileCollect.Items[j].SerialNo));
            Ljo.AddPair(TJSONPair.Create('FileName', FTestPartSerialFileCollect.Items[j].FileName));
            Ljo.AddPair(TJSONPair.Create('FileSize', IntToStr(FTestPartSerialFileCollect.Items[j].FileSize)));
            Ljo.AddPair(TJSONPair.Create('FilePath', FTestPartSerialFileCollect.Items[j].FilePath));
            AFiles.AddElement(Ljo);
          finally
            //Ljo.Free;
          end;
        end;
      end;

      break;
    end;
  end;
end;

procedure TTestReqList.GetSerialFiles(AReqNo, APartNo,
  ASerialNo: string; out AFiles: TJSONArray);
var
  i: integer;
  Ljo: TJSONObject;
begin
  for i := 0 to FTestPartSerialFileCollect.Count - 1 do
  begin

    if (FTestPartSerialFileCollect.Items[i].ReqNo = AReqNo) and
       (FTestPartSerialFileCollect.Items[i].PartNo = APartNo) and
        (FTestPartSerialFileCollect.Items[i].SerialNo = ASerialNo) then
    begin
      try
        Ljo := TJSONObject.Create;
        Ljo.AddPair(TJSONPair.Create('FileName:', FTestPartSerialFileCollect.Items[i].FileName));
        Ljo.AddPair(TJSONPair.Create('FileSize:', IntToStr(FTestPartSerialFileCollect.Items[i].FileSize)));
        Ljo.AddPair(TJSONPair.Create('FilePath:', FTestPartSerialFileCollect.Items[i].FilePath));
        AFiles.AddElement(Ljo);
      finally
        Ljo.Free;
      end;
    end;
  end;
end;

function TTestReqList.GetSerialNo(ARowNo: integer): string;
var
  i,j: integer;
begin
  Result := '';

  for i := 0 to FTestPartCollect.Count - 1 do
  begin
    if FTestPartCollect.Items[i].RowNo = ARowNo then
    begin
      for j := 0 to FTestPartSerialCollect.Count - 1 do
      begin
        if FTestPartCollect.Items[i].FID = FTestPartSerialCollect.Items[j].ID then
        begin
          Result := FTestPartSerialCollect.Items[j].FSERIAL_NO;
          break;
        end;
      end;

      break;
    end;
  end;
end;

function TTestReqList.GetSide(ARowNo: integer): string;
var
  i,j: integer;
begin
  Result := '';

  for i := 0 to FTestPartCollect.Count - 1 do
  begin
    if FTestPartCollect.Items[i].RowNo = ARowNo then
    begin
      for j := 0 to FTestPartSerialCollect.Count - 1 do
      begin
        if FTestPartCollect.Items[i].FID = FTestPartSerialCollect.Items[j].ID then
        begin
          Result := FTestPartSerialCollect.Items[j].FEXH_CAMSIDE;
          break;
        end;
      end;

      break;
    end;
  end;
end;

function TTestReqList.IsExistSerialFileFromList(AReqNo, APartNo, ASerialNo,
  AFileName: string): Boolean;
var
  i: integer;
begin
  Result := False;

  for i := 0 to FTestPartSerialFileCollect.Count - 1 do
  begin
    if (FTestPartSerialFileCollect.Items[i].ReqNo = AReqNo) and
       (FTestPartSerialFileCollect.Items[i].PartNo = APartNo) and
       (FTestPartSerialFileCollect.Items[i].SerialNo = ASerialNo) and
       (FTestPartSerialFileCollect.Items[i].FileName = AFileName) then
    begin
      Result := True;
      Break;
    end;
  end;
end;

procedure TTestReqList.SetBankPos(ARowNo: integer; ABank: string);
var
  i,j: integer;
begin
  for i := 0 to FTestPartCollect.Count - 1 do
  begin
    if FTestPartCollect.Items[i].RowNo = ARowNo then
    begin
      for j := 0 to FTestPartSerialCollect.Count - 1 do
      begin
        if FTestPartCollect.Items[i].FID = FTestPartSerialCollect.Items[j].ID then
        begin
          FTestPartSerialCollect.Items[j].BANK := ABank;
          break;
        end;
      end;

      break;
    end;
  end;
end;

procedure TTestReqList.SetExh_Intake(ARowNo: integer; ACycle: string);
var
  i,j: integer;
begin
  for i := 0 to FTestPartCollect.Count - 1 do
  begin
    if FTestPartCollect.Items[i].RowNo = ARowNo then
    begin
      for j := 0 to FTestPartSerialCollect.Count - 1 do
      begin
        if FTestPartCollect.Items[i].FID = FTestPartSerialCollect.Items[j].ID then
        begin
          FTestPartSerialCollect.Items[j].FEXH_INTAKE := ACycle;
          break;
        end;
      end;

      break;
    end;
  end;
end;

procedure TTestReqList.SetSerialNo(ARowNo: integer; ASerial: string);
var
  i,j: integer;
begin
  for i := 0 to FTestPartCollect.Count - 1 do
  begin
    if FTestPartCollect.Items[i].RowNo = ARowNo then
    begin
      for j := 0 to FTestPartSerialCollect.Count - 1 do
      begin
        if FTestPartCollect.Items[i].FID = FTestPartSerialCollect.Items[j].ID then
        begin
          FTestPartSerialCollect.Items[j].FSERIAL_NO := ASerial;
          break;
        end;
      end;

      break;
    end;
  end;
end;

procedure TTestReqList.SetSide(ARowNo: integer; ASide: string);
var
  i,j: integer;
begin
  for i := 0 to FTestPartCollect.Count - 1 do
  begin
    if FTestPartCollect.Items[i].RowNo = ARowNo then
    begin
      for j := 0 to FTestPartSerialCollect.Count - 1 do
      begin
        if FTestPartCollect.Items[i].FID = FTestPartSerialCollect.Items[j].ID then
        begin
          FTestPartSerialCollect.Items[j].FEXH_CAMSIDE := ASide;
          break;
        end;
      end;

      break;
    end;
  end;
end;

procedure TTestReqList.SetCylNo(ARowNo: integer; ACylNo: string);
var
  i,j: integer;
begin
  for i := 0 to FTestPartCollect.Count - 1 do
  begin
    if FTestPartCollect.Items[i].RowNo = ARowNo then
    begin
      for j := 0 to FTestPartSerialCollect.Count - 1 do
      begin
        if FTestPartCollect.Items[i].FID = FTestPartSerialCollect.Items[j].ID then
        begin
          FTestPartSerialCollect.Items[j].CYL_NO := ACylNo;
          break;
        end;
      end;

      break;
    end;
  end;
end;

{ TTestPartCollect }

function TTestPartCollect.Add: TTestPartItem;
begin
  Result := TTestPartItem(inherited Add);
end;

function TTestPartCollect.GetItem(Index: Integer): TTestPartItem;
begin
  Result := TTestPartItem(inherited Items[Index]);
end;

function TTestPartCollect.Insert(Index: Integer): TTestPartItem;
begin
  Result := TTestPartItem(inherited Insert(Index));
end;

procedure TTestPartCollect.SetItem(Index: Integer; const Value: TTestPartItem);
begin
  Items[Index].Assign(Value);
end;

{ TTestPartSerialCollect }

function TTestPartSerialCollect.Add: TTestPartSerialItem;
begin
  Result := TTestPartSerialItem(inherited Add);
end;

function TTestPartSerialCollect.GetItem(Index: Integer): TTestPartSerialItem;
begin
  Result := TTestPartSerialItem(inherited Items[Index]);
end;

function TTestPartSerialCollect.Insert(Index: Integer): TTestPartSerialItem;
begin
  Result := TTestPartSerialItem(inherited Insert(Index));
end;

procedure TTestPartSerialCollect.SetItem(Index: Integer;
  const Value: TTestPartSerialItem);
begin
  Items[Index].Assign(Value);
end;

{ TTestPartSerialFileCollect }

function TTestPartSerialFileCollect.Add: TTestPartSerialFileItem;
begin
  Result := TTestPartSerialFileItem(inherited Add);
end;

function TTestPartSerialFileCollect.GetItem(
  Index: Integer): TTestPartSerialFileItem;
begin
  Result := TTestPartSerialFileItem(inherited Items[Index]);
end;

function TTestPartSerialFileCollect.Insert(
  Index: Integer): TTestPartSerialFileItem;
begin
  Result := TTestPartSerialFileItem(inherited Insert(Index));
end;

procedure TTestPartSerialFileCollect.SetItem(Index: Integer;
  const Value: TTestPartSerialFileItem);
begin
  Items[Index].Assign(Value);
end;

{ TTestPartItem }

procedure TTestPartItem.Assign(Source: TPersistent);
begin
  if Source is TTestPartItem then
  begin
    ID := TTestPartItem(Source).ID;
    FileLocation := TTestPartItem(Source).FileLocation;
    FileAction := TTestPartItem(Source).FileAction;
    RowNo := TTestPartItem(Source).RowNo;
    Req_No := TTestPartItem(Source).Req_No;
    PART_NO := TTestPartItem(Source).PART_NO;
    SEQ_NO := TTestPartItem(Source).SEQ_NO;
    MS_NO := TTestPartItem(Source).MS_NO;
    PARTNAME := TTestPartItem(Source).PARTNAME;
    MAKER := TTestPartItem(Source).MAKER;
    PARTTYPE := TTestPartItem(Source).PARTTYPE;
    PARTSPEC := TTestPartItem(Source).PARTSPEC;
    STATUS := TTestPartItem(Source).STATUS;
  end
  else
    inherited;
end;

{ TTestPartSerialItem }

procedure TTestPartSerialItem.Assign(Source: TPersistent);
begin
  if Source is TTestPartSerialItem then
  begin
    ID := TTestPartSerialItem(Source).ID;
    FileLocation := TTestPartSerialItem(Source).FileLocation;
    FileAction := TTestPartSerialItem(Source).FileAction;
    BANK := TTestPartSerialItem(Source).BANK;
    CYL_NO := TTestPartSerialItem(Source).CYL_NO;
    EXH_INTAKE := TTestPartSerialItem(Source).EXH_INTAKE;
    EXH_CAMSIDE := TTestPartSerialItem(Source).EXH_CAMSIDE;
    SERIAL_NO := TTestPartSerialItem(Source).SERIAL_NO;
  end
  else
    inherited;
end;

{ TTestPartSerialFileItem }

procedure TTestPartSerialFileItem.Assign(Source: TPersistent);
begin
  if Source is TTestPartSerialFileItem then
  begin
    RowNo := TTestPartSerialFileItem(Source).RowNo;
    ID := TTestPartSerialFileItem(Source).ID;
    FileLocation := TTestPartSerialFileItem(Source).FileLocation;
    FileAction := TTestPartSerialFileItem(Source).FileAction;
    ReqNo := TTestPartSerialFileItem(Source).ReqNo;
    PartNo := TTestPartSerialFileItem(Source).PartNo;
    SerialNo := TTestPartSerialFileItem(Source).SerialNo;
    OwnerId := TTestPartSerialFileItem(Source).OwnerId;
    FileName := TTestPartSerialFileItem(Source).FileName;
    FilePath := TTestPartSerialFileItem(Source).FilePath;
    FileSize := TTestPartSerialFileItem(Source).FileSize;
  end
  else
    inherited;
end;

end.
