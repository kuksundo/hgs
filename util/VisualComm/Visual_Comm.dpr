{*******************************************************}
{                                                       }
{       Report Designer                                 }
{       Extension Library example of                    }
{       TELDesigner, TELDesignPanel                     }
{                                                       }
{       (c) 2001, Balabuyev Yevgeny                     }
{       E-mail: stalcer@rambler.ru                      }
{                                                       }
{*******************************************************}

program Visual_Comm;

uses
  Forms,
  frmDocUnit in 'frmDocUnit.pas' {frmDoc},
  pjhObjectInspector in 'pjhObjectInspector.pas' {frmProps},
  About in 'About.pas' {AboutF},
  frmConst in 'frmConst.pas',
  UtilUnit in 'util\UtilUnit.pas',
  CopyData in 'util\CopyData.pas',
  ConsoleDebug in 'util\ConsoleDebug.pas',
  EasterEgg in 'util\EasterEgg.pas',
  EZLines in 'util\EZLines.pas',
  PackageList in 'PackageList.pas' {ProjOption},
  HiMECSComponentCollect in '..\HiMECS\Application\Source\Common\HiMECSComponentCollect.pas',
  pjhLogicPanelUnit in 'Component\pjhLogicPanelUnit.pas',
  frmMainUnit in 'frmMainUnit.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Logic designer';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmProps, frmProps);
  Application.Run;
end.
