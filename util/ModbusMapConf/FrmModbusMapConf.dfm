object Form1: TForm1
  Left = 545
  Top = 378
  Caption = 'Form1'
  ClientHeight = 644
  ClientWidth = 1077
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1077
    Height = 644
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Modus Map Configuration'
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 1069
        Height = 81
        Align = alTop
        TabOrder = 0
        object Button1: TButton
          Left = 355
          Top = 2
          Width = 116
          Height = 25
          Caption = 'Save To XML'
          TabOrder = 0
          OnClick = Button1Click
        end
        object EncryptCB: TCheckBox
          Left = 788
          Top = 30
          Width = 97
          Height = 17
          Caption = 'XML Encryption'
          TabOrder = 1
        end
        object RGConvert: TRadioGroup
          Left = 6
          Top = 0
          Width = 154
          Height = 43
          Caption = 'Address Convert To'
          Columns = 2
          Items.Strings = (
            'Decimal'
            'Hexa')
          TabOrder = 2
        end
        object RGModeSelect: TRadioGroup
          Left = 494
          Top = 2
          Width = 288
          Height = 73
          Caption = 'File Open Mode'
          Columns = 2
          ItemIndex = 2
          Items.Strings = (
            'Modbus Map Conf.'
            'Engine Parameter Conf.'
            'Engine Param JSON'
            'S7 PLC JSON'
            'Sqlite')
          TabOrder = 3
        end
        object Button3: TButton
          Left = 355
          Top = 29
          Width = 116
          Height = 25
          Caption = 'Save To JSON'
          TabOrder = 4
          OnClick = Button3Click
        end
        object Button4: TButton
          Left = 166
          Top = 57
          Width = 129
          Height = 25
          Caption = 'Calc Absolute Index'
          TabOrder = 5
          OnClick = Button4Click
        end
        object Button5: TButton
          Left = 166
          Top = 26
          Width = 129
          Height = 25
          Caption = 'Get TagName From DB'
          TabOrder = 6
          OnClick = Button5Click
        end
        object Button6: TButton
          Left = 166
          Top = -1
          Width = 129
          Height = 25
          Caption = 'Remove Dummy'
          TabOrder = 7
          OnClick = Button6Click
        end
        object Button7: TButton
          Left = 788
          Top = -1
          Width = 187
          Height = 25
          Caption = 'Append Proj_Eng_No To TagName'
          TabOrder = 8
          OnClick = Button7Click
        end
        object Button8: TButton
          Left = 355
          Top = 58
          Width = 116
          Height = 25
          Caption = 'Save To Sqlite'
          TabOrder = 9
          OnClick = Button8Click
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 81
        Width = 1069
        Height = 8
        Align = alTop
        TabOrder = 1
      end
      object Panel3: TPanel
        Left = 0
        Top = 584
        Width = 1069
        Height = 32
        Align = alBottom
        BevelInner = bvRaised
        TabOrder = 2
        object Label1: TLabel
          Left = 2
          Top = 6
          Width = 40
          Height = 13
          Caption = 'Formula:'
        end
        object FormulaEdit: TEdit
          Left = 48
          Top = 6
          Width = 689
          Height = 21
          ImeName = 'Microsoft IME 2010'
          TabOrder = 0
        end
      end
      object PageControl2: TPageControl
        Left = 0
        Top = 89
        Width = 1069
        Height = 495
        ActivePage = TabSheet3
        Align = alClient
        TabOrder = 3
        object TabSheet3: TTabSheet
          Caption = 'TabSheet1'
          TabVisible = False
          object CoolBar1: TCoolBar
            Left = 0
            Top = 0
            Width = 1061
            Height = 22
            AutoSize = True
            Bands = <
              item
                Control = ToolBar1
                ImageIndex = -1
                MinHeight = 22
                Width = 1059
              end>
            EdgeBorders = []
            object ToolBar1: TToolBar
              Left = 11
              Top = 0
              Width = 1050
              Height = 22
              AutoSize = True
              Caption = 'ToolBar1'
              Color = clBtnFace
              Customizable = True
              Images = ImageList1
              ParentColor = False
              TabOrder = 0
              Transparent = True
              object btnLeftAlignment: TToolButton
                Left = 0
                Top = 0
                Caption = 'btnLeftAlignment'
                Down = True
                Grouped = True
                ImageIndex = 0
                Style = tbsCheck
                OnClick = btnLeftAlignmentClick
              end
              object btnCenterAlignment: TToolButton
                Left = 23
                Top = 0
                Caption = 'btnCenterAlignment'
                Grouped = True
                ImageIndex = 1
                Style = tbsCheck
                OnClick = btnCenterAlignmentClick
              end
              object btnRightAlignment: TToolButton
                Left = 46
                Top = 0
                Caption = 'btnRightAlignment'
                Grouped = True
                ImageIndex = 2
                Style = tbsCheck
                OnClick = btnRightAlignmentClick
              end
              object ToolButton6: TToolButton
                Left = 69
                Top = 0
                Width = 8
                Caption = 'ToolButton6'
                ImageIndex = 5
                Style = tbsSeparator
              end
              object ToolButton3: TToolButton
                Left = 77
                Top = 0
                Caption = 'ToolButton3'
                Grouped = True
                ImageIndex = 3
                Style = tbsCheck
                OnClick = ToolButton3Click
              end
              object ToolButton4: TToolButton
                Left = 100
                Top = 0
                Caption = 'ToolButton4'
                Down = True
                Grouped = True
                ImageIndex = 4
                Style = tbsCheck
                OnClick = ToolButton4Click
              end
              object ToolButton5: TToolButton
                Left = 123
                Top = 0
                Caption = 'ToolButton5'
                Grouped = True
                ImageIndex = 5
                Style = tbsCheck
                OnClick = ToolButton5Click
              end
              object ToolButton7: TToolButton
                Left = 146
                Top = 0
                Width = 8
                Caption = 'ToolButton7'
                ImageIndex = 15
                Style = tbsSeparator
              end
              object btnAddRow: TToolButton
                Left = 154
                Top = 0
                Hint = 'Add Row'
                Caption = 'btnAddRow'
                ImageIndex = 6
                ParentShowHint = False
                ShowHint = True
                OnClick = btnAddRowClick
              end
              object btnAddCol: TToolButton
                Left = 177
                Top = 0
                Hint = 'Add Column'
                Caption = 'btnAddCol'
                ImageIndex = 7
                ParentShowHint = False
                ShowHint = True
              end
              object ToolButton10: TToolButton
                Left = 200
                Top = 0
                Width = 8
                Caption = 'ToolButton10'
                ImageIndex = 7
                Style = tbsSeparator
              end
              object ToolButton13: TToolButton
                Left = 208
                Top = 0
                Hint = 'Clear Rows'
                Caption = 'ToolButton13'
                ImageIndex = 8
                ParentShowHint = False
                ShowHint = True
                OnClick = ToolButton13Click
              end
              object ToolButton12: TToolButton
                Left = 231
                Top = 0
                Width = 8
                Caption = 'ToolButton12'
                ImageIndex = 8
                Style = tbsSeparator
              end
              object ToolButton14: TToolButton
                Left = 239
                Top = 0
                Hint = 'Delete Row'
                Caption = 'ToolButton14'
                ImageIndex = 9
                ParentShowHint = False
                ShowHint = True
                OnClick = ToolButton14Click
              end
              object ToolButton16: TToolButton
                Left = 262
                Top = 0
                Hint = 'Delete Column'
                Caption = 'ToolButton16'
                ImageIndex = 10
                ParentShowHint = False
                ShowHint = True
                OnClick = ToolButton16Click
              end
              object ToolButton15: TToolButton
                Left = 285
                Top = 0
                Width = 8
                Caption = 'ToolButton15'
                ImageIndex = 11
                Style = tbsSeparator
              end
              object ToolButton8: TToolButton
                Left = 293
                Top = 0
                Hint = 'Move Row Up'
                Caption = 'ToolButton8'
                ImageIndex = 11
                ParentShowHint = False
                ShowHint = True
                OnClick = ToolButton8Click
              end
              object ToolButton17: TToolButton
                Left = 316
                Top = 0
                Hint = 'Move Row Down'
                Caption = 'ToolButton17'
                ImageIndex = 12
                ParentShowHint = False
                ShowHint = True
                OnClick = ToolButton17Click
              end
              object ToolButton20: TToolButton
                Left = 339
                Top = 0
                Width = 8
                Caption = 'ToolButton20'
                ImageIndex = 15
                Style = tbsSeparator
              end
              object ToolButton18: TToolButton
                Left = 347
                Top = 0
                Hint = 'Move Column Left'
                Caption = 'ToolButton18'
                ImageIndex = 13
                ParentShowHint = False
                ShowHint = True
                OnClick = ToolButton18Click
              end
              object ToolButton19: TToolButton
                Left = 370
                Top = 0
                Hint = 'Move Column Right'
                Caption = 'ToolButton19'
                ImageIndex = 14
                ParentShowHint = False
                ShowHint = True
                OnClick = ToolButton19Click
              end
              object ToolButton9: TToolButton
                Left = 393
                Top = 0
                Width = 8
                Caption = 'ToolButton9'
                ImageIndex = 15
                Style = tbsSeparator
              end
              object ToolButton21: TToolButton
                Left = 401
                Top = 0
                Hint = 'Save To CSV File'
                Caption = 'ToolButton21'
                ImageIndex = 15
                ParentShowHint = False
                ShowHint = True
                OnClick = ToolButton21Click
              end
              object ToolButton22: TToolButton
                Left = 424
                Top = 0
                Hint = 'Open From Text File'
                Caption = 'ToolButton22'
                ImageIndex = 16
                ParentShowHint = False
                ShowHint = True
                OnClick = ToolButton22Click
              end
              object ToolButton1: TToolButton
                Left = 447
                Top = 0
                Width = 8
                Caption = 'ToolButton1'
                ImageIndex = 17
                Style = tbsSeparator
              end
              object btnBold: TToolButton
                Left = 455
                Top = 0
                Hint = 'Bold'
                Caption = 'btnBold'
                ImageIndex = 17
                ParentShowHint = False
                ShowHint = True
                Style = tbsCheck
                OnClick = btnBoldClick
              end
              object btnItalic: TToolButton
                Left = 478
                Top = 0
                Hint = 'Italic'
                Caption = 'btnItalic'
                ImageIndex = 18
                ParentShowHint = False
                ShowHint = True
                Style = tbsCheck
                OnClick = btnItalicClick
              end
              object btnUnderline: TToolButton
                Left = 501
                Top = 0
                Hint = 'Underline'
                Caption = 'btnUnderline'
                ImageIndex = 19
                ParentShowHint = False
                ShowHint = True
                Style = tbsCheck
                OnClick = btnUnderlineClick
              end
              object ToolButton2: TToolButton
                Left = 524
                Top = 0
                Width = 8
                Caption = 'ToolButton2'
                ImageIndex = 20
                Style = tbsSeparator
              end
              object ColorPickerEditor1: TNxColorPicker
                Left = 532
                Top = 0
                Width = 105
                Height = 22
                TabOrder = 0
                Text = '$00FFFFFF'
                ShowPreview = True
                OnChange = ColorPickerEditor1Change
                Options = [coColorsButton, coNoneButton]
                HideFocus = False
                SelectedColor = clWhite
              end
              object ToolButton11: TToolButton
                Left = 637
                Top = 0
                Width = 8
                Caption = 'ToolButton11'
                ImageIndex = 21
                Style = tbsSeparator
              end
              object JvLabel8: TJvLabel
                AlignWithMargins = True
                Left = 645
                Top = 0
                Width = 120
                Height = 22
                Alignment = taCenter
                AutoSize = False
                Caption = 'ParamNo Filter'
                Color = 14671839
                FrameColor = clGrayText
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -13
                Font.Name = #47569#51008' '#44256#46357
                Font.Style = [fsBold]
                Layout = tlCenter
                Margin = 5
                ParentColor = False
                ParentFont = False
                RoundedFrame = 3
                Transparent = True
                HotTrackFont.Charset = ANSI_CHARSET
                HotTrackFont.Color = clWindowText
                HotTrackFont.Height = -13
                HotTrackFont.Name = #47569#51008' '#44256#46357
                HotTrackFont.Style = []
              end
              object ParamNoFilterEdit: TEdit
                Left = 765
                Top = 0
                Width = 121
                Height = 22
                ImeName = 'Microsoft IME 2010'
                TabOrder = 1
                OnChange = ParamNoFilterEditChange
              end
            end
          end
          object Panel4: TPanel
            Left = 0
            Top = 22
            Width = 1061
            Height = 463
            Align = alClient
            BevelWidth = 2
            Caption = 'Panel4'
            TabOrder = 1
            object NextGrid1: TNextGrid6
              Left = 2
              Top = 2
              Width = 1057
              Height = 459
              Align = alClient
              ParentColor = False
              PopupMenu = PopupMenu1
              TabOrder = 0
              OnKeyDown = NextGrid1KeyDown
              OnMouseDown = NextGrid1MouseDown
              OnMouseMove = NextGrid1MouseMove
              ActiveView = NxReportGridView61
              ActiveViewIndex = 0
              Filtered = True
              MultiSelect = True
              ScrollBars = [sbHorizontal, sbVertical]
              SelectFullRow = True
              UserDefinedColorPalette.GeometryHoverColor = clBlack
              OnCellDblClick = NextGrid1CellDblClick
              OnEditEnter = NextGrid1EditEnter
              OnEditExit = NextGrid1EditExit
              FitOptions = [foColumn, foRow]
              object NxReportGridView61: TNxReportGridView6
                GridLines = True
              end
            end
          end
        end
      end
      object Button2: TButton
        Left = 3
        Top = 49
        Width = 157
        Height = 25
        Caption = 'Dec <-> Hex Convert'
        TabOrder = 4
        OnClick = Button2Click
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 8
    Top = 152
    object File1: TMenuItem
      Caption = 'File'
      object Close1: TMenuItem
        Caption = 'File Open'
        OnClick = Close1Click
      end
      object FileAppend1: TMenuItem
        Caption = 'File Append'
        OnClick = FileAppend1Click
      end
      object FileOpenFromExcel1: TMenuItem
        Caption = 'Open From Excel'
        OnClick = FileOpenFromExcel1Click
      end
      object OpenFromExcelofMap1: TMenuItem
        Caption = 'Open From Excel of Modbus RawData'
        Hint = 'HiMECS-DF-A2-NG AVAT Modbus Data'#47484' Excel'#47196' '#48512#53552' Grid'#47196' Loiad'#54632
        OnClick = OpenFromExcelofMap1Click
      end
      object OpenFromExcelofDFA2LM1: TMenuItem
        Caption = 'Open From Excel of DF-A2-LM'
        Hint = 'HiMECS-DF-A2-LM AVAT Modbus Data'#47484' Excel'#47196' '#48512#53552' Grid'#47196' Loiad'#54632
        OnClick = OpenFromExcelofDFA2LM1Click
      end
      object ConvertTagtoAddress1: TMenuItem
        Caption = 'Convert Tag to Address'
        OnClick = ConvertTagtoAddress1Click
      end
      object N10: TMenuItem
        Caption = '-'
      end
      object SaveToCSV1: TMenuItem
        Caption = 'Save To CSV'
        OnClick = SaveToCSV1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object SystemClose1: TMenuItem
        Caption = 'System Close'
      end
    end
    object Etc1: TMenuItem
      Caption = 'Etc'
      object ClearClipBoard1: TMenuItem
        Caption = 'Clear ClipBoard List'
        OnClick = ClearClipBoard1Click
      end
      object N13: TMenuItem
        Caption = '-'
      end
      object CopyFieldsFromGridIndex1: TMenuItem
        Caption = 'Copy Fields From Grid Index'
        Hint = #51077#47141#48155#51008' Index'#51004' Fields'#47484' '#49440#53469#46108' Fields'#50640' '#48373#49324#54632
        OnClick = CopyFieldsFromGridIndex1Click
      end
      object N14: TMenuItem
        Caption = '-'
      end
      object ResetCellColorFromLevelIndex1: TMenuItem
        Caption = 'Reset Cell Color From LevelIndex'
        OnClick = ResetCellColorFromLevelIndex1Click
      end
      object ResetCellColorFromLevelIndex2: TMenuItem
        Caption = 'Set Cell Color From LevelIndex'
        Hint = #49888#44508' '#52628#44032#51064' '#44221#50864' 1, Dummy Field'#47484' '#49688#51221#54620' '#44221#50864' 2,  '#44592#51316' '#51452#49548#51032' Filed'#44032' '#48320#44221' '#46104#50632#51012' '#44221#50864' 3'
        OnClick = ResetCellColorFromLevelIndex2Click
      end
      object SetCellColorFromAddress1: TMenuItem
        Caption = 'Set Cell Color From Address+FCode'
        Hint = 'Address'#50752' FCode'#47484' '#48708#44368#54616#50668' '#50724#47492#49692#52264' '#51064#51648' '#54869#51064#54632', '#50500#45768#47732' Cell Color '#48320#44221#54632
        OnClick = SetCellColorFromAddress1Click
      end
    end
    object ool1: TMenuItem
      Caption = 'Tool'
      object AdjustDummyFieldFromDBbyAddress1: TMenuItem
        Caption = 'Adjust Dummy Field From DB by Address'
        Hint = 
          #54788#51116' Load'#46108' data'#50752' '#51069#50612#50728' DB'#51032' Address'#47484' '#44592#51456#51004#47196' Desc'#47484' '#48708#44368#54616#50668'  FEngineParamter' +
          #51032' TagName'#51060' dummy'#51064' '#44221#50864#50640#47564' Update'#54632
        OnClick = AdjustDummyFieldFromDBbyAddress1Click
      end
      object CompareDescFromDBbyAddress1: TMenuItem
        Caption = 'Adjust Fields From DB by Address except dummy'
        Hint = 
          #54788#51116' Load'#46108' data'#50752' '#51069#50612#50728' DB'#51032' Address'#47484' '#44592#51456#51004#47196' Desc'#47484' '#48708#44368#54616#50668' '#52264#51060#51216#51012' FEnginePara' +
          'mter'#50640' Update'#54632
        OnClick = CompareDescFromDBbyAddress1Click
      end
      object AddDummy2Grid1: TMenuItem
        Caption = 'Add Dummy 2 Grid'
        Hint = #54788#51116' Load'#46108' Data'#51032' Address(10'#51652#49688')'#47484' '#48708#44368#54616#50668' Dummy'#47484' Grid'#50640' '#52628#44032#54632
        OnClick = AddDummy2Grid1Click
      end
      object SetParameterCatetorybyDersc1: TMenuItem
        Caption = 'Set ParameterCatetory by Desc'
        Hint = 'Description'#51012' '#54876#50857#54616#50668' ParameterCatetory '#49444#51221' '#48143' Grid'#50640' '#52628#44032
        OnClick = SetParameterCatetorybyDersc1Click
      end
      object N15: TMenuItem
        Caption = '-'
      end
      object UpdateFieldsFromDBMapDBModbusTagNameDescFieldUpdate1: TMenuItem
        Caption = 'Update Fields From DB'
        Hint = 
          #54788#51116' Open'#46108' '#51088#47308#47484' '#49440#53469#54620' '#44592#51316' DB'#50752' '#48708#44368#54616#50668' Modbus '#51452#49548#44032' '#44057#51008' '#44221#50864' TagName'#44284' Desc'#47484' '#51228#50808#54620 +
          ' '#45208#47672#51648' Field'#47484' Update'#54632
        OnClick = UpdateFieldsFromDBMapDBModbusTagNameDescFieldUpdate1Click
      end
      object CreateEPItemincfile1: TMenuItem
        Caption = 'Create EPItem.inc file'
        Hint = 
          'TEngineParameterItem.Assign'#50640#49436' '#49549#46020' '#54693#49345#51012' '#50948#54644' Code'#47484' '#51088#46041' '#49373#49457#54632'. MainUnit.p' +
          'as'#51032' EngParamTV'#50640#49436' '#44160#49353#54624#46412' '#50896#48376' EngParam'#51012' '#48373#49324#54624#46412' '#49324#50857#46120
        OnClick = CreateEPItemincfile1Click
      end
    end
  end
  object ImageList1: TImageList
    Left = 35
    Top = 191
    Bitmap = {
      494C0101150018002C0110001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000006000000001002000000000000060
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C0686000B0586000B0586000B0585000A05050009048
      5000904840008040400070384000703840000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B0A0900060483000604830006048
      30006048300060483000C0687000D0888000C06050005048400080808000E0D8
      D000B0B8B00050404000A0484000804040000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B0A09000FFFFFF00B0A09000B0A0
      9000B0A09000B0A09000C0707000E0909000D08880006050400070606000B0B0
      A000D0D0C00060585000A0484000804040000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B0A09000FFFFFF00FFFFFF00FFF8
      FF00F0F0F000F0E8E000C0788000E098A000E090900060504000605040006050
      40006050400060504000B0585000904850000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B0A09000FFFFFF00FFFFFF00F0E8
      F000A0A0A00070687000D0808000F0A0A000E098A000E0909000D0888000D078
      8000C0707000C0686000B0605000A05050000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B0A09000FFFFFF00F0F0F0009080
      7000A0803000B0582000D0889000F0A8B000D0787000D0606000C0585000B050
      4000B0402000B0483000C0686000A05050000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C0A89000FFFFFF0090909000E098
      400090B8100020B01000D0909000F0B0B000E0707000FFFFFF00FFF8F000F0E8
      E000E0D8D000B0504000C0707000B05850000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C0A8A000FFFFFF0070686000F0D0
      B00060E8400080C01000E098A000FFB8C000F0888000FFFFFF00FFFFFF00FFF8
      F000F0E8E000C0585000A0606000B05860000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C0B0A000FFFFFF0080808000D0E0
      D000A0E8A000F0B85000E0A0A000FFC0C000FF909000FFFFFF00FFFFFF00FFFF
      FF00FFF8F000D060600080404000B05860000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D0B0A000FFFFFF00E0E0E0006080
      6000C0E0B000D0D88000E0A8A000E0A0A000E098A000D0909000D0889000D080
      8000C0788000C0707000C0687000C06860000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D0B8A000FFFFFF00FFFFFF00D0D0
      D0007078700060805000C0C8C000F0F0F000B0A09000B0A09000604830000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D0B8B000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00B0A090006048300060483000604830000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D0C0B000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0A89000D0C8C00060483000D0B0A0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E0C0B000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0A8A00060483000D0B0A000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E0C0B000E0C0B000E0C0B000E0C0
      B000E0C0B000D0C0B000D0B8B000D0B0A000D0B0A00000000000000000000000
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
      0000000000000000000000000000000000007088900060809000607880005070
      8000506070004058600040485000303840002030300020203000101820001010
      1000101020000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007088900090A0B00070B0D0000090
      D0000090D0000090D0000090C0001088C0001080B0001080B0002078A0002070
      9000204860000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008088900080C0D00090A8B00080E0
      FF0060D0FF0050C8FF0050C8FF0040C0F00030B0F00030A8F00020A0E0001090
      D000206880002028300000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008090A00080D0F00090A8B00090C0
      D00070D8FF0060D0FF0060D0FF0050C8FF0050C0FF0040B8F00030B0F00030A8
      F0001088D0002048600000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008090A00080D8F00080C8E00090A8
      B00080E0FF0070D0FF0060D8FF0060D0FF0060D0FF0050C8FF0040C0F00040B8
      F00030B0F0002068800010486000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000008080800000000000000000000000
      0000000000000000000000000000000000008098A00090E0F00090E0FF0090A8
      B00090B8C00070D8FF0060D8FF0060D8FF0060D8FF0060D0FF0050D0FF0050C8
      FF0040B8F00030A0E00040607000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008098A00090E0F000A0E8FF0080C8
      E00090A8B00080E0FF0080E0FF0080E0FF0080E0FF0080E0FF0080E0FF0080E0
      FF0070D8FF0070D8FF0050A8D000506070000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000090A0A000A0E8F000A0E8FF00A0E8
      FF0090B0C00090B0C00090A8B00090A8B00080A0B00080A0B0008098A0008098
      A0008090A0008090A00080889000708890000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000090A0B000A0E8F000A0F0FF00A0E8
      FF00A0E8FF0080D8FF0060D8FF0060D8FF0060D8FF0060D8FF0060D8FF0060D8
      FF00708890000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000090A0B000A0F0F000B0F0F000A0F0
      FF00A0E8FF00A0E8FF0070D8FF0090A0A0008098A0008098A0008090A0008090
      9000708890000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000090A8B000A0D0E000B0F0F000B0F0
      F000A0F0FF00A0E8FF0090A0B000000000000000000000000000000000000000
      0000000000009068500090685000906850000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000090A8B00090A8B00090A8
      B00090A8B00090A8B00090A8B000000000000000000000000000000000000000
      0000000000000000000090685000906850000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000090786000000000000000
      000000000000A090800000000000907860000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A0908000A088
      8000B09880000000000000000000000000000000000000000000000000000000
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
      00000000000000000000000000000000000000000000C0C0C000C0686000B058
      5000A0505000A0505000A0505000904850009048400090484000804040008038
      4000803840007038400070383000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D0687000F0909000E080
      8000B048200040302000C0B8B000C0B8B000D0C0C000D0C8C00050505000A040
      3000A0403000A038300070384000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0A8A000B0806000B080
      6000A0786000A0705000A0684000905840009050300060483000000000006048
      3000000000006048300000000000000000000000000060483000000000006048
      300000000000C0A8A000B0806000B0806000A0786000A0705000A06840009058
      40009050300060483000000000000000000000000000D0707000FF98A000F088
      8000E0808000705850004040300090787000F0E0E000F0E8E00090807000A040
      3000A0404000A040300080384000000000000000000000000000000000000000
      0000000000000000000000000000A05830000000000000000000000000000000
      00000000000000000000000000000000000000000000C0A8A000FFF0F000D0C0
      B000D0C0B000D0C0B000D0B0A000C0A89000C0A8900060483000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0A8A000FFF0F000D0C0B000D0C0B000D0C0B000D0B0A000C0A8
      9000C0A8900060483000000000000000000000000000D0787000FFA0A000F090
      9000F0888000705850000000000040403000F0D8D000F0E0D00080786000B048
      4000B0484000A040400080404000000000000000000000000000000000000000
      00000000000000000000D0704000D05820009048200000000000000000000000
      00000000000000000000000000000000000000000000C0B0A000FFF0F000FFF0
      F000FFF0F00080000000F0D8D000F0C8B000C0A8900060483000000000000000
      0000000000006048300000000000000000000000000060483000000000000000
      000000000000C0B0A000FFF0F000FFF0F000FFF0F00080000000F0D8D000F0C8
      B000C0A8900060483000000000000000000000000000D0788000FFA8B000FFA0
      A000F0909000705850007058500070585000705850007060500080686000C058
      5000B0505000B048400080404000000000000000000000000000000000000000
      000000000000D0784000FF986000F0783000D058200090482000000000000000
      00000000000000000000000000000000000000000000D0B0A000FFF8F000FFF8
      F0008000000080000000FFE8E000F0D8D000C0A8900060483000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D0B0A000FFF8F000FFF8F000FFF0F0008000000080000000F0D8
      D000C0A8900060483000000000000000000000000000E0808000FFB0B000FFB0
      B000FFA0A000F0909000F0888000E0808000E0788000D0707000D0687000C060
      6000C0585000B050500090484000000000000000000000000000000000000000
      0000E0805000FFB89000FFA87000FF986000F0783000D0582000904820000000
      00000000000000000000000000000000000000000000D0B8A000FFF8F0008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000000000006048300000000000000000000000000060483000000000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000D0B8B00060483000000000000000000000000000E0889000FFB8C000FFB8
      B000D0606000C0605000C0585000C0504000B0503000B0483000A0402000A038
      1000C0606000C05850009048400000000000000000000000000000000000E088
      6000FFC0A000FFC0A000FFB89000FFA87000FF986000E0885000D07040009048
      20000000000000000000000000000000000000000000D0B0A000FFFFFF00FFFF
      FF008000000080000000FFF8F000FFF0F000D0B8B00060483000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D0B0A000FFFFFF00FFFFFF00FFF8F0008000000080000000FFF0
      F000D0B8B00060483000000000000000000000000000E0909000FFC0C000D068
      6000FFFFFF00FFFFFF00FFF8F000F0F0F000F0E8E000F0D8D000E0D0C000E0C8
      C000A0381000C060600090485000000000000000000000000000E0987000E098
      7000E0987000E0906000FFC0A000FFB89000FFA87000D0582000D0602000E068
      3000E068300000000000000000000000000000000000D0B8A000FFFFFF00FFFF
      FF00FFF8F00080000000FFF8F000FFF0F000D0B8B00060483000000000000000
      0000000000006048300000000000000000000000000060483000000000000000
      000000000000D0B8A000FFFFFF00FFFFFF00FFF8F00080000000FFF8F000FFF0
      F000D0B8B00060483000000000000000000000000000E098A000FFC0C000D070
      7000FFFFFF00FFFFFF00FFFFFF00FFF8F000F0F0F000F0E8E000F0D8D000E0D0
      C000A0402000D0686000A0505000000000000000000000000000000000000000
      000000000000F0A88000FFC0A000FFC0A000FFB89000E0703000000000000000
      00000000000000000000000000000000000000000000D0B0A000FFFFFF00FFFF
      FF00FFF8F000FFF8F000FFF8F000FFF0F000FFE8E00060483000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D0B0A000FFFFFF00FFFFFF00FFF8F000FFF8F000FFF8F000FFF0
      F000FFE8E00060483000000000000000000000000000F0A0A000FFC0C000E078
      7000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF8F000F0F0F000F0E8E000F0D8
      D000B0483000D0707000A0505000000000000000000000000000000000000000
      000000000000F0B09000E0A07000E0906000E0805000E0704000000000000000
      00000000000000000000000000000000000000000000C0B0A000C0B0A000C0B0
      A000C0B0A000C0B0A000C0B0A000C0A8A000C0A89000C0A8A000000000006048
      3000000000006048300000000000000000000000000060483000000000006048
      300000000000C0B0A000C0B0A000C0B0A000C0B0A000C0B0A000C0B0A000C0A8
      A000C0A89000C0A8A000000000000000000000000000F0A8A000FFC0C000E080
      8000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF8F000F0F0F000F0E8
      E000B0503000E0788000A0505000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F0B0B000FFC0C000F088
      9000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF8F000F0F0
      F000C050400060303000B0585000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F0B0B000FFC0C000FF90
      9000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF8
      F000C0585000B0586000B0586000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F0B8B000F0B8B000F0B0
      B000F0B0B000F0A8B000F0A0A000E098A000E0909000E0909000E0889000E080
      8000D0788000D0787000D0707000000000000000000000000000000000000000
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
      0000807060009078600090706000000000000000000000000000000000000000
      0000000000000000000000000000000000006048300060483000604830006048
      3000604830007058400080685000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A0807000A088
      7000D0B0A000D0B0A000C0B0A000B09880006048300000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFF8F000FFF8F000FFF0
      E000FFF0E000FFE8E00090786000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0988000E0C0B000D0C0
      B000E0D0C000F0E0E000FFF8F000B0988000A090800060483000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFF8FF00FFF8
      F000FFF0F000FFF0E000A0908000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D0785000C0704000B0684000B0604000A0583000000000000000
      00000000000000000000000000000000000000000000D0B0A000F0F0E000F0E8
      E000F0F0F000FFF8FF00FFF8F000FFFFFF00B0988000A0908000604830000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFF8F000FFF8F000B0A09000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D0785000F0703000F0703000F0703000A0583000000000000000
      00000000000000000000000000000000000000000000D0A89000FFF8FF00FFFF
      FF00FFFFFF00F0F0F000F0E8E000F0E0E000FFFFFF00B0988000A09080006048
      3000000000000000000000000000000000006048300060483000604830006048
      3000604830006048300060483000604830006048300070584000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000009080700090706000806850006048300060483000000000000000
      0000000000000000000000000000000000000000000000000000E0885000D080
      5000D0785000D0785000FF804000F0703000F0703000A0583000A05030009050
      3000904820000000000000000000000000000000000000000000D0A89000FFFF
      FF00FFFFFF00FFF8FF00F0F0F000F0E8E000F0E0E000FFFFFF00B0988000A090
      800060483000000000000000000000000000F0C0A000F0B89000F0A88000F0A0
      7000F0987000F0906000F0885000F0885000F088500080605000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000090807000E0906000E0703000E068300060483000000000000000
      000000000000000000000000000000000000000000000000000000000000E088
      6000FFC0A000FF987000FF885000FF804000F0703000F0682000F0682000D068
      300000000000000000000000000000000000000000000000000000000000D0A8
      9000FFFFFF00FFFFFF00FFF8FF00F0F0F000F0E8E000F0E0E000FFFFFF00B098
      8000A0908000604830000000000000000000FFE0D000FFD8C000FFC8B000F0C0
      A000F0B8A000F0B09000F0A88000F0A07000F088500080706000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000090807000F0A07000F0906000E070400060483000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E0886000FFC0A000FFB08000FFA07000F0885000F0703000D06030000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D0A89000FFFFFF00FFFFFF00FFF8FF00F0F0F000F0E8E000F0E0E000FFFF
      FF00B0988000806050000000000000000000FFF0F000FFE8E000FFE0D000FFD8
      C000FFD0C000F0C8B000F0C0A000F0B09000F0A88000A0908000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000090807000F0B09000F0A08000E080500060483000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000E0886000FFC0A000FFB09000FFA06000D0683000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D0A89000FFFFFF00FFFFFF00FFF8FF00F0F0F000F0E8E000F0E0
      E000FFFFFF00A08070000000000000000000B0A09000B0A09000B0A09000B098
      9000A0989000A0989000A0908000A0908000A0908000A0908000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000090888000F0B8A000F0B09000E090600060483000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000E0885000FFC0A000E070400000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000D0A89000FFFFFF00FFFFFF00FFF8FF00FFF0F000FFF8
      FF00E0D0C000B09080000000000000000000FFFFFF00FFF8F000FFF0F000FFF0
      E000FFE8E000FFE8E000A0807000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B0A09000907060007058
      400060483000A0888000FFC8B000F0C0A000E0A0800060483000907060008068
      5000705840006048300000000000000000000000000000000000000000000000
      0000000000000000000000000000E08850000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000D0A89000FFFFFF00FFFFFF00FFF8FF00E0D0
      D000B0887000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFF8
      F000FFF0F000FFF0E000B0989000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B0A09000FFFFFF00C0C0
      C000C0C0C000A0909000FFD0C000FFC8B000F0A8900060483000FFFFFF00C0C0
      C000C0C0C0006048300000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D0A89000C0A09000B0907000B090
      800000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFF8F000B0908000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0A8A000FFFFFF00FFFF
      FF00C0C0C000A0989000FFD8C000FFD0C000F0B8A00060483000FFFFFF00FFFF
      FF00C0C0C0006048300000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C0B8B000C0B0A000C0B0A000C0B0
      A000C0A8A000C0A8A000B0A09000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0B8B000FFFFFF00FFFF
      FF00FFFFFF00B0A0A000FFD8D000FFD8C000FFD0C00060483000FFFFFF00FFFF
      FF00FFFFFF006048300000000000000000000000000000000000000000000000
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
      00000000000000000000000000000000000000000000A0887000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000604830000000000000000000A0887000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000060483000000000006048300060483000604830006048
      3000604830006048300000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000070605000F0906000E0805000E070400060483000000000000000
      000000000000000000000000000000000000B0A09000A0887000806050006048
      3000604830006048300060483000604830006048300060483000604830006048
      300060483000604830006048300060483000B0A09000A0887000806050006048
      3000604830006048300060483000604830006048300060483000604830006048
      300060483000604830006048300060483000FFF8F000FFF8F000FFF0E000FFF0
      E000FFE8E0008060500000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000080706000F0A89000E0906000E080500060483000000000000000
      00000000000000000000000000000000000000000000B0A09000FFF8F000F0D8
      D000E0D8D000E0D0C000E0C8C000E0C8C000E0C0B000E0B8B000E0B8A000D0B0
      A000D0A89000D0A89000604830000000000000000000B0A09000FFF8F000F0D8
      D000E0D8D000E0D0C000E0C8C000E0C8C000E0C0B000E0B8B000E0B8A000D0B0
      A000D0A89000D0A890006048300000000000FFFFFF00FFF8FF00FFF8F000FFF0
      F000FFF0E0009078600000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000090887000F0C8B000F0A88000E090600060504000000000000000
      00000000000000000000000000000000000000000000B0A09000FFFFFF00FFF8
      F000FFF0F000F0F0E000F0E8E000F0E0E000F0E0D000F0D8D000F0D0C000F0D0
      C000E0C8C000D0B0A000604830000000000000000000B0A09000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D0B0A0006048300000000000FFFFFF00FFFFFF00FFFFFF00FFF8
      F000FFF8F000A090800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A0989000FFD8C000F0C0A000F0A8800070504000000000000000
      00000000000000000000000000000000000000000000B0A09000FFFFFF00FFF8
      FF00FFF8F000FFF0F000F0F0F000F0E8E000F0E0E000F0E0D000F0D8D000F0D8
      C000F0D0C000E0B8A000604830000000000000000000B0A09000FFFFFF00FFF8
      FF00FFF8F000FFF0F000F0F0F000F0E8E000F0E0E000F0E0D000F0D8D000F0D8
      C000F0D0C000E0B8A0006048300000000000D0C0B000C0B8B000C0B0A000C0A8
      A000B0A09000A090800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A0989000FFE0D000FFD0C000F0C0A00080605000000000000000
      00000000000000000000000000000000000000000000B0A09000FFFFFF00FFFF
      FF00FFF8FF00FFF8F000FFF0F000F0F0F000F0E8E000F0E8E000F0E0D000F0D8
      D000F0D8D000E0C0B000604830000000000000000000B0A09000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000E0C0B00060483000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000807060006048
      3000604830006048300060483000604830000000000000000000000000000000
      000000000000B0989000A0989000A08880009078700080706000000000000000
      00000000000000000000000000000000000000000000C0A89000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000E0C8C000604830000000000000000000C0A89000FFFFFF00FFFF
      FF00FFFFFF00FFF8FF00FFF8F000FFF0F000F0F0F000F0E8E000F0E8E000F0E0
      D000F0D8D000E0C8C00060483000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000090807000F0C0
      A000F0B09000F0987000F0885000E07840000000000000000000000000000000
      0000000000000000000000000000100810000000000000000000000000000000
      00000000000000000000000000000000000000000000C0A8A000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFF8FF00FFF8F000FFF8F000FFF0F000F0E8E000F0E8
      E000F0E0D000E0D0C000604830000000000000000000C0A8A000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFF8FF00FFF8F000FFF8F000FFF0F000F0E8E000F0E8
      E000F0E0D000E0D0C00060483000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A0908000FFD8
      C000FFD0B000F0C0A000F0A88000F09060000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0A8A000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F0D8D000604830000000000000000000C0A8A000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF8F000FFF8F000FFF0F000F0E8
      E000F0E8E000F0D8D00060483000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B0989000FFE8
      E000FFE0D000FFD8C000F0C8B000F0B8A0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0B0A000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF8FF00FFF8F000FFF0
      F000F0F0E000F0E0D000604830000000000000000000C0B0A000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF8FF00FFF8F000FFF0
      F000F0F0E000F0E0D00060483000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B0989000B098
      9000A09080009088800080706000807060000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D0B0A000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF8FF00FFF8
      F000FFF0F000F0E8E000604830000000000000000000D0B0A000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF8FF00FFF8
      F000FFF0F000F0E8E00060483000000000006048300060483000604830006048
      3000604830006048300000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D0B8A000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF8
      FF00FFF8F000F0E8E000705850000000000000000000D0B8A000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF8
      FF00FFF8F000F0E8E0007058500000000000FFF8F000FFF8F000FFF0E000FFF0
      E000FFE8E0008068500000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B0A09000907060007058
      40006048300060483000000000000000000000000000B0A09000907060008068
      50007058400060483000000000000000000000000000D0B0A000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00907860000000000000000000D0B0A000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF009078600000000000FFFFFF00FFF8FF00FFF8F000FFF0
      F000FFF0E0009078700000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B0A09000FFF8F000FFF0
      E000FFE0D00060483000000000000000000000000000C0B0A000FFF8F000FFF0
      E000FFE0D000604830000000000000000000D0B0A000D0B0A000D0B8A000D0B8
      A000D0B0A000C0B0A000C0B0A000C0B0A000C0B0A000C0A8A000C0A8A000C0A8
      9000C0A89000B0A09000A090800090786000D0B0A000D0B0A000D0B8A000D0B8
      A000D0B0A000C0B0A000C0B0A000C0B0A000C0B0A000C0A8A000C0A8A000C0A8
      9000C0A89000B0A09000A090800090786000FFFFFF00FFFFFF00FFFFFF00FFF8
      F000FFF8F000A090800000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0A8A000FFFFFF00FFF8
      FF00FFF0E00060483000000000000000000000000000D0C0C000FFFFFF00FFF8
      FF00FFF0E00060483000000000000000000000000000D0B0A000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000B0A090000000000000000000D0B0A000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000B0A0900000000000D0B8B000C0B0A000C0A8A000C0A8
      A000B0A09000B090800000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0B8B000FFFFFF00FFFF
      FF00FFF8FF0060483000000000000000000000000000D0C8C000FFFFFF00FFFF
      FF00FFF8FF006048300000000000000000000000000000000000000000000000
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
      00000000000000000000000000000000000000000000A0887000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000060483000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B0A09000A0887000806050006048
      3000604830006048300060483000604830006048300060483000604830006048
      3000604830006048300060483000604830000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B0A09000F0D8D000F0D8
      D000E0D0C000E0C8C000E0C0B000E0C0B000E0B8A000D0B0A000D0A8A000D0A8
      9000D0A08000D098800060483000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B0A09000FFF8F000FFF0
      F000F0F0F000F0E8E000F0E0E000F0E0D000F0D8D000F0D0C000E0C8C000E0C8
      C000E0C8B000D0A0900060483000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B0A09000FFFFFF00FFF8
      F000FFF8F000F0F0F000F0E8E000F0E0E000F0E0D000F0D8D000F0D0C000E0D0
      C000E0C8C000D0A8900060483000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B0A09000FFFFFF00FFFF
      FF00FFF8FF00FFF8F000FFF0F000F0E8E000F0E8E000F0E0D000F0D8D000F0D0
      C000E0D0C000D0B0A00060483000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0A89000FFFFFF00FFFF
      FF00FFFFFF00FFF8FF00FFF8F000FFF0F000F0E8E000F0E8E000F0E0D000F0D8
      D000F0D8D000E0C0B00060483000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0A8A000FFFFFF00FFFF
      FF00FFFFFF00FFF8FF00FFF8F000FFF0F000F0E8E000F0E8E000F0E8E000F0E0
      E000F0D8D000E0C8C00060483000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0A8A000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF8F000FFF0F000F0F0F000F0E8
      E000F0E0E000E0D0C00060483000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0B0A000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F0D8D00060483000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D0B0A000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFF8FF00FFF8
      F000FFF0F000F0E0E00060483000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D0B8A000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F0E0E00070585000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D0B0A000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0090786000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D0B0A000D0B0A000D0B8A000D0B8
      A000D0B0A000C0B0A000C0B0A000C0B0A000C0B0A000C0A8A000C0A8A000C0A8
      9000C0A89000B0A09000A0908000907860000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D0B0A000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000B0A0900000000000424D3E000000000000003E000000
      2800000040000000600000000100010000000000000300000000000000000000
      000000000000000000000000FFFFFF00FFFF000000000000FC00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000001F000000000000001F000000000000001F000000000000
      003F000000000000007F000000000000FFFFFFFFFFFFFFFF0007FFFFFFFFFFFF
      0007FFFFFFFFE00F0003FFFFFFFFFFFF0003E01FE07FF83F0001F18FF8FFF11F
      0001F18FF8FFF39F0000F18FFC7FF39F0000F01FFC7FF39F0007F18FFE3FF39F
      0007F18FFE3FF39F01F8F18FFF1FF39F81FCE01FFE0FE10FFFBAFFFFFFFFFFFF
      FFC7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8001
      FFFFFFFFFFFF8001FFFF802BA8038001FEFF803FF8038001FC7F803BB8038001
      F83F803FF8038001F01F800BA0038001E00F803FF8038001C007803BB8038001
      F83F803FF8038001F83F802BA8038001FFFFFFFFFFFF8001FFFFFFFFFFFF8001
      FFFFFFFFFFFF8001FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFF
      F00101FFFC7FFFFFC07F01FFFEFFFFFF803F01FFFEFFF83F801F01FFFEFFF83F
      800F003FF83FC007C007003BF83FE00FE0030001F83FF01FF003003BF83FF83F
      F803003FF83FFC7FFC0301FF8003FEFFFE0701FF8003FFFFFF0F01FF8003FFFF
      FFFF01FF8003FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFFDBFFD03FFF83F
      0000000003FFF83F8001800103FFF83F8001800103FFF83F8001800103FFF83F
      80018001FFC0F83F80018001FEC0FEFF80018001FC00FEFF80018001FEC0FC7F
      80018001FFC0FEFF8001800103FFFFFF8001800103FF83838001800103FF8383
      0000000003FF8383BFFDBFFD03FF8383FFFFFFFFFFFFFFFFFFFFFFFFFFFFBFFD
      FFFFFFFFFFFF0000003FC00FF0038001FFFFFFFFFFFF80010003000300038001
      FFFFFFFFFFFF8001003FC00FF0038001FFFFFFFFFFFF80010003000300038001
      FFFFFFFFFFFF8001003FC00FF0038001FFFFFFFFFFFF80010003000300038001
      FFFFFFFFFFFF0000FFFFFFFFFFFFBFFD00000000000000000000000000000000
      000000000000}
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Engine Parameter|*.param|All Files|*.*'
    Left = 40
    Top = 152
  end
  object SaveDialog1: TSaveDialog
    Left = 112
    Top = 152
  end
  object SaveDialog2: TSaveDialog
    Left = 160
    Top = 152
  end
  object PopupMenu1: TPopupMenu
    Left = 200
    Top = 152
    object Properties1: TMenuItem
      Caption = 'Properties'
      OnClick = Properties1Click
    end
    object N12: TMenuItem
      Caption = '-'
    end
    object N2: TMenuItem
      Caption = #52395#48264#51704' '#51460#51032' '#54788#51116#50676' '#44050' '#47784#46160' '#44057#44172
      OnClick = N2Click
    end
    object N3: TMenuItem
      Caption = #49440#53469#54620' '#51460#51032' '#54788#51116#50676' '#44050' '#50500#47000#47196' '#44057#44172' '
      OnClick = N3Click
    end
    object CopyRow1: TMenuItem
      Caption = 'Copy Row'
      OnClick = CopyRow1Click
    end
    object N11: TMenuItem
      Caption = #49440#53469#54620' '#51460#51032' '#54788#51116#50676' '#44050' '#50500#47000#47196' 1'#50473' '#51613#44032
      OnClick = N11Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object EditMatrixData1: TMenuItem
      Caption = 'Edit Matrix Data'
      OnClick = EditMatrixData1Click
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object CopyFieldsFromTagName1: TMenuItem
      Caption = 'Copy Fields From Grid Index'
      Hint = #51077#47141#48155#51008' Index'#51004' Fields'#47484' '#49440#53469#46108' Fields'#50640' '#48373#49324#54632
      Visible = False
      OnClick = CopyFieldsFromTagName1Click
    end
    object SetAlarmEnable1: TMenuItem
      Caption = 'Set AlarmEnable'
      OnClick = SetAlarmEnable1Click
    end
    object SetAlarmDisable1: TMenuItem
      Caption = 'Set AlarmDisable'
      OnClick = SetAlarmDisable1Click
    end
    object SetContacttoA1: TMenuItem
      Caption = 'Set Contact to A'
      OnClick = SetContacttoA1Click
    end
    object SetContacttoB1: TMenuItem
      Caption = 'Set Contact to B'
      OnClick = SetContacttoB1Click
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object agNameCalculated1: TMenuItem
      Caption = 'TagName Calculated'
      OnClick = agNameCalculated1Click
    end
    object SetFormula1: TMenuItem
      Caption = 'Set Formula'
      object N7: TMenuItem
        Caption = ' + '
        OnClick = N7Click
      end
      object N8: TMenuItem
        Caption = ' - '
        OnClick = N8Click
      end
      object N9: TMenuItem
        Caption = ' * '
        OnClick = N9Click
      end
    end
  end
  object EngParamSource: TDropTextSource
    DragTypes = [dtCopy]
    Left = 16
    Top = 213
  end
end
