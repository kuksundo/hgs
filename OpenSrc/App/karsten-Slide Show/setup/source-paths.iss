; ***** BEGIN LICENSE BLOCK *****
; Version: MPL 1.1/GPL 2.0/LGPL 2.1
;
; The contents of this file are subject to the Mozilla Public License Version
; 1.1 (the "License"); you may not use this file except in compliance with
; the License. You may obtain a copy of the License at
; http://www.mozilla.org/MPL/
;
; Software distributed under the License is distributed on an "AS IS" basis,
; WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
; for the specific language governing rights and limitations under the
; License.
;
; The Original Code is Karsten Bilderschau, Version 3.2.12.
;
; The Initial Developer of the Original Code is Matthias Muntwiler.
; Portions created by the Initial Developer are Copyright (C) 2006
; the Initial Developer. All Rights Reserved.
;
; Contributor(s):
;
; Alternatively, the contents of this file may be used under the terms of
; either the GNU General Public License Version 2 or later (the "GPL"), or
; the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
; in which case the provisions of the GPL or the LGPL are applicable instead
; of those above. If you wish to allow use of your version of this file only
; under the terms of either the GPL or the LGPL, and not to allow others to
; use your version of this file under the terms of the MPL, indicate your
; decision by deleting the provisions above and replace them with the notice
; and other provisions required by the GPL or the LGPL. If you do not delete
; the provisions above, a recipient may use your version of this file under
; the terms of any one of the MPL, the GPL or the LGPL.
;
; ***** END LICENSE BLOCK ***** *)

; karsten installer source paths
; $Id: source-paths.iss 109 2007-01-21 17:00:23Z hiisi $
;
; in order to customize source paths to your development environment
; create a copy of this file and name it source-paths.local.iss
; customize paths in the the local file
; do not change this template file
;
; paths must be relative to the setup directory (or absolute)

;installer soure
;this must be defined in a relative way by the calling script, because
;  - there may be differently named working directories
;it should point to the directory where the karsten.iss file is located
#ifndef setupsrc
  #error variable setupsrc is undefined. it must contain the path to karsten.iss.
#endif

; location of compiled executables
#define binsrc setupsrc + "/../bin"

; location of the source files
#define auxsrc setupsrc + "/.."

; location of the compiled third-party libraries (jclXX.bpl etc.)
#define libsrc "c:/program files/Common Files/mm/lib"

; location of the delphi run-time libraries
#define vclsrc "c:/windows/system32"

; location of the delphi bin folder
#define delphibin "c:/program files/borland/bds/4.0/bin"

; location of the demo files
#define demosrc setupsrc + "/../demo"
