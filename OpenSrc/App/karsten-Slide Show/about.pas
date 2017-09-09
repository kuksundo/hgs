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
 * The Original Code is about.pas of Karsten Bilderschau, version 3.2.12.
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

{ $Id: about.pas 65 2006-10-22 00:20:52Z hiisi $ }

{
@abstract "About" dialog box
@author matthias muntwiler <hiisi@users.sourceforge.net>
@cvs $Date: 2006-10-21 19:20:52 -0500 (Sa, 21 Okt 2006) $
}
unit About;

interface

uses Windows, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ShellAPI, SysUtils, Globals, ComCtrls,
  JclFileUtils, JvExControls, JvComponent, JvLinkLabel;

type
  { @abstract "About" dialog box
    The "About" box displays version and license information.
    Contributors should add their name to @link(SContributors).
    Licensed third-party modules should be added to @link(SThirdParties).
  }
  TAboutBox = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    ProductNameLabel: TLabel;
    VersionLabel: TLabel;
    CopyrightLabel: TLabel;
    CloseBtn: TBitBtn;
    LicenseInfo: TJvLinkLabel;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LicenseInfoLinkClick(Sender: TObject; LinkNumber: Integer;
      LinkText, LinkParam: string);
  private
    { Extracts version info from the resource of the exe file }
    VersionInfo: TJclFileVersionInfo;
  end;

implementation
uses
  gnugettext;

{$R *.DFM}

const
  { Shell verb that opens a web link in a browser. }
  SShellOpenVerb = 'open';

const
  { First lines of the license info field }
  SLicenseInfo: array[0..13] of string = (
    'Karsten SlideShow is Open Source Software. ',
    'The source code is available from <link>http://karsten.sourceforge.net</link> ' +
      'under the terms of the Mozilla Public License.<p>',
    'Use of this program is governed by the license terms ' +
      'that are distributed with the program and the source code.<p>',

    'Karsten SlideShow contains program code by:<br>',
    '· Matthias Muntwiler (initial developer), © 2006<br>',

    '· Borland Software Corporation: Delphi Runtime Library (RTL), © 2005<br>',
    '· Borland Software Corporation: Visual Components Library (VCL), © 2005<br>',
    '· Project JEDI: Code Library (JCL), <link>http://jcl.sourceforge.net</link>, © 2005<br>',
    '· Project JEDI: Visual Components Library (JVCL), <link>http://jvcl.sourceforge.net</link>, © 2005<br>',
    '· Project JEDI: DirectX 8 API translation, © 2001<br>',
    '· Gustavo Daud: PNG Delphi, <link>http://pngdelphi.sourceforge.net</link>, © 2003<br>',
    '· Martijn Saly: PNG Components, <link>http://www.thany.org/</link>, © 2005<br>',
    '· David Vignoni: Nuvola Icon Theme, <link>http://www.icon-king.com</link>, © 2004<br>',
    '· Lars B. Dybdahl and others: dxgettext translation tools, <link>http://dybdahl.dk/dxgettext/</link>, © 2005<br>'
    );

procedure TAboutBox.FormCreate(Sender: TObject);
const
  cIndent = 10;
var
  i: integer;
  s: string;
begin
  TranslateComponent(Self);
  VersionInfo := TJclFileVersionInfo.Create(ParamStr(0));
  ProductNameLabel.Caption := VersionInfo.ProductName;
  VersionLabel.Caption := Format('Version %s', [VersionInfo.FileVersion]);
  CopyrightLabel.Caption := VersionInfo.LegalCopyright;
  ProgramIcon.Picture.Icon := Application.Icon;
  s := '';
  for i := Low(SLicenseInfo) to High(SLicenseInfo) do
    s := s + SLicenseInfo[i];
  LicenseInfo.Caption := s;
end;

procedure TAboutBox.FormDestroy(Sender: TObject);
begin
  FreeAndNil(VersionInfo);
end;

procedure TAboutBox.LicenseInfoLinkClick;
begin
  ShellExecute(0, sShellOpenVerb, PChar(LinkText), nil, nil, 0);
end;

end.
