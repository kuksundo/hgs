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
 * The Original Code is SchonerConfig.pas of Karsten Bilderschau, version 3.2.12.
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

{ $Id: SchonerConfig.pas 90 2006-11-02 06:22:45Z hiisi $ }

{
@abstract Collection editor window for screen saver configuration
@author matthias muntwiler <hiisi@users.sourceforge.net>
@created 2000/07/16
@cvs $Date: 2006-11-02 00:22:45 -0600 (Do, 02 Nov 2006) $

@link(TSchonerConfigFenster) opens when the user clicks 'configure'
in the screen saver properties dialog box of Windows.
}
unit SchonerConfig;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	sammelfen, Menus, ImgList, StdActns, ActnList, StdCtrls, Buttons,
	ComCtrls, ToolWin, KarsReg, JvFormPlacement, JvAppStorage,
  JvAppRegistryStorage, JvComponentBase, JvMRUManager, ExtDlgs, ExtCtrls,
  JvMTComponents, JvThread;

type
	TSchonerConfigFenster = class(TCollectionForm)
		BOk: TBitBtn;
		BCancel: TBitBtn;
		procedure BOkClick(Sender: TObject);
		procedure BCancelClick(Sender: TObject);
	protected
		procedure UpdateCaption; override;
	public
		constructor Create(AOwner: TComponent); override;
	end;

var
	SchonerConfigFenster: TSchonerConfigFenster;

implementation

{$R *.DFM}

resourcestring
	sWinTitleSSConfiguration = 'Karsten ScreenSaver';
	sUntitled = 'untitled';

procedure TSchonerConfigFenster.BOkClick(Sender: TObject);
var
	Reg:TUserRegistry;
begin
	Reg:=TUserRegistry.Create;
	try
		Reg.ScrDokument:=Filename;
	finally
		Reg.Free;
	end;
	PostMessage(Handle,wm_Close,0,0);
end;

procedure TSchonerConfigFenster.BCancelClick(Sender: TObject);
begin
	Modified:=false;
	PostMessage(Handle,wm_Close,0,0);
end;

procedure TSchonerConfigFenster.UpdateCaption;
var
	part1,part2,part3:string;
begin
	part1 := sWinTitleSSConfiguration;
	if Length(fileName) > 0 then
    part2 := ExtractFileName(fileName)
  else
    part2 := sUntitled;
	if Modified then
    part3 := ' *'
  else
    part3 := '';
	Caption := part1 + ' - ' + part2 + part3;
end;

constructor TSchonerConfigFenster.Create(AOwner: TComponent);
begin
	inherited;
	AShowScreenSaver.Visible := false;
	AShowScreenSaver.Enabled := false;
	AFileExit.Enabled := false;
	AFileExit.Visible := false;
end;

end.
 
