  private
    FProductType: TEngineProductType;
    FProductModel: TEngineModel;
    FTierNo: TTierNo;
    FFilePath,//Original File Path
    FRelFilePath,//Manual DblClick할때 참조하는 파일 상대 경로(Doc Path + FRelFilePath)
    FFileName: string;
    FMSNumber,
    FPlateNumber,
    FDrawNumber,
    FSectionNo,  //Control System의 경우 Panel Name 저장됨
    FRevNo,
    FCategory_Eng,
    FCategory_Kor,
    FCategory_No,
    FSystemDesc_Eng,
    FSystemDesc_Kor,
    FPartDesc_Eng,
    FPartDesc_Kor : string;
    FPageNo_B,//Begin
    FPageNo_E //End
    : integer;
  public
    FIsHideItem: Boolean;
  published
    property ProductType: TEngineProductType read FProductType write FProductType;
    property ProductModel: TEngineModel read FProductModel write FProductModel;
    property TierNo: TTierNo read FTierNo write FTierNo;
    property FilePath: string read FFilePath write FFilePath;
    property RelFilePath: string read FRelFilePath write FRelFilePath;
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
    property PageNo_B: integer read FPageNo_B write FPageNo_B;
    property PageNo_E: integer read FPageNo_E write FPageNo_E;
