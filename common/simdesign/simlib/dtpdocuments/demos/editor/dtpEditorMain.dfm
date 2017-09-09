object frmMain: TfrmMain
  Left = 479
  Top = 150
  Width = 1016
  Height = 692
  Caption = 'frmMain'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = mnuMain
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object sbMain: TStatusBar
    Left = 0
    Top = 619
    Width = 1008
    Height = 19
    Panels = <
      item
        Width = 150
      end
      item
        Width = 50
      end>
  end
  object cbMain: TCoolBar
    Left = 0
    Top = 0
    Width = 1008
    Height = 49
    BandBorderStyle = bsNone
    Bands = <
      item
        Break = False
        Control = ToolBar1
        HorizontalOnly = True
        ImageIndex = -1
        MinHeight = 79
        Width = 1004
      end>
    object ToolBar1: TToolBar
      Left = 9
      Top = 0
      Width = 991
      Height = 38
      AutoSize = True
      ButtonHeight = 36
      ButtonWidth = 68
      Caption = 'tbMain'
      EdgeInner = esNone
      EdgeOuter = esNone
      Images = ilMain
      ShowCaptions = True
      TabOrder = 0
      object ToolButton1: TToolButton
        Left = 0
        Top = 2
        Action = acFileOpen
        AutoSize = True
      end
      object ToolButton3: TToolButton
        Left = 37
        Top = 2
        Action = acFileSave
        AutoSize = True
      end
      object ToolButton7: TToolButton
        Left = 73
        Top = 2
        Width = 8
        Caption = 'ToolButton7'
        Style = tbsSeparator
      end
      object tbAdd: TToolButton
        Left = 81
        Top = 2
        AutoSize = True
        Caption = 'Add'
        DropdownMenu = pmShapeAdd
        ImageIndex = 7
        Style = tbsDropDown
        OnClick = tbAddClick
      end
      object ToolButton9: TToolButton
        Left = 124
        Top = 2
        Action = acDelete
        AutoSize = True
      end
      object ToolButton4: TToolButton
        Left = 166
        Top = 2
        Width = 8
        Caption = 'ToolButton4'
        Style = tbsSeparator
      end
      object ToolButton5: TToolButton
        Left = 174
        Top = 2
        Action = acZoomWidth
        AutoSize = True
        Caption = 'Width'
      end
      object ToolButton6: TToolButton
        Left = 213
        Top = 2
        Action = acZoomPage
        AutoSize = True
        Caption = 'Page'
      end
      object ToolButton13: TToolButton
        Left = 249
        Top = 2
        Action = acZoomMinus
        AutoSize = True
      end
      object ToolButton14: TToolButton
        Left = 305
        Top = 2
        Action = acZoomPlus
        AutoSize = True
      end
      object ToolButton10: TToolButton
        Left = 355
        Top = 2
        Width = 8
        Caption = 'ToolButton10'
        Style = tbsSeparator
      end
      object ToolButton11: TToolButton
        Left = 363
        Top = 2
        Action = acPagePrev
        AutoSize = True
        Caption = 'Prev'
      end
      object ToolButton12: TToolButton
        Left = 396
        Top = 2
        Action = acPageNext
        AutoSize = True
        Caption = 'Next'
      end
      object ToolButton19: TToolButton
        Left = 429
        Top = 2
        Width = 8
        Caption = 'ToolButton19'
        Style = tbsSeparator
      end
      object ToolButton15: TToolButton
        Left = 437
        Top = 2
        Action = acMoveBack
        AutoSize = True
      end
      object ToolButton16: TToolButton
        Left = 503
        Top = 2
        Action = acMoveFwd
        AutoSize = True
      end
      object ToolButton17: TToolButton
        Left = 564
        Top = 2
        Action = acGroup
        AutoSize = True
      end
      object ToolButton18: TToolButton
        Left = 604
        Top = 2
        Action = acUngroup
        AutoSize = True
      end
      object ToolButton20: TToolButton
        Left = 656
        Top = 2
        Action = acAlign
        AutoSize = True
        DropdownMenu = pmAlignment
        Style = tbsDropDown
      end
      object ToolButton2: TToolButton
        Left = 703
        Top = 2
        Width = 8
        Caption = 'ToolButton2'
        ImageIndex = 29
        Style = tbsSeparator
      end
      object ToolButton8: TToolButton
        Left = 711
        Top = 2
        Action = acPan
        AllowAllUp = True
        AutoSize = True
        Grouped = True
        ImageIndex = 44
      end
      object ToolButton21: TToolButton
        Left = 741
        Top = 2
        Action = acZoom
        AllowAllUp = True
        AutoSize = True
        Grouped = True
        ImageIndex = 42
      end
      object ToolButton22: TToolButton
        Left = 779
        Top = 2
        Action = acDragZoom
        AllowAllUp = True
        AutoSize = True
        Grouped = True
        ImageIndex = 43
      end
      object ToolButton23: TToolButton
        Left = 843
        Top = 2
        Action = acZoomInOut
        AllowAllUp = True
        AutoSize = True
        Grouped = True
        ImageIndex = 6
      end
    end
  end
  object pnlMain: TPanel
    Left = 0
    Top = 49
    Width = 1008
    Height = 570
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object spThumbs: TSplitter
      Left = 0
      Top = 497
      Width = 1008
      Height = 2
      Cursor = crVSplit
      Align = alBottom
      Beveled = True
    end
    object lvThumbs: TListView
      Left = 0
      Top = 499
      Width = 1008
      Height = 71
      Align = alBottom
      Color = clAppWorkSpace
      Columns = <>
      DragMode = dmAutomatic
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMenu
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      HideSelection = False
      LargeImages = ilThumbs
      MultiSelect = True
      OwnerData = True
      ParentFont = False
      SmallImages = ilThumbs
      TabOrder = 0
      OnChange = lvThumbsChange
      OnClick = lvThumbsClick
      OnData = lvThumbsData
      OnEdited = lvThumbsEdited
      OnExit = lvThumbsExit
      OnDragDrop = lvThumbsDragDrop
      OnDragOver = lvThumbsDragOver
      OnKeyDown = lvThumbsKeyDown
      OnStartDrag = lvThumbsStartDrag
    end
    object pnlTop: TPanel
      Left = 0
      Top = 0
      Width = 1008
      Height = 497
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object spLeft: TSplitter
        Left = 301
        Top = 0
        Width = 5
        Height = 497
        Beveled = True
      end
      object pnlLeft: TPanel
        Left = 0
        Top = 0
        Width = 301
        Height = 497
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        object pcEdit: TPageControl
          Left = 0
          Top = 0
          Width = 301
          Height = 497
          ActivePage = tsPage
          Align = alClient
          TabOrder = 0
          object tsShape: TTabSheet
            Caption = 'Shape'
          end
          object tsEffect: TTabSheet
            Caption = 'Effect'
            ImageIndex = 3
          end
          object tsPage: TTabSheet
            Caption = 'Page'
            ImageIndex = 1
            object Label17: TLabel
              Left = 8
              Top = 32
              Width = 260
              Height = 13
              Caption = 'Uncheck this box to override default document settings'
            end
            object Bevel3: TBevel
              Left = 8
              Top = 72
              Width = 249
              Height = 9
              Shape = bsTopLine
            end
            object Label18: TLabel
              Left = 8
              Top = 140
              Width = 95
              Height = 13
              Caption = 'Width x Height [mm]'
            end
            object Label19: TLabel
              Left = 8
              Top = 164
              Width = 54
              Height = 13
              Caption = 'Page color:'
            end
            object cpbPageColor: TColorPickerButton
              Left = 112
              Top = 161
              Width = 81
              Height = 22
              PopupSpacing = 8
              ShowSystemColors = False
              OnChange = cpbPageColorChange
            end
            object Label20: TLabel
              Left = 8
              Top = 88
              Width = 49
              Height = 13
              Caption = 'Page size:'
            end
            object Bevel4: TBevel
              Left = 8
              Top = 192
              Width = 249
              Height = 9
              Shape = bsTopLine
            end
            object Label21: TLabel
              Left = 8
              Top = 200
              Width = 37
              Height = 13
              Caption = 'Margins'
            end
            object Label22: TLabel
              Left = 24
              Top = 228
              Width = 21
              Height = 13
              Caption = 'Left:'
            end
            object Label23: TLabel
              Left = 136
              Top = 228
              Width = 22
              Height = 13
              Caption = 'Top:'
            end
            object Label24: TLabel
              Left = 24
              Top = 252
              Width = 28
              Height = 13
              Caption = 'Right:'
            end
            object Label25: TLabel
              Left = 136
              Top = 252
              Width = 36
              Height = 13
              Caption = 'Bottom:'
            end
            object Bevel5: TBevel
              Left = 8
              Top = 280
              Width = 249
              Height = 9
              Shape = bsTopLine
            end
            object Label26: TLabel
              Left = 8
              Top = 300
              Width = 76
              Height = 13
              Caption = 'Gridsize in [mm]:'
            end
            object cpbGridColor: TColorPickerButton
              Left = 112
              Top = 321
              Width = 81
              Height = 22
              PopupSpacing = 8
              ShowSystemColors = False
              OnChange = cpbGridColorChange
            end
            object Label27: TLabel
              Left = 8
              Top = 324
              Width = 45
              Height = 13
              Caption = 'Gridcolor:'
            end
            object Bevel8: TBevel
              Left = 8
              Top = 352
              Width = 249
              Height = 9
              Shape = bsTopLine
            end
            object pnlTitle: TPanel
              Left = 0
              Top = 0
              Width = 293
              Height = 25
              Align = alTop
              BevelOuter = bvNone
              Color = clBtnShadow
              TabOrder = 0
              object lblTitle: TLabel
                Left = 8
                Top = 3
                Width = 121
                Height = 18
                Caption = 'Page Settings'
                Font.Charset = ANSI_CHARSET
                Font.Color = clWhite
                Font.Height = -16
                Font.Name = 'Verdana'
                Font.Style = [fsBold]
                ParentFont = False
              end
            end
            object chbIsDefaultPage: TCheckBox
              Left = 8
              Top = 48
              Width = 153
              Height = 17
              Caption = 'This is a default page'
              Checked = True
              State = cbChecked
              TabOrder = 1
              OnClick = chbIsDefaultPageClick
            end
            object edPageWidth: TEdit
              Left = 112
              Top = 136
              Width = 65
              Height = 21
              TabOrder = 2
              OnExit = edPageWidthExit
            end
            object edPageHeight: TEdit
              Left = 192
              Top = 136
              Width = 65
              Height = 21
              TabOrder = 3
              OnExit = edPageHeightExit
            end
            object chbLandscape: TCheckBox
              Left = 112
              Top = 112
              Width = 97
              Height = 17
              Caption = 'Landscape'
              TabOrder = 4
              OnClick = chbLandscapeClick
            end
            object cbbPageSize: TComboBox
              Left = 112
              Top = 84
              Width = 145
              Height = 21
              ItemHeight = 13
              TabOrder = 5
              Text = 'cbbPageSize'
              OnChange = cbbPageSizeChange
            end
            object edMarginLeft: TEdit
              Left = 64
              Top = 224
              Width = 65
              Height = 21
              TabOrder = 6
              OnExit = edMarginLeftExit
            end
            object edMarginTop: TEdit
              Left = 176
              Top = 224
              Width = 65
              Height = 21
              TabOrder = 7
              OnExit = edMarginTopExit
            end
            object edMarginRight: TEdit
              Left = 64
              Top = 248
              Width = 65
              Height = 21
              TabOrder = 8
              OnExit = edMarginRightExit
            end
            object edMarginBottom: TEdit
              Left = 176
              Top = 248
              Width = 65
              Height = 21
              TabOrder = 9
              OnExit = edMarginBottomExit
            end
            object edGridSize: TEdit
              Left = 112
              Top = 296
              Width = 65
              Height = 21
              TabOrder = 10
              OnExit = edGridSizeExit
            end
            object chbBackgroundImage: TCheckBox
              Left = 8
              Top = 358
              Width = 137
              Height = 17
              Caption = 'Background Image'
              TabOrder = 11
              OnClick = chbBackgroundImageClick
            end
            object chbBackgroundTiled: TCheckBox
              Left = 176
              Top = 358
              Width = 65
              Height = 17
              Caption = 'Tiled'
              TabOrder = 12
              OnClick = chbBackgroundTiledClick
            end
          end
          object tsDocument: TTabSheet
            Caption = 'Document'
            ImageIndex = 3
            object Label6: TLabel
              Left = 8
              Top = 40
              Width = 85
              Height = 13
              Caption = 'Default page size:'
            end
            object Label7: TLabel
              Left = 8
              Top = 92
              Width = 95
              Height = 13
              Caption = 'Width x Height [mm]'
            end
            object Bevel1: TBevel
              Left = 8
              Top = 144
              Width = 249
              Height = 9
              Shape = bsTopLine
            end
            object Label8: TLabel
              Left = 8
              Top = 152
              Width = 73
              Height = 13
              Caption = 'Default margins'
            end
            object Label9: TLabel
              Left = 24
              Top = 180
              Width = 21
              Height = 13
              Caption = 'Left:'
            end
            object Label10: TLabel
              Left = 141
              Top = 180
              Width = 22
              Height = 13
              Caption = 'Top:'
            end
            object Label11: TLabel
              Left = 24
              Top = 204
              Width = 28
              Height = 13
              Caption = 'Right:'
            end
            object Label12: TLabel
              Left = 136
              Top = 204
              Width = 36
              Height = 13
              Caption = 'Bottom:'
            end
            object Bevel2: TBevel
              Left = 8
              Top = 232
              Width = 249
              Height = 9
              Shape = bsTopLine
            end
            object Label13: TLabel
              Left = 152
              Top = 247
              Width = 76
              Height = 13
              Caption = 'Gridsize in [mm]:'
            end
            object cpbDefaultPageCol: TColorPickerButton
              Left = 112
              Top = 113
              Width = 81
              Height = 22
              PopupSpacing = 8
              ShowSystemColors = False
              OnChange = cpbDefaultPageColChange
            end
            object Label14: TLabel
              Left = 8
              Top = 116
              Width = 90
              Height = 13
              Caption = 'Default page color:'
            end
            object cpbDefaultGridCol: TColorPickerButton
              Left = 72
              Top = 240
              Width = 68
              Height = 22
              PopupSpacing = 8
              ShowSystemColors = False
              OnChange = cpbDefaultGridColChange
            end
            object Label15: TLabel
              Left = 17
              Top = 247
              Width = 49
              Height = 13
              Caption = 'Grid Color:'
            end
            object Bevel6: TBevel
              Left = 8
              Top = 296
              Width = 249
              Height = 9
              Shape = bsTopLine
            end
            object Label28: TLabel
              Left = 8
              Top = 304
              Width = 70
              Height = 13
              Caption = 'Thumbnail size'
            end
            object Label29: TLabel
              Left = 24
              Top = 332
              Width = 31
              Height = 13
              Caption = 'Width:'
            end
            object Label30: TLabel
              Left = 136
              Top = 332
              Width = 34
              Height = 13
              Caption = 'Height:'
            end
            object Bevel7: TBevel
              Left = 8
              Top = 360
              Width = 249
              Height = 9
              Shape = bsTopLine
            end
            object Label31: TLabel
              Left = 128
              Top = 394
              Width = 115
              Height = 13
              Caption = 'Shape Nudge Dist [mm]:'
            end
            object Label32: TLabel
              Left = 112
              Top = 418
              Width = 132
              Height = 13
              Caption = 'Mouse Wheel Scroll Speed:'
            end
            object Label33: TLabel
              Left = 8
              Top = 418
              Width = 55
              Height = 13
              Caption = 'Zoom Step:'
            end
            object cpbGuideColor: TColorPickerButton
              Left = 72
              Top = 268
              Width = 68
              Height = 22
              PopupSpacing = 8
              ShowSystemColors = False
              OnChange = cpbGuideColorChange
            end
            object Label34: TLabel
              Left = 8
              Top = 269
              Width = 58
              Height = 13
              Caption = 'Guide Color:'
            end
            object Panel1: TPanel
              Left = 0
              Top = 0
              Width = 293
              Height = 25
              Align = alTop
              BevelOuter = bvNone
              Color = clBtnShadow
              TabOrder = 0
              object Label1: TLabel
                Left = 8
                Top = 3
                Width = 165
                Height = 18
                Caption = 'Document Settings'
                Font.Charset = ANSI_CHARSET
                Font.Color = clWhite
                Font.Height = -16
                Font.Name = 'Verdana'
                Font.Style = [fsBold]
                ParentFont = False
              end
            end
            object cbbDefaultPageSize: TComboBox
              Left = 112
              Top = 36
              Width = 145
              Height = 21
              ItemHeight = 0
              TabOrder = 1
              Text = 'cbbDefaultPageSize'
              OnChange = cbbDefaultPageSizeChange
            end
            object chbDefaultLandscape: TCheckBox
              Left = 112
              Top = 64
              Width = 97
              Height = 17
              Caption = 'Landscape'
              TabOrder = 2
              OnClick = chbDefaultLandscapeClick
            end
            object edDefaultPageWidth: TEdit
              Left = 112
              Top = 88
              Width = 65
              Height = 21
              TabOrder = 3
              OnExit = edDefaultPageWidthExit
            end
            object edDefaultPageHeight: TEdit
              Left = 192
              Top = 88
              Width = 65
              Height = 21
              TabOrder = 4
              OnExit = edDefaultPageHeightExit
            end
            object edDefaultMarginLeft: TEdit
              Left = 64
              Top = 176
              Width = 65
              Height = 21
              TabOrder = 5
              OnExit = edDefaultMarginLeftExit
            end
            object edDefaultMarginTop: TEdit
              Left = 176
              Top = 176
              Width = 65
              Height = 21
              TabOrder = 6
              OnExit = edDefaultMarginTopExit
            end
            object edDefaultMarginRight: TEdit
              Left = 64
              Top = 200
              Width = 65
              Height = 21
              TabOrder = 7
              OnExit = edDefaultMarginRightExit
            end
            object edDefaultMarginBottom: TEdit
              Left = 176
              Top = 200
              Width = 65
              Height = 21
              TabOrder = 8
              OnExit = edDefaultMarginBottomExit
            end
            object edDefaultGridSize: TEdit
              Left = 234
              Top = 241
              Width = 39
              Height = 21
              TabOrder = 9
              OnExit = edDefaultGridSizeExit
            end
            object edThumbWidth: TEdit
              Left = 64
              Top = 328
              Width = 65
              Height = 21
              TabOrder = 10
              OnExit = edThumbWidthExit
            end
            object edThumbHeight: TEdit
              Left = 176
              Top = 328
              Width = 65
              Height = 21
              TabOrder = 11
              OnExit = edThumbHeightExit
            end
            object chbDefaultTiled: TCheckBox
              Left = 176
              Top = 366
              Width = 65
              Height = 17
              Caption = 'Tiled'
              TabOrder = 12
              OnClick = chbDefaultTiledClick
            end
            object chbDefaultBgrImage: TCheckBox
              Left = 8
              Top = 366
              Width = 137
              Height = 17
              Caption = 'Background Image'
              Color = clBtnFace
              ParentColor = False
              TabOrder = 13
              OnClick = chbDefaultBgrImageClick
            end
            object chbShapeNudge: TCheckBox
              Left = 8
              Top = 389
              Width = 91
              Height = 17
              Caption = 'Shape Nudge'
              TabOrder = 14
              OnClick = chbShapeNudgeClicked
            end
            object edShapeNudgeDistance: TEdit
              Left = 249
              Top = 389
              Width = 36
              Height = 21
              TabOrder = 15
              OnExit = edShapeNudgeDistanceExit
            end
            object edMouseWheelScrollSpeed: TEdit
              Left = 249
              Top = 413
              Width = 36
              Height = 21
              TabOrder = 16
              OnExit = edMouseWhellScrollSpeedWxit
            end
            object edZoomStep: TEdit
              Left = 69
              Top = 413
              Width = 36
              Height = 21
              TabOrder = 17
              OnExit = edZoomStepExit
            end
          end
          object tsUser: TTabSheet
            Caption = 'User'
            ImageIndex = 4
            DesignSize = (
              293
              469)
            object Label2: TLabel
              Left = 8
              Top = 56
              Width = 103
              Height = 13
              Caption = 'Internal rendering DPI'
            end
            object Label4: TLabel
              Left = 136
              Top = 56
              Width = 85
              Height = 13
              Caption = 'Resample method'
            end
            object Label5: TLabel
              Left = 8
              Top = 104
              Width = 57
              Height = 13
              Caption = 'Print quality:'
            end
            object Label16: TLabel
              Left = 8
              Top = 32
              Width = 252
              Height = 13
              Caption = 'Note: this info is stored in the registry (for current user)'
            end
            object Panel2: TPanel
              Left = 0
              Top = 0
              Width = 293
              Height = 25
              Align = alTop
              BevelOuter = bvNone
              Color = clBtnShadow
              TabOrder = 0
              object Label3: TLabel
                Left = 8
                Top = 3
                Width = 154
                Height = 18
                Caption = 'User Preferences'
                Font.Charset = ANSI_CHARSET
                Font.Color = clWhite
                Font.Height = -16
                Font.Name = 'Verdana'
                Font.Style = [fsBold]
                ParentFont = False
              end
            end
            object edRenderDPI: TEdit
              Left = 8
              Top = 72
              Width = 97
              Height = 21
              TabOrder = 1
              OnExit = edRenderDPIExit
            end
            object cbbResampleMethod: TComboBox
              Left = 136
              Top = 72
              Width = 129
              Height = 21
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 2
              OnChange = cbbResampleMethodChange
              Items.Strings = (
                'Fast, low quality'
                'Medium'
                'High'
                'Superhigh (slow)')
            end
            object cbbPrintQuality: TComboBox
              Left = 8
              Top = 120
              Width = 257
              Height = 21
              ItemHeight = 0
              TabOrder = 3
              Text = 'cbbPrintQuality'
              OnChange = cbbPrintQualityChange
            end
            object rgMultiSelectMethod: TRadioGroup
              Left = 8
              Top = 152
              Width = 257
              Height = 57
              Caption = 'Select multiple shapes by...'
              Items.Strings = (
                'Using [CTRL] + mouse drag'
                'Starting mouse drag from empty area')
              TabOrder = 4
              OnClick = rgMultiSelectMethodClick
            end
            object rgPerformance: TRadioGroup
              Left = 8
              Top = 216
              Width = 257
              Height = 57
              Caption = 'Performance control'
              Items.Strings = (
                'Favour memory over speed (safest)'
                'Favour speed over memory (only w. much mem!)')
              TabOrder = 5
              OnClick = rgPerformanceClick
            end
            object btnTest: TButton
              Left = 8
              Top = 288
              Width = 81
              Height = 25
              Caption = 'Export Shape'
              TabOrder = 6
              OnClick = btnTestClick
            end
            object btnAbort: TButton
              Left = 184
              Top = 288
              Width = 75
              Height = 25
              Caption = 'Abort Test'
              TabOrder = 7
              Visible = False
              OnClick = btnAbortClick
            end
            object mmMessages: TMemo
              Left = 8
              Top = 320
              Width = 277
              Height = 93
              Anchors = [akLeft, akTop, akRight, akBottom]
              TabOrder = 8
            end
          end
          object tsDebug: TTabSheet
            Caption = 'Debug'
            ImageIndex = 5
            object pnlDebug: TPanel
              Left = 0
              Top = 0
              Width = 293
              Height = 439
              Align = alClient
              BevelOuter = bvNone
              Caption = 'pnlDebug'
              TabOrder = 0
              object mmDebug: TMemo
                Left = 0
                Top = 0
                Width = 293
                Height = 439
                Align = alClient
                Lines.Strings = (
                  'debug info:')
                TabOrder = 0
              end
            end
            object pnlClear: TPanel
              Left = 0
              Top = 439
              Width = 293
              Height = 30
              Align = alBottom
              BevelOuter = bvNone
              TabOrder = 1
              object btnClear: TButton
                Left = 8
                Top = 4
                Width = 75
                Height = 25
                Caption = 'Clear'
                TabOrder = 0
                OnClick = btnClearClick
              end
            end
          end
        end
      end
      object pnlDocument: TPanel
        Left = 306
        Top = 0
        Width = 702
        Height = 497
        Align = alClient
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Small Fonts'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object pnlRulerTop: TPanel
          Left = 0
          Top = 0
          Width = 702
          Height = 21
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object rsrCorner: TdtpRsRulerCorner
            Left = 0
            Top = 0
            Width = 21
            Height = 21
            Hint = 'millimeter'
            Units = ruMilli
            Flat = True
            ScaleColor = clWindow
            TickColor = clWindowText
            Align = alLeft
            Position = cpLeftTop
            OnClick = rsrCornerClick
          end
          object rsrTop: TdtpRsRuler
            Left = 21
            Top = 0
            Width = 681
            Height = 21
            Units = ruMilli
            Flat = True
            ScaleColor = clWindow
            TickColor = clWindowText
            Direction = rdTop
            HairLine = True
            HairLinePos = -1
            HairLineStyle = hlsLine
            Offset = -13.000000237641070000
            ShowMinus = True
            ScreenDpm = 3.023696660995483000
            Scale = 1.000000000000000000
            Align = alClient
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
        end
        object pnlRulerLeft: TPanel
          Left = 0
          Top = 21
          Width = 21
          Height = 476
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 1
          object rsrLeft: TdtpRsRuler
            Left = 0
            Top = 0
            Width = 21
            Height = 476
            Units = ruMilli
            Flat = True
            ScaleColor = clWindow
            TickColor = clWindowText
            Direction = rdLeft
            HairLine = True
            HairLinePos = -1
            HairLineStyle = hlsLine
            Offset = -11.999999831181130000
            ShowMinus = True
            ScreenDpm = 3.023696660995483000
            Scale = 1.000000000000000000
            Align = alClient
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
        end
        object Document: TdtpDocument
          Left = 21
          Top = 21
          Width = 681
          Height = 476
          Color = clAppWorkSpace
          CurrentPageIndex = 0
          DefaultGridSize = 5.000000000000000000
          DefaultMarginBottom = 10.000000000000000000
          DefaultMarginLeft = 10.000000000000000000
          DefaultMarginRight = 10.000000000000000000
          DefaultMarginTop = 10.000000000000000000
          DefaultPageHeight = 297.000000000000000000
          DefaultPageWidth = 210.000000000000000000
          Device = dtPrinter
          PageCount = 1
          PageHeight = 297.000000000000000000
          PageWidth = 210.000000000000000000
          FontEmbedding = False
          GuideColor = clRed
          GuidesToFront = False
          GuidesVisible = True
          HitSensitivity = 1.000000000000000000
          Mode = vmEdit
          Modified = True
          RulerTop = rsrTop
          RulerLeft = rsrLeft
          RulerCorner = rsrCorner
          ScreenDPI = 76.801895141601560000
          SnapToGuides = True
          StoreThumbnails = False
          UseDocumentBoard = True
          WindowLeft = -0.330720990896225000
          ZoomPercent = 100.000000000000000000
          OnDocumentChanged = DocumentChanged
          OnDrawQualityIndicator = BitmapDrawQualityIndicator
          OnFocusShape = DocumentFocusShape
          OnPageChanged = DocumentPageChanged
          OnProgress = DocumentProgress
          OnSelectionChanged = DocumentSelectionChanged
          OnShapeChanged = DocumentShapeChanged
          OnShapeEditClosed = DocumentShapeEditClosed
          OnShapeInsertClosed = DocumentShapeInsertClosed
          OnShapeLoadAdditionalInfo = DocumentShapeLoadAdditionalInfo
          Align = alClient
          PopupMenu = pmShapeAdd
          TabOrder = 2
          OnDragDrop = DocumentDragDrop
          OnDragOver = DocumentDragOver
          OnMouseMove = DocumentMouseMove
          OnStartDrag = DocumentStartDrag
        end
      end
    end
  end
  object mnuMain: TMainMenu
    Images = ilMain
    Left = 744
    Top = 96
    object File1: TMenuItem
      Caption = '&File'
      object Open1: TMenuItem
        Action = acFileOpen
      end
      object New1: TMenuItem
        Action = acFileNew
      end
      object Save1: TMenuItem
        Action = acFileSave
      end
      object SaveAs1: TMenuItem
        Action = acFileSaveAs
      end
      object Print1: TMenuItem
        Action = acPrint
      end
      object Printcurrentpage1: TMenuItem
        Action = acPrintPage
      end
      object mnuAddFiletypeAssoc: TMenuItem
        Caption = 'Add Filetype association for *.dtp'
        OnClick = mnuAddFiletypeAssocClick
      end
      object mnuRemoveFiletypeAssoc: TMenuItem
        Caption = 'Remove Filetype association'
        Enabled = False
        OnClick = mnuRemoveFiletypeAssocClick
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object acExit1: TMenuItem
        Action = acExit
      end
    end
    object Edit1: TMenuItem
      Caption = '&Edit'
      object Undo1: TMenuItem
        Action = acUndo
      end
      object Redo1: TMenuItem
        Action = acRedo
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object Cut1: TMenuItem
        Action = acCut
      end
      object Copy1: TMenuItem
        Action = acCopy
      end
      object Paste1: TMenuItem
        Action = acPaste
      end
    end
    object Shape1: TMenuItem
      Caption = '&Shape'
      object Addshape1: TMenuItem
        Caption = 'Add shape...'
        object AddTextShape3: TMenuItem
          Action = acShapeAddText
        end
        object mnuAddSpecialTextShape: TMenuItem
          Caption = 'Add Special Text Shape'
          object AddCurvedText1: TMenuItem
            Action = acShapeAddCurvedText
          end
          object AddProjectiveText1: TMenuItem
            Action = acShapeAddProjectiveText
          end
          object AddWavyText1: TMenuItem
            Action = acShapeAddWavyText
          end
        end
        object AddMemoShape2: TMenuItem
          Action = acShapeAddMemo
        end
        object AddPhotoShape2: TMenuItem
          Action = acShapeAddBitmap
        end
        object AddCropBitmap1: TMenuItem
          Action = acShapeAddCropBitmap
        end
        object AddMetafile2: TMenuItem
          Action = acShapeAddMeta
        end
        object AddLineShape1: TMenuItem
          Action = acShapeAddLine
        end
        object AddEllipse2: TMenuItem
          Action = acShapeAddEllipse
        end
        object AddRectangle2: TMenuItem
          Action = acShapeAddRectangle
        end
        object AddRoundedRectangle2: TMenuItem
          Action = acShapeAddRoundRect
        end
        object AddFreehand1: TMenuItem
          Action = acShapeAddFreehand
        end
      end
      object DeleteShapes1: TMenuItem
        Action = acShapeDelete
      end
      object N8: TMenuItem
        Caption = '-'
      end
      object MoveBack1: TMenuItem
        Action = acMoveBack
      end
      object MoveFwd1: TMenuItem
        Action = acMoveFwd
      end
      object ToBkgnd1: TMenuItem
        Action = acMoveToBg
      end
      object ToFgnd1: TMenuItem
        Action = acMoveToFg
      end
      object N9: TMenuItem
        Caption = '-'
      end
      object Group1: TMenuItem
        Action = acGroup
      end
      object Ungroup1: TMenuItem
        Action = acUngroup
      end
      object Align1: TMenuItem
        Caption = '-'
      end
      object Align2: TMenuItem
        Caption = 'Align...'
        object AlignLeft1: TMenuItem
          Action = acAlignLft
        end
        object AlignCenter1: TMenuItem
          Action = acAlignCtr
        end
        object AlignRight1: TMenuItem
          Action = acAlignRgt
        end
        object AlignTop1: TMenuItem
          Action = acAlignTop
        end
        object AlignMiddle1: TMenuItem
          Action = acAlignMid
        end
        object AlignBottom1: TMenuItem
          Action = acAlignBtm
        end
      end
    end
    object Page1: TMenuItem
      Caption = '&Page'
      object Addnewpageatend2: TMenuItem
        Action = acPageAdd
      end
      object Insertpagehere1: TMenuItem
        Action = acPageInsert
      end
      object EditPageName1: TMenuItem
        Action = acPageEditName
      end
      object DeletePage1: TMenuItem
        Action = acPageDelete
      end
      object N11: TMenuItem
        Caption = '-'
      end
      object NextPage1: TMenuItem
        Action = acPageNext
      end
      object PreviousPage1: TMenuItem
        Action = acPagePrev
      end
      object N14: TMenuItem
        Caption = '-'
      end
      object ExportasImage1: TMenuItem
        Action = acPageExportAsImage
      end
    end
    object Tools1: TMenuItem
      Caption = '&Tools'
      object Histogram1: TMenuItem
        Action = acToolHistogram
      end
      object AutoLevels1: TMenuItem
        Action = acToolAutoLevels
      end
    end
    object View1: TMenuItem
      Caption = '&View'
      object acViewToolbar1: TMenuItem
        Action = acViewToolbar
      end
      object acViewEditpane1: TMenuItem
        Action = acViewEditpane
      end
      object acViewThumbs1: TMenuItem
        Action = acViewThumbs
      end
      object ShowRulers1: TMenuItem
        Action = acRulers
      end
      object Word2003Handles1: TMenuItem
        Action = acHandlesW2K3
      end
      object ShowShapeHints1: TMenuItem
        Action = acShowShapeHints
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object ZoomWidth1: TMenuItem
        Action = acZoomWidth
      end
      object ZoomPage1: TMenuItem
        Action = acZoomPage
      end
      object ZoomIn1: TMenuItem
        Action = acZoomPlus
      end
      object Zoomout1: TMenuItem
        Action = acZoomMinus
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object ShowMargin1: TMenuItem
        Action = acMargin
      end
      object ShowMarginHints1: TMenuItem
        Action = acShowMarginHints
      end
      object MarginsLocked1: TMenuItem
        Action = acLockMargins
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object PrintLayout1: TMenuItem
        Action = acStyleLayout
        GroupIndex = 1
        RadioItem = True
      end
      object ShowPageShadow1: TMenuItem
        Action = acShowPageShadow
        GroupIndex = 1
      end
      object AddTextShape2: TMenuItem
        Action = acStyleNormal
        GroupIndex = 1
        RadioItem = True
      end
      object N2: TMenuItem
        Caption = '-'
        GroupIndex = 1
      end
      object DocumentMisc1: TMenuItem
        Caption = 'Document Misc'
        GroupIndex = 2
        object ZoomWithMouse1: TMenuItem
          Action = acZoomWithMouseButton
        end
        object ZoomWithMouseWheel1: TMenuItem
          Action = acZoomWithMouseWheel
        end
        object ZoomWithRectangle1: TMenuItem
          Action = acZoomWithRectangle
        end
        object PanWithMouseButton1: TMenuItem
          Action = acPanWithMouseButton
        end
      end
      object N17: TMenuItem
        Caption = '-'
        GroupIndex = 2
      end
      object Grid1: TMenuItem
        Caption = 'Grid'
        GroupIndex = 2
        object NoHelpers1: TMenuItem
          Action = acHelpersNone
          GroupIndex = 2
          RadioItem = True
        end
        object acHelpersDots1: TMenuItem
          Action = acHelpersDots
          GroupIndex = 2
        end
        object ShowGrid1: TMenuItem
          Action = acHelpersGrid
          GroupIndex = 2
          RadioItem = True
        end
        object ShowPattern1: TMenuItem
          Action = acHelpersPattern
          GroupIndex = 2
          RadioItem = True
        end
        object acSnapToGrid1: TMenuItem
          Action = acSnapToGrid
          GroupIndex = 2
        end
      end
      object N10: TMenuItem
        Caption = '-'
        GroupIndex = 2
      end
      object Guides1: TMenuItem
        Caption = 'Guides'
        GroupIndex = 2
        object ShowGuides1: TMenuItem
          Action = acShowGuides
        end
        object SnapToGuides1: TMenuItem
          Action = acSnapToGuides
        end
        object GuidestoFront1: TMenuItem
          Action = acGuidesToFront
        end
        object LockGuides1: TMenuItem
          Action = acLockGuides
        end
        object GuideHintsEnabled1: TMenuItem
          Action = acShowGuideHints
        end
        object N18: TMenuItem
          Caption = '-'
        end
        object DeleteCurrentPageGuides1: TMenuItem
          Caption = 'Delete CurrentPage Guides'
          OnClick = DeleteCurrentPageGuidesClick
        end
        object DeleteAllDocumentGuides1: TMenuItem
          Caption = 'Delete All Document Guides'
          OnClick = DeleteAllDocumentGuidesClick
        end
      end
      object N16: TMenuItem
        Caption = '-'
        GroupIndex = 2
      end
      object AutomaticThumbnailupdate1: TMenuItem
        Action = acAutoThumbUpdate
        GroupIndex = 2
      end
      object N15: TMenuItem
        Caption = '-'
        GroupIndex = 2
      end
      object StepRotation1: TMenuItem
        Action = acStepRotation
        GroupIndex = 2
      end
      object HotzoneScrolling1: TMenuItem
        Caption = 'Hotzone Scrolling'
        GroupIndex = 2
        object Never1: TMenuItem
          Action = acHotzoneNever
        end
        object Whenmousedown1: TMenuItem
          Action = acHotzoneMouseDown
        end
        object Always1: TMenuItem
          Action = acHotzoneAlways
        end
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object Contents1: TMenuItem
        Action = acHelpContents
      end
      object N13: TMenuItem
        Caption = '-'
      end
      object About1: TMenuItem
        Action = acAbout
      end
    end
  end
  object alMain: TActionList
    Images = ilMain
    Left = 712
    Top = 96
    object acFileOpen: TAction
      Caption = 'Open'
      Hint = 'Open a document'
      ImageIndex = 0
      OnExecute = acFileOpenExecute
    end
    object acFileNew: TAction
      Caption = 'New'
      Hint = 'Create new document'
      ImageIndex = 1
      OnExecute = acFileNewExecute
    end
    object acFileSave: TAction
      Caption = 'Save'
      Hint = 'Save this document'
      ImageIndex = 2
      OnExecute = acFileSaveExecute
    end
    object acFileSaveAs: TAction
      Caption = 'Save As...'
      Hint = 'Save under different name'
      OnExecute = acFileSaveAsExecute
    end
    object acZoomWidth: TAction
      Caption = 'Zoom Width'
      Hint = 'Zoom to page width'
      ImageIndex = 3
      OnExecute = acZoomWidthExecute
    end
    object acZoomPage: TAction
      Caption = 'Zoom Page'
      Hint = 'Zoom to full page'
      ImageIndex = 4
      OnExecute = acZoomPageExecute
    end
    object acZoomPlus: TAction
      Caption = 'Zoom In'
      ImageIndex = 6
      OnExecute = acZoomPlusExecute
    end
    object acZoomMinus: TAction
      Caption = 'Zoom out'
      ImageIndex = 5
      OnExecute = acZoomMinusExecute
    end
    object acShapeAddText: TAction
      Caption = 'Add Text Shape'
      ImageIndex = 32
      OnExecute = acShapeAddTextExecute
    end
    object acShapeAddPolygonText: TAction
      Caption = 'Add Polygon Text'
      ImageIndex = 32
      OnExecute = acShapeAddPolygonTextExecute
    end
    object acShapeAddCurvedText: TAction
      Caption = 'Add Curved Text'
      ImageIndex = 32
      OnExecute = acShapeAddCurvedTextExecute
    end
    object acShapeAddProjectiveText: TAction
      Caption = 'Add Projective Text'
      ImageIndex = 32
      OnExecute = acShapeAddProjectiveTextExecute
    end
    object acShapeAddWavyText: TAction
      Caption = 'Add Wavy Text'
      ImageIndex = 32
      OnExecute = acShapeAddWavyTextExecute
    end
    object acShapeAddMemo: TAction
      Caption = 'Add Memo Shape'
      ImageIndex = 32
      OnExecute = acShapeAddMemoExecute
    end
    object acShapeAddBitmap: TAction
      Caption = 'Add Bitmap Shape'
      ImageIndex = 34
      OnExecute = acShapeAddBitmapExecute
    end
    object acShapeAddCropBitmap: TAction
      Caption = 'Add Crop Bitmap'
      ImageIndex = 34
      OnExecute = acShapeAddCropBitmapExecute
    end
    object acShapeAddMeta: TAction
      Caption = 'Add Metafile'
      ImageIndex = 33
      OnExecute = acShapeAddMetaExecute
    end
    object acShapeAddLine: TAction
      Caption = 'Add Line Shape'
      ImageIndex = 36
      OnExecute = acShapeAddLineExecute
    end
    object acShapeAddPolyline: TAction
      Caption = 'Add Polyline'
      ImageIndex = 35
      OnExecute = acShapeAddPolylineExecute
    end
    object acShapeAddEllipse: TAction
      Caption = 'Add Ellipse'
      ImageIndex = 38
      OnExecute = acShapeAddEllipseExecute
    end
    object acShapeAddRectangle: TAction
      Caption = 'Add Rectangle'
      ImageIndex = 39
      OnExecute = acShapeAddRectangleExecute
    end
    object acShapeAddRoundRect: TAction
      Caption = 'Add Rounded Rectangle'
      ImageIndex = 40
      OnExecute = acShapeAddRoundRectExecute
    end
    object acShapeAddFreehand: TAction
      Caption = 'Add Freehand'
      ImageIndex = 35
      OnExecute = acShapeAddFreehandExecute
    end
    object acDelete: TAction
      Caption = 'Delete'
      Hint = 'Delete selected shapes or pages'
      ImageIndex = 10
      OnExecute = acDeleteExecute
    end
    object acStyleLayout: TAction
      Caption = 'Print Layout'
      Checked = True
      Hint = 'Show as print layout'
      OnExecute = acStyleLayoutExecute
    end
    object acStyleNormal: TAction
      Caption = 'No borders'
      Hint = 'Show normal'
      OnExecute = acStyleNormalExecute
    end
    object acRulers: TAction
      Caption = 'Rulers'
      Checked = True
      OnExecute = acRulersExecute
    end
    object acHandlesW2K3: TAction
      Caption = 'Word2003 Handles'
      Checked = True
      OnExecute = acHandlesW2K3Execute
    end
    object acHelpersNone: TAction
      Caption = 'No Helpers'
      Checked = True
      OnExecute = acHelpersNoneExecute
    end
    object acHelpersDots: TAction
      Caption = 'Show Dots'
      OnExecute = acHelpersDotsExecute
    end
    object acHelpersGrid: TAction
      Caption = 'Show Grid'
      OnExecute = acHelpersGridExecute
    end
    object acHelpersPattern: TAction
      Caption = 'Show Pattern'
      OnExecute = acHelpersPatternExecute
    end
    object acMargin: TAction
      Caption = 'Show Margins'
      Checked = True
      OnExecute = acMarginExecute
    end
    object acViewThumbs: TAction
      Caption = 'Page thumbnails'
      Checked = True
      OnExecute = acViewThumbsExecute
    end
    object acViewToolbar: TAction
      Caption = 'Toolbar'
      Checked = True
      OnExecute = acViewToolbarExecute
    end
    object acViewEditpane: TAction
      Caption = 'Edit panel'
      Checked = True
      OnExecute = acViewEditpaneExecute
    end
    object acExit: TAction
      Caption = '&Exit'
      OnExecute = acExitExecute
    end
    object acPageAdd: TAction
      Caption = 'Add new page at end'
      Hint = 'Add a new page at the end'
      ImageIndex = 1
      OnExecute = acPageAddExecute
    end
    object acPageInsert: TAction
      Caption = 'Insert page here'
      Hint = 'Insert a page at current location'
      ImageIndex = 1
      OnExecute = acPageInsertExecute
    end
    object acPagePrev: TAction
      Caption = 'Previous Page'
      Hint = 'Go to previous page'
      ImageIndex = 11
      OnExecute = acPagePrevExecute
    end
    object acPageNext: TAction
      Caption = 'Next Page'
      Hint = 'Go to next page'
      ImageIndex = 12
      OnExecute = acPageNextExecute
    end
    object acPageEditName: TAction
      Caption = 'Edit Page Name'
      ImageIndex = 9
      OnExecute = acPageEditNameExecute
    end
    object acUndo: TAction
      Caption = '&Undo'
      ImageIndex = 25
      ShortCut = 16474
      OnExecute = acUndoExecute
    end
    object acRedo: TAction
      Caption = 'Redo'
      ImageIndex = 24
      ShortCut = 24666
      OnExecute = acRedoExecute
    end
    object acMoveBack: TAction
      Caption = 'Move Back'
      Hint = 'Move shape backwards'
      ImageIndex = 14
      OnExecute = acMoveBackExecute
    end
    object acMoveFwd: TAction
      Caption = 'Move Fwd'
      Hint = 'Move shape forwards'
      ImageIndex = 15
      OnExecute = acMoveFwdExecute
    end
    object acMoveToBg: TAction
      Caption = 'To Bkgnd'
      Hint = 'Move shape to background'
      ImageIndex = 16
      OnExecute = acMoveToBgExecute
    end
    object acMoveToFg: TAction
      Caption = 'To Fgnd'
      Hint = 'Move shape to foreground'
      ImageIndex = 17
      OnExecute = acMoveToFgExecute
    end
    object acGroup: TAction
      Caption = 'Group'
      Hint = 'Group selected shapes'
      ImageIndex = 18
      OnExecute = acGroupExecute
    end
    object acUngroup: TAction
      Caption = 'Ungroup'
      Hint = 'Ungroup selected shapes'
      ImageIndex = 19
      OnExecute = acUngroupExecute
    end
    object acCut: TAction
      Caption = 'Cut'
      ImageIndex = 20
      OnExecute = acCutExecute
    end
    object acCopy: TAction
      Caption = 'Copy'
      ImageIndex = 21
      OnExecute = acCopyExecute
    end
    object acPaste: TAction
      Caption = 'Paste'
      ImageIndex = 22
      OnExecute = acPasteExecute
    end
    object acAnchors: TAction
      Caption = 'Set Anchors'
      Hint = 'Set the shape anchors'
    end
    object acPrint: TAction
      Caption = 'Print...'
      ImageIndex = 23
      OnExecute = acPrintExecute
    end
    object acPrintPage: TAction
      Caption = 'Print current page'
      ImageIndex = 23
      OnExecute = acPrintPageExecute
    end
    object acAlignLft: TAction
      Caption = 'Align Left'
      Hint = 'Align shapes with left edges'
      ImageIndex = 28
      OnExecute = acAlignLftExecute
    end
    object acAlignCtr: TAction
      Caption = 'Align Center'
      Hint = 'Align shapes with horizontal centers'
      ImageIndex = 27
      OnExecute = acAlignCtrExecute
    end
    object acAlignRgt: TAction
      Caption = 'Align Right'
      Hint = 'Align shapes with right edges'
      ImageIndex = 30
      OnExecute = acAlignRgtExecute
    end
    object acAlignTop: TAction
      Caption = 'Align Top'
      Hint = 'Align shapes with top edges'
      ImageIndex = 26
      OnExecute = acAlignTopExecute
    end
    object acAlignMid: TAction
      Caption = 'Align Middle'
      Hint = 'Align shapes with vertical middle'
      ImageIndex = 29
      OnExecute = acAlignMidExecute
    end
    object acAlignBtm: TAction
      Caption = 'Align Bottom'
      Hint = 'Align shapes with bottom edges'
      ImageIndex = 31
      OnExecute = acAlignBtmExecute
    end
    object acAlign: TAction
      Caption = 'Align'
      ImageIndex = 28
      OnExecute = acAlignExecute
    end
    object acSnapToGrid: TAction
      Caption = 'Snap To Grid'
      OnExecute = acSnapToGridExecute
    end
    object acStepRotation: TAction
      Caption = 'Step-Rotation'
      OnExecute = acStepRotationExecute
    end
    object acAutoThumbUpdate: TAction
      Caption = 'Automatic Thumbnail update'
      Checked = True
      OnExecute = acAutoThumbUpdateExecute
    end
    object acHotzoneAlways: TAction
      Caption = 'Always'
      OnExecute = acHotzoneAlwaysExecute
    end
    object acHotzoneMouseDown: TAction
      Caption = 'When mouse down'
      OnExecute = acHotzoneMouseDownExecute
    end
    object acHotzoneNever: TAction
      Caption = 'Never'
      OnExecute = acHotzoneNeverExecute
    end
    object acAbout: TAction
      Caption = 'About...'
      OnExecute = acAboutExecute
    end
    object acHelpContents: TAction
      Caption = 'Contents'
      ImageIndex = 37
      OnExecute = acHelpContentsExecute
    end
    object acShapeDelete: TAction
      Caption = 'Delete Shape(s)'
      ImageIndex = 10
      OnExecute = acShapeDeleteExecute
    end
    object acPageDelete: TAction
      Caption = 'Delete Page(s)'
      ImageIndex = 10
      OnExecute = acPageDeleteExecute
    end
    object acPageExportAsImage: TAction
      Caption = 'Export as Image...'
      ImageIndex = 8
      OnExecute = acPageExportAsImageExecute
    end
    object acToolHistogram: TAction
      Caption = 'Histogram'
      OnExecute = acToolHistogramExecute
    end
    object acToolAutoLevels: TAction
      Caption = 'AutoLevels'
      OnExecute = acToolAutoLevelsExecute
    end
    object acSnapToGuides: TAction
      Caption = 'Snap To Guides'
      OnExecute = acSnapToGuidesExecute
    end
    object acShowGuides: TAction
      Caption = 'Show Guides'
      OnExecute = acShowGuidesExecute
    end
    object acGuidesToFront: TAction
      Caption = 'Guides To Front'
      OnExecute = acGuidestoFrontExecute
    end
    object acLockGuides: TAction
      Caption = 'Lock Guides'
      OnExecute = acLockGuidesExecute
    end
    object acPan: TAction
      AutoCheck = True
      Caption = 'Pan'
      GroupIndex = 58
      OnExecute = MouseButtonPan
    end
    object acZoom: TAction
      AutoCheck = True
      Caption = 'Zoom'
      GroupIndex = 58
      OnExecute = MouseButtonZoom
    end
    object acDragZoom: TAction
      AutoCheck = True
      Caption = 'Drag Zoom'
      GroupIndex = 58
      OnExecute = MouseButtonDragZoom
    end
    object acZoomInOut: TAction
      AutoCheck = True
      Caption = 'Zoom In/Out'
      GroupIndex = 58
      OnExecute = MouseButtonZoomInOut
    end
    object acShowGuideHints: TAction
      Caption = 'Show Guide Hints'
      OnExecute = acShowGuideHintsExecute
    end
    object acZoomWithMouseWheel: TAction
      Caption = 'Zoom With Mouse Wheel'
      OnExecute = acZoomWithMouseWheellExecute
    end
    object acZoomWithMouseButton: TAction
      Caption = 'Zoom With Mouse Button'
      OnExecute = acZoomWithMouseButtonExecute
    end
    object acZoomWithRectangle: TAction
      Caption = 'Zoom With Rectangle'
      OnExecute = acZoomWithRectangleExecute
    end
    object acShowPageShadow: TAction
      Caption = 'Show Page Shadow'
      OnExecute = acShowPageShadowExecute
    end
    object acPanWithMouseButton: TAction
      Caption = 'Pan With Mouse Button'
      OnExecute = acPanWithMouseButtonExecute
    end
    object acLockMargins: TAction
      Caption = 'Margins Locked'
      OnExecute = acLockMarginsExecute
    end
    object acShowMarginHints: TAction
      Caption = 'Show Margin Hints'
      OnExecute = acShowMarginHintsExecute
    end
    object acShowShapeHints: TAction
      Caption = 'Show Shape Hints'
      OnExecute = acShowShapeHintsExecute
    end
  end
  object ilMain: TImageList
    Left = 680
    Top = 96
    Bitmap = {
      494C01012D008400940010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      000000000000360000002800000040000000C0000000010020000000000000C0
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0080808000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0080808000C0C0C000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF0080808000C0C0C000C0C0C0008080
      8000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF0080808000C0C0C000C0C0C000C0C0C0008080
      800080808000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00808080000000000080808000808080008080
      8000808080008080800080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0080808000C0C0C000C0C0C00000000000808080008080
      8000808080008080800000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF0080808000C0C0C000FFFFFF00FFFFFF00C0C0C000000000008080
      80008080800000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF008080
      800080808000C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C0000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0080808000C0C0
      C000C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C0000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0080808000C0C0C000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C0000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C0000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080808000C0C0C000C0C0C000C0C0
      C000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C0000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000808080008080800000000000C0C0
      C000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C0000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C0C0C0000000000000000000FFFF
      FF00FFFFFF0080808000FFFFFF00FFFFFF0080808000FFFFFF0000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C0C0C00080808000FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF0000000000FFFFFF00C0C0C00080808000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00C0C0C000808080000000
      00008080800080808000000000008080800080808000C0C0C000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF00C0C0C00080808000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000000000000000000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF00C0C0C0000000000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0080808000000000000000000000000000000000000000
      0000000000008000000080000000800000008000000000000000000000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000000000000080800000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF00000000000000000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF000000000080808000000000000000000000000000000000008000
      000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0080000000800000008000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF00808080000000000000000000000000000000000080000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C00000000000000000000080800000FFFF0000FF
      FF0000FFFF0000FFFF00C0C0C000C0C0C00000FFFF0000FFFF0000FFFF0000FF
      FF0000000000808080000000000000000000000000000000000080000000FFFF
      FF00800000008000000080000000800000008000000080000000FFFFFF008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C00000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF00000000000000000000FFFF0000FFFF0000FFFF0000FF
      FF00808080000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00800000008000000080000000800000008000000080000000FFFFFF00FFFF
      FF00800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C0000000000000000000000000000080800000FF
      FF0000FFFF0000FFFF00000000000000000000FFFF0000FFFF0000FFFF000000
      0000808080000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C0000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF00000000000000000000FFFF0000FFFF0000FFFF008080
      8000000000000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF008000000080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000000000000000000000000000000000000080
      800000FFFF0000FFFF00000000000000000000FFFF0000FFFF00000000008080
      8000000000000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF0080000000800000008000000080000000FFFFFF00FFFFFF00FFFF
      FF00800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C00000000000000000000000000000000000000000000000
      000000FFFF0000FFFF00000000000000000000FFFF0000FFFF00808080000000
      000000000000000000000000000000000000000000000000000080000000FFFF
      FF00FFFFFF0080000000800000008000000080000000FFFFFF00FFFFFF008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000080800000FFFF0000FFFF0000FFFF0000FFFF0000000000808080000000
      000000000000000000000000000000000000000000000000000080000000FFFF
      FF00FFFFFF00FFFFFF008000000080000000FFFFFF00FFFFFF00FFFFFF008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000FFFF0000FFFF0000FFFF0080808000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0080000000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080800000FFFF0000FFFF000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000008000000080000000800000008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF00C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000800080008000800080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000008000800080008000FFFFFF00FFFFFF00C0C0C000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      800080008000FFFFFF00FFFFFF000000000000000000C0C0C000C0C0C0008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000000000000000000000000000008080
      80000000000000000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000800000008000
      000000000000000000000000000000000000808080008000800080008000FFFF
      FF00FFFFFF000000000000000000800080008000800000000000C0C0C000C0C0
      C000808080000000000000000000000000000000000000000000808080000000
      000000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      00000000000080808000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000000000000000000000000000000000008080800080008000FFFFFF000000
      000000000000800080008000800080008000800080008000800000000000C0C0
      C000C0C0C000808080000000000000000000000000008080800000000000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C00000000000808080000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000000000000000000000000000000000008080800000000000000000008000
      800080008000800080000080800000FFFF008000800080008000800080000000
      0000C0C0C000C0C0C00080808000000000000000000000000000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000000000000000000008000
      0000000000000000000000000000000000008080800080008000800080008000
      8000800080008000800080008000008080008000800080008000800080008000
      800000000000C0C0C000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C0000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000000000000000000000000000000000000000
      0000000000000000000000000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000080008000FFFFFF008000
      80008000800080008000800080008000800000FFFF0000FFFF00800080008000
      80008000800000000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C0000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000000000000000000000000000000000000000
      0000000000000000000080000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080008000FFFF
      FF0080008000800080008000800080008000800080000080800000FFFF0000FF
      FF008000800080008000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C0000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000000000000000000000000000000000000000
      0000000000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      8000FFFFFF00800080008000800080008000008080008000800000FFFF0000FF
      FF008000800080008000800080000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C0000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000000000000000000000000000000000000000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080008000FFFFFF00800080008000800000FFFF0000FFFF0000FFFF008000
      8000800080008000800000000000000000000000000000000000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000080008000FFFFFF00800080008000800080008000800080008000
      800000000000000000000000000000000000000000008080800000000000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C00000000000808080000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C0000000000000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080008000FFFFFF008000800080008000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      000000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      00000000000080808000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C0000000000000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800080008000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000000000000000000000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800080000000800000008000
      0000808080008080800000000000000000000000000000000000000000000000
      0000000000008080800000000000808000008080000080800000808000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000008000000080000000800000008080
      8000808080008080800080808000000000000000000000000000000000000000
      00000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000808000008080
      00000000000000000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C00000000000C0C0C000C0C0C00000000000C0C0C000C0C0C0000000
      0000C0C0C000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000808080000000000000000000000000008000000080000000800000008080
      8000808080008080800000000000000000000000000000000000000000000000
      00000000000000000000FFFF0000FFFFFF00FFFF0000FFFF0000FFFF00000000
      0000808000000000000000000000000000000000000000000000C0C0C000C0C0
      C00000000000C0C0C000C0C0C00000000000C0C0C000C0C0C00000000000C0C0
      C000C0C0C0000000000000000000000000000000000000000000000000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000000000000000000000000000000000000080808000800000008000
      0000808080000000000000000000808080008000000080000000800000008080
      8000808080008080800000000000000000000000000000000000000000000000
      00000000000000000000FFFF0000FFFF0000FFFFFF00FFFF0000FFFF00000000
      00008080000080800000000000000000000000000000C0C0C00000000000FFFF
      FF00C0C0C000FFFFFF00C0C0C000C0C0C000C0C0C00000000000C0C0C000C0C0
      C00000000000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000800000008080
      8000808080008080800080000000800000008000000080000000800000008080
      8000808080008080800000000000000000000000000000000000000000000000
      0000000000000000000080808000FFFF0000FFFF0000FFFF0000808000008080
      0000FFFF000080800000808000008080800000000000C0C0C000C0C0C0000000
      0000FFFFFF00FFFFFF0000000000C0C0C00000000000FFFFFF00FFFFFF000000
      0000C0C0C000C0C0C00000000000000000000000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000000000000000000000000000000000000000000000800000008000
      0000800000008000000080808000808080008000000080000000800000008080
      80008080800080808000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF0000000000000080800000808000008080000080800000FFFF
      000080800000FFFF0000808000000000000000000000C0C0C000C0C0C000C0C0
      C00000000000FFFFFF00FFFFFF0000000000C0C0C0000000000000000000C0C0
      C000C0C0C000C0C0C00000000000000000000000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      000000000000000000000000000000000000000000000000000000000000FF00
      00008000000080808000808080008080800080000000FF000000800000008080
      8000808080008080800000000000000000000000000000000000FF000000FF00
      0000FF00000080000000800000000000000080800000FFFFFF00FFFF0000FFFF
      0000FFFF000080800000808000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C0000000000000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C00000000000000000000000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF0000008080800080808000FF00000080000000FF0000008080
      800080808000808080000000000000000000000000000000000000000000FF00
      000080000000800000000000000000FFFF0000000000FFFF0000FFFFFF00FFFF
      0000FFFF0000FFFF0000808000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000800000008080800080000000FF000000800000008080
      8000808080008080800000000000000000000000000000000000000000000000
      000080000000000000008080800000FFFF0000FFFF000000000080800000FFFF
      FF008080000080800000000000008080800000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000000000000000
      0000C0C0C000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000FF0000008080
      8000808080008080800000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000FFFF00008080000000
      00000000000000000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000000000FFFF0000FF
      FF0000000000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF00000080000000FF000000800000008080
      8000808080008080800000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF000080800000808000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000000000FFFF0000FF
      FF0000000000C0C0C00000000000000000000000000000000000000000008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF0000008080
      8000808080008080800000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF000080800000808000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000000000000000
      0000C0C0C000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF0000008080
      8000808080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00C0C0C00000808000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000800000008000000080000000800000008000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000008080
      8000808080008080800000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000000080000000800000008000000080000000800000008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000008000000080000000800000008000000080000000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C000000000000000000000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000000000000000000000000000FFFFFF00FFFFFF0000000000000000008000
      0000800000008000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00000000000000000000000000FFFFFF00FFFFFF000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000FFFFFF00FFFFFF0000000000000000000000
      0000800000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      000000000000C0C0C000000000000000000000000000FFFFFF00FFFFFF000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000000000000000000000000000FFFFFF00FFFFFF0000000000000000000000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00000000000000000000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000FFFFFF00FFFFFF0000000000000000000000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF0000000000000000000000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF0000000000000000000000
      0000800000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00C0C0C000FFFFFF00C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C0C0C000FFFFFF00C0C0C000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF0000000000000000000000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF0000000000000000000000
      0000800000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000808080008000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000000000000000000000000000000000000800000008000
      0000800000008000000080000000000000000000000000000000000000000000
      000080000000808080000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000FFFFFF00FFFFFF0000000000000000000000
      0000800000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000800000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000008000000000000000000000000000000000000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      000000000000800000000000000000000000000000000000000000000000C0C0
      C000000000000000000000000000FFFFFF00FFFFFF0000000000000000000000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000800000008000000000000000000000000000000000000000800000008000
      0000800000000000000000000000000000000000000000000000000000000000
      000000000000800000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000FFFFFF00FFFFFF0000000000000000000000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000000000
      0000000000000000000000000000000000000000000000000000800000000000
      0000800000008000000000000000000000000000000000000000800000008000
      0000000000008000000000000000000000000000000000000000000000000000
      000000000000800000000000000000000000000000000000000000000000C0C0
      C000000000000000000000000000FFFFFF00FFFFFF0000000000000000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008000
      0000000000000000000000000000000000008000000080000000000000000000
      0000000000008000000000000000000000000000000000000000800000000000
      0000000000000000000080000000800000000000000000000000000000000000
      0000800000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00C0C0C000FFFFFF00C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000800000008000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000800000008000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000008000000080000000800000008000
      0000800000008000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000000000000000000080000000000000000000000080000000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00800000000000000000000000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000C0C0C0000000000000000000000000000000000000000000000000008000
      0000000000000000000080000000000000008000000000000000000000008000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      00000000000000000000FFFFFF00000000000000000080808000008080008080
      8000008080008080800080000000FFFFFF000000000000000000000000000000
      00000000000000000000FFFFFF00800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C00000000000000000000000000000000000000000008000
      0000000000000000000080000000000000008000000000000000000000008000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000808000808080000080
      8000808080000080800080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF008000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C00000FF000000FF000000FF0000C0C0C000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000800000008000000080000000000000008000000000000000000000008000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF0000000000000000000000
      00000000000000000000FFFFFF00000000000000000080808000008080008080
      8000008080008080800080000000FFFFFF00000000000000000000000000FFFF
      FF008000000080000000800000008000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C00000000000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000080000000000000008000000080000000800000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000808000808080000080
      8000808080000080800080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0080000000FFFFFF0080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C000C0C0C000000000000000000000000000000000000000
      0000000000000000000080000000000000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000000000000000FFFF
      FF00000000000000000000000000000000000000000080808000008080008080
      8000008080008080800080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF008000000080000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000C0C0C00000000000C0C0C000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF0000000000000000000000000000808000808080000080
      8000808080000080800080000000800000008000000080000000800000008000
      0000800000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C00000000000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000080808000008080008080
      8000008080008080800000808000808080000080800080808000008080008080
      800000808000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000C0C0C00000000000C0C0C000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000808000808080000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000000000008080
      8000008080000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000808000808080000080
      80000000000000FFFF00000000000000000000FFFF0000000000808080000080
      8000808080000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000808080008080800080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000808080008080800080808000000000000000000000000000000000000000
      0000000000008000000080000000800000008000000080000000800000008000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000008000000080000000800000008000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000808080008080800080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000808080008080800080808000000000000000000000000000000000000000
      0000000000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000808080008080800080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000000000000000000000000000000000000000
      0000000000008000000000000000000000000000000000000000000000000000
      0000000000000000000080000000000000000000000000000000000000000000
      0000000000008000000000000000000000000000000000000000000000000000
      0000000000000000000080000000000000000000000000000000000000000000
      00000000000000FFFF00FFFFFF0000FFFF00FFFFFF0000000000808080008080
      8000808080008080800080808000000000000000000000000000000000000000
      00000000000000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00000000008080800080808000000000000000000000000000000000000000
      0000000000008000000000000000000000000000000000000000000000000000
      0000000000000000000080000000000000000000000000000000000000000000
      0000000000008000000000000000000000000000000000000000000000000000
      0000000000000000000080000000000000000000000000000000000000000000
      000000000000FFFFFF0000FFFF00FFFFFF0000FFFF0000000000808080008080
      8000808080008080800080808000000000000000000000000000000000000000
      000000000000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF00000000008080800080808000000000000000000080000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000080000000000000000000000000000000000000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000080000000000000000000000000000000000000000000
      00000000000000FFFF00FFFFFF0000FFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00000000000000000000000000000000000000000080000000000000000000
      0000000000008000000000000000000000000000000000000000000000000000
      0000000000000000000080000000000000000000000000000000000000000000
      0000000000008000000000000000000000000000000000000000000000000000
      0000000000000000000080000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF00FFFFFF0000FFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF00000000000000000000000000000000000000000080000000000000000000
      0000000000008000000000000000000000000000000000000000000000000000
      0000000000000000000080000000000000000000000080000000000000000000
      0000000000008000000000000000000000000000000000000000000000000000
      0000000000000000000080000000000000000000000000000000808080008080
      800080808000808080008080800000000000FFFFFF0000FFFF00FFFFFF0000FF
      FF00000000000000000000000000000000000000000000000000808080008080
      80000000000000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00000000000000000000000000000000000000000080000000000000000000
      0000000000008000000000000000000000000000000000000000000000000000
      0000000000000000000080000000000000000000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      80008080800080808000808080000000000000FFFF00FFFFFF0000FFFF00FFFF
      FF00000000000000000000000000000000000000000000000000808080008080
      800000000000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF00000000000000000000000000000000000000000080000000000000000000
      0000000000008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000000000000000000080000000000000000000
      0000000000000000000000000000800000008000000080000000800000008000
      0000800000000000000000000000000000000000000000000000808080008080
      800080808000808080008080800000000000FFFFFF0000FFFF00FFFFFF0000FF
      FF00000000000000000000000000000000000000000000000000808080008080
      80000000000000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00000000000000000000000000000000000000000080000000000000000000
      0000000000000000000000000000000000000000000080000000000000000000
      0000000000000000000000000000000000000000000080000000000000000000
      0000000000000000000000000000000000000000000080000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000808080008080800080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000000000000000
      0000000000000000000000000000000000000000000080000000000000000000
      0000000000000000000000000000000000000000000080000000000000000000
      0000000000000000000000000000000000000000000080000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000808080008080800080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000808080008080800080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000800000008000000080000000800000008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000800000008000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FF000000FF000000FF000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080008080800080808000808080008080
      8000808080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000808080008080800080808000808080008080
      8000808080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000000000000000
      00000000000000000000000000000000000000000000000000000080000000FF
      000000FF000000FF00000080000000800000008000000080000000FF000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080008080800080808000808080008080
      8000808080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000808080008080800080808000808080008080
      8000808080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000800000000000
      00000000000000000000000000000000000000000000000000000080000000FF
      000000FF000000800000000000000000000000000000000000000080000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080008080800080808000808080008080
      8000808080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080008080800000000000000000000000000000000000000000000000
      0000800000008000000080000000800000008000000080000000800000008000
      000000000000000000000000000000000000000000000080000000FF000000FF
      0000000000000000000000000000000000000000000000000000000000000080
      000000FF000000FF000000000000000000000000000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF0000000000808080008080800080808000808080008080
      8000808080008080800000000000000000000000000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF000000
      0000808080008080800000000000000000000000000000000000000000000000
      0000800000008000000080000000800000008000000080000000800000008000
      000080000000000000000000000000000000000000000080000000FF000000FF
      0000000000000000000000000000000000000000000000000000000000000080
      000000FF000000FF00000000000000000000000000000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF0000000000808080008080800080808000808080008080
      800080808000808080000000000000000000000000000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF000000
      0000808080008080800000000000000000000000000000000000000000000000
      0000800000008000000080000000800000008000000080000000800000008000
      000000000000000000000000000000000000000000000080000000FF000000FF
      0000000000000000000000000000000000000000000000000000000000000080
      000000FF000000FF000000000000000000000000000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF0000000000808080008080800080808000808080008080
      8000808080008080800000000000000000000000000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF000000
      0000808080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000800000000000
      000000000000000000000000000000000000000000000080000000FF000000FF
      0000000000000000000000000000000000000000000000000000000000000080
      000000FF000000FF00000000000000000000000000000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000000000000000
      00000000000000000000000000000000000000000000000000000080000000FF
      000000FF00000000000000000000000000000080000000FF00000000000000FF
      000000FF00000000000000000000000000000000000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000000000000000000000000
      00000000000000000000000000000000000000000000000000000080000000FF
      000000FF00000000000000000000000000000080000000FF000000FF000000FF
      000000FF0000000000000000000000000000000000000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF000000
      000000000000000000000000000000000000000000000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      0000008000000000000000000000000000000080000000FF000000FF000000FF
      0000000000000000000000000000000000000000000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000080000000FF000000FF000000FF
      000000FF0000000000000000000000000000000000000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF000000
      000000000000000000000000000000000000000000000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000080000000800000008000000080
      0000008000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080000080800000808000008080
      0000808000008080000080800000808000008080000080800000808000008080
      0000808000000000000000000000000000000000000000000000000000000000
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000080808000000000000000
      00000000000000000000000000000000000080800000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0080800000FFFFFF0080800000FFFFFF00FFFFFF00FFFFFF008080
      00008080000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000808080000000000080800000FFFFFF00808000008080
      0000FFFFFF00808000008080000080800000FFFFFF008080000080800000FFFF
      FF008080000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000800000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000000000000000000080808000808080008080800080808000000000000000
      0000808080008080800000000000000000008080000080800000FFFFFF00FFFF
      FF00FFFFFF00808000008080000080800000FFFFFF008080000080800000FFFF
      FF00808000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      00000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000000000008080800080808000808080008080800080808000808080000000
      0000808080008080800000000000000000008080000080800000808000008080
      0000FFFFFF00808000008080000080800000FFFFFF008080000080800000FFFF
      FF00808000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF00000000000000000000000000000000000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000008000000080000000800000008000000080000000800000008000
      0000800000000000000000000000000000000000000000000000808080008080
      80000000000080808000C0C0C000808080008080800080808000808080000000
      00008080800080808000000000000000000080800000FFFFFF00FFFFFF00FFFF
      FF0080800000808000008080000080800000FFFFFF00FFFFFF00FFFFFF008080
      0000808000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF0000000000000000000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000000000000000000000000000000000000000000000808080008080
      80000000000080808000FFFF0000C0C0C0008080800080808000808080000000
      0000808080008080800000000000000000008080000080800000808000008080
      000080800000808000008080000080800000FFFFFF0080800000808000008080
      0000808000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000000080000000800000008000000080000000800000008000
      0000800000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00000000000000000080808000808080008080800080808000000000000000
      0000FFFFFF00FFFFFF0000000000000000008080000080800000808000008080
      000080800000808000008080000080800000FFFFFF0080800000808000008080
      0000808000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF0000000000000000008080000080800000808000008080
      0000808000008080000080800000808000008080000080800000808000008080
      0000808000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080000080800000808000008080
      0000808000008080000080800000808000008080000080800000808000008080
      0000808000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF0000000000000000000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800000000000FFFFFF00FFFFFF0000000000808080000000
      0000000000000000000000000000000000008080000080800000808000008080
      0000808000008080000080800000808000008080000080800000808000008080
      0000808000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000008000000080000000000000000000000000000000000000000000
      0000000000000000000000800000008000000080000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000000080000000800000008000000000000000000000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000008000000080000000800000008000000000000000000000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000008000000080000000800000008000000000000000000000008000
      0000800000008000000000000000000000000000000000000000000000000000
      000000000000000000000080000000FF000000FF000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0080000000800000008000
      0000800000000000000000000000000000000000000000000000000000008000
      000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0080000000800000008000
      0000800000000000000000000000000000000000000000000000000000008000
      000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0080000000800000008000
      0000800000000000000000000000000000000000000000000000000000000000
      000000000000000000000080000000FF000000FF000000800000000000000000
      000000000000000000000000000000000000000000000000000080000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008000
      000000000000000000000000000000000000000000000000000080000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008000
      000000000000000000000000000000000000000000000000000080000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000080000000FF000000FF000000800000000000000000
      000000000000000000000000000000000000000000000000000080000000FFFF
      FF00FFFFFF008000000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF008000
      000000000000000000000000000000000000000000000000000080000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008000
      000000000000000000000000000000000000000000000000000080000000FFFF
      FF00FFFFFF00FFFFFF008000000080000000FFFFFF00FFFFFF00FFFFFF008000
      0000000000000000000000000000000000000000000000000000008000000080
      000000800000008000000080000000FF000000FF000000800000008000000080
      0000008000000080000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF008000000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00800000000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00800000000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF008000000080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF008000000000000000000000000000000000000000000000000080000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF00000080000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF0080000000800000008000000080000000FFFFFF00FFFFFF00FFFF
      FF00800000000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00800000008000000080000000800000008000000080000000FFFFFF00FFFF
      FF00800000000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00800000008000000080000000800000008000000080000000FFFFFF00FFFF
      FF008000000000000000000000000000000000000000000000000080000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF00000080000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF008000000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00800000000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00800000008000000080000000800000008000000080000000FFFFFF00FFFF
      FF00800000000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00800000008000000080000000800000008000000080000000FFFFFF00FFFF
      FF00800000000000000000000000000000000000000000000000008000000080
      000000800000008000000080000000FF000000FF000000800000008000000080
      0000008000000080000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF008000000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00800000000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00800000000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF008000000080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00800000000000000000000000000000000000000000000000000000000000
      000000000000000000000080000000FF000000FF000000800000000000000000
      000000000000000000000000000000000000000000000000000080000000FFFF
      FF00FFFFFF0080000000800000008000000080000000FF000000FFFFFF008000
      000000000000000000000000000000000000000000000000000080000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008000
      000000000000000000000000000000000000000000000000000080000000FFFF
      FF00FFFFFF00FFFFFF008000000080000000FFFFFF00FFFFFF00FFFFFF008000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000080000000FF000000FF000000800000000000000000
      000000000000000000000000000000000000000000000000000080000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008000
      000000000000000000000000000000000000000000000000000080000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008000
      000000000000000000000000000000000000000000000000000080000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000080000000FF000000FF000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0080000000800000000000
      0000000000000000000000000000000000000000000000000000000000008000
      000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0080000000800000000000
      0000000000000000000000000000000000000000000000000000000000008000
      000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0080000000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000008000000080000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000008000000080000000800000008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000008000000080000000800000008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000008000000080000000800000008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000008000000080000000800000008000000080000000800000008080
      0000000000008000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000008080000080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000080800000000000000000000000000000000000000000008000
      000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00800000008000
      0000800000008000000080000000000000000000000000000000008080000080
      8000008080000080800000808000008080000080800000808000008080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000008080000080
      8000000000000000000000000000000000000000000000000000000000000000
      000000000000008080000000000000000000000000000000000080000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF008000000080000000000000000000000000000000FFFFFF00000000000080
      8000008080000080800000808000008080000080800000808000008080000080
      8000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000008080000080
      8000000000000000000000000000000000000000000000000000000000000000
      000000000000008080000000000000000000000000000000000080000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000080000000000000000000000000FFFF00FFFFFF000000
      0000008080000080800000808000008080000080800000808000008080000080
      8000008080000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000008080000080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000080800000000000000000000000000080000000FFFFFF00FFFF
      FF0080000000FFFFFF00FF00000080000000FF000000FFFFFF00FF0000008000
      0000FF000000FFFFFF00800000000000000000000000FFFFFF0000FFFF00FFFF
      FF00000000000080800000808000008080000080800000808000008080000080
      8000008080000080800000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000008080000080
      8000008080000080800000808000008080000080800000808000008080000080
      8000008080000080800000000000000000000000000080000000FFFFFF00FFFF
      FF0080000000FFFFFF0080000000FF00000080000000FFFFFF0080000000FF00
      000080000000FFFFFF0080000000000000000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000008080000080
      8000000000000000000000000000000000000000000000000000000000000000
      0000008080000080800000000000000000000000000080000000FFFFFF00FFFF
      FF0080000000FFFFFF0080000000FFFFFF0080000000FFFFFF0080000000FFFF
      FF0080000000FFFFFF00800000000000000000000000FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000008080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080800000000000000000000000000080000000FFFFFF00FFFF
      FF0080000000FFFFFF0080000000FFFFFF0080000000FFFFFF0080000000FFFF
      FF0080000000FFFFFF0080000000000000000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000008080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080800000000000000000000000000080000000FFFFFF008000
      000080000000FFFFFF0080000000FF00000080000000FFFFFF0080000000FF00
      000080000000FFFFFF00800000000000000000000000FFFFFF0000FFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000008080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080800000000000000000000000000080000000FFFFFF00FF00
      000080000000FFFFFF00FF00000080000000FF000000FFFFFF00FF0000008000
      0000FF000000FFFFFF0080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF00000000000000000000000000000000000000000000000000008080000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000008080000000000000000000000000000000000080000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000008080000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000008000000080000000800000008000000080000000800000008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000C00000000100010000000000000600000000000000000000
      000000000000000000000000FFFFFF00FF8F000000000000FF0F000000000000
      FE07000000000000FC03000000000000FC81000000000000F842000000000000
      E025000000000000C01B00000000000080170000000000000017000000000000
      001700000000000000170000000000002017000000000000602F000000000000
      090F000000000000121F000000000000FFFFC001FFFCFAAAFFFF8000FFF8FFFF
      C0030000FFF1FBFE80010001F863FFFF00000001E007FBFE00008003C00FFFFF
      00008003C00FFAAA0000C0078007FFFF0000C0078007FEFF0000E00F8007FDFF
      0000E00F8007BBFF8001F01FC00FB7FFC003F01FC00FAFFFFFFFF83FE01F9FFF
      FFFFF83FF03F83FFFFFFFCFFFFFFFFFFFFF0FE3FFFFFFFFFFFF0F81FFFFFFFFF
      FFF0E00FFFFF0000FFF08007F00F0000FF0F0003C0030000FF8F000180010000
      FF8F000080010000FF6F000100000000FEFF800100000000FDFFC00100000000
      FBFFE00000000000F7FFF000800100000FFFF803800100000FFFFC0FC0030000
      0FFFFE3FF00F00000FFFFFFFFFFFFFFFFFCFFC1FFFFFFFFFFF03F80F0001FFFF
      FE00F80700011FF8E701F803000100008601F80100011FF8000100000001BFF7
      C00100000001BFEFE00180000001BF1FF001C00000011F1FF801E00000011F1F
      FC01F40100011FEFFE01FC010001EFF7FF01FC010001F1F8FF81FC010001F000
      FFC1FE010001F1F8FFF1FF01FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      CDFFFFFFFFB3C003C80FFF0FF013C003CDFFFF0FFFB3FFFFCFFFF10FFFF3C437
      C803F10FC013C423C803C003C013C437C803C003C013C437C803F10FC013C437
      CFFFF10FFFF3C437C81FFF0FF813FC37C81FFF0FF813FC3FC81FFFFFF813FC3F
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFC3FFE7FFFFFFFFFFC3FFE7FFFFFFFFFFC37E007E7FFFFE7C437E007
      CF83C1F3C437E007DFC3C3FBC437E007DFE3C7FBC437FE7FDFD3CBFBC423F81F
      CF3BDCF3C437F81FE0FFFF07FFFFF81FFFFFFFFFC003FE7FFFFFFFFFC003FE7F
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3FFFE00FC00C007
      ED9FFE0080008003ED6FFE0000000001ED6F800000000001F16F800000000001
      FD1F800000010000FC7F800000030000FEFF800100030000FC7F80030003C000
      FD7F80070003E001F93F807F0003E007FBBF80FF0003F007FBBF81FF8007F003
      FBBFFFFFF87FF803FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF80FF801FF8F1F8
      FF80FF801800F000FF80FF801BF8F1F8F000F000FBFDFBFDF000F000FBFD1BFD
      F000F00083FD03FDF000F000BBFD1BFD80078007BBFDBBFD80078007BBFDB1F8
      80078007B801B00080078007BFBFB1B880078007BFBFBFBF80FF80FF1FB81F1F
      80FF80FF0038001FFFFFFFFF1FF81F1FFFFFFFFFFFFFFFFFFEFFFC3FFFFFFFFF
      FE7FF00FFC01FC01FE3FE007FC01FC01FE1FC003FC01FC01E00FC3C380018001
      E00787E180018001E00387E180018001E00787E180018001E00F872180018001
      FE1FC303800F800FFE3FC303800F800FFE7FE707800F800FFEFFFF03800F800F
      FFFFFF03800F800FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE4EFFDFFBF
      FFFF0003C7FDFF3FFC3F0003C3FBFE3F80010003C3F3FC3F80010003E1E7F803
      80010003F0C7F00380010003F80FE00380010003FC1FF00380010003FC1FF803
      80010003F80FFC3F80010003E0C7FE3FC8130003C1E3FF3FFC3FFFE4C3F1FFBF
      FFFFFFFFC7FDFFFFFFFFFFFFFFFFFFFFFFFCFFFCFFFCFFFFFFF8FFF8FFF8FFFF
      FFF1FFF1FFF1FC3FF863F863F863FC3FE007E007E007FC3FC00FC00FC00FFC3F
      C00FC00FC00FC003800780078007C003800780078007C003800780078007C003
      800780078007FC3FC00FC00FC00FFC3FC00FC00FC00FFC3FE01FE01FE01FFC3F
      F03FF03FF03FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFFFFE003C001F008
      001FE0038031E001000FE0038031C0030007E0038031C0010003E00380018001
      0001E003800180010001E00380018001001FE0038FF18001001FE0038FF18001
      001FE0038FF180018FF1E0078FF1C001FFF9E00F8FF1C003FF75E01F8FF5E007
      FF8FFFFF8001F00FFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object pmShapeAdd: TPopupMenu
    Images = ilMain
    Left = 651
    Top = 98
    object AddTextShape1: TMenuItem
      Action = acShapeAddText
    end
    object AddSpecialTextshape1: TMenuItem
      Caption = 'Add Special Text shape'
      object AddPolygonText1: TMenuItem
        Action = acShapeAddPolygonText
      end
      object acShapeAddCurvedText1: TMenuItem
        Action = acShapeAddCurvedText
      end
      object acShapeAddProjectiveText1: TMenuItem
        Action = acShapeAddProjectiveText
      end
      object AddWavyText2: TMenuItem
        Action = acShapeAddWavyText
      end
    end
    object AddMemoShape1: TMenuItem
      Action = acShapeAddMemo
    end
    object AddPhotoShape1: TMenuItem
      Action = acShapeAddBitmap
    end
    object AddCropBitmap2: TMenuItem
      Action = acShapeAddCropBitmap
    end
    object AddMetafile1: TMenuItem
      Action = acShapeAddMeta
    end
    object acShapeAddLine1: TMenuItem
      Action = acShapeAddLine
    end
    object AddFreehand2: TMenuItem
      Action = acShapeAddFreehand
    end
    object N12: TMenuItem
      Caption = '-'
    end
    object AddEllipse1: TMenuItem
      Action = acShapeAddEllipse
    end
    object AddRectangle1: TMenuItem
      Action = acShapeAddRectangle
    end
    object Addroundedrectangle1: TMenuItem
      Action = acShapeAddRoundRect
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object Addnewpageatend1: TMenuItem
      Action = acPageAdd
    end
    object InsertPage1: TMenuItem
      Action = acPageInsert
    end
  end
  object ilThumbs: TImageList
    Left = 619
    Top = 98
  end
  object pmAlignment: TPopupMenu
    Images = ilMain
    Left = 594
    Top = 98
    object AlignLeft2: TMenuItem
      Action = acAlignLft
    end
    object AlignCenter2: TMenuItem
      Action = acAlignCtr
    end
    object AlignRight2: TMenuItem
      Action = acAlignRgt
    end
    object AlignTop2: TMenuItem
      Action = acAlignTop
    end
    object AlignMiddle2: TMenuItem
      Action = acAlignMid
    end
    object AlignBottom2: TMenuItem
      Action = acAlignBtm
    end
  end
  object pmZOrder: TPopupMenu
    Left = 563
    Top = 98
    object MoveBack2: TMenuItem
      Action = acMoveBack
    end
    object MoveFwd2: TMenuItem
      Action = acMoveFwd
    end
    object ToBkgnd2: TMenuItem
      Action = acMoveToBg
    end
    object ToFgnd2: TMenuItem
      Action = acMoveToFg
    end
  end
end
