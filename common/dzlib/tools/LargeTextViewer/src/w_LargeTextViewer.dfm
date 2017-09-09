object f_LargeTextViewer: Tf_LargeTextViewer
  Left = 0
  Top = 0
  Caption = 'Large Text Viewer'
  ClientHeight = 344
  ClientWidth = 643
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = TheMainMenu
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object sg_Display: TdzVirtualStringGrid
    Left = 0
    Top = 0
    Width = 643
    Height = 325
    OnGetNonfixedCellData = sg_DisplayGetNonfixedCellData
    Align = alClient
    ColCount = 1
    FixedRows = 0
    RowCount = 1
    TabOrder = 0
    OnResize = sg_DisplayResize
  end
  object TheStatusBar: TStatusBar
    Left = 0
    Top = 325
    Width = 643
    Height = 19
    Panels = <>
    SimplePanel = True
    SimpleText = 'Indexing ...'
  end
  object tim_Update: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tim_UpdateTimer
    Left = 312
    Top = 176
  end
  object TheMainMenu: TMainMenu
    Left = 424
    Top = 176
    object mi_File: TMenuItem
      Caption = 'File'
      object mi_Open: TMenuItem
        Caption = 'Open'
        OnClick = mi_OpenClick
      end
      object mi_Exit: TMenuItem
        Caption = 'Exit'
        OnClick = mi_ExitClick
      end
    end
  end
  object TheOpenDialog: TOpenDialog
    Left = 192
    Top = 176
  end
end
