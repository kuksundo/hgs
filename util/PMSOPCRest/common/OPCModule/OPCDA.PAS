
{*******************************************************}
{                                                       }
{       OPC Data Access 2.0                             }
{                                                       }
{       Delphi conversion supplied by                   }
{       OPC Programmers' Connection                     }
{       http://dspace.dial.pipex.com/opc/               }
{       mailto:opc@dial.pipex.com                       }
{                                                       }
{*******************************************************}

unit OPCDA;

// ************************************************************************ //
// Type Lib: OPCProxy.dll
// IID\LCID: {B28EEDB2-AC6F-11D1-84D5-00608CB8A7E9}\0
// ************************************************************************ //

interface

uses
  Windows, ActiveX, SysUtils;

// *********************************************************************//
// GUIDS declared in the TypeLibrary                                    //
// *********************************************************************//
const
  LIBID_OPCDA: TGUID = '{B28EEDB2-AC6F-11D1-84D5-00608CB8A7E9}';
  IID_IOPCServer: TIID = '{39C13A4D-011E-11D0-9675-0020AFD8ADB3}';
  IID_IOPCServerPublicGroups: TIID = '{39C13A4E-011E-11D0-9675-0020AFD8ADB3}';
  IID_IOPCBrowseServerAddressSpace: TIID =
                                      '{39C13A4F-011E-11D0-9675-0020AFD8ADB3}';
  IID_IEnumString: TIID = '{00000101-0000-0000-C000-000000000046}';
  IID_IOPCGroupStateMgt: TIID = '{39C13A50-011E-11D0-9675-0020AFD8ADB3}';
  IID_IOPCPublicGroupStateMgt: TIID = '{39C13A51-011E-11D0-9675-0020AFD8ADB3}';
  IID_IOPCSyncIO: TIID = '{39C13A52-011E-11D0-9675-0020AFD8ADB3}';
  IID_IOPCAsyncIO: TIID = '{39C13A53-011E-11D0-9675-0020AFD8ADB3}';
  IID_IOPCItemMgt: TIID = '{39C13A54-011E-11D0-9675-0020AFD8ADB3}';
  IID_IEnumOPCItemAttributes: TIID = '{39C13A55-011E-11D0-9675-0020AFD8ADB3}';
  IID_IOPCDataCallback: TIID = '{39C13A70-011E-11D0-9675-0020AFD8ADB3}';
  IID_IOPCAsyncIO2: TIID = '{39C13A71-011E-11D0-9675-0020AFD8ADB3}';
  IID_IOPCItemProperties: TIID = '{39C13A72-011E-11D0-9675-0020AFD8ADB3}';

  CATID_OPCDAServer10: TGUID = '{63D5F430-CFE4-11d1-B2C8-0060083BA1FB}';
  CATID_OPCDAServer20: TGUID = '{63D5F432-CFE4-11d1-B2C8-0060083BA1FB}';

type
  TOleEnum = type Integer;

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                  //
// *********************************************************************//
type
  OPCDATASOURCE = TOleEnum;
const
  OPC_DS_CACHE  = 1;
  OPC_DS_DEVICE = 2;

type
  OPCBROWSETYPE = TOleEnum;
const
  OPC_BRANCH = 1;
  OPC_LEAF   = 2;
  OPC_FLAT   = 3;

type
  OPCNAMESPACETYPE = TOleEnum;
const
  OPC_NS_HIERARCHIAL = 1;
  OPC_NS_FLAT        = 2;

type
  OPCBROWSEDIRECTION = TOleEnum;
const
  OPC_BROWSE_UP   = 1;
  OPC_BROWSE_DOWN = 2;
  OPC_BROWSE_TO   = 3;

const
  OPC_READABLE = 1;
  OPC_WRITABLE = 2;

type
  OPCEUTYPE = TOleEnum;
const
  OPC_NOENUM     = 0;
  OPC_ANALOG     = 1;
  OPC_ENUMERATED = 2;

type
  OPCSERVERSTATE = TOleEnum;
const
  OPC_STATUS_RUNNING   = 1;
  OPC_STATUS_FAILED    = 2;
  OPC_STATUS_NOCONFIG  = 3;
  OPC_STATUS_SUSPENDED = 4;
  OPC_STATUS_TEST      = 5;

type
  OPCENUMSCOPE = TOleEnum;
const
  OPC_ENUM_PRIVATE_CONNECTIONS = 1;
  OPC_ENUM_PUBLIC_CONNECTIONS  = 2;
  OPC_ENUM_ALL_CONNECTIONS     = 3;
  OPC_ENUM_PRIVATE             = 4;
  OPC_ENUM_PUBLIC              = 5;
  OPC_ENUM_ALL                 = 6;

// *********************************************************************//
// OPC Quality flags                                                    //
// *********************************************************************//
// Masks for extracting quality subfields
// (note 'status' mask also includes 'Quality' bits)
  OPC_QUALITY_MASK           = $C0;
  OPC_STATUS_MASK            = $FC;
  OPC_LIMIT_MASK             = $03;

// Values for QUALITY_MASK bit field
  OPC_QUALITY_BAD            = $00;
  OPC_QUALITY_UNCERTAIN      = $40;
  OPC_QUALITY_GOOD           = $C0;

// STATUS_MASK Values for Quality = BAD
  OPC_QUALITY_CONFIG_ERROR   = $04;
  OPC_QUALITY_NOT_CONNECTED  = $08;
  OPC_QUALITY_DEVICE_FAILURE = $0C;
  OPC_QUALITY_SENSOR_FAILURE = $10;
  OPC_QUALITY_LAST_KNOWN     = $14;
  OPC_QUALITY_COMM_FAILURE   = $18;
  OPC_QUALITY_OUT_OF_SERVICE = $1C;

// STATUS_MASK Values for Quality = UNCERTAIN
  OPC_QUALITY_LAST_USABLE    = $44;
  OPC_QUALITY_SENSOR_CAL     = $50;
  OPC_QUALITY_EGU_EXCEEDED   = $54;
  OPC_QUALITY_SUB_NORMAL     = $58;

// STATUS_MASK Values for Quality = GOOD
  OPC_QUALITY_LOCAL_OVERRIDE = $D8;

// Values for Limit Bitfield
  OPC_LIMIT_OK    = $00;
  OPC_LIMIT_LOW   = $01;
  OPC_LIMIT_HIGH  = $02;
  OPC_LIMIT_CONST = $03;

// *********************************************************************//
// Property ID Code Assignments:                                        //
//   0000 to 4999 are reserved for OPC use                              //
// *********************************************************************//
  OPC_PROP_CDT            = 1;
  OPC_PROP_VALUE          = 2;
  OPC_PROP_QUALITY        = 3;
  OPC_PROP_time           = 4;
  OPC_PROP_RIGHTS         = 5;
  OPC_PROP_SCANRATE       = 6;

  OPC_PROP_UNIT           = 100;
  OPC_PROP_DESC           = 101;
  OPC_PROP_HIEU           = 102;
  OPC_PROP_LOEU           = 103;
  OPC_PROP_HIRANGE        = 104;
  OPC_PROP_LORANGE        = 105;
  OPC_PROP_CLOSE          = 106;
  OPC_PROP_OPEN           = 107;
  OPC_PROP_TIMEZONE       = 108;

  OPC_PROP_FGC            = 200;
  OPC_PROP_BGC            = 201;
  OPC_PROP_BLINK          = 202;
  OPC_PROP_BMP            = 203;
  OPC_PROP_SND            = 204;
  OPC_PROP_HTML           = 205;
  OPC_PROP_AVI            = 206;

  OPC_PROP_ALMSTAT        = 300;
  OPC_PROP_ALMHELP        = 301;
  OPC_PROP_ALMAREAS       = 302;
  OPC_PROP_ALMPRIMARYAREA = 303;
  OPC_PROP_ALMCONDITION   = 304;
  OPC_PROP_ALMLIMIT       = 305;
  OPC_PROP_ALMDB          = 306;
  OPC_PROP_ALMHH          = 307;
  OPC_PROP_ALMH           = 308;
  OPC_PROP_ALML           = 309;
  OPC_PROP_ALMLL          = 310;
  OPC_PROP_ALMROC         = 311;
  OPC_PROP_ALMDEV         = 312;
  
type

// *********************************************************************//
// Forward declaration of interfaces defined in Type Library            //
// *********************************************************************//
  IOPCServer = interface;
  IOPCServerPublicGroups = interface;
  IOPCBrowseServerAddressSpace = interface;
  IOPCGroupStateMgt = interface;
  IOPCPublicGroupStateMgt = interface;
  IOPCSyncIO = interface;
  IOPCAsyncIO = interface;
  IOPCItemMgt = interface;
  IEnumOPCItemAttributes = interface;
  IOPCDataCallback = interface;
  IOPCAsyncIO2 = interface;
  IOPCItemProperties = interface;

// *********************************************************************//
// Declaration of structures, unions and aliases.                       //
// *********************************************************************//
  OPCHANDLE = DWORD;
  POPCHANDLE = ^OPCHANDLE;
  OPCHANDLEARRAY = array[0..65535] of OPCHANDLE;
  POPCHANDLEARRAY = ^OPCHANDLEARRAY;

  PVarType = ^TVarType;
  TVarTypeList = array[0..65535] of TVarType;
  PVarTypeList = ^TVarTypeList;
  POleVariant = ^OleVariant;
  OleVariantArray = array[0..65535] of OleVariant;
  POleVariantArray = ^OleVariantArray;
  PLCID = ^TLCID;
  WORDARRAY = array[0..65535] of Word;
  PWORDARRAY = ^WORDARRAY;
  DWORDARRAY = array[0..65535] of DWORD;
  PDWORDARRAY = ^DWORDARRAY;
  TFileTimeArray = array[0..65535] of TFileTime;
  PFileTimeArray = ^TFileTimeArray;

  OPCGROUPHEADER = record
    dwSize:               DWORD;
    dwItemCount:          DWORD;
    hClientGroup:         OPCHANDLE;
    dwTransactionID:      DWORD;
    hrStatus:             HResult;
  end;
  POPCGROUPHEADER = ^OPCGROUPHEADER;

  OPCITEMHEADER1 = record
    hClient:              OPCHANDLE;
    dwValueOffset:        DWORD;
    wQuality:             Word;
    wReserved:            Word;
    ftTimeStampItem:      TFileTime;
  end;
  POPCITEMHEADER1 = ^OPCITEMHEADER1;
  OPCITEMHEADER1ARRAY = array[0..65535] of OPCITEMHEADER1;
  POPCITEMHEADER1ARRAY = ^OPCITEMHEADER1ARRAY;

  OPCITEMHEADER2 = record
    hClient:              OPCHANDLE;
    dwValueOffset:        DWORD;
    wQuality:             Word;
    wReserved:            Word;
  end;
  POPCITEMHEADER2 = ^OPCITEMHEADER2;
  OPCITEMHEADER2ARRAY = array[0..65535] of OPCITEMHEADER2;
  POPCITEMHEADER2ARRAY = ^OPCITEMHEADER2ARRAY;

  OPCGROUPHEADERWRITE = record
    dwItemCount:          DWORD;
    hClientGroup:         OPCHANDLE;
    dwTransactionID:      DWORD;
    hrStatus:             HResult;
  end;
  POPCGROUPHEADERWRITE = ^OPCGROUPHEADERWRITE;

  OPCITEMHEADERWRITE = record
    hClient:              OPCHANDLE;
    dwError:              HResult;
  end;
  POPCITEMHEADERWRITE = ^OPCITEMHEADERWRITE;
  OPCITEMHEADERWRITEARRAY = array[0..65535] of OPCITEMHEADERWRITE;
  POPCITEMHEADERWRITEARRAY = ^OPCITEMHEADERWRITEARRAY;

  OPCITEMSTATE = record
    hClient:              OPCHANDLE;
    ftTimeStamp:          TFileTime;
    wQuality:             Word;
    wReserved:            Word;
    vDataValue:           OleVariant;
  end;
  POPCITEMSTATE = ^OPCITEMSTATE;
  OPCITEMSTATEARRAY = array[0..65535] of OPCITEMSTATE;
  POPCITEMSTATEARRAY = ^OPCITEMSTATEARRAY;

  OPCSERVERSTATUS = record
    ftStartTime:          TFileTime;
    ftCurrentTime:        TFileTime;
    ftLastUpdateTime:     TFileTime;
    dwServerState:        OPCSERVERSTATE;
    dwGroupCount:         DWORD;
    dwBandWidth:          DWORD;
    wMajorVersion:        Word;
    wMinorVersion:        Word;
    wBuildNumber:         Word;
    wReserved:            Word;
    szVendorInfo:         POleStr;
  end;
  POPCSERVERSTATUS = ^OPCSERVERSTATUS;

  OPCITEMDEF = record
    szAccessPath:         POleStr;
    szItemID:             POleStr;
    bActive:              BOOL;
    hClient:              OPCHANDLE;
    dwBlobSize:           DWORD;
    pBlob:                PByteArray;
    vtRequestedDataType:  TVarType;
    wReserved:            Word;
  end;
  POPCITEMDEF = ^OPCITEMDEF;

  OPCITEMATTRIBUTES = record
    szAccessPath:         POleStr;
    szItemID:             POleStr;
    bActive:              BOOL;
    hClient:              OPCHANDLE;
    hServer:              OPCHANDLE;
    dwAccessRights:       DWORD;
    dwBlobSize:           DWORD;
    pBlob:                PByteArray;
    vtRequestedDataType:  TVarType;
    vtCanonicalDataType:  TVarType;
    dwEUType:             OPCEUTYPE;
    vEUInfo:              OleVariant;
  end;
  POPCITEMATTRIBUTES = ^OPCITEMATTRIBUTES;
  OPCITEMATTRIBUTESARRAY = array[0..65535] of OPCITEMATTRIBUTES;
  POPCITEMATTRIBUTESARRAY = ^OPCITEMATTRIBUTESARRAY;

  OPCITEMRESULT = record
    hServer:              OPCHANDLE;
    vtCanonicalDataType:  TVarType;
    wReserved:            Word;
    dwAccessRights:       DWORD;
    dwBlobSize:           DWORD;
    pBlob:                PByteArray;
  end;
  POPCITEMRESULT = ^OPCITEMRESULT;
  OPCITEMRESULTARRAY = array[0..65535] of OPCITEMRESULT;
  POPCITEMRESULTARRAY = ^OPCITEMRESULTARRAY;

// *********************************************************************//
// Interface: IOPCServer
// GUID:      {39C13A4D-011E-11D0-9675-0020AFD8ADB3}
// *********************************************************************//
  IOPCServer = interface(IUnknown)
    ['{39C13A4D-011E-11D0-9675-0020AFD8ADB3}']
    function AddGroup(
            szName:                     POleStr;
            bActive:                    BOOL;
            dwRequestedUpdateRate:      DWORD;
            hClientGroup:               OPCHANDLE;
            pTimeBias:                  PLongint;
            pPercentDeadband:           PSingle;
            dwLCID:                     DWORD;
      out   phServerGroup:              OPCHANDLE;
      out   pRevisedUpdateRate:         DWORD;
      const riid:                       TIID;
      out   ppUnk:                      IUnknown): HResult; stdcall;
    function GetErrorString(
            dwError:                    HResult;
            dwLocale:                   TLCID;
      out   ppString:                   POleStr): HResult; stdcall;
    function GetGroupByName(
            szName:                     POleStr;
      const riid:                       TIID;
      out   ppUnk:                      IUnknown): HResult; stdcall;
    function GetStatus(
      out   ppServerStatus:             POPCSERVERSTATUS): HResult; stdcall;
    function RemoveGroup(
            hServerGroup:               OPCHANDLE;
            bForce:                     BOOL): HResult; stdcall;
    function CreateGroupEnumerator(
            dwScope:                    OPCENUMSCOPE;
      const riid:                       TIID;
      out   ppUnk:                      IUnknown): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IOPCServerPublicGroups
// GUID:      {39C13A4E-011E-11D0-9675-0020AFD8ADB3}
// *********************************************************************//
  IOPCServerPublicGroups = interface(IUnknown)
    ['{39C13A4E-011E-11D0-9675-0020AFD8ADB3}']
    function GetPublicGroupByName(
            szName:                     POleStr;
      const riid:                       TIID;
      out   ppUnk:                      IUnknown): HResult; stdcall;
    function RemovePublicGroup(
            hServerGroup:               OPCHANDLE;
            bForce:                     BOOL): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IOPCBrowseServerAddressSpace
// GUID:      {39C13A4F-011E-11D0-9675-0020AFD8ADB3}
// *********************************************************************//
  IOPCBrowseServerAddressSpace = interface(IUnknown)
    ['{39C13A4F-011E-11D0-9675-0020AFD8ADB3}']
    function QueryOrganization(
      out   pNameSpaceType:             OPCNAMESPACETYPE): HResult; stdcall;
    function ChangeBrowsePosition(
            dwBrowseDirection:          OPCBROWSEDIRECTION;
            szString:                   POleStr): HResult; stdcall;
    function BrowseOPCItemIDs(
            dwBrowseFilterType:         OPCBROWSETYPE;
            szFilterCriteria:           POleStr;
            vtDataTypeFilter:           TVarType;
            dwAccessRightsFilter:       DWORD;
      out   ppIEnumString:              IEnumString): HResult; stdcall;
    function GetItemID(
            szItemDataID:               POleStr;
      out   szItemID:                   POleStr): HResult; stdcall;
    function BrowseAccessPaths(
            szItemID:                   POleStr;
      out   ppIEnumString:              IEnumString): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IOPCGroupStateMgt
// GUID:      {39C13A50-011E-11D0-9675-0020AFD8ADB3}
// *********************************************************************//
  IOPCGroupStateMgt = interface(IUnknown)
    ['{39C13A50-011E-11D0-9675-0020AFD8ADB3}']
    function GetState(
      out   pUpdateRate:                DWORD;
      out   pActive:                    BOOL;
      out   ppName:                     POleStr;
      out   pTimeBias:                  Longint;
      out   pPercentDeadband:           Single;
      out   pLCID:                      TLCID;
      out   phClientGroup:              OPCHANDLE;
      out   phServerGroup:              OPCHANDLE): HResult; stdcall;
    function SetState(
            pRequestedUpdateRate:       PDWORD;
      out   pRevisedUpdateRate:         DWORD;
            pActive:                    PBOOL;
            pTimeBias:                  PLongint;
            pPercentDeadband:           PSingle;
            pLCID:                      PLCID;
            phClientGroup:              POPCHANDLE): HResult; stdcall;
    function SetName(
            szName:                     POleStr): HResult; stdcall;
    function CloneGroup(
            szName:                     POleStr;
      const riid:                       TIID;
      out   ppUnk:                      IUnknown): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IOPCPublicGroupStateMgt
// GUID:      {39C13A51-011E-11D0-9675-0020AFD8ADB3}
// *********************************************************************//
  IOPCPublicGroupStateMgt = interface(IUnknown)
    ['{39C13A51-011E-11D0-9675-0020AFD8ADB3}']
    function GetState(
      out   pPublic:                    BOOL): HResult; stdcall;
    function MoveToPublic: HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IOPCSyncIO
// GUID:      {39C13A52-011E-11D0-9675-0020AFD8ADB3}
// *********************************************************************//
  IOPCSyncIO = interface(IUnknown)
    ['{39C13A52-011E-11D0-9675-0020AFD8ADB3}']
    function Read(
            dwSource:                   OPCDATASOURCE;
            dwCount:                    DWORD;
            phServer:                   POPCHANDLE;
      out   ppItemValues:               POPCITEMSTATEARRAY;
      out   ppErrors:                   PResultList): HResult; stdcall;
    function Write(
            dwCount:                    DWORD;
            phServer:                   POPCHANDLE;
            pItemValues:                POleVariant;
      out   ppErrors:                   PResultList): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IOPCAsyncIO
// GUID:      {39C13A53-011E-11D0-9675-0020AFD8ADB3}
// *********************************************************************//
  IOPCAsyncIO = interface(IUnknown)
    ['{39C13A53-011E-11D0-9675-0020AFD8ADB3}']
    function Read(
            dwConnection:               DWORD;
            dwSource:                   OPCDATASOURCE;
            dwCount:                    DWORD;
            phServer:                   POPCHANDLE;
      out   pTransactionID:             DWORD;
      out   ppErrors:                   PResultList): HResult; stdcall;
    function Write(
            dwConnection:               DWORD;
            dwCount:                    DWORD;
            phServer:                   POPCHANDLE;
            pItemValues:                POleVariant;
      out   pTransactionID:             DWORD;
      out   ppErrors:                   PResultList): HResult; stdcall;
    function Refresh(
            dwConnection:               DWORD;
            dwSource:                   OPCDATASOURCE;
      out   pTransactionID:             DWORD): HResult; stdcall;
    function Cancel(
            dwTransactionID:            DWORD): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IOPCItemMgt
// GUID:      {39C13A54-011E-11D0-9675-0020AFD8ADB3}
// *********************************************************************//
  IOPCItemMgt = interface(IUnknown)
    ['{39C13A54-011E-11D0-9675-0020AFD8ADB3}']
    function AddItems(
            dwCount:                    DWORD;
            pItemArray:                 POPCITEMDEF;
      out   ppAddResults:               POPCITEMRESULTARRAY;
      out   ppErrors:                   PResultList): HResult; stdcall;
    function ValidateItems(
            dwCount:                    DWORD;
            pItemArray:                 POPCITEMDEF;
            bBlobUpdate:                BOOL;
      out   ppValidationResults:        POPCITEMRESULTARRAY;
      out   ppErrors:                   PResultList): HResult; stdcall;
    function RemoveItems(
            dwCount:                    DWORD;
            phServer:                   POPCHANDLE;
      out   ppErrors:                   PResultList): HResult; stdcall;
    function SetActiveState(
            dwCount:                    DWORD;
            phServer:                   POPCHANDLE;
            bActive:                    BOOL;
      out   ppErrors:                   PResultList): HResult; stdcall;
    function SetClientHandles(
            dwCount:                    DWORD;
            phServer:                   POPCHANDLE;
            phClient:                   POPCHANDLE;
      out   ppErrors:                   PResultList): HResult; stdcall;
    function SetDatatypes(
            dwCount:                    DWORD;
            phServer:                   POPCHANDLE;
            pRequestedDatatypes:        PVarType;
      out   ppErrors:                   PResultList): HResult; stdcall;
    function CreateEnumerator(
      const riid:                       TIID;
      out   ppUnk:                      IUnknown): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IEnumOPCItemAttributes
// GUID:      {39C13A55-011E-11D0-9675-0020AFD8ADB3}
// *********************************************************************//
  IEnumOPCItemAttributes = interface(IUnknown)
    ['{39C13A55-011E-11D0-9675-0020AFD8ADB3}']
    function Next(
            celt:                       ULONG;
      out   ppItemArray:                POPCITEMATTRIBUTESARRAY;
      out   pceltFetched:               ULONG): HResult; stdcall;
    function Skip(
            celt:                       ULONG): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(
      out   ppEnumItemAttributes:       IEnumOPCItemAttributes):
            HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IOPCDataCallback
// GUID:      {39C13A70-011E-11D0-9675-0020AFD8ADB3}
// *********************************************************************//
  IOPCDataCallback = interface(IUnknown)
    ['{39C13A70-011E-11D0-9675-0020AFD8ADB3}']
    function OnDataChange(
            dwTransid:                  DWORD;
            hGroup:                     OPCHANDLE;
            hrMasterquality:            HResult;
            hrMastererror:              HResult;
            dwCount:                    DWORD;
            phClientItems:              POPCHANDLE;
            pvValues:                   POleVariant;
            pwQualities:                PWORD;
            pftTimeStamps:              PFileTime;
            pErrors:                    PHResult): HResult; stdcall;
    function OnReadComplete(
            dwTransid:                  DWORD;
            hGroup:                     OPCHANDLE;
            hrMasterquality:            HResult;
            hrMastererror:              HResult;
            dwCount:                    DWORD;
            phClientItems:              POPCHANDLE;
            pvValues:                   POleVariant;
            pwQualities:                PWORD;
            pftTimeStamps:              PFileTime;
            pErrors:                    PHResult): HResult; stdcall;
    function OnWriteComplete(
            dwTransid:                  DWORD;
            hGroup:                     OPCHANDLE;
            hrMastererr:                HResult;
            dwCount:                    DWORD;
            pClienthandles:             POPCHANDLE;
            pErrors:                    PHResult): HResult; stdcall;
    function OnCancelComplete(
            dwTransid:                  DWORD;
            hGroup:                     OPCHANDLE): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IOPCAsyncIO2
// GUID:      {39C13A71-011E-11D0-9675-0020AFD8ADB3}
// *********************************************************************//
  IOPCAsyncIO2 = interface(IUnknown)
    ['{39C13A71-011E-11D0-9675-0020AFD8ADB3}']
    function Read(
            dwCount:                    DWORD;
            phServer:                   POPCHANDLE;
            dwTransactionID:            DWORD;
      out   pdwCancelID:                DWORD;
      out   ppErrors:                   PResultList): HResult; stdcall;
    function Write(
            dwCount:                    DWORD;
            phServer:                   POPCHANDLE;
            pItemValues:                POleVariant;
            dwTransactionID:            DWORD;
      out   pdwCancelID:                DWORD;
      out   ppErrors:                   PResultList): HResult; stdcall;
    function Refresh2(
            dwSource:                   OPCDATASOURCE;
            dwTransactionID:            DWORD;
      out   pdwCancelID:                DWORD): HResult; stdcall;
    function Cancel2(
            dwCancelID:                 DWORD): HResult; stdcall;
    function SetEnable(
            bEnable:                    BOOL): HResult; stdcall;
    function GetEnable(
      out   pbEnable:                   BOOL): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IOPCItemProperties
// GUID:      {39C13A72-011E-11D0-9675-0020AFD8ADB3}
// *********************************************************************//
  IOPCItemProperties = interface(IUnknown)
    ['{39C13A72-011E-11D0-9675-0020AFD8ADB3}']
    function QueryAvailableProperties(
            szItemID:                   POleStr;
      out   pdwCount:                   DWORD;
      out   ppPropertyIDs:              PDWORDARRAY;
      out   ppDescriptions:             POleStrList;
      out   ppvtDataTypes:              PVarTypeList): HResult; stdcall;
    function GetItemProperties(
            szItemID:                   POleStr;
            dwCount:                    DWORD;
            pdwPropertyIDs:             PDWORD;
      out   ppvData:                    POleVariantArray;
      out   ppErrors:                   PResultList): HResult; stdcall;
    function LookupItemIDs(
            szItemID:                   POleStr;
            dwCount:                    DWORD;
            pdwPropertyIDs:             PDWORD;
      out   ppszNewItemIDs:             POleStrList;
      out   ppErrors:                   PResultList): HResult; stdcall;
  end;

// Register clipboard formats for use with IDataObject / IAdviseSink
procedure OPCDARegisterClipboardFormats;

var

// OPC data stream formats
  OPCSTMFORMATDATA: UINT;
  OPCSTMFORMATDATATIME: UINT;
  OPCSTMFORMATWRITECOMPLETE: UINT;

implementation

procedure OPCDARegisterClipboardFormats;
begin
  OPCSTMFORMATDATA := RegisterClipboardFormat('OPCSTMFORMATDATA');
  OPCSTMFORMATDATATIME := RegisterClipboardFormat('OPCSTMFORMATDATATIME');
  OPCSTMFORMATWRITECOMPLETE :=
    RegisterClipboardFormat('OPCSTMFORMATWRITECOMPLETE');
end;

initialization
  OPCDARegisterClipboardFormats;

end.
