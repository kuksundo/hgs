object fmMain: TfmMain
  Left = 321
  Top = 151
  Width = 752
  Height = 634
  Caption = 'License Plate Recognition Demo'
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
  object StatusBar1: TStatusBar
    Left = 0
    Top = 557
    Width = 736
    Height = 19
    Panels = <>
  end
  object pcMain: TPageControl
    Left = 0
    Top = 0
    Width = 736
    Height = 557
    ActivePage = tsRecognise
    Align = alClient
    TabOrder = 1
    OnChange = pcMainChange
    OnChanging = pcMainChanging
    object tsRecognise: TTabSheet
      Caption = 'Recognise'
      DesignSize = (
        728
        529)
      object Label1: TLabel
        Left = 478
        Top = 0
        Width = 91
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Recognised text(s):'
      end
      object Label2: TLabel
        Left = 478
        Top = 168
        Width = 51
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Messages:'
      end
      object Label3: TLabel
        Left = 479
        Top = 312
        Width = 60
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Recognition:'
      end
      object lbGlyphNo: TLabel
        Left = 591
        Top = 312
        Width = 49
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'lbGlyphNo'
      end
      object imGlyph: TImage
        Left = 481
        Top = 336
        Width = 100
        Height = 200
        Anchors = [akTop, akRight]
        AutoSize = True
      end
      object Label6: TLabel
        Left = 593
        Top = 336
        Width = 111
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Alternatives (within 5%):'
      end
      object sbOcr: TScrollBox
        Left = 0
        Top = 40
        Width = 474
        Height = 501
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 0
        object imOCR: TImage
          Left = 0
          Top = 0
          Width = 105
          Height = 105
          AutoSize = True
          OnMouseDown = imOCRMouseDown
        end
      end
      object mmTexts: TMemo
        Left = 478
        Top = 16
        Width = 257
        Height = 145
        Anchors = [akTop, akRight]
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Fixedsys'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object mmMessages: TMemo
        Left = 478
        Top = 184
        Width = 257
        Height = 121
        Anchors = [akTop, akRight]
        ScrollBars = ssBoth
        TabOrder = 2
      end
      object udGlyph: TUpDown
        Left = 551
        Top = 312
        Width = 25
        Height = 16
        Anchors = [akTop, akRight]
        Orientation = udHorizontal
        TabOrder = 3
        OnClick = udGlyphClick
      end
      object Button1: TButton
        Left = 593
        Top = 456
        Width = 88
        Height = 25
        Action = aGlyphToEditor
        Anchors = [akTop, akRight]
        TabOrder = 4
      end
      object lbAlternatives: TListBox
        Left = 593
        Top = 352
        Width = 121
        Height = 97
        Anchors = [akTop, akRight]
        ItemHeight = 13
        TabOrder = 5
      end
      object btnRecognise: TButton
        Left = 88
        Top = 8
        Width = 75
        Height = 25
        Action = acRecogniseAll
        TabOrder = 6
      end
      object btnOpenBitmap: TButton
        Left = 0
        Top = 8
        Width = 81
        Height = 25
        Action = acFileOpen
        TabOrder = 7
      end
    end
    object tsTrainers: TTabSheet
      Caption = 'Trainers'
      ImageIndex = 1
      object ScrollBox2: TScrollBox
        Left = 0
        Top = 0
        Width = 736
        Height = 533
        Align = alClient
        TabOrder = 0
        object imTrainers: TImage
          Left = 0
          Top = 0
          Width = 105
          Height = 105
          AutoSize = True
        end
      end
    end
    object tsEditor: TTabSheet
      Caption = 'Editor'
      ImageIndex = 2
      object Label4: TLabel
        Left = 8
        Top = 8
        Width = 38
        Height = 13
        Caption = 'Trainers'
      end
      object Label5: TLabel
        Left = 8
        Top = 248
        Width = 61
        Height = 13
        Caption = 'Listed glyphs'
      end
      object Label7: TLabel
        Left = 616
        Top = 8
        Width = 38
        Height = 13
        Caption = 'Preview'
      end
      object Image1: TImage
        Left = 616
        Top = 24
        Width = 105
        Height = 105
      end
      object lbTrainers: TListBox
        Left = 8
        Top = 24
        Width = 121
        Height = 209
        ItemHeight = 13
        MultiSelect = True
        TabOrder = 0
      end
      object CheckListBox1: TCheckListBox
        Left = 8
        Top = 264
        Width = 121
        Height = 273
        ItemHeight = 13
        TabOrder = 1
      end
      object ScrollBox3: TScrollBox
        Left = 232
        Top = 40
        Width = 369
        Height = 497
        TabOrder = 2
      end
      object Button2: TButton
        Left = 136
        Top = 24
        Width = 81
        Height = 25
        Action = acTrainerNew
        TabOrder = 3
      end
      object Button3: TButton
        Left = 136
        Top = 56
        Width = 81
        Height = 25
        Action = acTrainerDelete
        TabOrder = 4
      end
    end
    object tsOCRSettings: TTabSheet
      Caption = 'OCR Settings'
      ImageIndex = 3
      object GroupBox1: TGroupBox
        Left = 8
        Top = 8
        Width = 185
        Height = 153
        Caption = 'Threshold'
        TabOrder = 0
        object Label8: TLabel
          Left = 16
          Top = 24
          Width = 27
          Height = 13
          Caption = 'Type:'
        end
        object Label9: TLabel
          Left = 96
          Top = 24
          Width = 75
          Height = 13
          Caption = 'High Threshold:'
        end
        object Label10: TLabel
          Left = 96
          Top = 72
          Width = 73
          Height = 13
          Caption = 'Low Threshold:'
        end
        object chbAdaptiveTreshold: TCheckBox
          Left = 16
          Top = 120
          Width = 145
          Height = 17
          Caption = 'Adaptive Thresholding'
          TabOrder = 0
        end
        object rbSingleTreshold: TRadioButton
          Left = 16
          Top = 48
          Width = 73
          Height = 17
          Caption = 'Single'
          TabOrder = 1
        end
        object rbDualTreshold: TRadioButton
          Left = 16
          Top = 64
          Width = 81
          Height = 17
          Caption = 'Dual'
          TabOrder = 2
        end
        object edTreshold: TEdit
          Left = 96
          Top = 40
          Width = 57
          Height = 21
          TabOrder = 3
          Text = '0'
        end
        object udTreshold: TUpDown
          Left = 153
          Top = 40
          Width = 15
          Height = 21
          Associate = edTreshold
          Max = 255
          TabOrder = 4
        end
        object edTresholdLo: TEdit
          Left = 96
          Top = 88
          Width = 57
          Height = 21
          TabOrder = 5
          Text = '0'
        end
        object udTresholdLo: TUpDown
          Left = 153
          Top = 88
          Width = 15
          Height = 21
          Associate = edTresholdLo
          Max = 255
          TabOrder = 6
        end
      end
      object GroupBox2: TGroupBox
        Left = 208
        Top = 8
        Width = 217
        Height = 185
        Caption = 'Glyph sizes in pixels'
        TabOrder = 1
        object Label11: TLabel
          Left = 16
          Top = 24
          Width = 54
          Height = 13
          Caption = 'Min. Width:'
        end
        object Label12: TLabel
          Left = 104
          Top = 24
          Width = 57
          Height = 13
          Caption = 'Max. Width:'
        end
        object Label13: TLabel
          Left = 16
          Top = 80
          Width = 57
          Height = 13
          Caption = 'Min. Height:'
        end
        object Label14: TLabel
          Left = 104
          Top = 80
          Width = 60
          Height = 13
          Caption = 'Max. Height:'
        end
        object Label15: TLabel
          Left = 16
          Top = 128
          Width = 107
          Height = 13
          Caption = 'Min. Glyph Pointcount:'
        end
        object edMinGlyphWidth: TEdit
          Left = 16
          Top = 40
          Width = 57
          Height = 21
          TabOrder = 0
          Text = '0'
        end
        object udMinGlyphWidth: TUpDown
          Left = 73
          Top = 40
          Width = 15
          Height = 21
          Associate = edMinGlyphWidth
          Max = 500
          TabOrder = 1
        end
        object edMaxGlyphWidth: TEdit
          Left = 104
          Top = 40
          Width = 57
          Height = 21
          TabOrder = 2
          Text = '0'
        end
        object udMaxGlyphWidth: TUpDown
          Left = 161
          Top = 40
          Width = 15
          Height = 21
          Associate = edMaxGlyphWidth
          Max = 500
          TabOrder = 3
        end
        object edMinGlyphHeight: TEdit
          Left = 16
          Top = 96
          Width = 57
          Height = 21
          TabOrder = 4
          Text = '0'
        end
        object udMinGlyphHeight: TUpDown
          Left = 73
          Top = 96
          Width = 15
          Height = 21
          Associate = edMinGlyphHeight
          Max = 500
          TabOrder = 5
        end
        object edMaxGlyphHeight: TEdit
          Left = 104
          Top = 96
          Width = 57
          Height = 21
          TabOrder = 6
          Text = '0'
        end
        object udMaxGlyphHeight: TUpDown
          Left = 161
          Top = 96
          Width = 15
          Height = 21
          Associate = edMaxGlyphHeight
          Max = 500
          TabOrder = 7
        end
        object edMinGlyphPointCount: TEdit
          Left = 16
          Top = 144
          Width = 57
          Height = 21
          TabOrder = 8
          Text = '0'
        end
        object udMinGlyphPointCount: TUpDown
          Left = 73
          Top = 144
          Width = 15
          Height = 21
          Associate = edMinGlyphPointCount
          Max = 1000
          TabOrder = 9
        end
      end
    end
  end
  object mnuMain: TMainMenu
    Left = 592
    object File1: TMenuItem
      Caption = '&File'
      object Open1: TMenuItem
        Action = acFileOpen
      end
      object SaveTrainers1: TMenuItem
        Action = acSaveOcrSetup
      end
      object LoadTrainers1: TMenuItem
        Action = acLoadOcrSetup
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Action = acExit
      end
    end
    object View1: TMenuItem
      Caption = 'View'
      object ShowTrainers1: TMenuItem
        Action = acShowTrainers
      end
    end
    object Tools1: TMenuItem
      Caption = 'Tools'
      object Recognise1: TMenuItem
        Action = acRecogniseAll
      end
      object acGlyphStats1: TMenuItem
        Action = acGlyphStats
      end
    end
  end
  object alMain: TActionList
    Left = 632
    object acFileOpen: TAction
      Caption = '&Open bitmap...'
      OnExecute = acFileOpenExecute
    end
    object acRecogniseAll: TAction
      Caption = 'Recognise'
      OnExecute = acRecogniseAllExecute
    end
    object acGlyphStats: TAction
      Caption = 'Glyph Statistics...'
      OnExecute = acGlyphStatsExecute
    end
    object acShowTrainers: TAction
      Caption = 'Show Trainers'
      OnExecute = acShowTrainersExecute
    end
    object acLoadOcrSetup: TAction
      Caption = 'Load OCR setup'
      OnExecute = acLoadOcrSetupExecute
    end
    object acSaveOcrSetup: TAction
      Caption = 'Save OCR setup'
      OnExecute = acSaveOcrSetupExecute
    end
    object aGlyphToEditor: TAction
      Caption = 'Glyph to editor'
      OnExecute = aGlyphToEditorExecute
    end
    object acTrainerNew: TAction
      Caption = 'New Trainer'
      OnExecute = acTrainerNewExecute
    end
    object acTrainerDelete: TAction
      Caption = 'Del Trainer(s)'
    end
    object acExit: TAction
      Caption = 'Exit'
      OnExecute = acExitExecute
    end
  end
end
