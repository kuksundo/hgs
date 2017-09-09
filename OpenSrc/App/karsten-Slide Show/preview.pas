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
 * The Original Code is preview.pas of Karsten Bilderschau, version 3.3.3.
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

{ $Id: preview.pas 117 2008-02-11 02:21:22Z hiisi $ }

{
@abstract preview form for images
@author matthias muntwiler <hiisi@users.sourceforge.net>
@created 2006-09-06
@cvs $Date: 2008-02-10 20:21:22 -0600 (So, 10 Feb 2008) $
}
unit preview;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, JvDockTree, JvDockControlForm, JvDockDelphiStyle,
  JvDockVIDStyle, JvComponentBase, globals, sammelklassen, bildklassen, StdCtrls;

type
  TPreviewForm = class(TForm)
    PreviewBox: TPaintBox;
    JvDockClient: TJvDockClient;
    JvDockDelphiStyle: TJvDockDelphiStyle;
    JvDockVIDStyle: TJvDockVIDStyle;
    PropertiesPanel: TPanel;
    FilenameLabel: TLabel;
    FrequencyLabel: TLabel;
    DisplayTimeLabel: TLabel;
    SequenceNumberLabel: TLabel;
    procedure PreviewBoxPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FPreviewBild: TBildobjekt;
    FBlank: boolean;
  protected
    procedure SetPreviewItem(const Value: TSammelobjekt);
    procedure SetPreviewBild(const Value: TBildobjekt);
  public
    { Displays a preview of a sammelobjekt.
      It assigns @link(TSammelobjekt.Bild) to @link(PreviewBild),
      and does not store a reference to the object.

      The preview is reloaded each time this property is assigned to.
      If set to @nil, the @link(PreviewBox) is blank.
      Use either @link(PreviewItem) or @link(PreviewBild). }
    property PreviewItem: TSammelobjekt write SetPreviewItem;
    { Displays a preview of a sammelbild.
      The property represents an internal object instance.
      Upon assignment, the properties of the source object are copied
      to the internal object, and the @link(PreviewBox) is updated.

      The preview is reloaded each time this property is assigned to.
      If set to @nil, the @link(PreviewBox) is blank.
      Use either @link(PreviewItem) or @link(PreviewBild). }
    property PreviewBild: TBildobjekt read FPreviewBild write SetPreviewBild;
  end;

var
  PreviewForm: TPreviewForm;

implementation
uses
  gnugettext;

{$R *.dfm}

procedure TPreviewForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(Self);
  FBlank := true;
  FPreviewBild := TBilderrahmen.Create;
end;

procedure TPreviewForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FBlank := true;
end;

procedure TPreviewForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FPreviewBild);
end;

procedure TPreviewForm.SetPreviewItem(const Value: TSammelobjekt);
begin
  if Assigned(Value) and (Value.BildStatus = bsOK) then begin
    try
      Value.BildSchalten;
      SetPreviewBild(Value.Bild);
      FilenameLabel.Caption := ExtractFileName(Value.Pfad);
      FrequencyLabel.Caption := Format(_('Frequency: %d'), [Value.Haeufigkeit]);
      DisplayTimeLabel.Caption := Format(_('Display Time: %d s'), [Value.Wartezeit]);
      SequenceNumberLabel.Caption := Format(_('Sequence Number: %d'), [Value.SequenceNumber]);
    except
      on EKarstenException do SetPreviewBild(nil);
    end;
  end else begin
    SetPreviewBild(nil);
  end;
end;

procedure TPreviewForm.SetPreviewBild;
begin
  if Assigned(Value) then begin
    if (Value is TStandardBild) or
      (Value is TBilderrahmen) and (TBilderrahmen(Value).Bildobjekt is TStandardBild)
    then begin
      if FBlank or (Value.Pfad <> FPreviewBild.Pfad) then
        PreviewBox.Invalidate;
      FPreviewBild.Assign(Value);
      FPreviewBild.BitmapModus := bmIsoStrecken;
      //PreviewBox.Color := FPreviewBild.Hintergrundfarbe;
      FPreviewBild.AusgabeCanvas := PreviewBox.Canvas;
      FBlank := false;
    end else begin
      if not FBlank then PreviewBox.Invalidate;
      FBlank := true;
    end;
  end else begin
    if not FBlank then PreviewBox.Invalidate;
    FBlank := true;
  end;
  if FBlank then begin
    FPreviewBild.BildFreigeben;
    FilenameLabel.Caption := '';
    FrequencyLabel.Caption := '';
    DisplayTimeLabel.Caption := '';
  end;
end;

procedure TPreviewForm.PreviewBoxPaint(Sender: TObject);
var
  DestRect: TRect;
begin
  try
    if not FBlank then begin
      DestRect := PreviewBox.ClientRect;
      DestRect := FPreviewBild.BildKoordinaten(DestRect);
      FPreviewBild.BildZeichnen(DestRect);
    end;
  except
    on EKarstenException do
      FBlank := true;
    on EInvalidGraphic do
      FBlank := true;
  end;
end;

end.
