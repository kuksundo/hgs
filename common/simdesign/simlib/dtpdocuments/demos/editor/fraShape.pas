{
  Unit fraShape

  This unit implements the frame editor that can be used to edit one or
  multiple TdtpShape objects. It only edits the properties of this basic
  shape, any descendants must implement a descending fraXXX unit.

  Project: DTP-Engine

  Creation Date: 05-08-2003 (NH)
  Version: 1.0

  Copyright (c) 2003 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit fraShape;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, fraBase, dtpShape, ExtCtrls, dtpDocument, dtpDefaults,
  fraMaskBase;

type

  // Width should be 270, Height should be 400
  TfrShape = class(TfrBase)
    trbAlpha: TTrackBar;
    Label1: TLabel;
    Label2: TLabel;
    edAngle: TEdit;
    lbAlpha: TLabel;
    Label3: TLabel;
    edLeft: TEdit;
    Label4: TLabel;
    edTop: TEdit;
    Label5: TLabel;
    edWidth: TEdit;
    Label6: TLabel;
    edHeight: TEdit;
    btnAnchors: TButton;
    lbAnchors: TLabel;
    btnPermissions: TButton;
    procedure trbAlphaChange(Sender: TObject);
    procedure edAngleExit(Sender: TObject);
    procedure edLeftExit(Sender: TObject);
    procedure edTopExit(Sender: TObject);
    procedure edWidthExit(Sender: TObject);
    procedure edHeightExit(Sender: TObject);
    procedure btnAnchorsClick(Sender: TObject);
    procedure btnPermissionsClick(Sender: TObject);
  private
    function AnchorsToDescription(Anchors: TShapeAnchors): string;
  protected
    procedure ShapesToFrame; override;
  public
  end;

implementation

uses
  frmAnchors, frmPermissions;

{$R *.DFM}

{ TfrShape }

function TfrShape.AnchorsToDescription(Anchors: TShapeAnchors): string;
var
  i: integer;
  AList: TStringList;
begin
  AList := TStringList.Create;
  try
    if saDefault in Anchors then
      AList.Add('Default')
    else begin
      if saPosXProp   in Anchors then AList.Add('PosX');
      if saPosYProp   in Anchors then AList.Add('PosY');
      if saSizeXProp  in Anchors then AList.Add('SizeX');
      if saSizeYProp  in Anchors then AList.Add('SizeY');
      if saLeftLock   in Anchors then AList.Add('Left');
      if saTopLock    in Anchors then AList.Add('Top');
      if saRightLock  in Anchors then AList.Add('Right');
      if saBottomLock in Anchors then AList.Add('Bottom');
    end;
    Result := '[';
    for i := 0 to AList.Count - 1 do begin
      Result := Result + AList[i];
      if i < AList.Count - 1 then
        Result := Result + ', ';
    end;
    Result := Result + ']';
  finally
    AList.Free;
  end;
end;

procedure TfrShape.btnAnchorsClick(Sender: TObject);
var
  i: integer;
begin
  with TdlgAnchors.Create(Application) do begin
    try
      Anchors := Shapes[0].Anchors;
      if ShowModal = mrOK then begin
        for i := 0 to ShapeCount - 1 do
          Shapes[i].Anchors := Anchors;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TfrShape.btnPermissionsClick(Sender: TObject);
var
  i: integer;
  AList: TList;
begin
  with TdlgPermissions.Create(Application) do
    try
      AList := TList.Create;
      try
        for i := 0 to ShapeCount - 1 do
          AList.Add(Shapes[i]);
        ShapesToDlg(AList);
        if ShowModal = mrOK then
          DlgToShapes(AList);
      finally
        AList.Free;
      end;
    finally
      Free;
    end;
end;

procedure TfrShape.edAngleExit(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    Shapes[i].DocRotate(StrToFloat(edAngle.Text));
  EndUpdate;
end;

procedure TfrShape.edHeightExit(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    Shapes[i].DocHeight := StrToFloat(edHeight.Text);
  EndUpdate;
end;

procedure TfrShape.edLeftExit(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    Shapes[i].DocLeft := StrToFloat(edLeft.Text);
  EndUpdate;
end;

procedure TfrShape.edTopExit(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    Shapes[i].DocTop := StrToFloat(edTop.Text);
  EndUpdate;
end;

procedure TfrShape.edWidthExit(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    Shapes[i].DocWidth := StrToFloat(edWidth.Text);
  EndUpdate;
end;

procedure TfrShape.ShapesToFrame;
var
  i: integer;
begin
  if ShapeCount = 0 then exit;
  // Title
  if ShapeCount = 1 then
    lblTitle.Caption := 'Standard shape'
  else
    lblTitle.Caption := Format('Standard shapes (%d items)', [ShapeCount]);
  // Main shape
  with Shapes[0] do begin
    // Bounds
    edLeft.Text   := Format(cDefaultMMFormat, [DocLeft]);
    edTop.Text    := Format(cDefaultMMFormat, [DocTop]);
    edWidth.Text  := Format(cDefaultMMFormat, [DocWidth]);
    edHeight.Text := Format(cDefaultMMFormat, [DocHeight]);

    // Angle
    edAngle.Text := Format(cDefaultDegFormat, [DocAngle]);

    // Alpha
    trbAlpha.Position := MasterAlpha;
    lbAlpha.Caption   := IntToStr(MasterAlpha);

    // Anchors
    lbAnchors.Caption := AnchorsToDescription(Anchors);
  end;
  // Additional shapes
  for i := 1 to ShapeCount - 1 do with Shapes[i] do begin
    if edLeft.Text <> Format(cDefaultMMFormat, [DocLeft]) then
      edLeft.Text := '';
    if edTop.Text <> Format(cDefaultMMFormat, [DocTop]) then
      edTop.Text := '';
    if edWidth.Text <> Format(cDefaultMMFormat, [DocWidth]) then
      edWidth.Text := '';
    if edHeight.Text <> Format(cDefaultMMFormat, [DocHeight]) then
      edHeight.Text := '';
    if edAngle.Text <> Format(cDefaultDegFormat, [DocHeight]) then
      edAngle.Text := '';
    if lbAlpha.Caption <> IntToStr(MasterAlpha) then
      lbAlpha.Caption := 'Various';
    if AnchorsToDescription(Anchors) <> lbAnchors.Caption then
      lbAnchors.Caption := 'Various';
  end;
end;

procedure TfrShape.trbAlphaChange(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    with Shapes[i] do begin
      // This ensures that we don't get 1001 undo states when moving the slider
      // up and down
      NextUndoNoRepeatedPropertyChange;
      MasterAlpha := trbAlpha.Position;
    end;
  EndUpdate;
end;

end.
