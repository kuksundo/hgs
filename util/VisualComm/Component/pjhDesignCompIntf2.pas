unit pjhDesignCompIntf2;

interface

uses
  Windows, Messages, SysUtils, Classes, vcl.Graphics, vcl.Controls, vcl.Forms,
  vcl.Dialogs, pjhClasses;

type
  IpjhDesignCompInterface2 = interface ['{A1C8E0BF-7F3A-4F1D-8297-09F570507F67}']
    //function GetpjhValues(AIndex: integer): string;
    //procedure SetpjhValues(AIndex: integer; AValue: string);
    procedure SetpjhValues2Channel(AIndex: integer; AValueX, AValueY: string);
    function GetpjhTagInfoList: TStringList;
    procedure SetpjhTagInfoList(AValue: TStringList);
    function GetpjhChannelCount: integer;
    //function GetpjhTagInfos(AIndex: integer): TpjhTagInfo;
    //procedure SetpjhTagInfos(AIndex: integer; AValue: TpjhTagInfo);

    property pjhTagInfoList: TStringList read GetpjhTagInfoList write SetpjhTagInfoList;
    //property pjhTagInfos[Idx: integer]: TpjhTagInfo read GetpjhTagInfos write SetpjhTagInfos;
    //property pjhValues[Idx: integer]: string read GetpjhValues write SetpjhValues;
    property pjhChannelCount: integer read GetpjhChannelCount;
  end;

implementation

end.
