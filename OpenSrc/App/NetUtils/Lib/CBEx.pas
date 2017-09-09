{*******************************************************}
{                                                       }
{                TCoolBarEx Version 2.0                 }
{                                                       }
{          Copyright (c) 1999-2016 Vadim Crits          }
{                                                       }
{*******************************************************}

unit CBEx;

{$IF CompilerVersion >= 24}
  {$LEGACYIFEND ON}
{$IFEND}

interface

uses
  Windows, Messages, Classes, Controls, Forms, Menus, CommCtrl, ComCtrls;

const
  RBBS_USECHEVRON = $00000200;
  RBBIM_IDEALSIZE = $00000200;
  RBN_CHEVRONPUSHED = RBN_FIRST - 10;

type
  TCoolBarEx = class(TCoolBar)
  private
    FFormHandle: HWND;
    FFormInstance: Pointer;
    FDefFormProc: Pointer;
    FToolBarPopup: TPopupMenu;
    procedure FormWndProc(var Message: TMessage);
  protected
    procedure SetParent(AParent: TWinControl); override;
    procedure AlignControls(AControl: TControl; var Rect: TRect); override;
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  PNMReBarChevron = ^TNMReBarChevron;
  TNMReBarChevron = packed record
    hdr: NMHDR;
    uBand: UINT;
    wID: UINT;
    lParam: LPARAM;
    rc: TRect;
    lParamNM: LPARAM;
  end;

procedure Register;

implementation

uses Themes, Types;

{$R CBEx.res}

procedure Register;
begin
  RegisterComponents('Win32', [TCoolBarEx]);
end;

constructor TCoolBarEx.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFormHandle := 0;
  FFormInstance := Classes.MakeObjectInstance(FormWndProc);
  FToolBarPopup := TPopupMenu.Create(Self);
end;

destructor TCoolBarEx.Destroy;
begin
  if FFormHandle <> 0 then
    SetWindowLong(FFormHandle, GWL_WNDPROC, LongInt(FDefFormProc));
  Classes.FreeObjectInstance(FFormInstance);
  FToolBarPopup.Free;
  inherited Destroy;
end;

procedure TCoolBarEx.FormWndProc(var Message: TMessage);

  procedure CopyMenuItem(Destination, Source: TMenuItem);
  var
    I: Integer;
    SubItem: TMenuItem;
  begin
    for I := 0 to Source.Count - 1 do
    begin
      if not Source[I].Visible then
        Continue;
      SubItem := TMenuItem.Create(Self);
      with Source[I] do
      begin
        SubItem.Action := Action;
        if not Assigned(SubItem.Action) then
        begin
          SubItem.AutoCheck := AutoCheck;
          SubItem.Caption := Caption;
          SubItem.Checked := Checked;
          SubItem.Enabled := Enabled;
          SubItem.HelpContext := HelpContext;
          SubItem.Hint := Hint;
          SubItem.ImageIndex := ImageIndex;
          SubItem.ShortCut := ShortCut;
          SubItem.OnClick := OnClick;
        end;
        SubItem.Break := Break;
        SubItem.Default := Default;
        SubItem.GroupIndex := GroupIndex;
        SubItem.RadioItem := RadioItem;
        SubItem.SubMenuImages := SubMenuImages;
        SubItem.Tag := Tag;
      end;
      if Source[I].Count > 0 then
        CopyMenuItem(SubItem, Source[I]);
      Destination.Add(SubItem);
    end;
  end;

var
  Band: TCoolBand;
  R: TRect;
  I: Integer;
  CurItem: TMenuItem;
  P: TPoint;
begin
  try
    with Message do
    begin
      if Msg = WM_NOTIFY then
        if PNMHDR(LParam)^.Code = RBN_CHEVRONPUSHED then
          with PNMReBarChevron(LParam)^ do
            if wID <> 0 then
            begin
            {$IF CompilerVersion < 23}
              Band := TCoolBand(wID);
            {$ELSE}
              Band := TCoolBand(Bands.FindItemID(wID - 1));
            {$IFEND}
              with TToolBar(Band.Control) do
              begin
                FToolBarPopup.Items.Clear;
                if Assigned(Menu) then
                  FToolBarPopup.Images := Menu.Images
                else
                  FToolBarPopup.Images := Images;
                R := ClientRect;
                for I := 0 to ButtonCount - 1 do
                  with Buttons[I] do
                    if Left + Width > R.Right then
                    begin
                      CurItem := TMenuItem.Create(Self);
                      if Style in [tbsSeparator, tbsDivider] then
                        CurItem.Caption := '-'
                      else
                      begin
                        CurItem.Action := Action;
                        if not Assigned(CurItem.Action) then
                        begin
                          CurItem.Caption := Caption;
                          CurItem.Checked := Down;
                          CurItem.Enabled := Enabled;
                          CurItem.HelpContext := HelpContext;
                          CurItem.Hint := Hint;
                          CurItem.ImageIndex := ImageIndex;
                          CurItem.OnClick := OnClick;
                        end;
                        CurItem.RadioItem := Grouped;
                        CurItem.Tag := Tag;
                        if Grouped or (Style = tbsCheck) then
                          CurItem.ImageIndex := -1
                        else if CurItem.ImageIndex = -1 then
                          CurItem.ImageIndex := ImageIndex;
                      end;
                      if Assigned(DropdownMenu) then
                      begin
                        if (Style = tbsDropDown) and Assigned(OnClick) then
                          CurItem.OnClick := nil;
                        CopyMenuItem(CurItem, DropdownMenu.Items);
                      end
                      else if Assigned(MenuItem) then
                      begin
                        if not Assigned(FToolBarPopup.Images) then
                          FToolBarPopup.Images := MenuItem.GetParentMenu.Images;
                        if Assigned(MenuItem.OnClick) then
                          MenuItem.Click;
                        CopyMenuItem(CurItem, MenuItem);
                      end;
                      FToolBarPopup.Items.Add(CurItem);
                    end;
                P := Self.ClientToScreen(Point(rc.Left, rc.Bottom));
                FToolBarPopup.Popup(P.X + 2, P.Y + 2);
              end;
            end;
      Result := CallWindowProc(FDefFormProc, FFormHandle, Msg, WParam, LParam);
    end;
  except
    Application.HandleException(Self);
  end;
end;

procedure TCoolBarEx.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if Assigned(AParent) then
    if (AParent is TCustomForm) and (FFormHandle = 0) then
    begin
      FFormHandle := AParent.Handle;
      FDefFormProc := Pointer(GetWindowLong(FFormHandle, GWL_WNDPROC));
      SetWindowLong(FFormHandle, GWL_WNDPROC, Longint(FFormInstance));
    end;
end;

// QualityCentral
// Report #: 70868 Status: Open
// Ever-growing CoolBands in TCoolBar
procedure TCoolBarEx.AlignControls(AControl: TControl; var Rect: TRect);
const
  ComCtlVersionIE6 = $0006000A;
  Offset: array[Boolean] of Integer = (-1, 3);
var
  I: Integer;
  A: array of Integer;
  SelfLocked: Boolean;
begin
  if {$IF CompilerVersion < 23}
       ThemeServices.ThemesEnabled
     {$ELSE}
       StyleServices.Enabled
     {$IFEND} and (GetComCtlVersion >= ComCtlVersionIE6) then
  begin
    if not (csDestroying in ComponentState) and (Bands.Count > 0) then
    begin
      SetLength(A, Bands.Count);
      for I := 0 to Bands.Count - 1 do
        A[I] := Bands[I].Width;
      SelfLocked := LockWindowUpdate(Handle);
      try
        inherited AlignControls(AControl, Rect);
        for I := 0 to Bands.Count - 1 do
          with Bands[I] do
            if not FixedSize and (Width <> A[I]) then
              Width := Width + Offset[FixedOrder];
      finally
        if SelfLocked then
          LockWindowUpdate(0);
      end;
    end;
  end
  else
    inherited AlignControls(AControl, Rect);
end;

procedure TCoolBarEx.WndProc(var Message: TMessage);

  function IsValidButtonBar(ToolBar: TToolBar): Boolean;
  var
    I: Integer;
  begin
    with ToolBar do
    begin
      Result := ButtonCount > 0;
      if Result then
        for I := 0 to ControlCount - 1 do
          if not (Controls[I] is TToolButton) then
          begin
            Result := False;
            Break;
          end;
      if Result and Wrapable then
        Wrapable := False;
    end;
  end;

  function GetIdealSize(Band: TCoolBand): UINT;
  var
    I: Integer;
  begin
    Result := 0;
    with Band do
      if Control is TToolBar then
        if IsValidButtonBar(Control as TToolBar) then
          with TToolBar(Control) do
            for I := ButtonCount - 1 downto 0 do
              if Buttons[I].Visible then
              begin
                Result := Buttons[I].Left + Buttons[I].Width;
                System.Break;
              end;
  end;

var
  IdealSize: UINT;
  Band: TCoolBand;
begin
  if not (csDesigning in ComponentState) then
    with Message do
      if (Msg = RB_INSERTBAND) or (Msg = RB_SETBANDINFO) then
        with PReBarBandInfo(LParam)^ do
          if wID <> 0 then
          begin
          {$IF CompilerVersion < 23}
            Band := TCoolBand(wID);
          {$ELSE}
            Band := TCoolBand(Bands.FindItemID(wID - 1));
          {$IFEND}
            with Band do
              if Assigned(Control) then
              begin
                if MinHeight < Control.Height then
                  MinHeight := Control.Height;
                IdealSize := GetIdealSize(Band);
                if IdealSize > 0 then
                begin
                  fMask := fMask or RBBIM_IDEALSIZE;
                  fStyle := fStyle or RBBS_USECHEVRON;
                  cxIdeal := IdealSize;
                  Screen.Cursor := crDefault;
                end;
              end;
          end;
  inherited;
end;

end.
