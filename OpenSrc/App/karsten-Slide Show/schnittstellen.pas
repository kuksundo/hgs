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
 * The Original Code is schnittstellen.pas of Karsten Bilderschau, version 3.2.12.
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

{ $Id: schnittstellen.pas 2 2006-03-06 00:31:17Z hiisi $ }

{
@abstract Interfaces for internal use
@author matthias muntwiler <hiisi@users.sourceforge.net>
@created 1999/09/26
@cvs $Date: 2006-03-05 18:31:17 -0600 (So, 05 Mrz 2006) $

Are these interfaces used at all?
}
unit schnittstellen;

interface
uses windows,globals,sammelklassen;

type
	IFenster=interface
		['{74845A82-69E3-11D3-A7E5-0000B4812410}']
		procedure Show;
		procedure Hide;
		procedure Close;
	end;

	ISammlungsfenster=interface(IFenster)
		['{74845A83-69E3-11D3-A7E5-0000B4812410}']
		function	BildBereit:boolean;
		function	SchaubildSchalten:TSammelobjekt;
		function	Bildbearbeitung:IBildbearbeitung;
		//function	GetSchaubild:TBild;
		//procedure SchaufensterSchliesst(Sender:TObject);
	end;

	ISchaufenster=interface(IFenster)
		['{74845A84-69E3-11D3-A7E5-0000B4812410}']
		procedure AnzeigeModusWechseln(neuerModus:tAnzeigeModus);
		procedure AblaufModusWechseln(anhalten:boolean);
		procedure Weiterschalten;
		//procedure ExternesSchaufenster(fenster:hWnd);
		//procedure SammlungsfensterSchliesst(Sender:TObject);
	end;

implementation

end.
