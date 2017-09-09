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
 * The Original Code is mediaplayer.pas of Karsten Bilderschau, version 3.2.12.
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

{ $Id: mediaplayer.pas 54 2006-10-15 02:30:45Z hiisi $ }

{
@abstract MCI playback control form
@author matthias muntwiler <hiisi@users.sourceforge.net>
@created 2000/01/08
@cvs $Date: 2006-10-14 21:30:45 -0500 (Sa, 14 Okt 2006) $

The @link(TMediaPlayerForm) handles playback of MCI-compatible movie files.
MCI (media control interface) is superseded by DirectX.
A DirectX playback control for karsten is implemented in @link(dscontrol).
}
unit mediaplayer;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	MPlayer, Menus;

type
	TMediaPlayerForm = class(TForm)
		MediaPlayer: TMediaPlayer;
    PMMediaplayerKontext: TPopupMenu;
		MISchliessen: TMenuItem;
		procedure FormClose(Sender: TObject; var Action: TCloseAction);
		procedure MISchliessenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
	private
		{ Private-Deklarationen }
	public
		{ Public-Deklarationen }
	end;

var
	MediaPlayerForm: TMediaPlayerForm;

implementation
uses
  gnugettext;
  
{$R *.DFM}

procedure TMediaPlayerForm.FormClose(Sender: TObject;
	var Action: TCloseAction);
begin
	action:=caHide;
end;

procedure TMediaPlayerForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(Self);
end;

procedure TMediaPlayerForm.MISchliessenClick(Sender: TObject);
begin
	Close;
end;

end.
