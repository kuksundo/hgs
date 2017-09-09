object frmTileDemo: TfrmTileDemo
  Left = 322
  Top = 178
  Width = 870
  Height = 660
  Caption = 
    'Tile Demo (Random-access loading of Jpeg files) - copyright 2007' +
    ' SimDesign BV'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object sbMain: TStatusBar
    Left = 0
    Top = 587
    Width = 862
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 105
    Height = 587
    Align = alLeft
    Caption = 'Panel1'
    TabOrder = 1
  end
  object MainMenu1: TMainMenu
    Left = 792
    Top = 16
    object mnuFile: TMenuItem
      Caption = 'File'
      object mnuOpenJpeg: TMenuItem
        Caption = 'Open Jpeg...'
        OnClick = mnuOpenJpegClick
      end
      object mnuGenerateJpeg: TMenuItem
        Caption = 'Generate Jpeg...'
        OnClick = mnuGenerateJpegClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mnuExit: TMenuItem
        Caption = 'E&xit'
        OnClick = mnuExitClick
      end
    end
    object mnuScale: TMenuItem
      Caption = 'Scale'
      object mnuFullSize: TMenuItem
        Caption = 'Full Size'
        Checked = True
        RadioItem = True
        OnClick = mnuFullSizeClick
      end
      object mnuHalfSize: TMenuItem
        Caption = '1/2 Size'
        RadioItem = True
        OnClick = mnuHalfSizeClick
      end
      object mnuQuarterSize: TMenuItem
        Caption = '1/4 Size'
        RadioItem = True
        OnClick = mnuQuarterSizeClick
      end
      object mnuEighthSize: TMenuItem
        Caption = '1/8 Size'
        RadioItem = True
        OnClick = mnuEighthSizeClick
      end
    end
    object mnuHelp: TMenuItem
      Caption = 'Help'
      object mnuVisitWebsite: TMenuItem
        Caption = 'Visit NativeJpg website'
        OnClick = mnuVisitWebsiteClick
      end
    end
  end
end
