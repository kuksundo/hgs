object frmMain: TfrmMain
  Left = 518
  Top = 306
  Width = 593
  Height = 490
  Caption = 'Viewer for NativeSvg + Pyro (by Nils Haeck)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = mnuMain
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object sbMain: TStatusBar
    Left = 0
    Top = 413
    Width = 577
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 577
    Height = 413
    ActivePage = tsSource
    Align = alClient
    TabOrder = 1
    object tsImage: TTabSheet
      Caption = 'Image'
    end
    object tsDebug: TTabSheet
      Caption = 'Debug'
      ImageIndex = 1
      object mmDebug: TMemo
        Left = 0
        Top = 0
        Width = 569
        Height = 385
        Align = alClient
        Lines.Strings = (
          'Debug Info')
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
    object tsSource: TTabSheet
      Caption = 'Source'
      ImageIndex = 2
      object mmSource: TMemo
        Left = 0
        Top = 0
        Width = 569
        Height = 385
        Align = alClient
        Lines.Strings = (
          'mmSource')
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
  end
  object mnuMain: TMainMenu
    Left = 464
    Top = 8
    object mnuFile: TMenuItem
      Caption = 'File'
      object mnuLoadSVG: TMenuItem
        Caption = 'Load SVG'
        OnClick = mnuLoadSVGClick
      end
      object mnuExit: TMenuItem
        Caption = 'Exit'
        OnClick = mnuExitClick
      end
    end
    object mnuDemo: TMenuItem
      Caption = 'Demo'
      object mnuClear: TMenuItem
        Caption = 'Clear'
        OnClick = mnuClearClick
      end
      object mnuAddLines: TMenuItem
        Caption = 'Add Lines'
        OnClick = mnuAddLinesClick
      end
      object mnuAddRectangles: TMenuItem
        Caption = 'Add Rectangles'
        OnClick = mnuAddRectanglesClick
      end
      object mnuAddElllipses: TMenuItem
        Caption = 'Add Ellipses'
        OnClick = mnuAddEllipsesClick
      end
      object mnuAddPath: TMenuItem
        Caption = 'Add Path'
        OnClick = mnuAddPathClick
      end
      object mnuAddText: TMenuItem
        Caption = 'Add Text'
        OnClick = mnuAddTextClick
      end
      object mnuStressTest: TMenuItem
        Caption = 'Add 500 x 500 Rects'
        OnClick = mnuStressTestClick
      end
    end
    object mnuInteractive: TMenuItem
      Caption = 'Interactive'
      object mnuClickme: TMenuItem
        Caption = 'Click me'
        OnClick = mnuClickmeClick
      end
    end
    object mnuTest: TMenuItem
      Caption = 'Test'
      object mnuRefreshRate: TMenuItem
        Caption = 'Refresh Rate'
        OnClick = mnuRefreshRateClick
      end
      object mnuSetAntiAliasing: TMenuItem
        Caption = 'Set Anti-Aliasing'
        object mnuAANone: TMenuItem
          Caption = 'None'
          RadioItem = True
          OnClick = mnuAANoneClick
        end
        object mnuAAVeryLow: TMenuItem
          Caption = 'Very Low (2 levels)'
          RadioItem = True
          OnClick = mnuAAVeryLowClick
        end
        object mnuAALow: TMenuItem
          Caption = 'Low (4 levels)'
          RadioItem = True
          OnClick = mnuAALowClick
        end
        object mnuAAMedium: TMenuItem
          Caption = 'Medium (16 levels)'
          RadioItem = True
          OnClick = mnuAAMediumClick
        end
        object mnuAAHigh: TMenuItem
          Caption = 'High (256 levels)'
          Checked = True
          RadioItem = True
          OnClick = mnuAAHighClick
        end
      end
      object mnuSetPremultiplication: TMenuItem
        Caption = 'Set Premultiplication'
        object mnuPlain: TMenuItem
          Caption = 'Plain'
          GroupIndex = 1
          RadioItem = True
          OnClick = mnuPlainClick
        end
        object mnuPremultiplied: TMenuItem
          Caption = 'Premultiplied'
          Checked = True
          GroupIndex = 1
          RadioItem = True
          OnClick = mnuPremultipliedClick
        end
      end
      object mnuSetEngine: TMenuItem
        Caption = 'Set Engine'
        object mnuPyroEngine: TMenuItem
          Caption = 'Pyro'
          Checked = True
          GroupIndex = 2
          RadioItem = True
          OnClick = mnuPyroEngineClick
        end
        object mnuGDIEngine: TMenuItem
          Caption = 'GDI'
          GroupIndex = 2
          RadioItem = True
          OnClick = mnuGDIEngineClick
        end
      end
    end
    object mnuHelp: TMenuItem
      Caption = 'Help'
      object mnuAbout: TMenuItem
        Caption = 'About'
        OnClick = mnuAboutClick
      end
    end
  end
end
