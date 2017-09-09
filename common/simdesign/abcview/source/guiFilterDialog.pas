{ unit FilterDialogs

  This unit holds the FilterFrame which is defined in one of the filtering units,
  and provides for the common dialog interface.

  Modifications:
  23May2004: Added FrameOKClick

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit guiFilterDialog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ImgList, ExtCtrls, BrowseTrees,
  Mask, rxToolEdit, RXSpin, guiItemView, ActnList, RxCombos, guiFilterFrame;

type

  TdlgFilter = class(TForm)
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    btnApply: TBitBtn;
    ilFilter: TImageList;
    btnHelp: TBitBtn;
    pnFilter: TPanel;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
  private
    FItem: TBrowseItem;
    FFrame: TFilterFrame;      // Base frame class for filter dialogs
  protected
    procedure SetItem(Value: TBrowseItem);
  public
    property Frame: TFilterFrame read FFrame write FFrame;
    property Item: TBrowseItem read FItem write SetItem;
    // Call ItemToFilter to set the properties of the item in the
    // filter dialog
    procedure ItemToDlg;
    procedure DlgToItem;
    procedure DlgClose;
  end;

var
  dlgFilter: TdlgFilter;

implementation

uses
  ThumbItems, {Utils,} guiMain, sdItems, guiOptions;

{$R *.DFM}

procedure TdlgFilter.SetItem(Value: TBrowseItem);
begin
  if Value <> FItem then
  begin
    // Close old frame
    DlgClose;
    // Open new frame
    FItem := Value;
    ItemToDlg;
  end;
end;

procedure TdlgFilter.ItemToDlg;
begin
  with Item do
  begin
    if not assigned(Item.FrameClass) then
      exit;

    // Remove old frame
    if assigned(Frame) and (Frame.ClassType <> Item.FrameClass) then
      FreeAndNil(FFrame);

    // Create the new frame

    if not assigned(Frame) then
    begin
      Frame := Item.FrameClass.Create(Self);
      Frame.Parent := pnFilter;
      Frame.Align := alClient;
    end;
    Frame.Item := Item;

    // Dialog's icon
    if not Item.GetIcon(Icon) then
      ilFilter.GetIcon(Item.DialogIcon, Icon);

    // Dialog's caption
    btnHelp.HelpContext := Item.HelpContext;

    // And set control properties
    Frame.FilterToDlg;
    Self.Caption := Item.DialogCaption;
  end;
end;

procedure TdlgFilter.DlgToItem;
begin
  with Item do
  begin
    if assigned(Frame) then
      with Frame do
      begin
        // Convert the frame control's values into filter specifiers
        DlgToFilter;
        // After this, some items' filters need to be initialized
        InitialiseFilter;
      end;
    Filter.Execute;
  end;
end;

procedure TdlgFilter.DlgClose;
begin
  if assigned(Frame) then
    // Do any closing of the frame
    Frame.FrameClose;
end;

//
// Methods
//

procedure TdlgFilter.btnApplyClick(Sender: TObject);
begin
  DlgToItem;
end;

procedure TdlgFilter.btnOKClick(Sender: TObject);
begin
  DlgToItem;
  if assigned(Frame) then
    Frame.FrameOKClick;
  DlgClose;
  Close;
end;

procedure TdlgFilter.btnCancelClick(Sender: TObject);
begin
  DlgClose;
  Close;
end;

end.
