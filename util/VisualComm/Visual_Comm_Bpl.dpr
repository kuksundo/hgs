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

program Visual_Comm_Bpl;

uses
  Forms,
  About in 'About.pas' {AboutF},
  frmConst in 'frmConst.pas',
  UtilUnit in 'util\UtilUnit.pas',
  CopyData in 'util\CopyData.pas',
  ConsoleDebug in 'util\ConsoleDebug.pas',
  EasterEgg in 'util\EasterEgg.pas',
  EZLines in 'util\EZLines.pas',
  PackageList in 'PackageList.pas' {ProjOption},
  frmSDIDocBplUnit in 'frmSDIDocBplUnit.pas' {frmSDIDoc},
  HiMECSComponentCollect in '..\HiMECS\Application\Source\Common\HiMECSComponentCollect.pas',
  pjhLogicPanelUnitNoBpl in 'Component\pjhLogicPanelUnitNoBpl.pas',
  frmDocInterface in 'frmDocInterface.pas',
  pjhOIInterface in 'pjhOIInterface.pas',
  frmMainInterface in 'frmMainInterface.pas',
  frmDocBplUnit in 'frmDocBplUnit.pas' {frmDoc},
  frmSDIDocPanelBplUnit in 'frmSDIDocPanelBplUnit.pas' {frmSDIDocPanel},
  frmMainBplUnit in 'frmMainBplUnit.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Logic designer';
  //Application.ShowMainForm := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
