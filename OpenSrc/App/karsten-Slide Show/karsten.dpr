(* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is karsten.dpr of Karsten Bilderschau, version 3.2.12.
 *
 * The Initial Developer of the Original Code is Matthias Muntwiler.
 * Portions created by the Initial Developer are Copyright (C) 2006
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** *)

{ $Id: karsten.dpr 148 2010-02-20 20:31:17Z hiisi $ }

{
@abstract Main program
@author matthias muntwiler <hiisi@users.sourceforge.net>
@created 1999/05/29
@cvs $Date: 2010-02-20 21:31:17 +0100 (Sa, 20 Feb 2010) $

This is the karsten main program.
It creates an invisible main window that keeps track of all open documents.
Only one instance is allowed to run in order to make sure that all COM
requests are handled in the same process space.
}
program karsten;

{%TogetherDiagram 'ModelSupport_karsten\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_karsten\karsten\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_karsten\About\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_karsten\mediaplayer\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_karsten\bildklassen\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_karsten\SchauFen\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_karsten\wallpaper\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_karsten\KarsCanv\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_karsten\sammelfen\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_karsten\SchonerConfig\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_karsten\sammlung\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_karsten\schnittstellen\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_karsten\karsmain\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_karsten\globals\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_karsten\SchauServer\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_karsten\repair\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_karsten\ssconfig\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_karsten\bildprop\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_karsten\SchonerSchau\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_karsten\thumbnails\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_karsten\sammelklassen\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_karsten\ConfigServer\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_karsten\karsten_TLB\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_karsten\dscontrol\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_karsten\autoserv\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_karsten\SchonerServer\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_karsten\karsreg\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_karsten\default.txvpck'}
{%TogetherDiagram 'ModelSupport_karsten\sammelklassen\default.txvpck'}
{%TogetherDiagram 'ModelSupport_karsten\karsten\default.txvpck'}
{%TogetherDiagram 'ModelSupport_karsten\repair\default.txvpck'}
{%TogetherDiagram 'ModelSupport_karsten\sammlung\default.txvpck'}
{%File 'karsten.tlb'}

uses
  {$ifdef madExcept}
  madExcept,
  madLinkDisAsm,
  madListModules,
  madListHardware,
  madListProcesses,
  {$endif}
  gnugettext,
  SysUtils,
  Windows,
  messages,
  Forms,
  schnittstellen in 'schnittstellen.pas',
  karsten_TLB in 'karsten_TLB.pas',
  globals in 'globals.pas',
  karsreg in 'karsreg.pas',
  comserv,
  sammelfen in 'sammelfen.pas' {CollectionForm},
  about in 'about.pas' {AboutBox},
  schaufen in 'schaufen.pas' {Schaufenster},
  sammlung in 'sammlung.pas',
  bildprop in 'bildprop.pas' {BildEigenschaftenDlg},
  karscanv in 'karscanv.pas',
  bildklassen in 'bildklassen.pas',
  sammelklassen in 'sammelklassen.pas',
  wallpaper in 'wallpaper.pas',
  autoserv in 'autoserv.pas' {KarstenServer: CoClass},
  ssconfig in 'ssconfig.pas' {SSConfigForm},
  mediaplayer in 'mediaplayer.pas' {MediaPlayerForm},
  SchauServer in 'SchauServer.pas' {KarstenSchauServer: CoClass},
  ConfigServer in 'ConfigServer.pas' {KarstenConfigServer: CoClass},
  SchonerServer in 'SchonerServer.pas' {KarstenSchonerServer: CoClass},
  SchonerSchau in 'SchonerSchau.pas' {SchonerSchauFenster},
  karsmain in 'karsmain.pas' {KarstenMain},
  dscontrol in 'dscontrol.pas' {DirectShowControl},
  repair in 'repair.pas' {SammlungRepairForm},
  thumbnails in 'thumbnails.pas',
  sammelfenUtils in 'sammelfenUtils.pas',
  preview in 'preview.pas' {PreviewForm},
  jobs in 'jobs.pas',
  shelllinks in 'shelllinks.pas',
  recentfiles in 'recentfiles.pas',
  WinHelpViewer,
  repair.search in 'repair.search.pas',
  sammelklassen.visitors in 'sammelklassen.visitors.pas',
  multimonitor in 'multimonitor.pas',
  shell in 'shell.pas';

resourcestring
  SAppTitle = 'Karsten SlideShow';

{$R *.TLB}

{$R *.RES}

begin
	Randomize;
  Application.Initialize;
  Application.Title := SAppTitle;
	Application.HelpFile := 'karsten.hlp';
	Application.CreateForm(TKarstenMain, KarstenMain);
  EvalStartupParameters;
	Application.ShowMainForm := false (*ComServer.StartMode=smStandalone*) ;
  if not IsFirstAppInstance then
    PostMessage(Application.Handle, wm_Close, 0, 0);
	Application.Run;
end.

