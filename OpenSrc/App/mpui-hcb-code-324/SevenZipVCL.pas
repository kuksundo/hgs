(* MPUI-hcb, an MPlayer frontend for Windows
   Copyright (C) 2006-2013 Huang Chen Bin <hcb428@foxmail.com>
   based on TsevenZip by Ivo Andonov and TSevenZipVCL by Rainer Geigenberger ( -> http://www.rg-software.de - SevenZipVCL@rg-software.de )

   Thanks to:
    - Marko Kamin
    - Craig Peterson
    - Roberto
    - Erik Smith
    - Sergey Prokhorov
    - Flurin Honegger
    - Zach Saw
    - Guillaume Di Giusto
    This Unit is under Mozilla Public Licence
    (
     - You can use this Unit for free in free, share and commercial application.
     - Mark clearly in your Readme or Help file that you use this unit/VCL with a link the
       SevenZipVCL Homepage ( http://www.rg-software.de )
     - Any changes of the source must be publised ( Just send it to me :- ) SevenZipVCL@rg-software.de )
    )
*)
unit SevenZipVCL;
interface

uses
  Windows, SysUtils, TntSysUtils, Tntdialogs, Classes,
  TntWindows, ActiveX ,core, locale, plist;

const
//7z internal consts

//Extract
  //NAskMode
  kExtract = 0;
  kTest    = 1;
  kSkip    = 2;

  //NOperationResult
  kOK                = 0;
  kUnSupportedMethod = 1;
  kDataError         = 2;
  kCRCError          = 3;

  FNAME_MAX32 = 512;

// SevenZIP onMessage Errorcode
  FNoError             = 0;
  FFileNotFound        = 1;
  FDataError           = 2;
  FCRCError            = 3;
  FUnsupportedMethod   = 4;
  FIndexOutOfRange     = 5;                                    //FHO 21.01.2007
  FUsercancel          = 6;
  FNoSFXarchive        = 7;
  FSFXModuleError      = 8;
  FSXFileCreationError = 9;                                    //FHO 21.01.2007
  FNoFilesToAdd        =10;                                    //FHO 21.01.2007
  FNoFileCreated       =11;

  c7zipResMsg:array[FNoError..FNoFileCreated] of string=       //FHO 21.01.2007
  { 0}('Success',                                              //FHO 21.01.2007
  { 1} 'File not found',                                       //FHO 21.01.2007
  { 2} 'Data Error',                                           //FHO 21.01.2007
  { 3} 'CRC Error',                                            //FHO 21.01.2007
  { 4} 'Unsupported Method',                                   //FHO 21.01.2007
  { 5} 'Index out of Range',                                   //FHO 21.01.2007
  { 6} 'User canceled operation',                              //FHO 21.01.2007
  { 7} 'File is not an 7z SFX archive',                        //FHO 21.01.2007
  { 8} 'SFXModule error ( Not found )',                        //FHO 21.01.2007
  { 9} 'Could not create SFX',                                 //FHO 21.01.2007
  {10} 'No files to add',                                      //FHO 21.01.2007
  {11} 'Could not create file'                                 //FHO 21.01.2007

       );                                                      //FHO 21.01.2007



const
  kpidNoProperty = 0;
  kpidHandlerItemIndex = 2;
  kpidPath = 3;
  kpidName = 4;
  kpidExtension = 5;
  kpidIsFolder = 6;
  kpidSize = 7;
  kpidPackedSize = 8;
  kpidAttributes = 9;
  kpidCreationTime = 10;
  kpidLastAccessTime = 11;
  kpidLastWriteTime = 12;
  kpidSolid = 13;
  kpidCommented = 14;
  kpidEncrypted = 15;
  kpidSplitBefore = 16;
  kpidSplitAfter = 17;
  kpidDictionarySize = 18;
  kpidCRC = 19;
  kpidType = 20;
  kpidIsAnti = 21;
  kpidMethod = 22;
  kpidHostOS = 23;
  kpidFileSystem = 24;
  kpidUser = 25;
  kpidGroup = 26;
  kpidBlock = 27;
  kpidComment = 28;
  kpidPosition = 29;

  kpidTotalSize = $1100;
  kpidFreeSpace = $1101;
  kpidClusterSize = $1102;
  kpidVolumeName = $1103;

  kpidLocalName = $1200;
  kpidProvider = $1201;
  kpidUserDefined = $10000;


//jjw 18.10.2006
type
  TCreateObjectFunc = function ( const clsid: PGUID; const iid: PGUID; out _out ): Integer; stdcall;


//----------------------------------------------------------------------------------------------------
//--------------Widestring Classes--------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------

type
  TCompressType = ( LZMA,PPMD );
  TCompressStrength = ( SAVE,FAST,NORMAL,MAXIMUM,ULTRA );
  TLZMAStrength = 0..27;
  TPPMDMem = 1..31;
  TPPMDSize = 2..32;

  AddOptsEnum = ( AddRecurseDirs, AddSolid, AddStoreOnlyFilename, AddIncludeDriveLetter, AddEncryptFilename );
  AddOpts = Set Of AddOptsEnum;

  ExtractOptsEnum = ( ExtractNoPath,ExtractOverwrite );
  ExtractOpts = Set Of ExtractOptsEnum;

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//--------------Start SevenZip Interface-------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
type
  TInterfacedObject = class( TObject, IUnknown )
  protected
    FRefCount: Integer;
    function QueryInterface( const IID: TGUID; out Obj ): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    class function NewInstance: TObject; override;
    property RefCount: Integer read FRefCount;
  end;

const
//000
  szIID_IProgress =                         '{23170F69-40C1-278A-0000-000000050000}';
//30
  szIID_ISequentialInStream =               '{23170F69-40C1-278A-0000-000300010000}';
  szIID_ISequentialOutStream =              '{23170F69-40C1-278A-0000-000300020000}';
  szIID_IInStream =                         '{23170F69-40C1-278A-0000-000300030000}';
  szIID_IOutStream =                        '{23170F69-40C1-278A-0000-000300040000}';
  szIID_IStreamGetSize =                    '{23170F69-40C1-278A-0000-000300060000}';
  szIID_IOutStreamFlush =                   '{23170F69-40C1-278A-0000-000300070000}';
//400
  szIID_ICompressProgressInfo =             '{23170F69-40C1-278A-0000-000400040000}';
  szIID_ICompressCoder =                    '{23170F69-40C1-278A-0000-000400050000}';
  szIID_ICompressCoder2 =                   '{23170F69-40C1-278A-0000-000400180000}';
  szIID_ICompressSetCoderProperties =       '{23170F69-40C1-278A-0000-000400200000}';
  szIID_ICompressSetDecoderProperties =     '{23170F69-40C1-278A-0000-000400210000}';
  szIID_ICompressSetDecoderProperties2 =    '{23170F69-40C1-278A-0000-000400220000}';
  szIID_ICompressWriteCoderProperties =     '{23170F69-40C1-278A-0000-000400230000}';
  szIID_ICompressGetInStreamProcessedSize = '{23170F69-40C1-278A-0000-000400240000}';
  szIID_ICompressGetSubStreamSize =         '{23170F69-40C1-278A-0000-000400300000}';
  szIID_ICompressSetInStream =              '{23170F69-40C1-278A-0000-000400310000}';
  szIID_ICompressSetOutStream =             '{23170F69-40C1-278A-0000-000400320000}';
  szIID_ICompressSetInStreamSize =          '{23170F69-40C1-278A-0000-000400330000}';
  szIID_ICompressSetOutStreamSize =         '{23170F69-40C1-278A-0000-000400340000}';
  szIID_ICompressFilter =                   '{23170F69-40C1-278A-0000-000400400000}';
  szIID_ICryptoProperties =                 '{23170F69-40C1-278A-0000-000400800000}';
  szIID_ICryptoSetPassword =                '{23170F69-40C1-278A-0000-000400900000}';
  szIID_ICryptoSetCRC =                     '{23170F69-40C1-278A-0000-000400A00000}';
//500
  szIID_ICryptoGetTextPassword =            '{23170F69-40C1-278A-0000-000500100000}';
  szIID_ICryptoGetTextPassword2 =           '{23170F69-40C1-278A-0000-000500110000}';
//600
  szIID_ISetProperties =                    '{23170F69-40C1-278A-0000-000600030000}';
  szIID_IArchiveOpenCallback =              '{23170F69-40C1-278A-0000-000600100000}';
  szIID_IArchiveExtractCallback =           '{23170F69-40C1-278A-0000-000600200000}';
  szIID_IArchiveOpenVolumeCallback =        '{23170F69-40C1-278A-0000-000600300000}';
  szIID_IInArchiveGetStream =               '{23170F69-40C1-278A-0000-000600400000}';
  szIID_IArchiveOpenSetSubArchiveName =     '{23170F69-40C1-278A-0000-000600500000}';
  szIID_IInArchive =                        '{23170F69-40C1-278A-0000-000600600000}';
  szIID_IArchiveUpdateCallback =            '{23170F69-40C1-278A-0000-000600800000}';
  szIID_IArchiveUpdateCallback2 =           '{23170F69-40C1-278A-0000-000600820000}';
  szIID_IOutArchive =                       '{23170F69-40C1-278A-0000-000600A00000}';
  szIID_CCrypto_Hash_SHA256  =              '{23170F69-40C1-278B-0703-000000000000}';
  szIID_CCrypto7zAESEncoder  =              '{23170F69-40C1-278B-06F1-070100000100}';
  szIID_CCrypto7zAESDecoder  =              '{23170F69-40C1-278B-06F1-070100000000}';

  CLSID_CFormat:array[0..ZipTypeCount]of TGUID =(
{  CLSID_CFormat7z: TGUID = }                      '{23170F69-40C1-278A-1000-000110070000}',
{  CLSID_CFormatRar: TGUID = }                     '{23170F69-40C1-278A-1000-000110030000}',
{  CLSID_CFormatZip: TGUID = }                     '{23170F69-40C1-278A-1000-000110010000}',
{  CLSID_CFormat001: TGUID = }                     '{23170F69-40C1-278A-1000-000110070000}',
{  CLSID_CFormatArj: TGUID = }                     '{23170F69-40C1-278A-1000-000110040000}',
{  CLSID_CFormatBZip2: TGUID = }                   '{23170F69-40C1-278A-1000-000110020000}',
{  CLSID_CFormatZ: TGUID =  }                      '{23170F69-40C1-278A-1000-000110050000}',
{  CLSID_CFormatLzh: TGUID = }                     '{23170F69-40C1-278A-1000-000110060000}',
{  CLSID_CFormatCab: TGUID = }                     '{23170F69-40C1-278A-1000-000110080000}',
//  CLSID_CFormatNsis: TGUID =                     '{23170F69-40C1-278A-1000-000110090000}';
{  CLSID_CFormatLzma: TGUID = }                    '{23170F69-40C1-278A-1000-0001100a0000}',
(*  CLSID_CFormatPe: TGUID =                       '{23170F69-40C1-278A-1000-000110dd0000}';
  CLSID_CFormatElf: TGUID =                        '{23170F69-40C1-278A-1000-000110de0000}';
  CLSID_CFormatMach_O: TGUID =                     '{23170F69-40C1-278A-1000-000110df0000}';
  CLSID_CFormatUdf: TGUID =                        '{23170F69-40C1-278A-1000-000110e00000}';  *)
{  CLSID_CFormatXar: TGUID =  }                    '{23170F69-40C1-278A-1000-000110e10000}',
//  CLSID_CFormatMub: TGUID =                      '{23170F69-40C1-278A-1000-000110e20000}';
{  CLSID_CFormatHfs: TGUID =    }                  '{23170F69-40C1-278A-1000-000110e30000}',
{  CLSID_CFormatDmg: TGUID =    }                  '{23170F69-40C1-278A-1000-000110e40000}',
//  CLSID_CFormatCompound: TGUID =                 '{23170F69-40C1-278A-1000-000110e50000}';
{  CLSID_CFormatWim: TGUID =  }                    '{23170F69-40C1-278A-1000-000110e60000}',
//{  CLSID_CFormatIso: TGUID =  }                   '{23170F69-40C1-278A-1000-000110e70000}',  
//  CLSID_CFormatBkf: TGUID =                      '{23170F69-40C1-278A-1000-000110e80000}';
//  CLSID_CFormatChm: TGUID =                      '{23170F69-40C1-278A-1000-000110e90000}';
{  CLSID_CFormatSplit: TGUID = }                   '{23170F69-40C1-278A-1000-000110ea0000}',
{  CLSID_CFormatRpm: TGUID =   }                   '{23170F69-40C1-278A-1000-000110eb0000}',
{  CLSID_CFormatDeb: TGUID =   }                   '{23170F69-40C1-278A-1000-000110ec0000}',
{  CLSID_CFormatCpio: TGUID =  }                   '{23170F69-40C1-278A-1000-000110ed0000}',
{  CLSID_CFormatTar: TGUID =   }                   '{23170F69-40C1-278A-1000-000110ee0000}',
{  CLSID_CFormatGZip: TGUID =  }                   '{23170F69-40C1-278A-1000-000110ef0000}'

    );

 // CLSID_CFormat7z: TGUID = szCLSID_CFormat7z;
  IID_IInArchive: TGUID = szIID_IInArchive;
  IID_IOutArchive: TGUID = szIID_IOutArchive;
  IID_ISetProperties: TGUID = szIID_ISetProperties;
  IID_ICompressCoder: TGUID = szIID_ICompressCoder;
  IID_ICryptoGetTextPassword: TGUID = szIID_ICryptoGetTextPassword;
  IID_ICryptoGetTextPassword2: TGUID = szIID_ICryptoGetTextPassword2;
  IID_ICryptoSetPassword: TGUID = szIID_ICryptoSetPassword;
  IID_IOutStream: TGUID = szIID_IOutStream;
  IID_ISequentialInStream: TGUID = szIID_ISequentialInStream;
  IID_IInStream: TGUID = szIID_IInStream;
  IID_IStreamGetSize: TGUID = szIID_IStreamGetSize;
  IID_IArchiveOpenCallback: TGUID = szIID_IArchiveOpenCallback;
  IID_ICompressGetSubStreamSize: TGUID = szIID_ICompressGetSubStreamSize;
  IID_IArchiveOpenSetSubArchiveName: TGUID = szIID_IArchiveOpenSetSubArchiveName;
  IID_IArchiveExtractCallback: TGUID = szIID_IArchiveExtractCallback;
  IID_IArchiveOpenVolumeCallback: TGUID = szIID_IArchiveOpenVolumeCallback;
  IID_IArchiveUpdateCallback: TGUID = szIID_IArchiveUpdateCallback;
  IID_IArchiveUpdateCallback2: TGUID = szIID_IArchiveUpdateCallback2;
  IID_IProgress: TGUID = szIID_IProgress;
  IID_ISequentialOutStream: TGUID = szIID_ISequentialOutStream;

type
  HARC = THandle;
  PInt64 = ^Int64;

type

  ISequentialOutStream = interface( IUnknown )
    [ szIID_ISequentialOutStream ]
    function Write( const data; size: DWORD; processedSize: PDWORD ): Integer; stdcall;
  end;

  ISequentialInStream = interface( IUnknown )
    [ szIID_ISequentialInStream ]
    function Read( var data; size: DWORD; processedSize: PDWORD ): Integer; stdcall;
  end;

  ICryptoGetTextPassword = interface( IUnknown )
    [ szIID_ICryptoGetTextPassword ]
    function CryptoGetTextPassword( var Password: PWideChar ): Integer; stdcall;
  end;

  IInStream = interface( ISequentialInStream )
    [ szIID_IInStream ]
    function Seek( offset: Int64; seekOrigin: DWORD;newPosition: PInt64 ): Integer; stdcall;
  end;

  IStreamGetSize = interface( IUnknown )
    [ szIID_IStreamGetSize ]
    function GetSize( var size: Int64 ): Integer; stdcall;
  end;

  IArchiveOpenCallback = interface( IUnknown )
    [ szIID_IArchiveOpenCallback ]
    function SetTotal( const files: Int64; const bytes: Int64 ): Integer; stdcall;
    function SetCompleted( const files: Int64; const bytes: Int64 ): Integer; stdcall;
  end;

  IProgress = interface( IUnknown )
    [ szIID_IProgress ]
    function SetTotal( total: Int64 ): Integer; stdcall;
    function SetCompleted( const completeValue: PInt64 ): Integer; stdcall;
  end;

  IArchiveExtractCallback = interface( IProgress )
    [ szIID_IArchiveExtractCallback ]
    function GetStream( index: DWORD; out outStream: ISequentialOutStream;  askExtractMode: DWORD ): Integer; stdcall;
    // GetStream OUT: S_OK - OK, S_FALSE - skeep this file
    function PrepareOperation( askExtractMode: Integer ): Integer; stdcall;
    function SetOperationResult( resultEOperationResult: Integer ): Integer; stdcall;
  end;

  IInArchive = interface( IUnknown )
    [ szIID_IInArchive ]
    function Open( stream: IInStream; const maxCheckStartPosition: PInt64; openArchiveCallback: IArchiveOpenCallback ): Integer; stdcall;
    function Close( ): Integer; stdcall;
    function GetNumberOfItems( out numItems: DWORD ): Integer; stdcall;
    function GetProperty( index: DWORD; propID: PROPID; var value: PROPVARIANT ): Integer; stdcall;
    function Extract( const indices: PDWORD; numItems: DWORD;   testMode: Integer; extractCallback: IArchiveExtractCallback ): Integer; stdcall;
    function GetArchiveProperty( propID: PROPID; value: PPROPVARIANT ): Integer; stdcall;
    function GetNumberOfProperties( var numProperties: DWORD ): Integer; stdcall;
    function GetPropertyInfo( index: DWORD; var name: TBSTR; var propID: PROPID; var varType: {PVARTYPE}Integer ): Integer; stdcall;
    function GetNumberOfArchiveProperties( var numProperties ): Integer; stdcall;
    function GetArchivePropertyInfo( index: DWORD; name: PBSTR; propID: PPROPID; varType: {PVARTYPE}PInteger ): Integer; stdcall;
  end;

  IOutStream = interface( ISequentialOutStream )
    [ szIID_IOutStream ]
    function Seek( offset: Int64; seekOrigin: DWORD; newPosition: PInt64 ): Integer; stdcall;
    function SetSize( newSize: Int64 ): Integer; stdcall;
  end;

// -----------------------------------------------------------------------------

  TSevenZip = class;   // for reference only, implementated later below
  TOpenVolume = procedure( var arcFileName: WideString; Removable: Boolean; out Cancel: Boolean ) of object;

  TFiles = record
    Name: WideString;
    Handle: cardinal; //Integer;                              //FHO  20.01.2007
    Size: Int64;//DWORD;                                      // RG  26.01.2007
    OnRemovableDrive: Boolean;
  end;                           //FHO 17.01.2007

  TArrayOfFiles = array of TFiles;                             //FHO 17.01.2007

  TMyStreamWriter = class( TInterfacedObject, ISequentialOutStream, IOutStream )
  private
    arcName: WideString;
    arcPosition, arcSize: int64; // DWORD;                     // RG  26.01.2007
    FPLastError:PInteger;                                      //FHO 22.01.2007
    MyLastError: Integer;                                      //FHO 22.01.2007
    Files: TFiles;

    function CreateNewFile: Boolean;
  protected
    property TheFiles: TFiles read Files;
  public
    destructor Destroy; override;
    constructor Create( PLastError:PInteger;sz: Widestring);
    function Write( const Data; Size: DWORD; ProcessedSize: PDWORD ): Integer; stdcall;
    function Seek( Offset: Int64; SeekOrigin: DWORD; NewPosition: PInt64 ): Integer; stdcall;
    function SetSize( newSize: Int64 ): Integer; stdcall;
  end;

  TMyStreamReader = class( TInterfacedObject, IInStream, IStreamGetSize, ISequentialInStream )
    FSevenZip: TSevenZip;
    arcName: WideString;
    arcPosition, arcSize: Int64; //DWORD;                     // RG  26.01.2007
    Files: TArrayOfFiles;
    FOnOpenVolume: TOpenVolume;
    FArchive: Boolean;
    MyLastError: Integer;                                      //FHO 22.01.2007
    
    FMultivolume: Boolean;
    function BrowseForFile(var Name:WideString): Boolean;
    function OpenVolume( Index: Integer ): Boolean;
    function OpenNextVolume: Boolean;
    function OpenLastVolume: Boolean;
  public
    constructor Create( Owner: TSevenZip; sz: Widestring; asArchive: Boolean );
    destructor Destroy; override;
    function Seek( Offset: Int64; SeekOrigin: DWORD; NewPosition: PInt64 ): Integer; stdcall;
    function Read( var Data; Size: DWORD; ProcessedSize: PDWORD ): Integer; stdcall;
    function GetSize( var Size: Int64 ): Integer; stdcall;
  end;

// -----------------------------------------------------------------------------

  TMyArchiveExtractCallback = class( TInterfacedObject, IArchiveExtractCallback, ICryptoGetTextPassword )
    FSevenzip: TSevenzip;
    FExtractDirectory: Widestring;
    FProgressFile: Widestring;
    FProgressFilePos: int64;
    FProgressFileSize: int64;
    FLastPos: int64;
    FFilestoextract: int64;
    FLastFileToExt: Boolean;
    FAllFilesExt: Boolean;
    FPassword: WideString;
    constructor Create( Owner: TSevenZip );
    function GetStream( index: DWORD; out outStream: ISequentialOutStream; askExtractMode: DWORD ): Integer; stdcall;
    // GetStream OUT: S_OK - OK, S_FALSE - skeep this file
    function PrepareOperation( askExtractMode: Integer ): Integer; stdcall;
    function SetOperationResult( resultEOperationResult: Integer ): Integer; stdcall;
    function SetTotal( total: Int64 ): Integer; stdcall;
    function SetCompleted( const completeValue: PInt64 ): Integer; stdcall;
// Shadow 29.11.2006
    function CryptoGetTextPassword( var Password: PWideChar ): Integer; stdcall;
  end;


  TMyArchiveOpenCallback = class( TInterfacedObject, IArchiveOpenCallback, ICryptoGetTextPassword )
    FSevenzip: TSevenzip;
    FPassword: WideString;
    constructor Create( Owner: TSevenZip );
    function SetTotal( const files: Int64; const bytes: Int64 ): Integer; stdcall;
    function SetCompleted( const files: Int64; const bytes: Int64 ): Integer; stdcall;
    function CryptoGetTextPassword( var Password: PWideChar ): Integer; stdcall;
  end;

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//--------------END SevenZip Interface--------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//--------------Start SevenZip VCL -------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------

  TSevenZip = class( TComponent )       // Twincontrol   TComponent
  private
    FErrCode: Integer;
    FLastError:Integer;                                        //FHO 22.01.2007
    FHandle: HWND;
    FExtrBaseDir: Widestring;
    FExtrOutName: Widestring;
    FSevenZipFileName: Widestring;
    FComment: Widestring;
    FRootDir: Widestring;
    Ffiles:  TWStringList;
    FAddOptions: Addopts;
    FExtractOptions: Extractopts;
    FNumberOfFiles: Integer;
    FCompresstype: TCompresstype;
    FCompstrength: TCompressStrength;
    FLZMAStrength: TLZMAStrength;
    FPPMDSize: TPPMDSize;
    FPPMDMem: TPPMDMem;
    FMainCancel: Boolean;                                                      //FHO 25.01.2007
    FCreateObject: TCreateObjectFunc;
    FOnOpenVolume: TOpenVolume;
    FPassword: WideString;

    function InternalGetIndexByFilename( FileToExtract:Widestring ): Integer;		//ZSA 21.02.2007
    procedure SetLastError(const Value: Integer);                       //FHO 17.01.2007
  protected
    inA: IInArchive;
  public
    constructor Create( AOwner: TComponent; ArcType:WideString ); overload;
    destructor Destroy; override;

    { Public Properties ( run-time only ) }
    property Handle: HWND read fHandle write fHandle;
    property ErrCode: Integer read fErrCode write fErrCode;
    property LastError:Integer read FLastError write SetLastError;// FLastError;//FHO 22.01.2007

    property SevenZipComment: Widestring read Fcomment write FComment;
    property Files: TWStringList read Ffiles write ffiles;

    { Public Methods }
    function Extract( TestArchive:Boolean=False ): Integer;
    function List(q:boolean): Integer;
    
  published
    { Public properties that also show on Object Inspector }
    property AddRootDir: Widestring read FRootDir write FRootDir;

    property AddOptions: AddOpts read FAddOptions write FAddOptions;
    property ExtractOptions: ExtractOpts read FExtractOptions write FExtractOptions;
    property ExtrBaseDir: Widestring read FExtrBaseDir write FExtrBaseDir;
    property ExtrOutName: Widestring read FExtrOutName write FExtrOutName;
    property LZMACompressType: TCompresstype read FCompresstype write FCompresstype;
    property LZMACompressStrength: TCompressStrength read FCompstrength write FCompstrength;
    property LZMAStrength: TLZMAStrength read FLZMAStrength write FLZMAstrength;
    property LPPMDmem: TPPMDmem read FPPMDmem write FPPMDmem;
    property LPPMDsize: TPPMDsize read FPPMDsize write FPPMDsize;
    property SZFileName: Widestring read FSevenZipFileName write FSevenZipFilename;
    property NumberOfFiles: Integer read FNumberOfFiles write FNumberOfFiles;
// Shadow 29.11.2006

    property Password: WideString read FPassword write FPassword;
  end;


// jjw 18.10.2006 FCreateobject - function CreateObject( const clsid: PGUID; const iid: PGUID; out _out ): Integer; stdcall; external '7za.dll';
//{$IFNDEF DynaLoadDLL}
//function CreateObject( const clsid: PGUID; const iid: PGUID; out _out ): Integer; stdcall; external '7za.dll'
//{$ENDIF}

procedure SortDWord( var A: array of DWord; iLo, iHi: DWord );
function DriveIsRemovable( Drive: WideString ): Boolean;

//Unicode procedures
function GetFileSizeandDateTime_Int64( fn: Widestring; var fs:int64; var ft:Tfiletime; var fa:Integer ): int64;
function FileExists_( fn: Widestring ): Boolean;

implementation

uses
  Forms, SevenZip;

//--------------------------------------------------------------------------------------------------
//-------------------Start UniCode procedures-------------------------------------------------------
//--------------------------------------------------------------------------------------------------

function FileExists_( fn: Widestring ): Boolean;
var
 fs:int64;
 ft:Tfiletime;
 fa:Integer;
begin
 if Win32PlatformIsUnicode then
   Result := ( GetFileSizeandDateTime_Int64( fn,fs,ft,fa ) > -1 )
  else
   Result := fileexists(string(fn));
end;

function PrevDir( Path: WideString ): WideString;
var
  l: Integer;
begin
  l := Length( Path );
  if ( l > 0 ) and ( Path[ l ] = '\' ) then Dec( l );
  while Path[ l ] <> '\' do Dec( l );
  Result := Copy( Path, 1, l );
end;

function GetFileSizeandDateTime_Int64( fn: Widestring; var fs:int64; var ft:Tfiletime; var fa:Integer ): int64;
var
  FindDataW: _Win32_Find_Dataw;
  FindDataA: _Win32_Find_DataA;
  SearchHandle: THandle;
begin
  //Result := 0;

  if Win32PlatformIsUnicode then
   SearchHandle := FindFirstFilew( PWideChar( fn ), FindDataW )
  else
    SearchHandle := FindFirstFile( PAnsiChar( Ansistring( fn ) ), FindDataA );

  if SearchHandle = INVALID_HANDLE_VALUE then
   begin
    Result := -1;
    fs := -1;
    fa := -1;
    ft.dwLowDateTime := 0;
    ft.dwHighDateTime := 0;
    exit;
   end;

  if Win32PlatformIsUnicode then
   begin
     LARGE_Integer( Result ).LowPart := FindDataW.nFileSizeLow;
     LARGE_Integer( Result ).HighPart := FindDataW.nFileSizeHigh;

     LARGE_Integer( fs ).LowPart := FindDataW.nFileSizeLow;
     LARGE_Integer( fs ).HighPart := FindDataW.nFileSizeHigh;

     ft.dwLowDateTime  := FinddataW.ftLastWriteTime.dwLowDateTime;
     ft.dwHighDateTime := FinddataW.ftLastWriteTime.dwHighDateTime;
     fa := FinddataW.dwFileAttributes;
   end
  else
   begin
     LARGE_Integer( Result ).LowPart := FindDataA.nFileSizeLow;
     LARGE_Integer( Result ).HighPart := FindDataA.nFileSizeHigh;

     LARGE_Integer( fs ).LowPart := FindDataA.nFileSizeLow;
     LARGE_Integer( fs ).HighPart := FindDataA.nFileSizeHigh;

     ft.dwLowDateTime  := FinddataA.ftLastWriteTime.dwLowDateTime;
     ft.dwHighDateTime := FinddataA.ftLastWriteTime.dwHighDateTime;
     fa := FinddataA.dwFileAttributes;
   end;

  Windows.FindClose( SearchHandle );
end;

function ForceDirectoriesW( Path: WideString; Attr: Word ): Boolean;
begin
  Result := TRUE;

  if Path = '' then exit;

  Path := WideExcludeTrailingBackslash( Path );
  if WideDirectoryExists( Path ) then Exit;

  if ( Length( Path ) < 3 ) or WideDirectoryExists(Path)
    or ( ExtractFilePath( Path ) = Path ) then Exit; // avoid 'xyz:\' problem.

  Result := ForceDirectoriesW( PrevDir( Path ), 0 ) and CreateDirectoryW( PWideChar( Path ), nil );
  if Result and ( Attr > 0 ) then SetFileAttributesW( PWideChar( Path ), Attr );
end;

//--------------------------------------------------------------------------------------------------
//-------------------End UniCode procedures---------------------------------------------------------
//--------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------
//  Start common functions
//------------------------------------------------------------------------------------------------
//some Delphi veriosn do not take the Int64 overload
function FileSeek(Handle: Integer; const Offset: Int64; Origin: Integer): Int64;
begin
  Result := Offset;
  Int64Rec(Result).Lo := SetFilePointer(THandle(Handle), Int64Rec(Result).Lo,@Int64Rec(Result).Hi, Origin);
end;

procedure SortDWord(var A:array of DWord; iLo,iHi:DWord);
var Lo,Hi,Mid,T:DWord;
begin
    Lo:=iLo;
    Hi:=iHi;
    Mid:=A[(Lo+Hi) div 2];
    repeat
      while A[Lo]<Mid do Inc(Lo);
      while A[Hi]>Mid do Dec(Hi);
      if Lo<=Hi then begin
        T:=A[Lo];
        A[Lo]:=A[Hi];
        A[Hi]:=T;
        Inc(Lo);
        if Hi>0 then Dec(Hi); //Using DWord and not Integers
      end;
    until Lo>Hi;
    if Hi>iLo then SortDWord(A,iLo,Hi);
    if Lo<iHi then SortDWord(A,Lo,iHi);
end;

function DriveIsRemovable( Drive: WideString ): Boolean;
var
  DT: Cardinal;
begin
  DT := GetDriveTypeW( PWideChar( Drive ) );
  Result := ( DT <> DRIVE_FIXED );
end;

//------------------------------------------------------------------------------------------------
//  End common functions
//--------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
//-------------------Start SevenZip Interface -----------------------------------------------
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------

function TInterfacedObject.QueryInterface( const IID: TGUID; out Obj ): HResult;
const E_NOINTERFACE = HResult( $80004002 );
begin
  if GetInterface( IID, Obj ) then Result:=0
  else Result := E_NOINTERFACE;
end;

function TInterfacedObject._AddRef: Integer;
begin
  Result := InterlockedIncrement( FRefCount );
end;

function TInterfacedObject._Release: Integer;
begin
  Result := InterlockedDecrement( FRefCount );
  if Result = 0 then Destroy;
end;

procedure TInterfacedObject.AfterConstruction;
begin
// Release the constructor's implicit refcount
  InterlockedDecrement( FRefCount );
end;

procedure TInterfacedObject.BeforeDestruction;
begin
  //if RefCount <> 0 then Error( reInvalidPtr );
end;

// Set an implicit refcount so that refcounting
// during construction won't destroy the object.
class function TInterfacedObject.NewInstance: TObject;
begin
  Result := inherited NewInstance;
  TInterfacedObject( Result ).FRefCount := 1;
end;

constructor TMyArchiveExtractCallback.Create( Owner: TSevenZip );
begin
  inherited Create;
  FSevenzip := Owner;
// Shadow 29.11.2006
  if Assigned( FSevenzip ) then
    FPassword := FSevenzip.Password
  else FPassword := '';
end;

function TMyArchiveExtractCallback.GetStream(index:DWORD;
  out outStream:ISequentialOutStream; askExtractMode:DWORD):Integer; stdcall;
var path:Propvariant; sz:Widestring;  //   fHnd: Integer;
    MyLastError:Integer;                                           //FHO 22.01.2007
begin
  path.vt:=VT_EMPTY;
  if self.FSevenzip.FMainCancel or (not procArc) then
   begin
    outStream := nil;
    result := S_FALSE;
    exit;
   end;
  Case askExtractMode of
    kExtract:  begin
                 FSevenzip.inA.GetProperty(index,kpidPath,path);
                 if ExtractNoPath in FSevenzip.FExtractOptions then begin
                   if FSevenzip.FExtrOutName='' then
                     sz:=FExtractDirectory + WideExtractFileName(path.bstrVal)
                   else sz:=FExtractDirectory + FSevenzip.FExtrOutName;
                 end
                 else begin
                   if FSevenzip.FExtrOutName='' then
                     sz:=FExtractDirectory + path.bstrVal
                   else
                     sz:=FExtractDirectory + WideExtractFileDir(path.bstrVal) + FSevenzip.FExtrOutName;
                 end;

                 dec(FFilestoextract);
                 if FFilestoextract=0 then FLastFileToExt:=true;
                 outStream := nil;
                 if Win32PlatformIsUnicode then
                   ForceDirectoriesW(WideExtractFilePath(sz),FILE_ATTRIBUTE_NORMAL)
                 else
                   ForceDirectories(extractfilepath(String(sz)));
                 try
                   outStream:=TMyStreamWriter.Create(@MyLastError,sz);
                 except
                   outStream := nil;
                   Result := S_FALSE;
                   Exit;
                 end;
               end;
    ktest:     FSevenzip.inA.GetProperty( index, kpidPath, path );
    kskip:     begin
               end;
  end;
  Result := S_OK;
end;
// GetStream OUT: S_OK - OK, S_FALSE - skeep this file

function TMyArchiveExtractCallback.PrepareOperation( askExtractMode: Integer ): Integer; stdcall;
begin
  Result := S_OK;
end;

function TMyArchiveExtractCallback.SetOperationResult( resultEOperationResult: Integer ): Integer; stdcall;
begin
  Result := S_OK;
  case resultEOperationResult of
    kOK               : FSevenzip.ErrCode:=FNoError;
    kUnSupportedMethod: begin                                  //FHO 21.01.2007
                          FSevenzip.ErrCode:=FUnsupportedMethod;

                        end;
    kDataError        : begin                                  //FHO 21.01.2007
                          FSevenzip.ErrCode:=FDataError;

                        end;
    kCRCError         : begin                                  //FHO 21.01.2007
                          FSevenzip.ErrCode:=FCRCError;

                        end;
  end;

  if FLastFileToExt then FAllFilesExt := true; //no more files to extract, we can stop
end;

function TMyArchiveExtractCallback.SetTotal( total: Int64 ): Integer; stdcall;
begin
//all filesizes also skipped ones
  //if FFilestoextract = 0 then // we extract all files, so we set FMaxProgress here
     Result := S_OK;
  //else Result:=S_FAlSE;
end;

function TMyArchiveExtractCallback.SetCompleted( const completeValue: PInt64 ): Integer; stdcall;
begin
   if ( FProgressFilePos = 0 ) then
     FProgressFilePos := FProgressFilePos + ( completeValue^ - FLastPos );
   FLastPos := completeValue^;

//full and file progress position
  Result := S_OK;
  //have all files extracted. Could stop
  if self.FAllFilesExt then Result := S_FALSE;
  //User cancel operation
  if  Fsevenzip.FMainCancel or (not procArc) then begin
     Result := S_FALSE;
     FSevenzip.ErrCode:=FUsercancel;                           //FHO 21.01.2007
  end;
end;


function TMyArchiveExtractCallback.CryptoGetTextPassword( var Password: PWideChar ): Integer;
begin
  if Length( FPassword ) > 0 then begin
    Password:=SysAllocString(PWChar(FPassword));
    Result := S_OK;
  end else Result := S_FALSE;
end;


{============ TMyOpenarchiveCallbackReader =================================================}


function TMyArchiveOpenCallback.CryptoGetTextPassword( var Password: PWideChar ): Integer;
begin
  if FPassword='' then WideInputQuery(LOCstr_SetPW_Caption,FSevenzip.SZFileName,FPassword);
  if Length( FPassword ) > 0 then begin
    Password:=SysAllocString(PWChar(FPassword));
    FSevenZip.Password:=Password;
    Result := S_OK;
  end else Result := S_FALSE;
  TmpPW:=FPassword;
end;

constructor TMyArchiveOpenCallback.Create( Owner: TSevenZip );
begin
  inherited Create;
  FSevenzip := Owner;
// Shadow 29.11.2006
  if Assigned( FSevenzip ) then
    FPassword := FSevenzip.Password
  else FPassword := '';
end;

function TMyArchiveOpenCallback.SetTotal( const files: Int64; const bytes: Int64 ): Integer; stdcall;
begin
  Result := S_OK; //LifePower 07.01.2007
end;

function TMyArchiveOpenCallback.SetCompleted( const files: Int64; const bytes: Int64 ): Integer; stdcall;
begin
  Result := S_OK;
end;

{============ TMyStreamReader =================================================}

function TMyStreamReader.Seek( Offset: Int64; SeekOrigin: DWORD; NewPosition: PInt64 ): Integer; stdcall;
begin
  Result := S_OK;
  case SeekOrigin of
    soFromBeginning: arcPosition := Offset;
    soFromCurrent: arcPosition := arcPosition + Offset;
    soFromEnd: begin
      if arcSize > 0 then
        arcPosition := arcSize + Offset
      else Result := S_FALSE;
    end;
  end;
  if newPosition <> nil then newPosition^ := arcPosition;
end;

function TMyStreamReader.Read( var Data; Size: DWORD; ProcessedSize: PDWORD ): Integer; stdcall;
var fIdx:Integer; fPos:Int64; pSize,Read:DWORD; Vsize:Int64; Buff:PChar;
begin
  if FArchive then begin
    if ( Length( Files ) <= 1 ) and ( arcPosition + Size > Files[ 0 ].Size ) then begin
      arcSize := arcPosition + Size;
      if not OpenLastVolume then begin
        Result := S_FALSE;
        Exit;
      end else FMultivolume := TRUE;
    end;
  end;

  if ( not FArchive ) or ( not FMultivolume ) then begin
    FileSeek( Files[ 0 ].Handle, arcPosition, soFromBeginning );
    if not ReadFile( Files[ 0 ].Handle, Data, Size, pSize, nil ) then begin
      MyLastError:=GetLastError;                               //FHO 22.01.2007
      pSize := 0;
    end;
    Inc( arcPosition, pSize );
    if ProcessedSize <> nil then ProcessedSize^ := pSize;
    Result := S_OK;
    Exit;
  end;

  fIdx := -1;
  vSize := 0;
  repeat
    Inc( fIdx );
    if ( not OpenVolume( fIdx + 1 ) ) and ( Files[ fIdx ].Handle = INVALID_HANDLE_VALUE ) then begin  //FHO 20.01.2007
      Result := S_FALSE;
      Exit;
    end;
    vSize := vSize + Files[ fIdx ].Size;
  until arcPosition < vSize;

  Buff := @Data;
  fPos := arcPosition - ( vSize - Files[ fIdx ].Size );
  Read := 0;
  while Read < Size do begin
    if Read > 0 then begin
      with Files[ fIdx - 1 ] do begin
        FileClose( Handle );
        Handle := INVALID_HANDLE_VALUE;                        //FHO 20.01.2007
        Size := 0;
      end;
      if ( not OpenVolume( fIdx + 1 ) ) and ( Files[ fIdx ].Handle = INVALID_HANDLE_VALUE ) then begin                                        //FHO 20.01.2007
        Result := S_FALSE;
        Exit;
      end;
    end;
    FileSeek( Files[ fIdx ].Handle, fPos, soFromBeginning );
    pSize := Size - Read;
    if Files[ fIdx ].Size < fPos + pSize then pSize := Files[ fIdx ].Size - fPos;
    if not ReadFile( Files[ fIdx ].Handle, Buff[ Read ], pSize, pSize, nil ) then begin
      MyLastError:=GetLastError;                               //FHO 22.01.2007
      Read := 0;
      Break;
    end;
    Inc( Read, pSize );
    Inc( fIdx );
    fPos := 0;
  end;
  Inc( arcPosition, Read );
  if Assigned( ProcessedSize ) then ProcessedSize^ := Read;
  if MyLastError=0 then
    Result := S_OK
  else
    Result := S_False;  
end;

function TMyStreamReader.GetSize(var size:Int64):Integer; stdcall;
begin
  if arcSize>0 then begin
    Size:=arcSize; Result:=S_OK;
  end
  else Result:=S_FALSE;
end;

function TMyStreamReader.BrowseForFile(var Name:WideString): Boolean;
begin
  if WidePromptForFileName(Name,'Any file(*.*)|*.*','',LOCstr_VolAsk_Caption,WideIncludeTrailingPathDelimiter(WideExtractFilePath(Name))) then
    Result:=GetLastError=0
  else Result:=FALSE;
end;

function TMyStreamReader.OpenVolume(Index:Integer):Boolean;
var i:Integer; s:WideString; fCancel:Boolean;
begin
  Result:=FALSE;

  if Index<=0 then Exit
  else if Index<=Length(Files) then begin
    if Files[Index-1].Handle<>INVALID_HANDLE_VALUE then begin //FHO 20.01.2007
      Result:=TRUE;
      Exit;
    end;
  end
  else begin
    i:=Length(Files);
    while i<Index do begin
      SetLength(Files,i+1);
      Files[i].Handle:=INVALID_HANDLE_VALUE;               //FHO 20.01.2007
      Files[i].Size:=0;
      Inc(i);
    end;
  end;

  Dec(Index);
  if Length(Files[Index].Name)<=0 then begin
    s:=IntToStr(Index+1);
    while Length(s)<3 do s:='0'+s;
// Shadow 28.11.2006
    Files[Index].Name:=GetFileName(arcName)+'.'+s;
  end;

  while Files[Index].Handle=INValid_Handle_Value do begin  //FHO 20.01.2007
    Files[Index].Handle:=Tnt_CreateFileW(PWChar(Files[Index].Name),GENERIC_READ,FILE_SHARE_READ,nil,OPEN_EXISTING,0,0);
    if Files[Index].Handle=INVALID_HANDLE_VALUE then begin //FHO 20.01.2007
      if Assigned(FOnOpenVolume) then begin
        FOnOpenVolume(Files[Index].Name,Files[Index].OnRemovableDrive,fCancel);
        if not fCancel then Continue;
      end
      else begin
        if BrowseForFile(Files[Index].Name) then Continue;
      end;
      Files[ Index ].Name := '';
      Result := FALSE;
      Exit;
    end;
    Files[ Index ].Size := FileSeek( Files[ Index ].Handle, int64(0), soFromEnd );
    FileSeek( Files[ Index ].Handle, int64(0), soFromBeginning );
  end;

  Result := ( Files[ Index ].Size > 0 );
end;

function TMyStreamReader.OpenNextVolume: Boolean;
begin
  Result := OpenVolume( Length( Files ) + 1 );
end;

function TMyStreamReader.OpenLastVolume: Boolean;
var Name:WideString; n:Integer;
  function GetLastVolumeFN(first:widestring):widestring;
  var n:integer; s,e,lastfound:widestring;
  begin
    Result:=''; s:=WideChangeFileExt(first,'');
    //lastfound:=first;
    if not TryStrToInt(Copy(WideExtractFileExt(first),2,MaxInt),n) then exit;
    e:= '00' + inttostr(n);

    repeat
      lastfound := s + '.' + e;
      inc(n);
      e:= inttostr(n);
      while Length( e ) < 3 do e := '0' + e;

    until not fileexists_( s + '.' + e);
    Result := lastfound;
  end;

begin
  Result := FALSE;
  repeat
   //name := '';
   name := GetLastVolumeFN(Arcname);
   if name = '' then
     if not BrowseForFile(Name) then Exit;
// Shadow 28.11.2006
   if Tnt_WideUpperCase(WideChangeFileExt(WideExtractFileName(Name),WideExtractFileExt(Files[0].Name))) <>
      Tnt_WideUpperCase(WideExtractFileName(Files[0].Name)) then Continue;
   if not TryStrToInt(Copy(WideExtractFileExt(Name),2,MaxInt),n) then Continue;
  until n>1;
  Result:=OpenVolume(n);
end;

constructor TMyStreamReader.Create(Owner:TSevenZip; sz:Widestring; asArchive:Boolean);
begin
  inherited Create;
  arcName:=sz; arcPosition:=0; FSevenZip := Owner;
  if Assigned(FSevenZip) then FOnOpenVolume:=FSevenZip.FOnOpenVolume
  else FOnOpenVolume:=nil;
  FArchive:=asArchive;
  FMultivolume:=FALSE;

  SetLength(Files,1);
  Files[0].Name:=arcName;
  Files[0].Handle:=Tnt_CreateFileW(PWChar(Files[0].Name),GENERIC_READ,FILE_SHARE_READ,nil,OPEN_EXISTING,0,0);
  Files[0].Size:=FileSeek(Files[0].Handle,int64(0),soFromEnd);
  Files[0].OnRemovableDrive:=DriveIsRemovable(Copy(WideExtractFilePath(Files[0].Name),1,2));

  if not FArchive then
    arcSize:=Files[0].Size
  else arcSize := 0;
end;

destructor TMyStreamReader.Destroy;
var
  i: Integer;
begin
  if MyLastError<>ERROR_SUCCESS then
    fSevenZip.LastError:=MyLastError;                          //FHO 22.01.2007
  for i:=0 to Length(Files)-1 do
    if Files[ i ].Handle <> INVALID_HANDLE_VALUE then begin  //FHO 20.01.2007
      FileClose( Files[ i ].Handle );
      Files[ i ].Name:='';                                       //FHO 20.01.2007
    end;
  SetLength( Files, 0 );
  inherited;
end;

{============ TMyStreamWriter =================================================}

function TMyStreamWriter.Write( const Data; Size: DWORD; ProcessedSize: PDWORD ): Integer; stdcall;
var Written: DWORD;
begin
  FileSeek( Files.Handle, arcPosition, soFromBeginning );
  if not WriteFile( Files.Handle, Data, Size, Written, nil ) then begin
    MyLastError:=GetLastError;                              //FHO 22.01.2007
    Written := 0;
  end;

  Inc( arcPosition, Written );
  if arcPosition > arcSize then arcSize := arcPosition;
  if Assigned( ProcessedSize ) then ProcessedSize^ := Written;
  if MyLastError=0 then                                       //FHO 22.01.2007
    Result := S_OK
  else
    Result := S_FALSE;
end;

function TMyStreamWriter.Seek( Offset: Int64; SeekOrigin: DWORD; NewPosition: PInt64 ): Integer; stdcall;
begin
  case SeekOrigin of
    soFromBeginning: arcPosition := Offset;
    soFromCurrent: arcPosition := arcPosition + Offset;
    soFromEnd: arcPosition := arcSize + Offset;
  end;
  if arcPosition > arcSize then arcSize := arcPosition;
  if newPosition <> nil then newPosition^ := arcPosition;
  Result := S_OK;
end;

function TMyStreamWriter.SetSize( newSize: Int64 ): Integer; stdcall;
begin
  Result := S_FALSE;
end;

destructor TMyStreamWriter.Destroy;
begin
  if Assigned(FPLastError) and
    (MyLastError<>ERROR_SUCCESS) then                          //FHO 22.01.2007
    FPLastError^:=MyLastError;                                 //FHO 22.01.2007
    FileClose( Files.Handle );                            //FHO 17.01.2007
    Files.Name:='';                                       //FHO 17.01.2007
  inherited;
end;

function TMyStreamWriter.CreateNewFile: Boolean;
begin
  Files.Name:=arcName;                                        //FHO 17.01.2007
  Files.Handle := Tnt_CreateFileW( PwideChar( arcName ), GENERIC_READ or GENERIC_WRITE, FILE_SHARE_READ, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0 );

  Result := Files.Handle <> INVALID_HANDLE_VALUE;
end;

constructor TMyStreamWriter.Create(PLastError:PInteger; sz: Widestring);
begin
  inherited Create;
  FPLastError:=PLastError;                                     //FHO 22.01.2007
  arcName := sz;
  arcPosition := 0;
  arcSize := 0;
  if not CreateNewFile then Abort;
end;


//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
//-------------------End SevenZip Interface -------------------------------------------------
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------
//-----------------Start SevenZip VCL-------------------------------------------------------
//------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------
//constructor destructor
//------------------------------------------------------------------------------------------------
constructor TSevenZip.Create( AOwner: TComponent ; ArcType:WideString );
var i:integer;
begin
  inherited Create( AOwner );
  ffiles := TWStringList.Create;
  FNumberOfFiles := -1;
  FPassword := '';
  FExtrOutName:='';
  FMainCancel := False;
  FCreateObject := nil;
  if F7zaLibh <> 0 then begin                                   //FHO 25.01.2007
    @FCreateObject := GetProcAddress( F7zaLibh, 'CreateObject' );
    if Assigned(FCreateObject) then begin
      i:=checkinfo(MediaType,ArcType);  
      FCreateObject(@CLSID_CFormat[i],@IID_IInArchive,inA);
    end;
  end;
end;

destructor TSevenzip.Destroy;
begin
//jjw 18.10.2006
  inA := nil;
  ffiles.Clear;
  ffiles.Free;

  inherited;
end;
//------------------------------------------------------------------------------------------------
//End constructor destructor
//------------------------------------------------------------------------------------------------

(*
function TSevenZip.GetIndexByFilename( FileToExtract: Widestring ): Integer;
var
  n: Integer;
  w: DWORD;
  fnameprop: PROPVARIANT;
  fileInArchive: widestring;
  ms: TMyStreamReader;
begin
  try
    Result := -1;
    ms := TMyStreamReader.Create( Self, FSevenZipFileName, TRUE );
    inA.Close;
    inA.Open( ms, nil, nil );
    inA.GetNumberOfItems( w ); //1..end
    FileToExtract := UppercaseW_( FileToExtract );
    for n := 0 to w-1 do begin
      fnameprop.vt := VT_EMPTY;
      inA.GetProperty( n, kpidPath, fnameprop );
      fileInArchive := UppercaseW_( OleStrToString( fnameprop.bstrVal ) );
      if ( fileInArchive = FileToExtract ) then begin
        Result := n;
        Break;
      end;
    end;
  finally
    inA.close;
  end
end;
*)

// ZSA 21.02.2006 -- By splitting GetIndexByFilename into two parts allow
//	the Extract function to translate filenames into indices correctly
//	without closing 'inA'
function TSevenZip.InternalGetIndexByFilename( FileToExtract: Widestring ): Integer;
var n: Integer; w: DWORD; fnameprop: PROPVARIANT; fileInArchive: widestring;
begin
  Result := -1;
  inA.GetNumberOfItems( w ); //1..end
  FileToExtract := Tnt_WideUpperCase( FileToExtract );
  for n := 0 to w-1 do begin
    fnameprop.vt := VT_EMPTY;
    inA.GetProperty( n, kpidPath, fnameprop );
    fileInArchive := Tnt_WideUpperCase( fnameprop.bstrVal  );
    if ( fileInArchive = FileToExtract ) then begin
      Result := n;
      Break;
    end;
  end;
end;

function TSevenZip.List(q:boolean):integer;
var ms:TMyStreamReader; updateOpenCallback:TmyArchiveOpenCallback;
    i:integer; fileCount:dword; path,Encrypted,size,attr:PROPVARIANT;
begin
  if not Assigned(inA) then begin Result:=-1; exit; end;
  try
    Ffiles.Clear; FNumberOfFiles:=-1;
    ms:=TMyStreamReader.Create(Self,FSevenZipFileName,true);
    inA.Close;
    updateOpenCallback:=TMyArchiveOpenCallback.Create(self);
    if inA.Open(ms,nil,updateOpencallback)<>0 then begin
      Result:=-1; exit; //don't open file or wrong password
    end;

    inA.GetNumberOfItems(fileCount);
    FNumberOfFiles:=fileCount;

    for i:=0 to fileCount-1 do begin
      path.vt:=VT_EMPTY; Encrypted.vt:=VT_EMPTY;
      size.vt:=VT_EMPTY; attr.vt:=VT_EMPTY;
      inA.GetProperty(i,kpidPath,path);
      inA.GetProperty(i,kpidSize,size);
      inA.GetProperty(i,kpidAttributes,attr);
      inA.GetProperty(i,kpidEncrypted,Encrypted);
      try    // isn't a directory or 0byte file
        if not (((attr.uiVal and $10)<>0) or (size.uhVal.QuadPart=0)) then ffiles.Add(path.bstrVal)
        else dec(FNumberOfFiles);
        if Encrypted.boolVal and (FPassword='') then WideInputQuery(LOCstr_SetPW_Caption,WideExtractFileName(SZFileName),FPassword);
        if q then break;
      except
        dec(FNumberOfFiles);
      end;
    end;
    Result := FNumberOfFiles;
  finally
   ina.Close;
   FMainCancel := False;
  end;
end;

function TSevenZip.Extract( TestArchive:Boolean=False ): Integer;
var updateCallback: TMyArchiveExtractCallback;
  updateOpenCallback: TmyArchiveOpenCallback;
  ms: TMyStreamReader;
  filesDW: array of DWORD; //index array of Filename to be extract
  Filestoex,w: DWORD; //count of files to be extract finally actually
  i,fileIndex,n: Integer;
begin
  if not Assigned(inA) then begin Result:=-1; exit; end;
  try
    ms:=TMyStreamReader.Create(Self,FSevenZipFileName,true);
    inA.Close;
    updateOpenCallback:=TMyArchiveOpenCallback.Create(self);
    if inA.Open(ms,nil,updateOpenCallback)<>0 then begin
      Result:=-1; exit; //don't open file or wrong password
    end;

    inA.GetNumberOfItems( w ); //1..end
    dec( w ); //Starting with 0..end-1

    n:=0;
    if FFiles.Count>0 then begin
      SetLength(filesDW,Ffiles.Count);
      for i:=0 to FFiles.count-1 do begin
        if not TryStrToInt(Ffiles.Strings[i],fileIndex) then
          fileIndex:=InternalGetIndexByFilename(Ffiles.Strings[i]);//don't need close ms
          //fileIndex:=GetINdexbyFilename( Ffiles.WStrings[ i ] );
        if (fileIndex<0) or (abs(fileIndex)>abs(w)) then begin
          Result:=-1; Exit;
        end;
        filesDW[n]:=fileIndex; Inc(n);
      end; // For i := 0
      Filestoex:=n;
    end
    else FilestoEx:=$FFFFFFFF; //   extract all files, FFiles.Count must be 0

    SetLength( filesDW, n );

    // filesdw must be sorted asc
    if length(filesdw)>1 then SortDWord(filesDW,low(filesdw),High(filesdw));

    updatecallback := TMyArchiveExtractCallback.Create( self );
    updatecallback.FExtractDirectory := WideIncludeTrailingPathDelimiter( Fextrbasedir );
    updatecallback.FFilestoextract   := ffiles.Count; //with all files ffiles.count = 0, thats ok
    updatecallback.FAllFilesExt      := false;        //Stop extracting if no more files to extract
    updatecallback.FLastFileToExt    := false;        //only 1 more to extact

    result:=inA.Extract(@filesDW[0],Filestoex,Integer(TestArchive),updatecallback);
  finally
    inA.close;
	  FMainCancel := False;
    FExtrOutName:= '';
  end;
end;

procedure TSevenZip.SetLastError(const Value: Integer);
begin
  FLastError := Value;
end;

//------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------
//-----------------End SevenZip VCL---------------------------------------------------------
//------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------

end.


