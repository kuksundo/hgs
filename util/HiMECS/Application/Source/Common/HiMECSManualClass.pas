unit HiMECSManualClass;

interface

uses System.SysUtils, Classes, Generics.Legacy, BaseConfigCollect, HiMECSConst;

type
  THiMECSOpManualItem = class(TCollectionItem)
  private
    FFilePath,
    FFileName: string;
    FMSNumber,
    FPlateNumber,
    FDrawNumber,
    FSectionNo,
    FRevNo,
    FCategory_Eng,
    FCategory_Kor,
    FCategory_No,
    FSystemDesc_Eng,
    FSystemDesc_Kor,
    FPartDesc_Eng,
    FPartDesc_Kor : string;
    FPageNo: integer;
  public
  published
    property FilePath: string read FFilePath write FFilePath;
    property FileName: string read FFileName write FFileName;
    property Category_No: string read FCategory_No write FCategory_No;
    property Category_Eng: string read FCategory_Eng write FCategory_Eng;
    property Category_Kor: string read FCategory_Kor write FCategory_Kor;
    property SystemDesc_Eng: string read FSystemDesc_Eng write FSystemDesc_Eng;
    property SystemDesc_Kor: string read FSystemDesc_Kor write FSystemDesc_Kor;
    property PartDesc_Eng: string read FPartDesc_Eng write FPartDesc_Eng;
    property PartDesc_Kor: string read FPartDesc_Kor write FPartDesc_Kor;
    property MSNumber: string read FMSNumber write FMSNumber;
    property PlateNumber: string read FPlateNumber write FPlateNumber;
    property DrawNumber: string read FDrawNumber write FDrawNumber;
    property SectionNo: string read FSectionNo write FSectionNo;
    property RevNo: string read FRevNo write FRevNo;
    property PageNo: integer read FPageNo write FPageNo;
  end;

  THiMECSOpManualCollect<T: THiMECSOpManualItem> = class(Generics.Legacy.TCollection<T>)
  private
    FManualLanguage: TManualLanguage;
  public
  published
    property ManualLanguage: TManualLanguage read FManualLanguage write FManualLanguage;
  end;

  THiMECSMaintenanceManualItem = class(TCollectionItem)
  private
  public
  published
  end;

  TMaintenanceManualCollect<T: THiMECSMaintenanceManualItem> = class(Generics.Legacy.TCollection<T>)
  private
    FManualLanguage: TManualLanguage;
  public
  published
    property ManualLanguage: TManualLanguage read FManualLanguage write FManualLanguage;
  end;

  THiMECSManualInfo = class(TpjhBase)
  private
    FOpManualCollect: THiMECSOpManualCollect<THiMECSOpManualItem>;
    FMaintenanceManualCollect: TMaintenanceManualCollect<THiMECSMaintenanceManualItem>;
    //ConfigJSONClass를 이용하여 환경설정 폼을 편집 시에 현재 CollectItem Index를 저장하기 위함
    FConfigItemIndex:integer;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Clear;
    property ConfigItemIndex: integer read FConfigItemIndex write FConfigItemIndex;
  published
    property OpManual: THiMECSOpManualCollect<THiMECSOpManualItem> read FOpManualCollect write FOpManualCollect;
    property ServiceManual: TMaintenanceManualCollect<THiMECSMaintenanceManualItem> read FMaintenanceManualCollect write FMaintenanceManualCollect;
  end;


implementation

{ TNotifyScheduleInfo }

{ THiMECSManualInfo }

procedure THiMECSManualInfo.Clear;
begin

end;

constructor THiMECSManualInfo.Create(AOwner: TComponent);
begin
  FOpManualCollect := THiMECSOpManualCollect<THiMECSOpManualItem>.Create;
  FMaintenanceManualCollect := TMaintenanceManualCollect<THiMECSMaintenanceManualItem>.Create;
end;

destructor THiMECSManualInfo.Destroy;
begin
  inherited;

  FMaintenanceManualCollect.Free;
  FOpManualCollect.Free;
end;

end.
