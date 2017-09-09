{ unit FilterFrames

  This unit implements a base dialog for all filters in the browse tree. Override
  this base dialog to create custom filter dialogs

  Modifications:
  24May2004: Added FrameOKClick

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit guiFilterFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type

  // TFilterFilter is the ancestor frame for all frames that implement filters
  TFilterFrame = class(TFrame)
  private
    FItem: pointer;
  public
    // DlgToFilter is called when saving the filter's values from the
    // control properties in the dialog
    procedure DlgToFilter; virtual;
    // FilterToDlg is called when initializing the dialog to show correct
    // control properties based on the filter
    procedure FilterToDlg; virtual;
    // Do any closing of the frame
    procedure FrameClose; virtual;
    // Handle click on OK button
    procedure FrameOKClick; virtual;
    // LoadFromStream is called to load the filter data from a stream
    procedure LoadFromStream(S: TStream); virtual;
    // SaveToStream is called to save the filter data to a stream
    procedure SaveToStream(S: TStream); virtual;
    // Pointer to TBrowseItem that is the backend of this frame
    property Item: pointer read FItem write FItem;
  end;

  // Create this class so we can dynamically generate filters
  TFilterFrameClass = class of TFilterFrame;

implementation

{$R *.DFM}

{ TfrFilter object }

procedure TFilterFrame.DlgToFilter;
begin
  // Base class does nothing
end;

procedure TFilterFrame.FilterToDlg;
begin
  // Base class does nothing
end;

procedure TFilterFrame.FrameClose;
begin
  // Base class does nothing
end;

procedure TFilterFrame.FrameOKClick;
begin
  // Base class does nothing
end;

procedure TFilterFrame.LoadFromStream(S: TStream);
begin
  // Base class does nothing
end;

procedure TFilterFrame.SaveToStream(S: TStream);
begin
  // Base class does nothing
end;

end.
