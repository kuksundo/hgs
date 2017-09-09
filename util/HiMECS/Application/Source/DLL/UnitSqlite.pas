unit UnitSqlite;

interface

uses SysUtils,Dialogs, SQLiteTable3;

type
  TSqliteUtil = class(TObject)
  public
    FSQLiteDb: TSQLiteDatabase;
    FSQLiteDbPath: string;

    constructor Create;
    destructor Destroy; override;
    //procedure db_alarm_delete (ident : string);
    procedure db_alarm_insert (ATableName, Adate, ATime, ATag, ADesc: string;
                              ALevel: integer);
    //procedure db_alarm_update_all (myid, mytitle, mydesc, mydate, mycolor, myincalendar, myinevents, myinplans, myintracker : string);

    //function db_alarm_read (ident : string; retfield : string):string;
    procedure db_create_database(ADbpath, ADBName: string);
    procedure db_create_alarm_table(ASQLiteDatabase: TSQLiteDatabase; ATableName: string);
  end;

implementation

{ TSqliteUtil }

constructor TSqliteUtil.Create;
begin
  inherited;

end;

procedure TSqliteUtil.db_create_database(ADbpath, ADBName: string);
begin
  ADbpath := IncludeTrailingBackslash(ADbPath);
  FSQLiteDb := TSQLiteDatabase.Create(ADbpath+ADBName);
end;

//구조는 같지만 월별 알람 저장 테이블로 각기 다른 이름의 테이블임
procedure TSqliteUtil.db_alarm_insert(ATableName, Adate, ATime, ATag, ADesc: string;
  ALevel: integer);
var
  sSQL: string;
begin
  //begin a transaction
  FSQLiteDb.BeginTransaction;

  sSQL := 'INSERT INTO ' + ATableName + ' (AlarmDate, AlarmTime, TaName, AlarmLevel, Description) VALUES ('+
          Adate+','+ATime+','+ATag+','+IntToStr(ALevel)+','+ADesc+');';
  //do the insert
  FSQLiteDb.ExecSQL(sSQL);
  //end the transaction
  FSQLiteDb.Commit;
end;

procedure TSqliteUtil.db_create_alarm_table(ASQLiteDatabase: TSQLiteDatabase;
  ATableName: string);
var
  LSql: string;
begin
  if Assigned(ASQLiteDatabase) then
  begin
    if ASQLiteDatabase.TableExists(ATableName) then
    begin
      MessageDLg('Table is already exist.',mtInformation,[mbOK],0);
      //sSQL := 'DROP TABLE ' + ATableName;;
      //ASQLiteDatabase.execsql(sSQL);
    end
    else
    begin
      LSql := 'CREATE TABLE '+ ATableName +' ([AlarmDate] TEXT PRIMARY KEY,[AlarmTime] TEXT PRIMARY KEY,';
      LSql := LSql + '[TaName] TEXT PRIMARY KEY,[AlarmLevel] INTEGER, [Description] TEXT, [RetAlarmDate]';
      LSql := LSql + ' TEXT, [RetAlarmTime] TEXT) COLLATE NOCASE);';// [picture] BLOB COLLATE NOCASE);';
      ASQLiteDatabase.execsql(LSql);
    end;
  end;

end;

destructor TSqliteUtil.Destroy;
begin
  if Assigned(FSQLiteDb) then
    FreeAndNil(FSQLiteDb);

  inherited;
end;

end.
