{ unit RootItems

  The root item

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!
}
unit guiRootItems;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, BrowseTrees, guiFilterFrame;

type

  TRootFrame = class(TFilterFrame)
    lbInfo: TLabel;
  private
  public
  end;

  TRootItem = class(TBrowseItem)
  protected
    procedure CreateFilterParams; override;
  public
  end;

implementation

uses
  ItemLists;

{$R *.DFM}

procedure TRootItem.CreateFilterParams;
begin
  // Defaults
  Caption := 'All Items';
  ImageIndex := 0;

  DialogCaption := Caption;
  DialogIcon := 0;

  // Construct a standard item list as filter - may change later
  Filter := TItemList.Create(False);
  Filter.Name := 'all items';

  // Set frame class
  FrameClass := TRootFrame;
end;

end.
