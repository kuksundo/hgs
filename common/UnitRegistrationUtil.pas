unit UnitRegistrationUtil;

interface

{$DEFINE USE_REGCODE}

uses
  SynCommons, Winapi.Windows,
  mORMot, OnGuard, OgUtil, Registry
  ,UnitRegCodeConst;

type
  TCheckRegMethod = (crmHTTP, crmIIF);
  TCheckRegMethods = set of TCheckRegMethod;

function CheckRegistration(AProdCode: string; ACRMs: TCheckRegMethods=[crmHTTP]): Boolean;
function CheckRegistrationUsingHTTP(AProdCode: string): Boolean;
function CheckRegistrationUsingIIF: Boolean;

implementation

uses SysUtils, Forms, mORMotSQLite3, FrmRegistration, UnitBase64Util,
  UnitHttpModule4RegServer, UnitRegistrationClass, UnitRegistrationRecord, GetIP;

function CheckRegistration(AProdCode: string; ACRMs: TCheckRegMethods): Boolean;
begin
  if crmHTTP in ACRMs then
  begin
    Result := CheckRegistrationUsingHTTP(AProdCode);
  end;

  if crmIIF in ACRMs then
  begin
    Result := CheckRegistrationUsingIIF;
  end;
end;

function CheckRegistrationUsingHTTP(AProdCode: string): Boolean;
var
  LCustomerInfo,
  LCustomerInfo2: RawUTF8;
  LDoc: variant;
  LResult: integer;
  LRegInfo: TRegistrationInfo;
  LStr, LSerialCode: string;
begin
  Result := False;
  LSerialCode := '';

  LRegInfo := TRegistrationInfo.Create(nil);
  try
    LStr := ExtractFileName(Application.ExeName);
    LRegInfo.RegCodeRecord.RegKey := LRegInfo.RegCodeRecord.RegKey + ChangeFileExt(LStr, '');
    LRegInfo.RegCodeRecord.AppName := LStr;
    LRegInfo.RegCodeRecord.IsUseMachineId := True;

    LStr := ChangeFileExt(ExtractFileName(Application.ExeName), DEFAULT_SERIAL_FILE_EXT);

    if FileExists(LStr) then
    begin
      LSerialCode := StringFromFile(LStr);
      LSerialCode := StringReplace(LSerialCode, #13#10, '', [rfReplaceAll]);
      LRegInfo.RegCodeRecord.SerialCode := LSerialCode;
      LRegInfo.RegCodeRecord.RegCode := LRegInfo.GenerateRegOrUsageCode;
    end;

    if LRegInfo.RegCodeRecord.IPAddress = '' then
      LRegInfo.RegCodeRecord.IPAddress := GetLocalIP(0);

    LResult := TRegistrationF.IsRegistrationValidFromRegistry(LRegInfo);

    if LSerialCode <> '' then
    begin
      LRegInfo.RegCodeRecord.SerialCode := LSerialCode;
      LRegInfo.RegCodeRecord.RegCode := LRegInfo.GenerateRegOrUsageCode;
    end;

    LRegInfo.RegCodeRecord.ProductCode := AProdCode;
    LRegInfo.GetProcessorInfo;

    if LResult = 4 then //ExpireDate
    begin
      LCustomerInfo := LRegInfo.RegCodeRecord.GetJSONValues(True, True, soSelect);
      LCustomerInfo2 := SendReqExpireDate_Http(LCustomerInfo);

      if LCustomerInfo2 <> '' then
      begin
        AssignSQLRegCodeManageFromJSON(LRegInfo.FRegCodeRecord, LCustomerInfo2);

        if ctDate in LRegInfo.RegCodeRecord.CodeTypes then
        begin
          if LRegInfo.RegCodeRecord.ExpireDate >= now then
          begin
            LRegInfo.SaveToRegistry;
            Result := True;
          end;
        end;
      end
      else
      begin
        try
          raise Exception.Create('Initialize error!');
        finally
          LRegInfo.Free;
          Halt(0);
        end;
      end;
    end
    else
    if LResult = 5 then //ExpireUsage
    begin

    end
    else
    if LResult <> 0 then //RegCode is not exist in registry
    begin
      LRegInfo.RegCodeRecord.SerialNo := 0;
      LRegInfo.RegCodeRecord.AppName := ExtractFileName(Application.ExeName);
      LCustomerInfo := LRegInfo.RegCodeRecord.GetJSONValues(True, True, soSelect);

      LCustomerInfo2 := SendReqSerialNo_Http(LCustomerInfo);

      if LCustomerInfo2 = '' then
      begin
        try
          raise Exception.Create('Initialize error!');
        finally
          LRegInfo.Free;
          Halt(0);
        end;
      end;

      LDoc := _JSON(LCustomerInfo2);

      if LDoc.SerialNo <> 0 then
      begin
        LRegInfo.RegCodeRecord.SerialNo := LDoc.SerialNo;
        LCustomerInfo := LRegInfo.RegCodeRecord.GetJSONValues(True, True, soSelect);
        LCustomerInfo2 := SendReqRegCode_Http(LCustomerInfo);

        if LCustomerInfo2 <> '' then
        begin
          AssignSQLRegCodeManageFromJSON(LRegInfo.FRegCodeRecord, LCustomerInfo2);
          LRegInfo.SaveToRegistry;
          LCustomerInfo := LRegInfo.RegCodeRecord.GetJSONValues(True, True, soSelect);
          LCustomerInfo := MakeRawUTF8ToBin64(LCustomerInfo);
          SendConfirmRegInfo_HTTP(LCustomerInfo);
  //        if TCodeType.ctDate in LRegInfo.RegCodeRecord.CodeTypes then
  //          LRegInfo.RegCodeRecord.CodeTypes := [];
  //        LRegInfo.LoadFromRegistry;

          LRegInfo.SaveSerialNoToFile(ChangeFileExt(Application.ExeName,DEFAULT_SERIAL_FILE_EXT));

          Result := True;
        end;
      end;
    end
    else
    if LResult = 0 then
      Result := True;


    if not Result then
    begin
      try
        raise Exception.Create('Initialize error!');
      finally
        LRegInfo.Free;
        Halt(0);
      end;
    end;
  finally
    LRegInfo.Free;
  end;
end;

function CheckRegistrationUsingIIF: Boolean;
begin

end;

//initialization
//  CheckRegistration;

end.
