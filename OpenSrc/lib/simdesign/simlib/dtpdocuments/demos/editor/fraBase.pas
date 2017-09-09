{
  Unit fraBase

  This unit implements the frame editor that can be used to as an ancestor
  for other frame editors. Any descendants must implement a descending
  fraXXX unit.

  Project: DTP-Engine

  Creation Date: 07-08-2003 (NH)
  Version: 1.0

  Copyright (c) 2003 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit fraBase;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  dtpDocument, dtpShape, StdCtrls, ExtCtrls;

type

  // Width should be 270, Height should be 400
  TfrBase = class(TFrame)
    pnlTitle: TPanel;
    lblTitle: TLabel;
  private
    FDocument: TdtpDocument;
    FShapes: TList;
    procedure SetDocument(const Value: TdtpDocument);
    function GetShapeCount: integer;
    function GetShapes(Index: integer): TdtpShape;
  protected
    FIsUpdating: boolean;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure ShapesToFrame; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Document: TdtpDocument read FDocument write SetDocument;
    property ShapeCount: integer read GetShapeCount;
    property Shapes[Index: integer]: TdtpShape read GetShapes;
  end;

  TfrBaseClass = class of TfrBase;

implementation

{$R *.DFM}

{ TfrEffect }

procedure TfrBase.BeginUpdate;
begin
  if FIsUpdating or (ShapeCount <= 1) or not assigned(Document) then exit;
  Document.BeginUndo;
  Document.BeginUpdate;
end;

constructor TfrBase.Create(AOwner: TComponent);
begin
  inherited;
  FShapes := TList.Create;
end;

destructor TfrBase.Destroy;
begin
  FShapes.Free;
  inherited;
end;

procedure TfrBase.EndUpdate;
begin
  if FIsUpdating or (ShapeCount <= 1) or not assigned(Document) then exit;
  Document.EndUndo;
  Document.EndUpdate;
end;

function TfrBase.GetShapeCount: integer;
begin
  Result := 0;
  if assigned(FShapes) then Result := FShapes.Count;
end;

function TfrBase.GetShapes(Index: integer): TdtpShape;
begin
  Result := nil;
  if (Index >= 0) and (Index < ShapeCount) then
    Result := TdtpShape(FShapes[Index])
end;

procedure TfrBase.SetDocument(const Value: TdtpDocument);
var
  i: integer;
  FTemp: pointer;
begin
  // Set to document
  FDocument := Value;
  // Clear shapes, and add new selected shapes from document
  FShapes.Clear;
  if assigned(Document) then with Document do
    // Add all selected
    for i := 0 to ShapeCount - 1 do // Document.Shapecount
      if Shapes[i].Selected then
        FShapes.Add(Shapes[i]);
  // Make the focused shape #0
  for i := 1 to ShapeCount - 1 do // Our own shapecount
    if Shapes[i] = Document.FocusedShape then begin
      FTemp := FShapes[0];
      FShapes[0] := FShapes[i];
      FShapes[i] := FTemp;
      break;
    end;
  // And show the correct editor data
  FIsUpdating := True;
  try
    ShapesToFrame;
  finally
    FIsUpdating := False;
  end;  
end;

procedure TfrBase.ShapesToFrame;
begin
// Default does nothing
end;

end.
