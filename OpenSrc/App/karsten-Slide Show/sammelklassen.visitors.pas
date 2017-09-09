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
 * The Original Code is sammelklassen.visitors.pas of Karsten Bilderschau, version 3.5.0.
 *
 * The Initial Developer of the Original Code is Matthias Muntwiler.
 * Portions created by the Initial Developer are Copyright (C) 2008
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

{ $Id: sammelklassen.visitors.pas 123 2008-10-30 02:34:02Z hiisi $ }

{
@abstract SlideShow window
@author matthias muntwiler <hiisi@users.sourceforge.net>
@created 2008-02-10
@cvs $Date: 2008-10-29 21:34:02 -0500 (Mi, 29 Okt 2008) $

Visitor classes that work on a sequence of @link(TSammelobjekt) objects,
checking or adjusting their properties.
}
unit sammelklassen.visitors;

interface
uses
  SysUtils, Classes, math, globals, sammelklassen;

type
  { Renumbers the sequence, assigning each item a unique number.
    The sequence is numbered in the order visited,
    previous numbers are not preserved.

    If the previous order is to be preserved
    the collection must be sorted by sequence number
    before this visitor is applied. }
  TRenumberSammelobjektSequence = class(TSammelobjektVisitor)
  private
    FFirstNumber: integer;
    FIncrement: integer;
    FCurSequenceNumber: integer;

  public
    constructor Create(AFirstNumber, AIncrement: integer);

    { Sequence number to be assigned to the first item. }
    property  FirstNumber: integer read FFirstNumber;

    { Distance between two sequence numbers. May be negative. }
    property  Increment: integer read FIncrement;

    { The sequence number assigned to the previous item. }
    property  CurSequenceNumber: integer read FCurSequenceNumber;

    procedure VisitSammelobjekt(ASammelobjekt: TSammelobjekt); override;
    procedure VisitSammelbild(ASammelbild: TSammelbild); override;
    procedure VisitSammelordner(ASammelordner: TSammelordner); override;
  end;

  { Reserves a range of sequence numbers by increasing existing numbers
    that are >= @link(ReserveLow).
    The properties @link(ReserveLow) and @link(ReserveHigh) define the range
    to be reserved. }
  TReserveSammelobjektSequence = class(TSammelobjektVisitor)
  private
    FReserveLow: integer;
    FReserveHigh: integer;
    FReserveRange: integer;
  public
    constructor Create(AReserveLow, AReserveHigh: integer);
    property  ReserveLow: integer read FReserveLow;
    property  ReserveRange: integer read FReserveRange;
    property  ReserverHigh: integer read FReserveHigh;
    procedure VisitSammelobjekt(ASammelobjekt: TSammelobjekt); override;
    procedure VisitSammelbild(ASammelbild: TSammelbild); override;
    procedure VisitSammelordner(ASammelordner: TSammelordner); override;
  end;

  { Moves the selected items to a new position in the sequence }
  TReorderSammelobjektSequence = class(TSammelobjektVisitor)
  private
    FDestSeqNo: integer;
    FSelCount: Integer;
    FCurSelSeqNo: integer;
  public
    {
      @param(ADestSeqNo New sequence number for the first selected item)
      @param(ASelCount Number of selected items)
    }
    constructor Create(ADestSeqNo, ASelCount: integer);
    property  DestSeqNo: integer read FDestSeqNo;
    property  SelCount: integer read FSelCount;
    property  CurSelSeqNo: integer read FCurSelSeqNo;
    procedure VisitSammelobjekt(ASammelobjekt: TSammelobjekt); override;
    procedure VisitSammelbild(ASammelbild: TSammelbild); override;
    procedure VisitSammelordner(ASammelordner: TSammelordner); override;
  end;

  { Scales the collection item display frequency.
    The scale is applied to items in the order visited. }
  TScaleSammelobjektFrequency = class(TSammelobjektVisitor)
  private
    FValueFirst: THaeufigkeit;
    FProcessedItemCount: integer;
    FScaleFactor: real;
    FSelectedOnly: boolean;
    FScaleOffset: real;
    FValueLast: THaeufigkeit;
    FItemCount: integer;
  public
    { The parameters initialize the properties.
      They cannot be changed afterwards. }
    constructor Create(AItemCount: integer; AValueFirst, AValueLast: THaeufigkeit;
      ASelectedOnly: boolean = false);
    { Number of items to be scaled.
      If @link(SelectedOnly) = @true this must be the number of items selected,
      otherwise the total number of items in the collection. }
    property  ItemCount: integer read FItemCount;
    { Only selected items (@link(TSammelobjekt.Selected) property) are scaled. }
    property  SelectedOnly: boolean read FSelectedOnly;
    { Value to be assigned to the first item. }
    property  ValueFirst: THaeufigkeit read FValueFirst;
    { Value to be assigned to the last item.
      The last value may be lower than the first one. }
    property  ValueLast: THaeufigkeit read FValueLast;
    { Identical to @link(ValueFirst). Used internally. }
    property  ScaleOffset: real read FScaleOffset;
    { Scaling factor determined from @link(ValueFirst) and @link(ValueLast).
      Used internally. }
    property  ScaleFactor: real read FScaleFactor;
    { Number of items processed so far.
      Used internally. }
    property  ProcessedItemCount: integer read FProcessedItemCount;
    procedure VisitSammelobjekt(ASammelobjekt: TSammelobjekt); override;
    procedure VisitSammelbild(ASammelbild: TSammelbild); override;
    procedure VisitSammelordner(ASammelordner: TSammelordner); override;
  end;

  { Scales the collection item display time.
    The scale is applied to items in the order visited. }
  TScaleSammelobjektDisplayTime = class(TSammelobjektVisitor)
  private
    FValueFirst: TWartezeit;
    FScaleFactor: real;
    FSelectedOnly: boolean;
    FScaleOffset: real;
    FValueLast: TWartezeit;
    FItemCount: integer;
    FProcessedItemCount: integer;
  public
    { The parameters initialize the properties.
      They cannot be changed afterwards. }
    constructor Create(AItemCount: integer; AValueFirst, AValueLast: TWartezeit;
      ASelectedOnly: boolean = false);
    { Number of items to be scaled.
      If @link(SelectedOnly) = @true this must be the number of items selected,
      otherwise the total number of items in the collection. }
    property  ItemCount: integer read FItemCount;
    { Only selected items (@link(TSammelobjekt.Selected) property) are scaled. }
    property  SelectedOnly: boolean read FSelectedOnly;
    { Value to be assigned to the first item. }
    property  ValueFirst: TWartezeit read FValueFirst;
    { Value to be assigned to the last item.
      The last value may be lower than the first one. }
    property  ValueLast: TWartezeit read FValueLast;
    { Identical to @link(ValueFirst). Used internally. }
    property  ScaleOffset: real read FScaleOffset;
    { Scaling factor determined from @link(ValueFirst) and @link(ValueLast).
      Used internally. }
    property  ScaleFactor: real read FScaleFactor;
    { Number of items processed so far.
      Used internally. }
    property  ProcessedItemCount: integer read FProcessedItemCount;
    { Value that follows after @link(ValueLast).
      Used internally. }
    procedure VisitSammelobjekt(ASammelobjekt: TSammelobjekt); override;
    procedure VisitSammelbild(ASammelbild: TSammelbild); override;
    procedure VisitSammelordner(ASammelordner: TSammelordner); override;
  end;

  { Moves the selected items to a new location.
    The collection must be sorted by frequency before reordering,
    otherwise the destination may not be well-defined. }
  TReorderSammelobjektFrequency = class(TSammelobjektVisitor)
  private
    FSelCount: integer;
    FDestItemBefore: TSammelobjekt;
    FDestItemAfter: TSammelobjekt;
    FDestValue: THaeufigkeit;
    FPrevValue: THaeufigkeit;
  public
    { The parameters initialize the properties.
      They cannot be changed afterwards.

      @param(ASelCount Number of selected items)
      @param(ADestItemBefore The collection item that is located just before the insertion point)
      @param(ADestItemAfter The collection item that is located just after the insertion point)
      }
    constructor Create(ASelCount: integer;
      const ADestItemBefore, ADestItemAfter: TSammelobjekt);
    { Number of selected items. }
    property  SelCount: integer read FSelCount;
    { The collection item that is located just before the insertion point }
    property  DestItemBefore: TSammelobjekt read FDestItemBefore;
    { The collection item that is located just after the insertion point }
    property  DestItemAfter: TSammelobjekt read FDestItemAfter;

    procedure VisitSammelobjekt(ASammelobjekt: TSammelobjekt); override;
    procedure VisitSammelbild(ASammelbild: TSammelbild); override;
    procedure VisitSammelordner(ASammelordner: TSammelordner); override;
  end;

  { Scales the collection item display time.
    The scale is applied to items in the order visited.
    The collection should be sorted by display time before scaling,
    otherwise the grouping by display time may not be preserved. }
  TReorderSammelobjektDisplayTime = class(TSammelobjektVisitor)
  private
    FSelCount: integer;
    FDestItemBefore: TSammelobjekt;
    FDestItemAfter: TSammelobjekt;
    FDestValue: TWartezeit;
    FPrevValue: TWartezeit;
  public
    { The parameters initialize the properties.
      They cannot be changed afterwards.

      @param(ASelCount Number of selected items)
      @param(ADestItemBefore The collection item that is located just before the insertion point)
      @param(ADestItemAfter The collection item that is located just after the insertion point)
      }
    constructor Create(ASelCount: integer;
      const ADestItemBefore, ADestItemAfter: TSammelobjekt);
    { Number of selected items. }
    property  SelCount: integer read FSelCount;
    { The collection item that is located just before the insertion point }
    property  DestItemBefore: TSammelobjekt read FDestItemBefore;
    { The collection item that is located just after the insertion point }
    property  DestItemAfter: TSammelobjekt read FDestItemAfter;
    procedure VisitSammelobjekt(ASammelobjekt: TSammelobjekt); override;
    procedure VisitSammelbild(ASammelbild: TSammelbild); override;
    procedure VisitSammelordner(ASammelordner: TSammelordner); override;
  end;

implementation

{ TRenumberSammelobjektSequence }

constructor TRenumberSammelobjektSequence.Create;
begin
  inherited Create;
  FFirstNumber := AFirstNumber;
  FIncrement := AIncrement;
  FCurSequenceNumber := FFirstNumber - FIncrement;
end;

procedure TRenumberSammelobjektSequence.VisitSammelobjekt;
begin
  Inc(FCurSequenceNumber, FIncrement);
  ASammelobjekt.SequenceNumber := FCurSequenceNumber;
end;

procedure TRenumberSammelobjektSequence.VisitSammelbild;
begin
  VisitSammelobjekt(ASammelbild);
end;

procedure TRenumberSammelobjektSequence.VisitSammelordner;
begin
  VisitSammelobjekt(ASammelordner);
end;

{ TReserveSammelobjektSequence }

constructor TReserveSammelobjektSequence.Create;
begin
  inherited Create;
  FReserveLow := AReserveLow;
  FReserveHigh := AReserveHigh;
  FReserveRange := Max(0, AReserveHigh - AReserveLow + 1);
end;

procedure TReserveSammelobjektSequence.VisitSammelobjekt;
begin
  if ASammelobjekt.SequenceNumber >= FReserveLow then
    ASammelobjekt.SequenceNumber := ASammelobjekt.SequenceNumber + FReserveRange;
end;

procedure TReserveSammelobjektSequence.VisitSammelbild;
begin
  VisitSammelobjekt(ASammelbild);
end;

procedure TReserveSammelobjektSequence.VisitSammelordner;
begin
  VisitSammelobjekt(ASammelordner);
end;

{ TReorderSammelobjektSequence }

constructor TReorderSammelobjektSequence.Create(ADestSeqNo, ASelCount: integer);
begin
  inherited Create;
  FDestSeqNo := ADestSeqNo;
  FSelCount := ASelCount;
  FCurSelSeqNo := ADestSeqNo - 1;
end;

procedure TReorderSammelobjektSequence.VisitSammelobjekt;
begin
  if ASammelobjekt.Selected then begin
    Inc(FCurSelSeqNo);
    ASammelobjekt.SequenceNumber := FCurSelSeqNo;
  end else begin
    if ASammelobjekt.SequenceNumber >= FDestSeqNo then
      ASammelobjekt.SequenceNumber := ASammelobjekt.SequenceNumber + FSelCount;
  end;
end;

procedure TReorderSammelobjektSequence.VisitSammelbild;
begin
  VisitSammelobjekt(ASammelbild);
end;

procedure TReorderSammelobjektSequence.VisitSammelordner;
begin
  VisitSammelobjekt(ASammelordner);
end;

{ TScaleSammelobjektFrequency }

constructor TScaleSammelobjektFrequency.Create;
begin
  inherited Create;
  FItemCount := AItemCount;
  FSelectedOnly := ASelectedOnly;
  FValueFirst := AValueFirst;
  FValueLast := AValueLast;
  if FItemCount > 1 then
    FScaleFactor := (integer(FValueLast) - integer(FValueFirst)) / (FItemCount - 1)
  else
    FScaleFactor := 0;
  FScaleOffset := FValueFirst;
  FProcessedItemCount := 0;
end;

procedure TScaleSammelobjektFrequency.VisitSammelobjekt;
begin
  if not SelectedOnly or ASammelobjekt.Selected then begin
    ASammelobjekt.Haeufigkeit := Round(FScaleOffset + FScaleFactor * FProcessedItemCount);
    Inc(FProcessedItemCount);
  end;
end;

procedure TScaleSammelobjektFrequency.VisitSammelbild;
begin
  VisitSammelobjekt(ASammelbild);
end;

procedure TScaleSammelobjektFrequency.VisitSammelordner;
begin
  VisitSammelobjekt(ASammelordner);
end;

{ TScaleSammelobjektDisplayTime }

constructor TScaleSammelobjektDisplayTime.Create;
begin
  inherited Create;
  FItemCount := AItemCount;
  FSelectedOnly := ASelectedOnly;
  FValueFirst := AValueFirst;
  FValueLast := AValueLast;
  if FItemCount > 1 then
    FScaleFactor := (integer(FValueLast) - integer(FValueFirst)) / (FItemCount - 1)
  else
    FScaleFactor := 0;
  FScaleOffset := FValueFirst;
  FProcessedItemCount := 0;
end;

procedure TScaleSammelobjektDisplayTime.VisitSammelobjekt;
begin
  if not SelectedOnly or ASammelobjekt.Selected then begin
    ASammelobjekt.Wartezeit := Round(FScaleOffset + FScaleFactor * FProcessedItemCount);
    Inc(FProcessedItemCount);
  end;
end;

procedure TScaleSammelobjektDisplayTime.VisitSammelbild;
begin
  VisitSammelobjekt(ASammelbild);
end;

procedure TScaleSammelobjektDisplayTime.VisitSammelordner;
begin
  VisitSammelobjekt(ASammelordner);
end;

{ TReorderSammelobjektFrequency }

constructor TReorderSammelobjektFrequency.Create;
begin
  inherited Create;
  FSelCount := ASelCount;
  FDestItemBefore := ADestItemBefore;
  FDestItemAfter := ADestItemAfter;
  FDestValue := Ceil((ADestItemBefore.Haeufigkeit + ADestItemAfter.Haeufigkeit) / 2);
  FPrevValue := Low(THaeufigkeit);
end;

procedure TReorderSammelobjektFrequency.VisitSammelobjekt;
begin
  if ASammelobjekt.Selected then begin
    ASammelobjekt.Haeufigkeit := FDestValue;

  end else begin
    FPrevValue := ASammelobjekt.Haeufigkeit;
    (*
    if ASammelobjekt.Haeufigkeit = FFollowingReplaceValue then begin
      FFollowingMatchValue := FFollowingReplaceValue;
      Inc(FFollowingReplaceValue);
    end;
    if ASammelobjekt.Haeufigkeit = FFollowingMatchValue then
      ASammelobjekt.Haeufigkeit := FFollowingReplaceValue;
    *)
  end;
end;

procedure TReorderSammelobjektFrequency.VisitSammelbild;
begin
  VisitSammelobjekt(ASammelbild);
end;

procedure TReorderSammelobjektFrequency.VisitSammelordner;
begin
  VisitSammelobjekt(ASammelordner);
end;

{ TReorderSammelobjektDisplayTime }

constructor TReorderSammelobjektDisplayTime.Create;
begin
  inherited Create;
  FSelCount := ASelCount;
  FDestItemBefore := ADestItemBefore;
  FDestItemAfter := ADestItemAfter;
  FDestValue := Ceil((ADestItemBefore.Haeufigkeit + ADestItemAfter.Haeufigkeit) / 2);
  FPrevValue := Low(TWartezeit);
end;

procedure TReorderSammelobjektDisplayTime.VisitSammelobjekt;
begin
  if ASammelobjekt.Selected then begin
    ASammelobjekt.Wartezeit := FDestValue;
  end else begin
    FPrevValue := ASammelobjekt.Wartezeit;
  end;
end;

procedure TReorderSammelobjektDisplayTime.VisitSammelbild;
begin
  VisitSammelobjekt(ASammelbild);
end;

procedure TReorderSammelobjektDisplayTime.VisitSammelordner;
begin
  VisitSammelobjekt(ASammelordner);
end;

end.
