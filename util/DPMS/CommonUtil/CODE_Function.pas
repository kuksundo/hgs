unit CODE_Function;

interface

function Check_for_Parent_GrpNm(FPGrp:String) : String; //코드그룹코드로 그룹명 리턴
function Check_for_Parent_Grp(FPGrpNm:String) : String; //코드그룹명으로 그룹코드 리턴

function Check_for_CODENM_Base_on_CODE(CODE:String) : String; //코드로 코드명 검색 후 리턴
function Check_for_CODE_Base_on_CODENM(CODENM:String) : String; //코드명으로 코드 검색 후 리턴

function Check_for_DeptName_From_DeptNo(FDeptNo:String):String;
function Check_for_DeptNo_From_DeptName(FCDNM:String) : String;
function Check_for_TeamName_From_TeamNo(FCDNM:String) : String;
function Check_for_TeamNo_From_TeamName(FCDNM:String) : String;



implementation
uses
  DataModule_Unit;

function Check_for_Parent_GrpNm(FPGrp:String) : String; //코드그룹코드로 그룹명 리턴
begin
  with DM1.OraQuery2 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select CDGRPNM from ZHITEMSCDGRP where CDGRP = :param1');
    parambyname('param1').AsString := FPGrp;
    Open;
    if not(RecordCount = 0) then
      Result := Fieldbyname('CDGRPNM').AsString
    else
      Result := '';
  end;
end;

function Check_for_Parent_Grp(FPGrpNm:String) : String; //코드그룹명으로 그룹코드 리턴
begin
  with DM1.OraQuery2 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select CDGRP from ZHITEMSCDGRP where CDGRPNM = :param1');
    parambyname('param1').AsString := FPGrpNm;
    Open;
    if not(RecordCount = 0) then
      Result := Fieldbyname('CDGRP').AsString
    else
      Result := '';
  end;
end;

function Check_for_CODENM_Base_on_CODE(CODE:String) : String; //코드로 코드명 검색 후 리턴
begin
  with DM1.OraQuery2 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select CODENM from ZHITEMSCODE where CODE = :param1');
    parambyname('param1').AsString := CODE;
    Open;
    if not(RecordCount = 0) then
      Result := Fieldbyname('CODENM').AsString
    else
      Result := '';
  end;
end;

function Check_for_CODE_Base_on_CODENM(CODENM:String) : String; //코드명으로 코드 검색 후 리턴
begin
  with DM1.OraQuery2 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select CODE from ZHITEMSCODE where CODENM = :param1');
    parambyname('param1').AsString := CODENM;
    Open;
    if not(RecordCount = 0) then
      Result := Fieldbyname('CODE').AsString
    else
      Result := '';
  end;
end;

function Check_for_DeptName_From_DeptNo(FDeptNo:String):String;
begin
  with DM1.OraQuery2 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select DESCR from DeptNo');
    SQL.Add('where DeptNo = :param1 and GUBUN = ''D''');
    parambyname('param1').AsString := FDeptNo;
    Open;

    if not(RecordCount = 0) then
      Result := Fieldbyname('DESCR').AsString
    else
      Result := '';
  end;
end;

function Check_for_DeptNo_From_DeptName(FCDNM:String) : String;
begin
  with DM1.OraQuery2 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select DeptNo from DeptNo');
    SQL.Add('where DESCR = :param1 and GUBUN = ''D''');
    parambyname('param1').AsString := FCDNM;
    Open;

    if not(RecordCount = 0) then
      Result := Fieldbyname('DeptNo').AsString
    else
      Result := '';
  end;
end;

function Check_for_TeamName_From_TeamNo(FCDNM:String) : String;
begin
  with DM1.OraQuery2 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select DESCR from DeptNo');
    SQL.Add('where DeptNo = :param1');
    parambyname('param1').AsString := FCDNM;
    Open;

    if not(RecordCount = 0) then
      Result := Fieldbyname('DESCR').AsString
    else
      Result := '';
  end;
end;

function Check_for_TeamNo_From_TeamName(FCDNM:String) : String;
begin
  with DM1.OraQuery2 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select DeptNo from DeptNo');
    SQL.Add('where DESCR = :param1');
    parambyname('param1').AsString := FCDNM;
    Open;

    if not(RecordCount = 0) then
      Result := Fieldbyname('DeptNo').AsString
    else
      Result := '';
  end;
end;

end.
