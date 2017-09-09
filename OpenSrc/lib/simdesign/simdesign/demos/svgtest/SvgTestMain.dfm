object frmMain: TfrmMain
  Left = 723
  Top = 147
  Width = 682
  Height = 525
  Caption = 
    'Svg test program for the NativeSvg library from simdesign (www.s' +
    'imdesign.nl)'
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
    Left = 478
    Top = 0
    Height = 448
    Align = alRight
  end
  object sbMain: TStatusBar
    Left = 0
    Top = 448
    Width = 666
    Height = 19
    Panels = <>
    SimplePanel = True
    SimpleText = 'Please drag and drop SVG file into this window'
  end
  object pnlRight: TPanel
    Left = 481
    Top = 0
    Width = 185
    Height = 448
    Align = alRight
    BevelOuter = bvNone
    Caption = 'pnlRight'
    TabOrder = 1
    object pnlControl: TPanel
      Left = 0
      Top = 388
      Width = 185
      Height = 60
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      object lbCount: TLabel
        Left = 120
        Top = 16
        Width = 17
        Height = 13
        Caption = '0/0'
      end
      object btnLeft: TButton
        Left = 16
        Top = 11
        Width = 41
        Height = 33
        Caption = '<'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnClick = btnLeftClick
      end
      object btnRight: TButton
        Left = 64
        Top = 11
        Width = 41
        Height = 33
        Caption = '>'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = btnRightClick
      end
    end
    object PageControl1: TPageControl
      Left = 0
      Top = 0
      Width = 185
      Height = 388
      ActivePage = tsDebug
      Align = alClient
      TabOrder = 1
      object tsDebug: TTabSheet
        Caption = 'Debug'
        object mmDebug: TMemo
          Left = 0
          Top = 0
          Width = 177
          Height = 360
          Align = alClient
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          ScrollBars = ssBoth
          TabOrder = 0
        end
      end
    end
  end
  object pnlCenter: TPanel
    Left = 0
    Top = 0
    Width = 478
    Height = 448
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pnlCenter'
    TabOrder = 2
    object pcMain: TPageControl
      Left = 0
      Top = 0
      Width = 478
      Height = 448
      ActivePage = tsImage
      Align = alClient
      TabOrder = 0
      object tsImage: TTabSheet
        Caption = 'Image'
        object scbImage: TScrollBox
          Left = 0
          Top = 0
          Width = 470
          Height = 420
          HorzScrollBar.Tracking = True
          VertScrollBar.Tracking = True
          Align = alClient
          TabOrder = 0
          object imImage: TImage
            Left = 0
            Top = 0
            Width = 105
            Height = 105
            AutoSize = True
          end
        end
      end
      object tsText: TTabSheet
        Caption = 'Text'
        ImageIndex = 1
        object seText: TSynEdit
          Left = 0
          Top = 0
          Width = 478
          Height = 424
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          TabOrder = 0
          Gutter.Font.Charset = DEFAULT_CHARSET
          Gutter.Font.Color = clWindowText
          Gutter.Font.Height = -11
          Gutter.Font.Name = 'Courier New'
          Gutter.Font.Style = []
          Highlighter = SynHTMLSyn1
          RemovedKeystrokes = <
            item
              Command = ecContextHelp
              ShortCut = 112
            end>
          AddedKeystrokes = <
            item
              Command = ecContextHelp
              ShortCut = 16496
            end>
        end
      end
    end
  end
  object mnuMain: TMainMenu
    Left = 328
    Top = 32
    object mnuFile: TMenuItem
      Caption = 'File'
      object mnuOpen: TMenuItem
        Caption = 'Open'
        OnClick = mnuOpenClick
      end
      object mnuSaveAs: TMenuItem
        Caption = 'Save as...'
        OnClick = mnuSaveAsClick
      end
      object mnuSavetoBitmap: TMenuItem
        Caption = 'Save to Bitmap...'
        OnClick = mnuSavetoBitmapClick
      end
      object mnuExit: TMenuItem
        Caption = 'Exit'
        OnClick = mnuExitClick
      end
    end
    object mnuOptions: TMenuItem
      Caption = 'Options'
      object mnuDebugOutput: TMenuItem
        Caption = 'Debug Output'
        Checked = True
        OnClick = mnuDebugOutputClick
        object mnuWsInfo: TMenuItem
          Tag = 1
          AutoCheck = True
          Caption = 'Info'
          Checked = True
          OnClick = mnuWsInfoClick
        end
        object mnuWsHint: TMenuItem
          Tag = 2
          AutoCheck = True
          Caption = 'Hint'
          Checked = True
          OnClick = mnuWsInfoClick
        end
        object mnuWsWarn: TMenuItem
          Tag = 4
          AutoCheck = True
          Caption = 'Warning'
          Checked = True
          OnClick = mnuWsInfoClick
        end
        object mnuWsFail: TMenuItem
          Tag = 8
          AutoCheck = True
          Caption = 'Failure'
          Checked = True
          OnClick = mnuWsInfoClick
        end
      end
    end
  end
  object SynHTMLSyn1: TSynHTMLSyn
    DefaultFilter = 'HTML Document (*.htm,*.html)|*.htm;*.html'
    Left = 360
    Top = 32
  end
end
