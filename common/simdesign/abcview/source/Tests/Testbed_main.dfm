object Form1: TForm1
  Left = 432
  Top = 241
  Width = 539
  Height = 360
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Notebook1: TNotebook
    Left = 0
    Top = 0
    Width = 531
    Height = 333
    Align = alClient
    PageIndex = 2
    TabOrder = 0
    object TPage
      Left = 0
      Top = 0
      Caption = 'Default'
      object Image2: TImage
        Left = 32
        Top = 48
        Width = 16
        Height = 16
      end
      object Label1: TLabel
        Left = 56
        Top = 48
        Width = 32
        Height = 13
        Caption = 'Label1'
      end
      object Image1: TImage
        Left = 32
        Top = 72
        Width = 32
        Height = 32
      end
      object Label2: TLabel
        Left = 32
        Top = 152
        Width = 32
        Height = 13
        Caption = 'Label2'
      end
      object Button1: TButton
        Left = 32
        Top = 16
        Width = 75
        Height = 25
        Caption = 'Button1'
        TabOrder = 0
      end
      object Edit1: TEdit
        Left = 120
        Top = 16
        Width = 121
        Height = 21
        TabOrder = 1
        Text = '*.bmp'
      end
      object Edit2: TEdit
        Left = 120
        Top = 120
        Width = 121
        Height = 21
        TabOrder = 2
        Text = 'c:\temp'
      end
      object Button2: TButton
        Left = 32
        Top = 120
        Width = 75
        Height = 25
        Caption = 'Button2'
        TabOrder = 3
        OnClick = Button2Click
      end
      object Button3: TButton
        Left = 32
        Top = 208
        Width = 75
        Height = 25
        Caption = 'Button3'
        TabOrder = 4
        OnClick = Button3Click
      end
      object Button4: TButton
        Left = 32
        Top = 240
        Width = 75
        Height = 25
        Caption = 'Button4'
        TabOrder = 5
        OnClick = Button4Click
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'TestCRW'
      object Label3: TLabel
        Left = 16
        Top = 8
        Width = 45
        Height = 13
        Caption = 'CRW file:'
      end
      object imCanon: TImage
        Left = 0
        Top = 232
        Width = 531
        Height = 101
        Align = alBottom
        AutoSize = True
        Stretch = True
      end
      object Label4: TLabel
        Left = 128
        Top = 120
        Width = 36
        Height = 13
        Caption = 'Gamma'
      end
      object Label5: TLabel
        Left = 200
        Top = 120
        Width = 49
        Height = 13
        Caption = 'Brightness'
      end
      object feCRWFile: TFilenameEdit
        Left = 16
        Top = 24
        Width = 505
        Height = 21
        NumGlyphs = 1
        TabOrder = 0
        Text = 'D:\Zipfiles\Programming\Delphi\Algorithms\CanonCRW\CRW_0834.crw'
      end
      object btnOpen: TButton
        Left = 16
        Top = 56
        Width = 105
        Height = 25
        Caption = 'Open!'
        TabOrder = 1
        OnClick = btnOpenClick
      end
      object reInfo: TRichEdit
        Left = 272
        Top = 56
        Width = 249
        Height = 105
        ScrollBars = ssBoth
        TabOrder = 2
      end
      object chbSmoothing: TCheckBox
        Left = 128
        Top = 56
        Width = 145
        Height = 17
        Caption = 'Additional smoothing'
        Checked = True
        State = cbChecked
        TabOrder = 3
      end
      object seGamma: TRxSpinEdit
        Left = 128
        Top = 136
        Width = 65
        Height = 21
        Increment = 0.05
        MaxValue = 3
        ValueType = vtFloat
        Value = 0.8
        TabOrder = 4
      end
      object btnSaveJPG: TButton
        Left = 16
        Top = 96
        Width = 105
        Height = 25
        Caption = 'Save as JPG!'
        TabOrder = 5
        OnClick = btnSaveJPGClick
      end
      object btnSaveBMP: TButton
        Left = 16
        Top = 136
        Width = 105
        Height = 25
        Caption = 'Save as BMP!'
        TabOrder = 6
        OnClick = btnSaveBMPClick
      end
      object seBright: TRxSpinEdit
        Left = 200
        Top = 136
        Width = 65
        Height = 21
        Increment = 0.2
        MaxValue = 1000
        ValueType = vtFloat
        Value = 1
        TabOrder = 7
      end
      object chbHalfscale: TCheckBox
        Left = 128
        Top = 80
        Width = 145
        Height = 17
        Caption = 'Half scale'
        TabOrder = 8
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Exif'
      object Label6: TLabel
        Left = 16
        Top = 8
        Width = 36
        Height = 13
        Caption = 'JPG file'
      end
      object btnExtractTags: TButton
        Left = 16
        Top = 56
        Width = 75
        Height = 25
        Caption = 'Extract Tags'
        TabOrder = 0
        OnClick = btnExtractTagsClick
      end
      object feTagFile: TFilenameEdit
        Left = 16
        Top = 24
        Width = 505
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        NumGlyphs = 1
        TabOrder = 1
        Text = 'D:\temp\testiptc.jpg'
      end
      object vstTags: TVirtualStringTree
        Left = 16
        Top = 88
        Width = 505
        Height = 233
        Anchors = [akLeft, akTop, akRight, akBottom]
        BorderStyle = bsSingle
        CheckImageKind = ckXP
        CustomCheckImages = ilLarge
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        Header.AutoSizeIndex = 0
        Header.Columns = <
          item
            Alignment = taLeftJustify
            ImageIndex = -1
            Layout = blGlyphLeft
            Position = 0
            Width = 200
            WideText = 'Name'
          end
          item
            Alignment = taLeftJustify
            ImageIndex = -1
            Layout = blGlyphLeft
            Position = 1
            Width = 280
            WideText = 'Value'
          end>
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'MS Sans Serif'
        Header.Font.Style = []
        Header.Options = [hoColumnResize, hoDrag, hoVisible]
        Header.Style = hsThickButtons
        HintAnimation = hatNone
        HintMode = hmDefault
        IncrementalSearchDirection = sdForward
        NodeDataSize = 4
        ParentFont = False
        TabOrder = 2
        TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoDeleteMovedNodes]
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toGridExtensions, toReportMode, toToggleOnDblClick, toWheelPanning]
        TreeOptions.PaintOptions = [toPopupMode, toShowBackground, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowTreeLines, toShowVertGridLines, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toFullRowSelect]
        OnExpanding = vstTagsExpanding
        OnGetText = vstTagsGetText
        OnInitNode = vstTagsInitNode
        WideDefaultText = 'Node'
      end
      object btnSaveNoExif: TButton
        Left = 120
        Top = 56
        Width = 113
        Height = 25
        Caption = 'Save without Exif'
        TabOrder = 3
        OnClick = btnSaveNoExifClick
      end
    end
  end
  object ilSmall: TImageList
    Left = 320
    Top = 8
  end
  object ilLarge: TImageList
    Left = 352
    Top = 8
  end
  object sdCanon: TSaveDialog
    Left = 384
    Top = 8
  end
  object sdJpg: TSaveDialog
    Left = 416
    Top = 8
  end
end
