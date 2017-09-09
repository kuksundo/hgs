object frmMain: TfrmMain
  Left = 614
  Top = 130
  Width = 672
  Height = 525
  Caption = 
    'Viewer for the NativeJpg library from simdesign (Delphi graphics' +
    '-compatible)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = mnuMain
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 468
    Top = 0
    Height = 447
    Align = alRight
  end
  object sbMain: TStatusBar
    Left = 0
    Top = 447
    Width = 656
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object pnlRight: TPanel
    Left = 471
    Top = 0
    Width = 185
    Height = 447
    Align = alRight
    BevelOuter = bvNone
    Caption = 'pnlRight'
    TabOrder = 1
    object pnlControl: TPanel
      Left = 0
      Top = 315
      Width = 185
      Height = 132
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 126
        Height = 13
        Caption = 'Lossless Brightness adjust:'
      end
      object lbBrightness: TLabel
        Left = 136
        Top = 8
        Width = 8
        Height = 13
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 8
        Top = 48
        Width = 116
        Height = 13
        Caption = 'Lossless Contrast adjust:'
      end
      object lbContrast: TLabel
        Left = 136
        Top = 48
        Width = 19
        Height = 13
        Caption = '1.0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbCount: TLabel
        Left = 120
        Top = 96
        Width = 17
        Height = 13
        Caption = '0/0'
      end
      object tbBrightness: TTrackBar
        Left = 8
        Top = 24
        Width = 169
        Height = 25
        Max = 200
        Min = -200
        PageSize = 10
        Frequency = 20
        TabOrder = 0
        ThumbLength = 10
      end
      object tbContrast: TTrackBar
        Left = 8
        Top = 64
        Width = 169
        Height = 25
        Max = 200
        Min = -200
        PageSize = 10
        Frequency = 20
        TabOrder = 1
        ThumbLength = 10
      end
      object btnLeft: TButton
        Left = 16
        Top = 91
        Width = 41
        Height = 33
        Caption = '<'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = btnLeftClick
      end
      object btnRight: TButton
        Left = 64
        Top = 91
        Width = 41
        Height = 33
        Caption = '>'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        OnClick = btnRightClick
      end
    end
    object mmDebug: TMemo
      Left = 0
      Top = 0
      Width = 185
      Height = 315
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 1
    end
  end
  object pnlCenter: TPanel
    Left = 0
    Top = 0
    Width = 468
    Height = 447
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pnlCenter'
    TabOrder = 2
    object PageControl1: TPageControl
      Left = 0
      Top = 0
      Width = 468
      Height = 447
      ActivePage = tsImage
      Align = alClient
      TabOrder = 0
      object tsImage: TTabSheet
        Caption = 'Image'
        object scbMain: TScrollBox
          Left = 0
          Top = 0
          Width = 460
          Height = 419
          HorzScrollBar.Tracking = True
          VertScrollBar.Tracking = True
          Align = alClient
          TabOrder = 0
          object imMain: TImage
            Left = 0
            Top = 0
            Width = 105
            Height = 105
            AutoSize = True
          end
        end
      end
      object tsMetadata: TTabSheet
        Caption = 'Metadata'
        ImageIndex = 1
        object reMetadata: TRichEdit
          Left = 0
          Top = 0
          Width = 460
          Height = 419
          Align = alClient
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Lucida Console'
          Font.Style = []
          Lines.Strings = (
            'Metadata will be listed here')
          ParentFont = False
          ScrollBars = ssBoth
          TabOrder = 0
          WordWrap = False
        end
      end
    end
  end
  object mnuMain: TMainMenu
    Left = 544
    Top = 24
    object mnuFile: TMenuItem
      Caption = 'File'
      object mnuOpen: TMenuItem
        Caption = 'Open Fullscale'
        OnClick = mnuOpenClick
      end
      object mnuReload: TMenuItem
        Caption = 'Reload'
        OnClick = mnuReloadClick
      end
      object mnuOpenDiv2: TMenuItem
        Caption = 'Open 1/2 scale'
        OnClick = mnuOpenDiv2Click
      end
      object mnuOpenDiv4: TMenuItem
        Caption = 'Open 1/4 scale'
        OnClick = mnuOpenDiv4Click
      end
      object mnuOpenDiv8: TMenuItem
        Caption = 'Open 1/8 scale'
        OnClick = mnuOpenDiv8Click
      end
      object mnuSaveAs: TMenuItem
        Caption = 'Save as...'
        OnClick = mnuSaveAsClick
      end
      object mnuSaveDebugInfo: TMenuItem
        Caption = 'Save Debug Info'
        OnClick = mnuSaveDebugInfoClick
      end
      object mnuConvertFromBitmap: TMenuItem
        Caption = 'Convert Jpeg from Bitmap'
        OnClick = mnuConvertFromBitmapClick
      end
      object mnuExit: TMenuItem
        Caption = 'Exit'
        OnClick = mnuExitClick
      end
    end
    object mnuLossless: TMenuItem
      Caption = 'Lossless'
      object mnuRotateFromExif: TMenuItem
        Caption = 'Rotate based on EXIF info'
        OnClick = mnuRotateFromExifClick
      end
      object mnuRotate90: TMenuItem
        Caption = 'Rotate 90'
        OnClick = mnuRotate90Click
      end
      object mnuRotate180: TMenuItem
        Caption = 'Rotate 180'
        OnClick = mnuRotate180Click
      end
      object mnuRotate270: TMenuItem
        Caption = 'Rotate 270'
        OnClick = mnuRotate270Click
      end
      object mnuFliphorizontal: TMenuItem
        Caption = 'Flip horizontal'
        OnClick = mnuFliphorizontalClick
      end
      object mnuFlipvertical: TMenuItem
        Caption = 'Flip vertical'
        OnClick = mnuFlipverticalClick
      end
      object mnuTranspose: TMenuItem
        Caption = 'Transpose'
        OnClick = mnuTransposeClick
      end
      object mnuCrop: TMenuItem
        Caption = 'Crop to 80%'
        OnClick = mnuCropClick
      end
      object mnuTouch: TMenuItem
        Caption = 'Touch'
        OnClick = mnuTouchClick
      end
    end
    object mnuOptions: TMenuItem
      Caption = 'Options'
      object mnuDebugOutput: TMenuItem
        Caption = 'Debug Output'
        Checked = True
        OnClick = mnuDebugOutputClick
      end
      object mnuClearOutput: TMenuItem
        Caption = 'Clear debug output'
        OnClick = mnuClearOutputClick
      end
      object mnuFastIDCT: TMenuItem
        Caption = 'Fast IDCT'
      end
      object mnuTiledDrawing: TMenuItem
        Caption = 'Tiled Drawing'
        OnClick = mnuTiledDrawingClick
      end
      object mnuExtractICC: TMenuItem
        Caption = 'Extract ICC profile...'
        OnClick = mnuExtractICCClick
      end
      object mnuInjectICC: TMenuItem
        Caption = 'Inject ICC profile...'
        OnClick = mnuInjectICCClick
      end
    end
  end
end
