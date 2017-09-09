unit HiTEMSConst_Unit;

interface

uses Windows, Classes, StdCtrls;

type
  PUserInfoRecord = ^TUserInfoRecord;
  TUserInfoRecord = record
    FUserId : String[7];
  end;

  TAttachedFileLocation = (aflDB, aflDisk, aflMemory);
  TAttachedFileAction = (afaNoAction, afaAdd, afaDelete, afaUpdate);

  TSerialAttachFileInfo = class
    FFileLocation: TAttachedFileLocation;
    FAction: TAttachedFileAction;
    FFileNameWithPath,
    FFileNameOnly: string;
  public
    constructor Create(AFileLocation:TAttachedFileLocation; AAction: TAttachedFileAction);
  published
    property FileLocation: TAttachedFileLocation read FFileLocation write FFileLocation;
    property Action: TAttachedFileAction read FAction write FAction;
    property FileNameWithPath: string read FFileNameWithPath write FFileNameWithPath;
    property FileNameOnly: string read FFileNameOnly write FFileNameOnly;
  end;


implementation

{ TSerialAttachFileInfo }

constructor TSerialAttachFileInfo.Create(AFileLocation: TAttachedFileLocation;
  AAction: TAttachedFileAction);
begin
  FFileLocation := AFileLocation;
  FAction := AAction;
end;

end.
