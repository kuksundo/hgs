object frmOptions: TfrmOptions
  Left = 344
  Top = 248
  HelpContext = 100
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsSingle
  Caption = 'ABC-View General Options'
  ClientHeight = 509
  ClientWidth = 773
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000001000000080000000010000080000000000
    1000800000000000010800000000000000800000000000000801000000000000
    8000100003000000000001000330000000000003300000000000003330000000
    000000333000000000003300000000000000000000000000000000000000FFFF
    00009FCF00008F8F0000C71F0000E23F0000F07F0000F8FF0000F07B00000231
    00000700000067810000E7830000C7030000FC070000FE1F0000FFFF0000}
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object OKBtn: TBitBtn
    Left = 600
    Top = 480
    Width = 75
    Height = 25
    TabOrder = 0
    Kind = bkOK
  end
  object CancelBtn: TBitBtn
    Left = 688
    Top = 480
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkCancel
  end
  object pcOptions: TPageControl
    Left = 16
    Top = 16
    Width = 745
    Height = 457
    ActivePage = tsFields
    Images = dmActions.ilMenu
    TabOrder = 2
    object tsBrowser: TTabSheet
      HelpContext = 105
      Caption = 'Browser'
      ImageIndex = 16
      object GroupBox7: TGroupBox
        Left = 456
        Top = 272
        Width = 273
        Height = 145
        HelpContext = 185
        Caption = 'Auto refresh'
        TabOrder = 3
        object chbEnableRefresh: TCheckBox
          Left = 8
          Top = 24
          Width = 257
          Height = 17
          Caption = 'Enable auto refresh (show updates in live folders)'
          TabOrder = 0
          OnClick = OptionsChanged
        end
        object chbFocusNew: TCheckBox
          Left = 8
          Top = 48
          Width = 137
          Height = 17
          Caption = 'Focus on new items'
          TabOrder = 1
          OnClick = OptionsChanged
        end
      end
      object GroupBox8: TGroupBox
        Left = 8
        Top = 24
        Width = 441
        Height = 241
        HelpContext = 165
        Caption = 'Background processes'
        TabOrder = 0
        object Label4: TLabel
          Left = 176
          Top = 26
          Width = 15
          Height = 13
          Caption = 'Mb'
        end
        object Bevel1: TBevel
          Left = 8
          Top = 112
          Width = 417
          Height = 2
        end
        object Label7: TLabel
          Left = 8
          Top = 116
          Width = 422
          Height = 37
          AutoSize = False
          Caption = 
            'Selecting these settings will allow faster operation of your col' +
            'lection, but the processes will slow down usage during the time ' +
            'they run initially:'
          WordWrap = True
        end
        object Label10: TLabel
          Left = 8
          Top = 26
          Width = 85
          Height = 13
          Caption = 'Thumbnail cache:'
        end
        object Label11: TLabel
          Left = 8
          Top = 50
          Width = 78
          Height = 13
          Caption = 'Graphics cache:'
        end
        object Label12: TLabel
          Left = 176
          Top = 50
          Width = 15
          Height = 13
          Caption = 'Mb'
        end
        object Label13: TLabel
          Left = 8
          Top = 72
          Width = 79
          Height = 13
          Caption = 'Decode threads:'
        end
        object Label14: TLabel
          Left = 184
          Top = 72
          Width = 34
          Height = 13
          Caption = 'Priority:'
        end
        object chbAutoCrc: TCheckBox
          Left = 8
          Top = 168
          Width = 425
          Height = 17
          Caption = 'Pre-calculate CRC value for new files (detect duplicate files)'
          TabOrder = 5
          OnClick = OptionsChanged
        end
        object chbAutoPixRef: TCheckBox
          Left = 8
          Top = 216
          Width = 425
          Height = 17
          Caption = 
            'Pre-calculate image metrics for new files (detect similar images' +
            ')'
          TabOrder = 6
          OnClick = OptionsChanged
        end
        object cbbPriority: TComboBox
          Left = 224
          Top = 70
          Width = 97
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 3
          OnChange = OptionsChanged
          Items.Strings = (
            'Run when Idle'
            'Lowest'
            'Lower'
            'Normal'
            'Higher')
        end
        object chbAutoThumb: TCheckBox
          Left = 8
          Top = 144
          Width = 425
          Height = 17
          Caption = 'Pre-load thumbnails'
          Checked = True
          State = cbChecked
          TabOrder = 4
          OnClick = OptionsChanged
        end
        object sedDecodeThreads: TSpinEdit
          Left = 112
          Top = 70
          Width = 57
          Height = 22
          MaxValue = 4
          MinValue = 1
          TabOrder = 2
          Value = 1
          OnChange = OptionsChanged
        end
        object sedThumbnailCache: TSpinEdit
          Left = 112
          Top = 20
          Width = 57
          Height = 22
          Increment = 5
          MaxValue = 500
          MinValue = 5
          TabOrder = 0
          Value = 60
          OnChange = OptionsChanged
        end
        object sedGraphicsCache: TSpinEdit
          Left = 112
          Top = 45
          Width = 57
          Height = 22
          Increment = 5
          MaxValue = 500
          MinValue = 5
          TabOrder = 1
          Value = 40
          OnChange = OptionsChanged
        end
        object chbAutoSCrc: TCheckBox
          Left = 8
          Top = 192
          Width = 425
          Height = 17
          Caption = 
            'Pre-calculate special value for truncated files (detect truncate' +
            'd files)'
          TabOrder = 7
          OnClick = OptionsChanged
        end
      end
      object GroupBox10: TGroupBox
        Left = 8
        Top = 272
        Width = 441
        Height = 145
        HelpContext = 170
        Caption = 'Background'
        TabOrder = 2
        object Label6: TLabel
          Left = 296
          Top = 16
          Width = 43
          Height = 13
          Caption = 'Example:'
        end
        object pbMainBgr: TPaintBox
          Left = 80
          Top = 22
          Width = 65
          Height = 19
          OnPaint = pbMainBgrPaint
        end
        object Label25: TLabel
          Left = 8
          Top = 24
          Width = 27
          Height = 13
          Caption = 'Color:'
        end
        object SpeedButton1: TSpeedButton
          Left = 48
          Top = 19
          Width = 23
          Height = 22
          Action = BgrColor
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            2000000000000004000000000000000000000000000000000000FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000000
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000000000000000000000000000FF00FF00FF00FF00FF00FF000000
            000000FF000000FF000000FF000000000000FFFF0000FFFF0000FFFF00000000
            0000FF00FF00FF00FF00FF00FF0000000000FF00FF00FF00FF00FF00FF000000
            000000FF000000FF000000FF000000000000FFFF0000FFFF0000FFFF00000000
            0000FF00FF00FF00FF00FF00FF0000000000FF00FF00FF00FF00FF00FF000000
            000000FF000000FF000000FF000000000000FFFF0000FFFF0000FFFF00000000
            0000FF00FF00FF00FF00FF00FF0000000000FF00FF00FF00FF00FF00FF000000
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000000000000000000000000000FF00FF00FF00FF00FF00FF000000
            000080808000808080008080800000000000FFFFFF00FFFFFF00FFFFFF000000
            000000000000000000000000000000000000FF00FF00FF00FF00FF00FF000000
            000080808000808080008080800000000000FFFFFF00FFFFFF00FFFFFF000000
            000000000000000000000000000000000000FF00FF00FF00FF00FF00FF000000
            000080808000808080008080800000000000FFFFFF00FFFFFF00FFFFFF000000
            000000000000000000000000000000000000FF00FF00FF00FF00FF00FF000000
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000000000000000000000000000FF00FF00FF00FF00FF00FF000000
            00000000FF000000FF000000FF000000000000FFFF0000FFFF0000FFFF000000
            0000FF000000FF000000FF00000000000000FF00FF00FF00FF00FF00FF000000
            00000000FF000000FF000000FF000000000000FFFF0000FFFF0000FFFF000000
            0000FF000000FF000000FF00000000000000FF00FF00FF00FF00FF00FF000000
            00000000FF000000FF000000FF000000000000FFFF0000FFFF0000FFFF000000
            0000FF000000FF000000FF00000000000000FF00FF00FF00FF00FF00FF000000
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
        end
        object Label27: TLabel
          Left = 8
          Top = 53
          Width = 24
          Height = 13
          Caption = 'Font:'
        end
        object SpeedButton2: TSpeedButton
          Left = 48
          Top = 48
          Width = 23
          Height = 22
          Action = BrgFont
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            2000000000000004000000000000000000000000000000000000FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00000000000000
            0000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00800000008000
            0000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00800000008000
            0000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF0000000000FF00FF00FF00FF00FF00FF00800000008000
            000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF0000008000FF00FF00FF00FF00FF00FF00800000008000
            000080000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF0000008000FF00FF00FF00FF00FF00FF00800000008000
            0000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00000080000000000000000000FF00FF00800000008000
            00000000000000000000FF00FF00FF00FF000000000000000000FF00FF00FF00
            FF00FF00FF00FF00FF00000080000000800000008000FF00FF00800000008000
            00008000000080000000FF00FF00FF00FF00800080008000800000000000FF00
            FF00FF00FF00FF00FF0000008000FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0080008000FF00
            FF00FF00FF00FF00FF0000008000000000000000000000000000FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0080008000FF00
            FF00FF00FF00FF00FF0000008000000080000000800000008000FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000800080000000
            0000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0080008000800080008000
            8000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0080008000FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00800080000000
            000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF008000
            800080008000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
        end
        object lblFontName: TLabel
          Left = 80
          Top = 53
          Width = 47
          Height = 13
          Caption = 'Fontname'
        end
        object Panel2: TPanel
          Left = 296
          Top = 32
          Width = 121
          Height = 97
          BevelOuter = bvLowered
          BevelWidth = 2
          TabOrder = 2
          object imMainBgr: TImage
            Left = 2
            Top = 2
            Width = 117
            Height = 93
            Align = alClient
          end
          object lblFont: TLabel
            Left = 8
            Top = 8
            Width = 35
            Height = 16
            Caption = 'Files'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = True
          end
        end
        object feBgrFile: TFilenameEdit
          Left = 8
          Top = 104
          Width = 273
          Height = 21
          OnBeforeDialog = feBgrFileBeforeDialog
          NumGlyphs = 1
          TabOrder = 1
          OnChange = feBgrFileChange
        end
        object chbBgrFile: TCheckBox
          Left = 8
          Top = 87
          Width = 273
          Height = 17
          Caption = 'Use background image:'
          TabOrder = 0
          OnClick = chbBgrFileClick
        end
        object chbOverrideListviewBgr: TCheckBox
          Left = 150
          Top = 22
          Width = 139
          Height = 17
          Caption = 'Override listview backgr.'
          TabOrder = 3
        end
      end
      object GroupBox13: TGroupBox
        Left = 456
        Top = 24
        Width = 273
        Height = 137
        HelpContext = 175
        Caption = 'General Preferences'
        TabOrder = 1
        object chbShowInfotip: TCheckBox
          Left = 8
          Top = 24
          Width = 97
          Height = 17
          Caption = 'Show infotips'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = OptionsChanged
        end
        object chbSortTypeWithExt: TCheckBox
          Left = 8
          Top = 96
          Width = 257
          Height = 17
          Caption = 'Use &Extension when sorting on file type'
          Checked = True
          State = cbChecked
          TabOrder = 3
          OnClick = OptionsChanged
        end
        object chbUpdateFromBgr: TCheckBox
          Left = 8
          Top = 48
          Width = 257
          Height = 17
          Caption = 'Background process causes updates'
          TabOrder = 1
          OnClick = OptionsChanged
        end
        object chbAutoVerify: TCheckBox
          Left = 8
          Top = 72
          Width = 249
          Height = 17
          Caption = 'Verify file existance automatically'
          Checked = True
          State = cbChecked
          TabOrder = 2
          OnClick = OptionsChanged
        end
      end
      object GroupBox25: TGroupBox
        Left = 456
        Top = 168
        Width = 273
        Height = 97
        HelpContext = 180
        Caption = 'Color Grouping'
        TabOrder = 4
        object rbNoGrouping: TRadioButton
          Left = 8
          Top = 24
          Width = 250
          Height = 17
          Caption = 'No color grouping'
          TabOrder = 0
        end
        object rbLightColors: TRadioButton
          Left = 8
          Top = 48
          Width = 250
          Height = 17
          Caption = 'Pastel color scheme (light)'
          TabOrder = 1
        end
        object rbDarkColors: TRadioButton
          Left = 8
          Top = 72
          Width = 250
          Height = 17
          Caption = 'Gloom color scheme (dark)'
          TabOrder = 2
        end
      end
    end
    object tsFields: TTabSheet
      HelpContext = 110
      Caption = 'Fields'
      ImageIndex = 15
      object GroupBox16: TGroupBox
        Left = 8
        Top = 24
        Width = 153
        Height = 185
        Caption = 'Standard File Fields'
        TabOrder = 0
        object clbFileFields: TRxCheckListBox
          Left = 16
          Top = 24
          Width = 121
          Height = 145
          CheckKind = ckCheckMarks
          ItemHeight = 13
          TabOrder = 0
          OnClick = clbFileFieldsClick
          InternalVersion = 202
          Strings = (
            'Name'
            1
            True
            'Size'
            1
            True
            'Type'
            1
            True
            'Modified'
            1
            True
            'Flags'
            1
            True
            'Folder'
            1
            True
            'Status'
            1
            True
            'Series'
            0
            True
            'Rating'
            0
            True
            'Groups'
            0
            True
            'CRC32'
            0
            True
            'Dimensions'
            1
            True
            'Compression'
            0
            True
            'Original Name'
            0
            True
            'Description'
            1
            True
            'Band'
            0
            True)
        end
      end
      object GroupBox17: TGroupBox
        Left = 8
        Top = 224
        Width = 497
        Height = 153
        Caption = 'Custom File Fields'
        TabOrder = 1
        Visible = False
        object Label15: TLabel
          Left = 288
          Top = 24
          Width = 56
          Height = 13
          Caption = 'Field Name:'
        end
        object Label16: TLabel
          Left = 288
          Top = 72
          Width = 67
          Height = 13
          Caption = 'Default Value:'
        end
        object RxCheckListBox2: TRxCheckListBox
          Left = 16
          Top = 24
          Width = 121
          Height = 113
          CheckKind = ckCheckMarks
          ItemHeight = 13
          TabOrder = 0
          InternalVersion = 202
        end
        object btnDelete: TButton
          Left = 144
          Top = 104
          Width = 129
          Height = 25
          Caption = 'Delete'
          Enabled = False
          TabOrder = 1
        end
        object btnAdd: TButton
          Left = 144
          Top = 40
          Width = 129
          Height = 25
          Caption = 'Add a Field'
          TabOrder = 2
        end
        object btnModify: TButton
          Left = 144
          Top = 72
          Width = 129
          Height = 25
          Caption = 'Modify'
          TabOrder = 3
        end
        object edFieldName: TEdit
          Left = 288
          Top = 40
          Width = 169
          Height = 21
          TabOrder = 4
          Text = 'FieldName1'
        end
        object edDefaultValue: TEdit
          Left = 288
          Top = 88
          Width = 169
          Height = 21
          TabOrder = 5
        end
        object chbSearchable: TCheckBox
          Left = 288
          Top = 120
          Width = 97
          Height = 17
          Caption = 'Searchable'
          TabOrder = 6
        end
      end
      object GroupBox19: TGroupBox
        Left = 168
        Top = 24
        Width = 153
        Height = 185
        Caption = 'Standard Folder Fields'
        TabOrder = 2
        object clbFolderFields: TRxCheckListBox
          Left = 16
          Top = 24
          Width = 121
          Height = 145
          CheckKind = ckCheckMarks
          ItemHeight = 13
          TabOrder = 0
          OnClick = clbFileFieldsClick
          InternalVersion = 202
          Strings = (
            'Name'
            1
            True
            'Path'
            1
            True
            'Type'
            1
            True
            'Modified'
            1
            True
            'Volumelabel'
            1
            True
            'Status'
            1
            True
            '# Files'
            1
            True
            'Total Size'
            1
            True
            'Attributes'
            1
            True
            'Filter'
            1
            True
            'Protection'
            1
            True)
        end
      end
    end
    object tsViewer: TTabSheet
      HelpContext = 115
      Caption = 'Viewer'
      ImageIndex = 10
      object GroupBox2: TGroupBox
        Left = 8
        Top = 24
        Width = 353
        Height = 97
        HelpContext = 195
        Caption = 'Windowed Mode'
        TabOrder = 0
        object chbWinShowToolbars: TCheckBox
          Left = 8
          Top = 24
          Width = 329
          Height = 17
          Caption = 'Show toolbars'
          TabOrder = 0
          OnClick = OptionsChanged
        end
        object chbWinShrinkFit: TCheckBox
          Left = 8
          Top = 48
          Width = 329
          Height = 17
          Caption = 'Shrink to fit window'
          TabOrder = 1
        end
        object chbWinGrowFit: TCheckBox
          Left = 8
          Top = 72
          Width = 329
          Height = 17
          Caption = 'Enlarge to fit window'
          TabOrder = 2
        end
      end
      object GroupBox5: TGroupBox
        Left = 8
        Top = 192
        Width = 441
        Height = 73
        HelpContext = 200
        Caption = 'Resampling'
        TabOrder = 2
        object Label9: TLabel
          Left = 8
          Top = 28
          Width = 25
          Height = 13
          Caption = 'Filter:'
        end
        object lblResampling: TLabel
          Left = 208
          Top = 52
          Width = 67
          Height = 13
          Caption = 'Delay: 300 ms'
        end
        object cbbResamplingFilter: TComboBox
          Left = 56
          Top = 24
          Width = 145
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
          OnChange = OptionsChanged
          Items.Strings = (
            'Box'
            'Triangle'
            'Hermite'
            'Bell'
            'Spline'
            'Lanczos III'
            'Mitchell')
        end
        object chbResamplingOnTheFly: TCheckBox
          Left = 8
          Top = 50
          Width = 193
          Height = 17
          Caption = 'Adjust images on the fly'
          TabOrder = 1
          OnClick = chbResamplingOnTheFlyClick
        end
        object rxsResampling: TRxSlider
          Left = 287
          Top = 45
          Width = 145
          Height = 24
          Increment = 100
          MaxValue = 2000
          TabOrder = 2
          Value = 300
          OnChange = rxsResamplingChange
        end
      end
      object GroupBox3: TGroupBox
        Left = 8
        Top = 272
        Width = 441
        Height = 105
        HelpContext = 190
        Caption = 'Viewer &Window'
        TabOrder = 3
        object Label1: TLabel
          Left = 240
          Top = 16
          Width = 43
          Height = 13
          Caption = 'Example:'
        end
        object pbShowBgr: TPaintBox
          Left = 80
          Top = 22
          Width = 65
          Height = 19
          OnPaint = pbShowBgrPaint
        end
        object Label28: TLabel
          Left = 8
          Top = 24
          Width = 27
          Height = 13
          Caption = 'Color:'
        end
        object SpeedButton3: TSpeedButton
          Left = 48
          Top = 19
          Width = 23
          Height = 22
          Action = ShowColor
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            2000000000000004000000000000000000000000000000000000FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000000
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000000000000000000000000000FF00FF00FF00FF00FF00FF000000
            000000FF000000FF000000FF000000000000FFFF0000FFFF0000FFFF00000000
            0000FF00FF00FF00FF00FF00FF0000000000FF00FF00FF00FF00FF00FF000000
            000000FF000000FF000000FF000000000000FFFF0000FFFF0000FFFF00000000
            0000FF00FF00FF00FF00FF00FF0000000000FF00FF00FF00FF00FF00FF000000
            000000FF000000FF000000FF000000000000FFFF0000FFFF0000FFFF00000000
            0000FF00FF00FF00FF00FF00FF0000000000FF00FF00FF00FF00FF00FF000000
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000000000000000000000000000FF00FF00FF00FF00FF00FF000000
            000080808000808080008080800000000000FFFFFF00FFFFFF00FFFFFF000000
            000000000000000000000000000000000000FF00FF00FF00FF00FF00FF000000
            000080808000808080008080800000000000FFFFFF00FFFFFF00FFFFFF000000
            000000000000000000000000000000000000FF00FF00FF00FF00FF00FF000000
            000080808000808080008080800000000000FFFFFF00FFFFFF00FFFFFF000000
            000000000000000000000000000000000000FF00FF00FF00FF00FF00FF000000
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000000000000000000000000000FF00FF00FF00FF00FF00FF000000
            00000000FF000000FF000000FF000000000000FFFF0000FFFF0000FFFF000000
            0000FF000000FF000000FF00000000000000FF00FF00FF00FF00FF00FF000000
            00000000FF000000FF000000FF000000000000FFFF0000FFFF0000FFFF000000
            0000FF000000FF000000FF00000000000000FF00FF00FF00FF00FF00FF000000
            00000000FF000000FF000000FF000000000000FFFF0000FFFF0000FFFF000000
            0000FF000000FF000000FF00000000000000FF00FF00FF00FF00FF00FF000000
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
        end
        object Panel1: TPanel
          Left = 296
          Top = 16
          Width = 121
          Height = 73
          BevelOuter = bvLowered
          BevelWidth = 2
          TabOrder = 1
          object imShowBgr: TImage
            Left = 2
            Top = 2
            Width = 117
            Height = 69
            Align = alClient
          end
        end
        object feShowFile: TFilenameEdit
          Left = 8
          Top = 65
          Width = 273
          Height = 21
          OnBeforeDialog = feShowFileBeforeDialog
          NumGlyphs = 1
          TabOrder = 2
          OnChange = feShowFileChange
        end
        object chbShowFile: TCheckBox
          Left = 8
          Top = 46
          Width = 273
          Height = 17
          Caption = 'Use background image:'
          TabOrder = 0
          OnClick = chbShowFileClick
        end
      end
      object GroupBox1: TGroupBox
        Left = 376
        Top = 24
        Width = 353
        Height = 97
        HelpContext = 195
        Caption = 'Full Screen Mode'
        TabOrder = 1
        object chbFullShowToolbars: TCheckBox
          Left = 8
          Top = 24
          Width = 329
          Height = 17
          Caption = 'Show toolbars'
          TabOrder = 0
          OnClick = OptionsChanged
        end
        object chbFullShrinkFit: TCheckBox
          Left = 8
          Top = 48
          Width = 329
          Height = 17
          Caption = 'Shrink to fit screen'
          TabOrder = 1
        end
        object chbFullGrowFit: TCheckBox
          Left = 8
          Top = 72
          Width = 329
          Height = 17
          Caption = 'Enlarge to fit screen'
          TabOrder = 2
        end
      end
    end
    object tsSlideshow: TTabSheet
      HelpContext = 120
      Caption = 'Slideshow'
      ImageIndex = 24
      object GroupBox6: TGroupBox
        Left = 8
        Top = 24
        Width = 353
        Height = 89
        Caption = 'Timed delay'
        TabOrder = 0
        object Label2: TLabel
          Left = 16
          Top = 64
          Width = 30
          Height = 13
          Caption = 'Delay:'
        end
        object DelayLabel: TLabel
          Left = 56
          Top = 64
          Width = 53
          Height = 13
          Caption = 'DelayLabel'
        end
        object DelaySlider: TRxSlider
          Left = 8
          Top = 16
          Width = 337
          Height = 40
          Increment = 500
          MaxValue = 8000
          TabOrder = 0
          Value = 1000
          OnChange = DelaySliderChange
        end
      end
      object SequenceRadio: TRadioGroup
        Left = 8
        Top = 120
        Width = 353
        Height = 73
        Caption = 'Sequence'
        ItemIndex = 0
        Items.Strings = (
          'Forwards'
          'Backwards')
        TabOrder = 1
        OnClick = OptionsChanged
      end
      object GroupBox11: TGroupBox
        Left = 8
        Top = 200
        Width = 353
        Height = 105
        Caption = 'Slide show options'
        TabOrder = 2
        object WrapAroundCheck: TCheckBox
          Left = 8
          Top = 24
          Width = 289
          Height = 17
          Caption = 'Wrap around when at end / begin of list'
          TabOrder = 0
          OnClick = OptionsChanged
        end
        object HideMouseCheck: TCheckBox
          Left = 8
          Top = 48
          Width = 217
          Height = 17
          Caption = 'Hide mouse when slideshow runs'
          TabOrder = 1
          OnClick = OptionsChanged
        end
        object chbResampleWhenSlide: TCheckBox
          Left = 8
          Top = 72
          Width = 329
          Height = 17
          Caption = 'High-Quality resampling during slideshow'
          TabOrder = 2
        end
      end
      object BitBtn4: TBitBtn
        Left = 80
        Top = 344
        Width = 75
        Height = 25
        Caption = 'BitBtn2'
        TabOrder = 3
        Visible = False
        OnClick = BitBtn4Click
      end
      object FilenameEdit1: TFilenameEdit
        Left = 168
        Top = 344
        Width = 121
        Height = 21
        DirectInput = False
        NumGlyphs = 1
        TabOrder = 4
        Text = 'Chimes.wav'
        Visible = False
      end
      object Button1: TButton
        Left = 88
        Top = 376
        Width = 75
        Height = 25
        Caption = 'Button1'
        TabOrder = 5
        Visible = False
        OnClick = Button1Click
      end
    end
    object tsFiling: TTabSheet
      HelpContext = 125
      Caption = 'Filing'
      ImageIndex = 1
      object GroupBox4: TGroupBox
        Left = 8
        Top = 24
        Width = 273
        Height = 209
        Caption = '&File delete'
        TabOrder = 0
        object Label8: TLabel
          Left = 16
          Top = 24
          Width = 128
          Height = 13
          Caption = 'Confirm when deleting files:'
        end
        object chUseRecycleBin: TCheckBox
          Left = 16
          Top = 176
          Width = 121
          Height = 17
          Caption = 'Use &recycle bin'
          TabOrder = 0
          OnClick = chUseRecycleBinClick
        end
        object chProtectWarn: TCheckBox
          Left = 16
          Top = 152
          Width = 249
          Height = 17
          Caption = 'Warn when trying to delete from protected folder'
          TabOrder = 1
          OnClick = OptionsChanged
        end
        object raConfirmDialog: TRadioButton
          Left = 40
          Top = 96
          Width = 225
          Height = 17
          Caption = 'Show interactive &Dialog'
          Checked = True
          TabOrder = 2
          TabStop = True
          OnClick = OptionsChanged
        end
        object raConfirmMessage: TRadioButton
          Left = 40
          Top = 72
          Width = 225
          Height = 17
          Caption = 'Show &Message'
          TabOrder = 3
          OnClick = OptionsChanged
        end
        object raNoConfirm: TRadioButton
          Left = 40
          Top = 48
          Width = 225
          Height = 17
          Caption = '&Never'
          TabOrder = 4
          OnClick = OptionsChanged
        end
        object chSingleFileNoWarn: TCheckBox
          Left = 40
          Top = 120
          Width = 225
          Height = 17
          Caption = 'No warning when deleting single file'
          TabOrder = 5
          OnClick = OptionsChanged
        end
      end
      object GroupBox9: TGroupBox
        Left = 288
        Top = 24
        Width = 273
        Height = 81
        Caption = 'Load / Save'
        TabOrder = 1
        object Label5: TLabel
          Left = 200
          Top = 50
          Width = 36
          Height = 13
          Caption = 'minutes'
          Enabled = False
        end
        object RescanCheck: TCheckBox
          Left = 16
          Top = 24
          Width = 217
          Height = 17
          Caption = 'Re-scan folders after a catalog is opened'
          Checked = True
          Enabled = False
          State = cbChecked
          TabOrder = 0
          OnClick = OptionsChanged
        end
        object AutoSaveCheck: TCheckBox
          Left = 16
          Top = 48
          Width = 129
          Height = 17
          Caption = 'Automatic save every:'
          Enabled = False
          TabOrder = 1
          OnClick = OptionsChanged
        end
        object SavePeriodEdit: TEdit
          Left = 152
          Top = 46
          Width = 41
          Height = 21
          Enabled = False
          TabOrder = 2
          Text = '10'
          OnExit = OptionsChanged
        end
      end
    end
    object tsThumbnails: TTabSheet
      HelpContext = 130
      Caption = 'Thumbnails'
      ImageIndex = 11
      object GroupBox14: TGroupBox
        Left = 8
        Top = 24
        Width = 313
        Height = 345
        Caption = 'Thumbnail Size'
        TabOrder = 0
        object lblPixels: TLabel
          Left = 120
          Top = 16
          Width = 76
          Height = 13
          Alignment = taCenter
          Caption = '100 x 100 pixels'
        end
        object sldVerSize: TRxSlider
          Left = 8
          Top = 24
          Width = 25
          Height = 209
          MinValue = 40
          MaxValue = 180
          Orientation = soVertical
          TabOrder = 0
          Value = 80
          OnChange = ThumbnailSizeDraw
        end
        object sldHorSize: TRxSlider
          Left = 34
          Top = 240
          Width = 265
          Height = 24
          MinValue = 60
          MaxValue = 240
          TabOrder = 1
          Value = 80
          OnChange = ThumbnailSizeDraw
        end
        object pnlThumbSize: TPanel
          Left = 40
          Top = 32
          Width = 250
          Height = 201
          BevelOuter = bvNone
          BorderStyle = bsSingle
          Color = clWindow
          TabOrder = 2
          object lblThumb: TLabel
            Left = 56
            Top = 148
            Width = 137
            Height = 16
            AutoSize = False
            Caption = 'Test_image.jpg'
            Color = clBackground
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindow
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object pnlThumb: TPanel
            Left = 56
            Top = 32
            Width = 137
            Height = 113
            BevelOuter = bvNone
            Color = clBackground
            TabOrder = 0
            object imgThumb: TImage
              Left = 8
              Top = 0
              Width = 121
              Height = 113
              Center = True
              Picture.Data = {
                0A544A504547496D616765724A0000FFD8FFE000104A46494600010101012C01
                2C0000FFDB00430006040506050406060506070706080A100A0A09090A140E0F
                0C1017141818171416161A1D251F1A1B231C1616202C20232627292A29191F2D
                302D283025282928FFDB0043010707070A080A130A0A13281A161A2828282828
                2828282828282828282828282828282828282828282828282828282828282828
                28282828282828282828282828FFC0001108012C012C03012200021101031101
                FFC4001F0000010501010101010100000000000000000102030405060708090A
                0BFFC400B5100002010303020403050504040000017D01020300041105122131
                410613516107227114328191A1082342B1C11552D1F02433627282090A161718
                191A25262728292A3435363738393A434445464748494A535455565758595A63
                6465666768696A737475767778797A838485868788898A92939495969798999A
                A2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6
                D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F01000301
                01010101010101010000000000000102030405060708090A0BFFC400B5110002
                0102040403040705040400010277000102031104052131061241510761711322
                328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728
                292A35363738393A434445464748494A535455565758595A636465666768696A
                737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7
                A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3
                E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F268
                C023E62724702AEDA8FDE0E3271D2AB26D60A5403919520F6CE33F9D5DB72A92
                AE396EE2BC35256396E24207980907073DEAFE9370D6D74B347F2B29C0EF9154
                622ACB807E6C9ED5346487040C62A1B44F52E6B36696B765E01B60BA2648B1D0
                0C72BF81E6A24DE63462BDB835AD16DBCD2E4D3CE0DC46C24849FE11DC7E358B
                0031B2861B5867AFB7F2A95629BE85D8F7150D9C9EBCD3E2251E43B7381EB504
                60B9625883DB8AB0BBC3E18609C1A91A45BB124C82363BB7A856278CFA54288C
                8658E4C0DAE54739FC69DF3AB0C0C9352CCC16E9E4DA3649F32FBF1CD03B206F
                BA3680081D7156B4C9CC57B1C84623390CBFEC91822A09981DA10F519C62A48F
                2ADBC8C74C0A2E80926B57B4BF9AD98FCA8C40F71B4E0FEB5323A145E79208C6
                29B7F96823B9C92CA42CADDF39E2962743145C7CFCEE18E9426039891B06301B
                A54F1EE03763A0A69425E21DB04FD2A6190A467B5689AE80349C08D635C6D073
                CF535248328039C823F2A6212B3BAAAEE2876B76C7152B2911E586ECD55DA603
                5816600F236E3AF6A46B7CB0F9464720E29B30224F946303D6ADAB9C28239C7E
                745EEF502008D13068D882474CD4D3CAD32A25D223ED1D48C1A7052598E30074
                A8E75620B0EA05270D06C86E2D2244568A4605872B8CE2A058E46F923D84F4E4
                E2AE8CB3B0032401CF4C539615E490013D4D66A1715EC52914C19503EEF2D8E4
                53A32082030241152A2193971C380768F4CD4C966C25628A9CF2066AACD6C34D
                3DC81AD4B3A9247A9C1A977145DB9002F4E2A29C4A65765FBABC714C132ECDB3
                8646E878CE3D295EDB889FCC0408F0BBCF247B54B1F96031936B39E73DB8AA91
                0190FC3390714E12F9B2EDE3CB87284918C9C7A554ACF41926A5A643E26F0E1D
                3AF5FCB778B314AC30124DC0EE03D0EDC5783CB6D3DA4D3DB5EA4915CDB92B24
                647DC39E01FA8E6BE800EB240A5F92AA131DB6E79E2B99F88FE165D72D9F55D3
                883AA47CC9183CDCAE3A9F703A56949F2FBAF61AB9E4F14B2472075728C0EE0C
                BC7357208E1D45A28D4F97765B6659BE520E304FD0F39F7ACF4C306DC4ED0318
                03F0C7D73D69CCA15C321C8C75E9F856AD16F6D09A589EDCB47711956C72ADC6
                E1EDEB57B4AD4EEB4CBFB6BDB398C377038923947186EA78FF0068819F6E2A28
                750063F26F94CD1ED014E32CB8EC0D4A34E59C9FB0CCB203CF965BE6FA7D6A39
                ADA3294ACD5CFB0BE1AF8E2C7C6BA345202B0EAB0A85BCB463F3A3EDEB8EE3DE
                BB1F2C7F70D7C2BA06AFA9E85ABC7A86993496F7F17DD283AE792A4679040DA4
                7BD7D57A67C4B8058C0BAC4045F08A332F96A48CB22B1FC8B63F0AEAA7894B49
                1D2AB2B687CCD7B6E96D7B3C3809B18A0503A0C06C7EB45B9559B29D48EF57B5
                589A78EDEEB6066954A3B29CFCEA54127F0155226552720E40F4AF3A3A1E5924
                49B723001E6A70000BC77A8954AB8CAE49E47352B7CCD181C6E04E7D31435701
                F033C52A153839E0E79AD0D62D966B44BFB6520BE127007DD6ED5988A32B9072
                4120E7A569D85F0855E37C98A4E1D49E0FF854B561D8A51B9C02A01C0C1AB009
                6872E70E08C1F6A8EFA15B7BD740C3CADF98C8FE21D6A58D91872DD14F6EB4B9
                93E852245662576F3C75F4AB2C81AD57BF93C8FA1EB5040CBE5B1CE32463DAA7
                8580709BB2B821BDC525AEE3084868C367820F38E94AB89432E49DBC1ED9A861
                0F1308D800396073DAAE84C8638EA47CD4905CB163247E634773CA38C1E38F6A
                A56CE6196449BEF866CFD01C0A993E55209EFCF1D451791190ACCAB9C33239EF
                C9C8A6D5C0B31392AB8E71DEA4CEECAE3AF154ED250111B3C615BF3ED56CB866
                F93AF5A88BB3D4072B379EE09E58EE3EFC7156083B0E5BAF6A80AFEF41032D8C
                9F7AB6550467232DD866B652B302BDCAC8B282DC2B0273F438A9A1CB8523FBA7
                9A8EF41F287190A48FCCE69F6EC3C9420E31C50DEB702D22B205461F3292AFED
                C71514D1CA46531D7A7AD49E7AB3CECC70ECD9E9D4E38A0A99482723F1AA52BE
                880A84BA231C30DC7D2AEDBAA16DCC0B0DB823D2ABDD997745E61276020003AD
                4F6D281CEEEA30C31DA8B5805B48DFECF1844F999063BF079A739DF1A155C3B2
                F00F07DCD16F70238A3DC58140003F4A8E4702E0BCAC4954288473919C1E2A92
                43B308203BBC8230D824F39CD430C25EDE392543B9D43B03CF3E95682C8652F0
                A92C0007D31DC5584B79F6463F711A9208EE460631468F604CC6B9B6572D1C47
                6CC482486C003BD55BA17313B109BD49CF03A715D0FD8DE262CA8ACCCB961919
                E7D29EF080A0946CFA608E7D3A557B252F22B639ED3EE4493840CA8DD3F78768
                07EB5A33F9B6D77340CFB5A2768CB03CFD47E74FBCD222995D0C60BF5CB0233F
                A5644D15D5BDC3BA169D40F9D8F24B939C8FC38C54F2CA1D2E36FB187F107C26
                D7F3DC6ADA4C6AB7218C9716D170B2165C6E41E98EB5E651BAE5485CA05DCDED
                CE306BDC2DEF4B122360B2229201FBCBEC3DBDAB90F19F8760BBBA9EFB4C8D12
                75662F12FCAB2A820703B11D7DEA9544F462B9C00CB72BC0CF18E314F8A66865
                4788B09539DCA7049FAD323532289103321E3007439E94D9393B492A47A8C62A
                D2BBB169A6757E0F94EADADD85A5DC11BA060CD215F9801C16CD5AF1978AA5B0
                D69A281E401A3476092602923A74EC30297E1ADB2C72DFEA536E58D62F251BA8
                56F3013FA7F3AE47519A2BDBE9EE2542CCEE71CF419E0563ECE32A9DD213496C
                7756E45D69F3DB2060EA3CD8C0E3249F9B9FA566A310BF36769CE07A81D6AC58
                CC6DEE925604056242E7A823A66A7D46D8C1A8C91E06C1CC64770466A65171D5
                1CF6208C3B306DC08C7029F838C11CFA7A0A567982F078C629C581F989C1C62A
                7510E04AED541F778FAE6A45201CB0F9BA81EB483690C0372C3AFA53E37FDCC8
                AA9F3123073D0771F8D0DB2D364F098E7B616EC017006C723A1CD5660D0DCB47
                20DBB786FC69F90ADB98ED0460E2AF4AABA840C588FB4AE33C7DE5A9B3656FB1
                5C200A003F2F5CD4A570D1003059493CF615572F11DAF95C02083D41ED534257
                6E3240EA334F4E81625705C29E72A0FE553C13165201C9F4A81D48FBAE791C8F
                5A231B2512A8CC6460F34B44268B8C859CB1384E9C1EB53D848619DDD977C5E5
                B0941EE58605416DC30046E520E0E69BB9D55954F248DDEE41C8A4D858AAA86D
                26F24938006C3FDE15A49233448D1E01239A84224E4C6E70E48287AE0FA5528A
                62A0AB92194918F5A992B6A55B4371791132BFDD0413EB9AB0090636233F29F6
                ACEB2689B6AB1203027F1AB1692B4CA81FA6CC803B647AD1CC9908B6FB9E3618
                FBDFA553DC63731E73F3119ABB6E55EDC301CB286033EA2B3252F6F7570A4676
                CA7BFE15ABD568335A0198986402DDCF6A915982A823F23544CC019A3072518A
                83EBC6734A930F21324EF0BB8007839ED55056680B7792AC71120E79C0F7269B
                0DA49247BF6E4B7BD53B9600C32302601D481FC55B1A49174E91B9FDD1CEE3BB
                1B4014E4F50B15A0B506F2E4380238DCA03839E06738AB12C5147223070B246A
                C91E48230C79EF5E69AB78E6FDEE258ED1618A3076A360EE3D793CD654BE28D5
                6526392F942B10492A38FD28F7ADA0EE751E33F17DE697AECB696011633FBC70
                EBF32EE5C8FA71C8AC3D37C5FA9DCEA76F14D72E63B890090E3183CE08F4E95C
                DDD99EF2E9E63235C4CF852D9C96006067D703A54021B905FCB8A6575F9812A4
                63861FD6AD538BF88692379FC6BAE42CF19BD2C5323E64192371C7F214E87C75
                AD97088D13EEEC739CFE7595AF5A315B4BF842B24F1A40769E43A2286C8F726B
                3E2D9110CCAC65C12074DA7B557B38762D24CECED7E24EA29B16786295464641
                3935D7693E3AD2B52C25C16B69DB03E61804FB578C3200060617D0F3D7AD3410
                BCEDC760BEB54A296B11F2A3DD6FE2B79E212DBBAEEEAAC9D4FD6A8A97598649
                6743942718383CE7EBD6BC9F4DD62F6C1B75B4EEA54E4216F9491D8FB576FA87
                8923FB2DA5DC96ACD653AEC12C5FC322A0DE08FF00798572D7A751ABA5726D6D
                CE6BC5960BA76A2AF02BC76F31DA14FCB82A9C923B67771F4AC8795846CAE148
                01B391C8C0CD74FE2CD5F4FD534AB630195AFF00CF612871D1362E0FBF7AC7F0
                D591D4F5BB3B72B94924065F4DA73D7F2FD6B6A526A179AD8A4AC7A059E973C3
                E0D16902813CA0CCC01C60B2C783FA7EB5CC7FC21F042AAB79AA4314D8CED1CF
                07A77AE83C71AA49656490594989EE09890A9E8A88873FCFF2AE0DEF1998B1D8
                F9E85BAE2B9292A926E71764C5BBD0EA01DA46470413835A77A8B3E9D14A9933
                44AB1C841F53D6B3D4172015E808ABFA24823B8659FF00D43A91213D9BB715AC
                D732D0C6E8A318F94EE2010011CF5CD48A11CF3C11D2A278D83BA498322E074C
                60F5C54AB8118DCBF37B50B6125DC58A33B4FA83525B9C0231939A746177743D
                3A548B0BAC2EF803078F7A1A1A1B200C01033838A7C2E22949079E1801EA3B52
                A28DF81C8C72BD39A63A98F865C64FAD26AC34ECCBDA8C6F7D09B98001730AE1
                D7FBE3D6B3848CC177A9047156E195A250413B8F009A0C51DD6C788112202197
                3F7CD424D16EC3518B846181C7E54A3310909C843C1EF9CD5442C840D8EA4678
                3571583C4431CE7078EB40B463E3335BBC914A0A3A12083C608EDF953A6276FC
                A73C8C9F5A6CECD34EED29324CC4B13EA4F73E9C558D2F4ABCD525305A28E079
                8CEC708A060E09EC48CE07B5572DF62E14A53768EE27CB92132703BF19FA7E63
                F3A926D3EE2FB1E4DBC9E7718214F4FEB5DCDA69163A7441634F3654251A561C
                1392381F40BF955C4CCACA1DDB68E30BC647A5774308E51BC99EC53CAA5CB79B
                B7C8F39B0D3354745CD95C7C8483989867F4A92CD6EE022292278D82EDF991BB
                023D2BD1150170A0850323238A6C6D279A42B707A64E7A53FA947A32FF00B2A9
                B5A49FDC71DA65A5E4B1848EDE66DAA06E0BC702AD5CF872FAE27126D8D37EE6
                3B9F079ED5D78667607702AA79C7154E4670C59188C6475AD161626B0CA29EED
                B3939746BF825C9859F0304A7233EB54A68DE19A248D0956889651F78306C576
                F1B18E220B65C9C83DC57416F6365790BC979650897E6C48539C1A4F0AB68B30
                AD94DB5833CDE1B9586268E6C6FC7DDC67EB55EE75ED3ED44C0CB1C0D246E396
                E99522AB7C5CF065C585AC9AF6933CD259C6D8BAB42C5BCB0CE0EF18EC057927
                972C851BCB62DB41F9791CA86EA7FD924FE15CD3C3CD68DE87995683A2ED22CE
                A50ACD670EA0A42BBC92412A8EAA53A363D0E7AD512BF283B007C63AF53DFF00
                4AD6D122803CB0EA33462DEE9023B37CCC986C83DB183D7D6B36EAD66B59234B
                81B58AEF5C9E48600E47E047E74D59686092EA471FCF30181D2894964CAF079E
                98CFF2A06D5907CB838E4E685853CBDCD3281CF4049FE54EC57535B4A73776DA
                869B81BEE507D9CE39F38C8BD3EAA0D60ABF980E031EC0FD0E3F9D5DB4B95B1B
                D82E612C5EDE45990FBA8C74FA559F1240905EC53DA80B6B750A4912AF63805D
                7EA18E0FE74D69A244EA9E86542713A090AEDDC370CF6CD20037202013F31EBD
                A9C6356721719E3E6E9CD3CC723C71CB1B16CE5481DA995721210963F32E3D17
                35D1786BC8BE59746BBC98EF3090961811CECCA49EBC6702B032080D82C01E69
                D11789D1E3F95D416C8EBBBD693D50B71B3C125ACEF0CCB89579E79246588FFC
                74035DEFC37B1115BDD5F305DF2A18101EE43A671F813558D847E2B862B98DD2
                3D4A3CC520C6372050887DBBFE75D16A0F0E87E1B0118E60453907AC842E6B93
                118856F67D58D3B1C1F8A350FED1D6247DC0451AA2A11C7206D27F91FC2AB79F
                1420096004B7CC33C7B11F983CD3A0B13732858017691F0AA57249CE78F735EC
                3E15FD9F86BBA4AEA1E24BE9F4FBE95C85B709BB646385E770EB8CF4EF5AA953
                A71516EC5C22F738E818F23E53C73CE29DB9485DD9247DEC0EB509C060E060E3
                39E95246CC1370C6581FC2B3D3A1C4B7D4B97D0A5C2A4F0B7EF225559C1E0EE2
                3008AA30E460139DCB9C7F4A9E2B8315C062BB931F38CF51DE9D7B6E90491F96
                D9474C838FC6A55D1A3484032410A3DF9E9417254297185CFE3420E0140C4679
                C0CD4B6F13CB26D8E2DF21E88A326AEC98F91F400BB87C879231E94EC65B241D
                AA304FBD6F58785753BB00FD95A35EBB9CE2BA6B2F87AC42FDB26F908CE13D6B
                48E1E72D91D14F09566F4479E2EE23054B29E063B549E5B070C8ADC7A035EC9A
                7784349B5418B6591C75320CD6C5B6996B12ED585027655502BAA38295B56772
                CBA5F6A5F81E2325A497F09531CBF698B80421C106B25ECEEEDEE3CB922756DC
                17E6040C9E9CD7D14D6D109005403231C002B37597844005C411C8EC738C0278
                E87344B0316AE99A2CB5376523CAF44F0DCB7D6F0DE5D37956D32A4F0AF47652
                09C91F518C7E35D9C70DBDB5BADADA47E5C0482475DC7271BBD7838ABAAA640A
                73C018008FBBEC3D063B5232606DDA09CF06AE961E1077B9E8D0C253A5B2D4AF
                1843246AC09201246783F2E3FA668950A36E5181DAAC4309FB3EE2A44A0900D4
                3386709E637208C575DCEE51EC2BDB8DFF003E720E33555D5A2C300C0A9ABD78
                257F9946D04EE1839ED55E4759610771DC3E52A7839A5A03BDC4F31A22080369
                193C77A8E5899E366F7AB4B0908A25E01E95146CCC197F858F03E9526B1BF522
                D3217967DAA3201E4FA57611FCA8A0A9EC38E6B2F47B616F1336DCB3F209AD78
                B73001B83ED5A417531AB2B8496E92E9D730480186685A270C3920823935F23E
                B9A6B7877C49A9689312FF006098C7113D4C5C6D6CFE95F60951E51073F857CF
                DFB43686F6BABE93E208E31225C29B2B993FE9AEE2509FA8159D68DD1E46329F
                32E63CC24450846148C1CB77AD146FEDAB692C65918DE465A6B6918E3E766542
                99FEEED03F2ACA68D14B879433F5C2D3C18F2155CA1EA0EEC1DDDEBCEF25B9E1
                B441223C72309011210AC148C1039C67D32067F1A6B2954C81F31F5635AEE135
                B889CEDBD8D5769C60CCA308ABEE40C9CF7CD6544A63422546F331CAFF0074E4
                8E7F21F9D17213EE238CE09C12067835B56303EAFA0DE592216BBB42F796981C
                92E55641F4C0CE2B35A493E5200200C8A9B4ABE9F4BD4ADEF11987D99C3614FD
                E0A338FF00EB524DDAE3DF63310A360A302AC33F5C362A48DCC2E1E33CA9CE3B
                7D2AFEBF649637EAD0366D268D644DBCE0950597F06602A900BE584030F9C93E
                94DBBEC0892587723CD09CA93F30031CFD2A17219BE56382300E2A489DE394BA
                1C138FA7E553CD0473A86B675129C8F2CF6E01E3F33F952B94B73A4F86A9E6EA
                D7B2B676456C188EBC99005FD6B7F58D2AFBC55ACE9BA06951EE9EE25691D82E
                1638860166FA11D3BD53F0159BDAE9573336564B894C6B91D515948FD4FE95ED
                3F086CE2B6F0DCFAEC63177AACAC039E4A451928A17EB8FD6B82BCD7B6E75AD8
                A5B9B1E17F06787FC29143F61B68AEAF91CEFBC7F99CE17A8F419E31FAD6ECB3
                995CBC8CECC7B86C55492650402DC81B467D2A32EBFDEAC253E6776742691F36
                14698863F7075C8C53993EF6C53B4F4E7A522A3060AC09CF3C9CF35344CC01F9
                4F1D8D75376679A97719B303727DFC77F5AB96845CC6D6ECA199C8F2493800E4
                F07F21F9D4001772171C93B771C02320027D3248AE97C21E1B9751856F26C2DA
                BAA4D10E8CF91F2903D0146C8F6AD631751D923A68509567CA86F867C2773AB0
                F3583456FC1DC4EDDC082781FF000161F515E93A37872CB4C2AD0C2BE6918673
                C9C5695A40AA8150044E76AE3850599BF9B55BC0439CE4E3AD7AD470D08ABBDC
                FA2A18485156EA2AEDF93E5017D2AC28E32CC71DAABC7B59412DD3B7AD4A1836
                0678F4AEAB58DDA25C8038C0F7CF5A702153239350B1C0392303DBA556373E5B
                AA3A92CFD00E69DEC4F2B617F76D6F1CAD90590823DEB9A79CCD26F72DE6678E
                383ED57F527591DC286214F27DEA8B0E47518E6B16DB674538245881473BFB8A
                92E625F281DA47D0D2A61D148EBD2A468DB7A866052A5246DCA8882840AAA588
                233CD57BA890AE78DBFDE07BD5E68D00218927D33DAA3312A0F2C01B3EF5514A
                C568984D6E060E42FAF4CD4504486E031D992304B1E94F25E369D578DC1547AA
                FBD4E9120B67668FEF71CFF3A4C3420BA50CC3730DABEF4DB4843DEC51A20C2F
                2FCF4A7995493010BC0CE31D7F1AD5D12111445DF0D231E4E31C7A52B5D8AA4B
                9625C8D022807A0AB3115241350CAC33C549160006B64AC723D55C966F98617A
                FA7AD715F1974A7D57E1D6AF0227993C005DC25060EE8F2D9C77E322BB5C720F
                BD472C0B323472AEE8D91A365CF55618343D51CF38A71B1F14C2E64855DB8919
                15891D3047F8F14EDECB10DC899078279ADAF1C7869FC2FE2BD534842CD6F1C8
                CF6D91D61661839EFCE47E158D10423F7993B47DD53CD797512523C2A8B964D0
                E8A42180DC11860820F2063B1EC7BE6B6A753AE5B19E3C0D46052CE88BFEB932
                117007539EBEC6B1E1843B208E399E6791634058004B30503383EB5F4E787FC0
                9E19F0D582DACF6EF7BA885533DCE4821F695F9403F28C76E79E6A3939B51470
                EEAFC27CC24B3B00064F4F419F4E7BD248AC0F9A3200624E78C1AFA62F7E0F78
                6B576F374DB8B8B266C9280E5493D783CD635CFC02BAE045AC4263CF024461C5
                269C76412C34E3A33C7B4E47D4B41BDD30926E2DD4CB6A48C1625D43267BF4CF
                E9EF5CF8C05949FBC0639F50718AFA374EF80B756D3C577FDBA3CF8DC48BB212
                C320E7D453355F802F7174D3DBEAD1461D54323444738E4F5EF59A72EC67EC9A
                3E77703605276B114D2584C0A15DC32463AE4E7FC47E55EE377F00F5947610EA
                368E36900B12BFD2B124F837E26D3AE639A4B78AE224604F9526EC807E94DD4E
                45763F672B11C0BFD9FA45AA67252D93049EE63424FEBFA57A4FC13D485D7C31
                B1B47C2DC69534B6F3027248672CAC3F3FD2B85D62D7FB3A0923D42092258B0B
                87523763E5E3FC3DAB07C39E38B8D135BB6996345D3C385B98D0F5461C93C761
                DEBCC8B94DC9456E426D3D4FA1A5707EF75ED509900EA3F5A844D1CB04735BC8
                1E09D16585B1C94619CE2ABB48371E7359496B666F76786226655C9E83AE6828
                CA0967E09E99EB50C2CA40CF73EB5347B729E603E59209E33FC4A3AFFC0ABD26
                B53920B99F29B5E12D1CEB3E21B5B09431864DED230E80A046519EDF749F7AF6
                145569E428A1137B3617809CB12ABE832C78AC0F0958FF0066E936B18402EE48
                D5E7F5F330EA79EDC62BA28A12AABB87CA3B67A9AF5B0D4B955CFA5C0619D382
                6C922DC09F4CE6A5C927A522E41C638A7A8C915D87A0DEA204DAA467DE84621B
                9E95318C05CB1AAFD49DC46DCE07345EC4277259586C27A8C74AA72336D33962
                012028C74A827120661F385C75CD4F72316D126E3B7AFE3593771CAD15A14464
                02A49209249F5A64AAA64000CF1D2A7E08208C7BD089BDF2ABD2A1683837616D
                D063007E152C69279ADBC0DB8E2A585002001CF7A9CC64B679E9D2AD1A399584
                5C927963C0F6A6CF1B6CC639F5AB65481D0F150DF315B76E32483C53173995B1
                9EED9E43972368C74AB8039400F001E953456E91919E4E7FA52BAA804AFD6915
                CE8A76B6C6E2F382DE5A9E4E7BD6CB2AC0028E71F85374DB76815CBE02939CE6
                92EB9FBA73CD5A8F531737395BA0E9369C91C63152C6A78F4EB9AAB19CC853AE
                E1F955E0A140C76A644B4D07A8DC3AE08A91723D0D44300839EB532A0C0C1ABB
                5F63191E23FB48E8DE6E9DA2EBD6A31359CA967330E3745212467E8C08FF0081
                578E49710CD0C493C7B1D060CA8B8CE4670477AFA8BE2CE8C359F873E2082242
                668AD85CA28ECD1EE715F27C1FBCB446DC4ABAA91EBC28FF001FD2BCFC546DAB
                3C8C5C2EEE8BF0A49632DBDD12AF0C575136E43D312A91F8D7D7DAF5B05D66E0
                8036E01CE7F8B9FF00F5D7C70F95865019918FEF0A91F2E41C838F5E2BEC2D0A
                F64D73C29E1FD5A74027BDB18A693FDE23FF00AFFA5714E5CB1161E7CBA5C92D
                048BF32F1815AF16A9711ED3E6700636E4D66CCFB142838A81A507AE722B89D5
                6B6349CAEF53A15D6A6C1DC10FE7FE352C7AC33719504F1DFF00C6B983231E41
                1F4CD2872403BBEB4BEB13EE73BD4EB46A4E48CAA91F89A5FB6FCAC38E7D4573
                30DD3270AC71F4ABB1DCF1F37523826A6588A96DC2C6A5D4365A844E9776F14A
                841F95D030C939AE3B5DF84FE18D632D15A2DB4815B69878E49CF23BD743F682
                84648C114AD7A0306C9C0ED9AC1E21F503CA351D235EF87B139679355F0E2950
                AE399AD940EE3FBA3A93E82A4B5F14E997702CD15D26D6ECDC115EB8B7D15D46
                F0CC82457E3648320FB7D0D7CFFE38F833AB4FE22B8B9F094902E953E2554915
                894639DC3E99A709D3AAED276225A2D11C841E5C68DE60CB8E369F43DEAC59C0
                2E6E228B68CF9C9951C0DA1E3279FA55704C9312F80EDD3E957745DF16A16A24
                1802405BDB2F180335EA45DDEA6386F8D33DD9EDFCBBB9B6AE0F98C09CFF00B6
                7FA715632A7686E0E6A49948BCB838CFEF1F8CF6DE698D82C0EDE735EDC15A28
                FABA6EF1561E146690820123AD397278C1A715C0C6726A86DF722F31B0377205
                30F20E0023AF03A548E02E326A01BD18B6DE33C0A4D94927B12B21647041200F
                5EB4C99436D1B7381D3D296294B600072339AB3B449124883E53956CF620E2B3
                96DA19556D6E5296D8B2A955FAD3A08B683D88F6AB9123038C7153C70866CE39
                A85AEE4C6A5915214191C60E6ADAC793D2A7484961D00A9FCADB83D6AD133AC5
                310E4E2AB5EC002E080C7EB5B222039EB50B445AE0285193D38A666AB34CC486
                352EBBD482189AB76F6A0C8CA4020FCD9C7E957BECC5D810A0E4E0FD6AFDB596
                173B79A104F109233A485421E00F5ACBBADB1838C60735D5FF006607E59B83D4
                528D32D011BA1DE7DCD6AFC8CA18C84357A9C758E199A563B78C006AFABAB9DA
                0E4E703DF807FA9FCAB767D22D9D70176F718AC4BAD3A7B0B886E231BE28BE77
                5230480AC0FF00307F0A9D51AFD6A9D4D53D464D2C313AC72BED72A1BA67156E
                D51641F24AAC0F02A9EB56BE4DC24BBB11BAE17239CF5AA56AED1B13B9C67DEB
                8A75E719680E5CD1BA3435AB790E937A02FDEB59F27B728700D7C690D814D374
                FF0094ACB240A3CA604370B82706BED0B7BB2985DE71EFCF154B55F0E685AE44
                CB7DA75BBB11B7CC0A1580C9C00476E6B9AAD794D58F3B109CFA9F1CC8A0B4C7
                09196423664F1815F597C3E73FF0ABBC1EF2A6C73A746AAB9EA00183F88C1AE2
                FC59F0522789A7D02E3EF2956B595F8C11D8D759E0992E22F0769BA7EAB6B2DA
                6A9A6C62CA5824E33B00DA54F42BB00E6B96ACDF23B9CF4E1691AB2B83231272
                7B552B898A11CF3F4A9A53824E3E9CF7AA6EC4B12FC8AF35CDD8D990348DBF76
                E24FA74A7A4D20C9279F4A8CB22B16C67DA9EB3311F22AE0FB561CE665886794
                F6E3D6B534B486E3749733AA91C052D8AC612C8067705FA734D7B83FDFC93EA2
                93A961AD8F40B5B38180F2991F8ECD9AB82C936818C915E616DA8CF0DC66299A
                33D322BA6D3FC4B7681566413A03D4F5ADE9CE8BF8C87268E966D322907DCC1F
                51C56749A2DDAB620BA644F404E3F9D5CB6F1058CC006996273FC32715AC8C1D
                4302083C823915D4B0946A7C2C399B3E32745476240DC3807353E93329B98526
                55D8668DB207712478E6AB480331C8277720F6C77E6ADE9B1849ADCB0053CD8F
                81CFFCB48EBAE30D4E7A17E747D04FBCDEDC927FE5A3E39EDBCD38A9352CDFF1
                F37031D246C1C7FB6681B58100FCDE95EE53D228FA9A6ED14550DE5C993B8FE3
                41988624B0C54CFF0074851CFB8AAE229194B1D8A99C648A6DF6365662B48241
                9F4A7A3E48CE76FA1E2981234608D9727FBB56E18E003E6881FA9CD66E444A71
                48608C60B20393DF356EDF0CA548E79F6C64E6AD5BC76E5062100D3E5B34C068
                5B6BFA67349CB43925594B468ACB1846E9FAD5A8A300671D6A11318FF7772111
                BB1EB9ABB1E0A8DB8618EA2A13B18CA6D047170582FEB5322EE5C639A2362060
                74EE0F15695410A477ED54A660EA1008DB691B7A7BD3624FDF676E0819AB718C
                9618E7B5322C19D4EEEBD063AFAD55FA993ABA0FB7B519002E075CFA9AB9E585
                5000EBC669D0AB2A1CF23AD48E3201AA8ABEA72B9B6C83183D781CD378C961CF
                B53D725882BC521014F15A2F329318C095CE31F8D43380C5F3C82BD0D4D2BFCA
                45527724B63A9040AB5A1AC1752B6BB6FE6C11F0095C9E47B5730C851C86E82B
                B1D4159AD63C75EF5CC5EC6158B15392715E5623E23A68CBDDB1594A993938C0
                AB16F30071DBF9D54620B0C0C76A767380A3915CAD04AECDEB69B80D9C1EDE95
                33450CF19464078C0FFEB9F5F7AC9B67F9402DCF715A36CEA0120F358BDF5307
                74EE616AB61259CA463309230D9EFE95952632DDF8AEFA4896E6078DD1595864
                E6B8FD66C1EC2E9A1C03137CD1B03D7DAB86BD26B588AF7337CB52DD38C75A09
                20155C7B54D280B1050793CE6AA4CDC6075AE36B41590C91C83962BEFC54524A
                08017934D0801249DC7D29242700018A8DB713D08DBE53B980C8E7AD69DBCA5A
                01B5D08EE3DAA82C05CE5855FB7B2C9015383D715B41DFE144357193A8B9611A
                0C8EFB6BABB03241691C7E64B803FBFD2A8585AAC52A6140DC39CD6C4684281B
                73F8D74AA492BA0B58F95ECEF2D75188CD69B832801A36ECD900903D3BD5D815
                59A131920BDC458DA7B7991D799697A8BD85C2DC076DEB838EBB881D3E99ED5D
                545E3084C71A084C5346F07CF9E0625424FE95EDFB27CDEE98514D4D1F564C4F
                9F7039CF9ADB79EBF39A88E3271C377A9AEE12B793E186E2491F8B1247E555AE
                A68EDA1324C72A0E071D4D7A51F8753E9E93F75114D74547CC4151DBA1355565
                79DC973F2F61D80AA71B4D3159262A406201C6383ED56155B2428E0F152D366C
                D27A22DC792F951803DEAEDB61812DDAA944005E3A0EA7357A1008001ED53CA9
                1938E8CD183692A031CF5ABF1124E3683EB59B06010704568404EEC039E29729
                C55158966823993E755DE3A122B0DD1ED6575DCCA7AF1C022BA15190770CD135
                B25CA0595724700D6528F73979ACCC7B2D41C3ED986F4EC7B8ADBB495644DCA4
                7D0F15892E9F35BB9C2FC99E08AD7445B7823231BB1924D64DA8994A57D8B8C4
                EE1B703BE734D8235139727EE0C28FAD539EE55A1009C9EE5474A934B7567F24
                36E7500B73D32322942BA6F95A3369F53657200E73C527386FA53BB0A435E8C5
                368E77B911271504AF81C726A693DB22AACE46D38EB8EB5A289D1057631E5E33
                8AAFE60DD9A1DB8C5404F38F5ADAC75C608B923B369CEE392AC7F438AC4BC0CF
                111C126B72C08963922E9C64FE26B16E0E06070DB89C7A62BC6C62B4AE453769
                3463321E4B71834D4077673534A492C0F5EB50C5B8B91B7F5AE295ADA1B4996A
                DC1C9E324D5E80851CF06AAC45635EA4B7D3A5049524BB707B560DB461736A19
                1F1904018C52DF5B2DE59BA6D5CA8DC9DC835574FDC63DCC0EDEC33D6B514B32
                ED45D9819CE295EE672679CCA4B03EB9231E8475155D91D8E456B6B76DF67D6A
                F57188D984CB8EDB8608AA2FB541DA2BCDAB06A5B8F757452951B3C704D491C5
                B80DDD454D1C64B92DCF1C54C10E320563BE84C848A350338E95A56E78C818E3
                A5568D081D3B66ADC3CA8C0AE8A764497E388324631F30AD184058C02A73F5AA
                16ACDBC7B5690DB8E4F35D49DD01F9F726CC2AAB67D698E866B791015F34F1CF
                1C673516E0130065B3CD4B962CAECA370EC3D2BE8A3B9853D1DD1F6D787B584F
                11685A56B1090CB7D1076C8C1DC18A9FC88C7EB546F6EC5D4812360634E7691D
                4E7FA579A7ECE9AAEA2DA06BFA6CDB9EC6C0C52DBBB0E52490B6E03D89EDDABB
                E8171940BC81C73EF5BDEEACCFA3C3DE51D4B663C95C02BC71CD5C547083B01D
                6AAAF9981B94E3D2ACA79DC053B475F5A56EC76A8F52CC6A9B7A71E99AD18228
                F8383D3D6B2D54A8C8FBC7AD68DB39E011DB1D6A9233AB176D0D08E28C2E724F
                E3572DE204820ED3D3D6AA5BB2902B4A02383D2868F32AB689E38D9472771FCA
                AC2A7C9C8C134D89F23E5193F5A9D43757E0D4F21E7CDEA30C7B1092A48C7355
                2E3CA5203E0375018D68960C368249F4C550BFD396E1086CB39EFE82B0A94EEB
                4328CACF530F52B8102EF076B1380A39CD69F87209443F6AB88824D36371F500
                6053ED341863984D366471C0C9E056D018185E07403D2B2A3879395E4C73A97D
                85A6B12013DC53B69A865073C66BD24BA19455D8C91D8A9C9038ACD9DC8C9238
                1535CB3293CD51B890B0C6715AD923BE8C08A4B85CF34C2E3860698CB93CF350
                CEFB07CAB9C76CF5A773BA304F63534B7C4E39C16DA3F5A87588C24FB8280197
                70C1CF7E45739E27D5A5D17C2FAC6A708DD3585B4970833D4A8240FCC574BA4E
                A16DE25F0D69FA9591DD0DEC09711B631F79738FA8E722BCDC5C5357392B2E49
                DCE72E0E4920E39C534921720F356EEEDCA89011CA9AA00E7827045790D728A4
                DEE5D8643E5FCBCBF7A66DC4BF31259BB62A285B6A31CE3B54B08633646E2B8E
                B9ACE5A11746A248CA10292303A56ADA6F6059F39C71CD61C232F96DDC7BD6BD
                9E481B98AAE3038AC93D4CA5B1CFF8AA223548DD7FE5AC3FC8E2B2042769F947
                4ADBF1312753DA7FE59C4001FDDCB735978C0E0D6135765C74890800BA82318F
                D6A55880278241A02F52464F6AB90ED923031CF715838D992D32BF959E47A558
                817E51C74A9920007DD34F55C1E95AA44135A7D306B4C460A82473542053BBA7
                BD6BC4BBA35278ADE160B5CFCE9468DDC08DC3161D3FA54D12912AF99F321201
                E71C7A553B78480AAAC77950C707A0AB314C60908DA4AA8DD96AFA56ADB19C53
                E647D29F066CD2C7E15699705712EAB7335D4AFDD991DA31F8633F9576CA2103
                E6054E33906B0FC1710B5F871E1180C6C08D3925E9D0B9663F9E4FE75B518569
                1779007604D6B63E930B1F7095982A0219B15A08570B83C802AAA0CE41DA569E
                A43B6E07923819F4A2C76729695806CD588A504F039AA68AEDD462AC40AB19C9
                3923DAA919CD2B1A96E84856271CF4AD08E40BC6739AC98A666C01C0AB71C841
                C1AA47054837B9AF0BE57838E2AE2642800E7359B66DBC8CF4AD081B7152381D
                2933CDAB1B32E4630BBB8CD3C0E09F5A8F3918038A733ED5C75A9B1C5ADC7100
                8ED9FA521C0EF51B3E17350B4DCD6962941B2691CE739E955E698820E734D792
                A8CD381939A691B53A3763A7977B6318FC6A84CC55BD40A592619CE7AD34306C
                E7BD69A6C7A10872A2232027D2A29FAE4734F9A319E2A3104B229D91B30C7619
                3F9544F4D0E88D96A713F17AF12D3E15F89E595F697B5480E3D5DF68FCF35E7B
                FB3BFC471A3DFDA786B58711E9D74A05B3B9FF005331EA0FA2B1C63DF8AF4AF8
                BBE09D77C5FA0DA687A51B7B7B792E7CCBD9267C651572AAA0649E79CF18F7AF
                3A4FD9E7570A0CDABE9ED212188024E587E1D0761D8F35E757A904ACD9C35AA2
                9BB23E86D5ECF2BE746BF27F11CD72D760248481F2FAFBD37C30FE28D21E1B3D
                5E18352B158FCB3716F26E922C74041038FD6B535CB4FDDBB42329C1DA46083F
                4AF26538DF4315A2B3325DF0AABD79CD6ADA9548547F11AC1DD9607A853838AD
                28EEB6600C63158CA449B306D04E7D335A8B222447CC215506E3F4AC4B49D5FE
                600F039C8C552D5B5113C4D6D016D99CB1C7E95929F425EA42D2B5DDCC93CADC
                BBB1FF0080E38AB22287660BC8723D6A846DF2824720715692604293C1E954A3
                D4BBF42C3DBC46302392453EE3349058CA8DB91D1B3EF8A4473EA7F3A9FCDDAA
                3924FB1AA7414B561664A219100DE38A52B9070322A48AE15931D4F704D4AA01
                5E001ED50E8B44389045D490A7701C0CD6B44C8A803313E840EA2B2D9BCB24A9
                01874CD457DAE5B69B2240C533B73866C11C91FD292892D33E0112C96A24DCAB
                F380B91D80AB9636736AB30882B16C840A8B9393E9EB544CAD3AAC6899653C92
                B5E93F0A6D7EC7657FAD32AB4B6EA90DB027FE5A6E3B8FE42BE9A5EEABB1537A
                9EE5E0B9BFB47E1DF85EE95C151A7470300724326462B6D632507EEB71031C8A
                E33E1327D8FC213E941B78D36EFCB539C1CBA173FCEBB3DD2655532475201AB8
                CB995D1F478769C55895C089540400D2C48C0297D818738151C60B6465F76738
                3533CBB1C2900B819CE3F4AAB9D5D0B287099C8CD2ACDCF4C9AAE19C2EFC8FA6
                29FBB1839009E4D34C9712C0B893270B802ADDA0924218F02A8C4448C307033E
                9D6AF25C0886D14EFD8C2A2E91469A3B449F2F6AD8B10444A1B9209CD7277176
                7ECF2943C8527F4AEB2DCFCB9CFA7E3C553D4F27151715A96777A70298CFCE0F
                6A6484E7D298F9DA2848E38C6E3A57C8EB5565936739CE39A25241033D6AB4FF
                0077AD6F1EC74C20897ED0AF196FD2A9CC03022A24DC0ED5E7278E6AC436F2C9
                95C60FBD26D27A9BA8AA7A94DA3663F2F6AB36D61712E08002FD6B423B786CD0
                34CCA4F5C75AAF7DAC2C711F2879683BE335C75B1518BF7489622527CB4D1379
                16D6881EE1C120FEB55AE7578572B03051DF15CBDF6A124CE47987CBCE79EF54
                84A49E0F15E5D6C4CA64BA2DEB3674B26A81801B98851C7A0F5C77FCC9A7477D
                1B3633CE3AE07F8572E262377CE71DEA58A6C125988C0F98E381F8D70CA5725C
                15B43A9372B8043649F5F5ED48D7D024C13CC0091F301CE4FBD6148C62B64690
                ED2E3807A8AC7BB9B0ACEAE437406B372691935D0E92FF004FB7910CD6C30EC7
                2554F5358244E25606270578A822D4842A1A3987998E549A82E35A32BFC8A43F
                43CD62A777622ED686B1BA778C26F6047614E400AE39FF00135896F785F73027
                77BD585B895BF880FA56F08A04CD424A91D054AA59B18E6B2C16DB93926AC432
                1518DFFA56EA282FA9A40B0073FCE9F0B90719E0F154D4E586589A9C0C2E770A
                D544D2E5D8F19E0EDF7A9E391B69C3703BD550A5900F6A9630A8814024E7D69F
                292C9E7532C242637918C9E9F8D78EF8C65D425D7663A8C4EF3A80BB90150C07
                42057B1A10031079C70319A734513905E20E00C29750C71F5FCE8E4D74224AE7
                C373E9C74E8598B2949002983D7D6AF687E235D323B989D4B42DB762AF42D924
                B7EB581AA5EB4D20E70A33B42F38AAF696F35C4B88637908E0AA1FBBF5CD77EB
                25796864EA599EF9F0275C6D5351F175A4A31BA28AF538E9B06C63F8E457A8A0
                31C8E54B704AE71D6BE79F875AEC9E0C922BAB855CDEC8F6B7A32A4F92CB110C
                0E78F9B2715F455D7971CEC033346EC5908E8C339CFD302B4A73E67647D0E02A
                A9C6C86BB15524BB6E3ED52424050C4824F5A88C88C06D2C00EB9A7A37FB471E
                F5B3BA67A5B93127070011F5A14EF9075E9D299977CAC7B7356E002220BE0B63
                9E3142BB224D243989441B460D2212D8DD4F7F9C640E299E5E002339AB3356B1
                2050DF20FE2E0D755A45C2CF1819F981E99AE51011C83CF6A8D6E6E2CE759223
                D3A8CF5A2F639B1141D6565B9DF1F98E011EFCD238E315C847E2A08A3CF84E73
                C906AC8F17D86D1B96604FFB3D2973AEE79EF035E3F66E6E4E09E7D2AACBD09E
                A3BF358771E2DB7C911C523376E2A9CDE219E427CA8B8C7535A7B78AEA6F0C1D
                6EAAC6D4FAA2DA4DE5A45BCF5527BD2BEB33CB1E502A8F615856D7C6E676FB5F
                43FEAF03040E7391E9C568AC5B08E3E56008FA119E6BCDC45477BA7A0AA518C3
                E2DC91EE5D9812D927AD66DFCCDB31B8E33D3357D940849C739E2B2A64625B3C
                8EB5E7C9B7B18A76D4CD965DCD822984B007B0A9E48C06CD569492D8CF15CEEF
                D4993B8F8DC28C96CE7D6B4B43B1FED1BC5498FF00A247FBC9CE71D3902B208D
                CE171C7D6BA98545A782D197FD75EB60328EC4123F419A98ABBB184999DA85D3
                5EDDC93C9B4076DC001D00E00FC3AE6B2351F9AD8E0ED39AB93231C6D1819271
                E9C553B9C6369FFF005D54E04A399773148CCE0103B9EF4C4951642631972D8E
                9D0D5EBEB76918A0C73C8ABBE1DD35656BE0EB964906323DAB9251E57A09A5B8
                69B00917F785813CD681B39100F2CF06B6ADEC17628F2C6718CE687B730B9127
                DCC76AF42925620CA4595170CBC7D6AD42AA547F7BD2AD79782171C11914862C
                F0171EA735BD90ECC02E0E5C638C75CD4A9B080067342DAC9C0CEE1EF4AAA636
                F9D718AD3D0B2C1DCC4056C0C54913040077EE6A18D95D59770C9F7A7C4AD923
                8E3F1CD56DB869D4B76E577139C9EDED57118AA808C028E99E6B3A3658C6E3C9
                079157D674DA3E4152ECF62AD73E2EBCF0C5AE80962DABDCC77934D6EB7260B7
                6C840EA1955CF6F9594FE27D2B36E750754F2D079718F982A2E32076F7A9CDBD
                F6BD7F75750C524A370DFF00DD8940DAAA7B02074E79E38AB50E896E8E8D7DA9
                44B20192A8199931EB4A7349DE6CF2D2BEE54F0FE917BAF5F4D6967189E58D0B
                CA01E1114F258E3800739E7A57D19E03BB5BAF87FE199BCDF3E5168B6D23A9DD
                CAEE2013FD6BC7748F274D5B98F4C96ECDFDCDBADBB1230462418181D72703DF
                35EB1F0F347BED0BC3F7967A86C0AEF1CB6F0039F286D20863EAD9E95A50ADCD
                3B45687B397B7095EDA1D3C38F358380C38E86AC210EDB540C0ED8AA91A4A028
                418E39C8AD3B68D514647CC457A5B9F42E5D496DD151090006C7A51261994E3E
                B4E71C641C534714D2B196EEE38B151802852C7249E3D3140618C62901C9C0EB
                4C04249C81C531E12E9926A54425B383B7FDD356540DB820D0D5C5CF6D8C19A0
                2A08009FAD5516A5C9DCA315D2496EB2720803DF8ACFBE9EC74E87CDBCBA8625
                2700BB8E6B2705D4D63888A5AEE63258B8919863EBED5318D638434A551705FE
                638381C9E3A63F1AE5FC43F15742D3D5E3B00F7B28E018C6D5F7393E95E41E28
                F1BEB7E22170B24A21B373FEA2018047FB5FD6B9E528C4C2B661182D373B2F88
                3E3F86EA0BFD2746BADD12810CD711361A57593E658DBD36B024FF003AF58F84
                DAECDABF8434BB5D5C20D563815431E0CC8A485623B3715F2B69525BC5AA5A49
                3A0FB30957CC5C755C8C0FAE4039EF8AF603AC4B61AD5ADF40CC16DA769D401B
                772ED2718EC0838AE4AB372D0F3A3CD88BC99EEB72854B478E8483F956648B82
                5B1FAD6DCD2C37D6B0DF5B32BC13E1D5D4F0723FC78ACF788B2302315C92EC73
                C5BB18D76BC66B35D09624722B72E6DC63A74F7AA0F1107A62B2065290810CA5
                4E5821FC38AEDB5689534FD36041B638A15DA07FBA07F2CFE75C8490E2298918
                F94E4FE15DCEAB1192DED71D042B83F8538E8CC1EE71F73BD5C81D2B3AE149CE
                EEB5D15D40C3AA8FAD645D46792077AB9582C668894B6E61DAB574375FB5CB0B
                10AEE7781EBC7AD5609F29C8ED5572F1C8AD19FDE03953EFDAB171EA07730C7F
                2F4E075E6A4F214A00EB919C9E7B547A4DCC7A85909D7BE1586790C2AE4680B3
                020E3EB5AC64676B196D6CC1DB278CF1C76F4A6793862369FCEB6BCADC30474E
                955A485831C2D6F165AD48228599805182072334AC8067A13E86AE24410E73C9
                1CD3DAD948DCA32D5B2B14D76325E004E76807DB8A91AD65455F2E43CF6CE6B4
                1A121464734E1106C7CCBE9C55EBD0168CC377F2A36590307CF5C5305F0C0F9F
                1F856CCB69B9C9DBC01D49E2A93E9C19B3B33F415695CEAA5CADEA7C9819F4CF
                09DDE931EA3148B7773F6996D957E57600632739E0F7F6ACE85C6781B54601C1
                3C553B7C3BE5F223E99F6E73FA1FD2A49E467B490C2A0B9DAA8ADD0E595707FE
                FAAC395CB7DCF32941F3247B3FC34D0A2B0D2EC35A9CABDFDF27996C8A726DA2
                2A431E7A12DC83CD7A3D9C21654009D8793E9F857371A0B16B3D391FE4B0B74B
                6C67D07CD9F5C31C57476CE3C9501C138CD7653858F72149A8AB1B0111ADB6BE
                318CF1FCAA258DD9B091614772D525AA02D286E46140E7DEAF451A919C838E71
                D289D4945D90BDACA0ED733A5B7B851B9143E7B66AB31B953868581FA5748802
                AE703FC29EC9C8E7AFB52F6937D4A58B97548E5D9AE07FCB16350DE5CDC436EC
                D0420C8013B4A920D761E5A81CF7A150020A838EFD2B372A8FA89E2FC8F20F0F
                78ABC437BE2596C351D322B2B5B685A4694866573D821CF3FD2BA77D56723202
                004E07CB5DA496365383E746AAE46DDCA31C564DF7862161BAD5FA9F5AC2A4EB
                A5A4885886CC0FB7CC4125F2476C548CD657B1F93AA5B4571030C1491011FA01
                8A8AEB4C96C99BCCDC10F1C1CD31094E5D328070319CD73FB59FDA63E6E6D19C
                E6BBF06F40D5612DA1DD369D74324472B6F8F07D3B8FCEBC5FC6DE08D6BC1F28
                FED185BECD203B2E621943CE304F626BE9AB1B9657508EC100E47F87A56D9F27
                55B47B4BF8629EDE75C4A8CB956E73D2BA69B5230AB453D8F8823DD2128CA583
                3062072463B8AF4FD1F56179636F2CAA4CCCAA92238FE2033FD2B67E227C3683
                C397C750D32291B4597692AED9FB348CD8DA0F71EFDAB8EBAD42DED9439700ED
                DC01182327AFF4AE6C45469F2A4634AACB0EDB3DA3E15F8AA088C7E1DBC7D90B
                822CD9BEEA30E4A31ED9EC6BD226B729E6655B0A79C76E71CFA66BE359BC4320
                9316E9855C05F5201C8CFA9CF7AF69F867F14AE6EAD058EB311BDF223DE6EC90
                65084F01B1D476A8B548ABC88F6BCEEF13D527873C804D539EDC647183DAACE9
                FADE99A9902D2EE2DEC3EE31C107D2ADDC420296C640E011DE9692D8B7CDD4C2
                7B7731C8B8E0A906BAEBA3E65A5B30E14C2A47E5583246164E0920E0F1DC1F4A
                DCB3226D1AD4A7CC114A13DF2A718A515EF58C9EE64EA0BB514804D644AB9E0A
                9E4FA56FDE2718EB5973C782320FE75A6EC68C96882B139AA3749F37B77C1ADA
                9E25C70BD7DEA84F1283C2F344E20C8B44D45F4CBB2F9CC7211E6A9FE2F4C7A5
                7A05B4F0DD411CD6EC1A37191FE07D2BCD59599C86E9DB8AD0D1B549B4D95CAB
                655B965EC71E83B565156D0971B9E883A6D5539C6734D3190092320D56D3757B
                5D422565902C83EF29E2B4F6AB292A3A0E3DEB78EAC8DB72A346876E0106A554
                C6076EF5215656C904A1EE052955C03CD6E931DEE4401DC428054D3E383692C5
                571FCA9E8B8058648E9C29A65E5CC1656F2CD732AC70C63E766380BF5CF6ABBD
                84C590617A6D03927B5713E24F1FF86FC3FA8FD8B56BE5FB505DC54483E51B88
                00E3A1E2BCFBE2CFC6696D8CDA6784D4F987892FA55E10FA47EA7D0F6F4AF9FD
                2E3CF0D2DE334D70EECF248F82CC4B139271EF45FA9AA7CA86457215D55CF1F4
                AD1B4559D6278D832F991E074E924649AC72A644CAAEE27D2B4748B668AEA275
                C92D2C68A0742A658C7F5AD2C9BD3732A2FDF563E811722E6E27B98C6FB6BA9E
                568A5C70EBBD882A7BE7F4C56D59A0014EEC8C74CD554B25B7C580005B5A168A
                351C05C16E47A75E6AFC362A08D99208AEAA69A47D3C669C55CD086678983236
                33C0EF9ADAB5B832428485DE7AE3B561C30CAA8303201AB56B0DC647967EEF5A
                52A6E7B9CF523196C740398C61BAFB54A090067D3159B0BCB19DB21AB0642578
                3D6B96507038A54EDB168C8381C7E746F3D8F154D9F70006011ED51F9EE18866
                03D0FAD73FB42396DD4BACE33D39A7C33889BE4C64F506B266BD11F59016F415
                0497AC4FEEF76719E954A57427B6A7444417F13232A6EEE3A573BA9E95F63632
                282633D70738150B6ACF0C8ACCA703D16B734ED56DB5080A4A55BDBA567249AD
                4CD3B339B86328B9C0DA4D68DA318DE320E3838A9EFAC920932806C6E7AD5586
                37F3371E8A0E056704E2CE884AECDA9EDA1BDB368668D6489D4A98DC6436462B
                E51F8B9E05B9F076AC2687CD9B45B9959A1909DFE4E7FE59B1EFCF4E95F58DA8
                2D00CFE86B2FC4FA359EBDA4DCE9FA9C424B6994875518C1C70C3D08AF4231E6
                8DD1954A4A7748F8914F018E70083D7A71906BA3F02EA11586B01249BC98E585
                E3760A07206547E759FE25D02E7C31ACDCE917CC24789B6C4E3812C6324303DF
                DC76ACA604B0CF3C96FA9C71594E3F659C49BA323D7DE724A3453EE0CC4068F8
                CF1C679EF57E5F15DEE856CB3C97B75163E4010EFCE7B807BD78E58DF4B6E4A0
                91C0DA013CF183C9A75E497520512CEEEBF794331E6B8FEAEF9AD7D0DAA635CA
                3CB63D35BC5F75AD6A73F957F75E445337D9831C3142BDF1EF5ECDF0735A5D43
                4BD534D94EE9AD25F3D33D5924CE083DF9539AF9534CB4BD79D4DBA344B8C6EC
                EDE3D33DEBD6BE095FBE8FE3FB1FB4DC195354B792D5F27E54208901C76F9811
                FF0002AA928C1E8C978953872347BF5D29DE4E2B2AF012C31D075AE82FD30ED9
                038F4FAE2B225037918CE6AD2BEA35B14580D9D2AA4D1679F7C56ABC7818D9CF
                D6AB491B118DBDFD69C9219897119EA14706ABB45C671CFD6B625870082BF8E6
                A9491A9073F281C67359F289B2A34CB6E3CC693CA8D54C85F3821477FAD735A0
                7C4DD72D0C925E6DB9B4791E48D655C320E8067F5CD56F887ACA472C5A0C07F7
                F769E7DC657FD5C43A03CF04FA572179265A472102ED2495F4038005632E68FC
                2C70873687AF0F8C16D188CDD69B280E3EF46EA467E94D9BE33E9E14EDD3AED8
                6393B857893DA4B79771411A02D1925DC8185F9801F9E73ED5AF7764969A7379
                632E530C4283D78A9F69516899C95AA383B44EC75AF8EB7524129D334F8A166C
                61E572D819C631C579A788FC6FACF888CCF7F792CC54165881F909EDC0FF00EB
                D71F6D379AB192BB8720823A60D2F98CB20F24F2BE831935D767F699CFED9CB7
                36353B459937C6BC6300FBE39AC75B7540411CE6BA9B50B3E9E482A4063B483E
                DCD576B2889C91CD737B6E56D335F6BA1C9A4ED1E0A9C0079C56FF0087C45FDB
                3A6492E562FB526FC36400766D18FF007B158FE46D1B4AA9079CE69373A412F9
                00F9EC2370338C1F354E47D02FEB5E9C5DD9BD2B29267D63716DFF00132BB046
                DC4EF9DDC75248ABD6D17030578EBCD4705CC7AAC169AA404491DF40B32B7638
                1823F026AD247860000B9EA4575A7647B6AA7BA3ADD51558EFCB75C629613966
                2A48E3B77A931BCE0C9F2E3A63AD4B140C1C05500750734DBB99B9924485806C
                76EE6A7DB851F2FEB4D55739071F2F5E69FC94C93F87AD632D0C5CAE57982762
                DBBEB517901D492381CD4A846F254639C734A4B392A064FB562F522C529EDA10
                A180507B93515BC51C331955707D49ABC6DC6DDD28E87A66A8EA3325BDA3CEFF
                002C51A876CF38159CDD909ABE8477015E10C9FEB18E4F7005605BBC96DAC446
                23B7CE0485EDC77A21D45EEE1468838900C903B64F4ABBA35A3DC6A0F248BC44
                8361F4CF5AE16AF22542DD4EBD59AEACCACCA3CD1B48AA489FBE239C7435B11C
                60C41F18620026A44B54500AAE0375F7AEA8C2E546761963100A39C8A926550C
                3079A9BCA2170A71F8550BB2C37609E057A346162E2F999E5DF1AFC2235BD08D
                DDAC2BF6EB440C8CBC1DB9CB81F857CDAB6333E16242F938E0739C74FCF8AFB3
                2FA5255C140472403CF046315F3FFC4CD3A2F0DDFF009F650116D76F2328ECAC
                24C75F7C56189838FBD1162B0AF979D1C1C1A0CA496B9711A01C0CFCD9AD554B
                3B24FDEB07651805B9CD1A0C775ADBB4AEDE4DAA67040C16ABDACF836E65B379
                2C23BA9A65E0050487CD79739372E49BB1E67B19B57E861EA1AE08D762F181BC
                01DB8CD7A0785AD85BE93677C18FF68CC826DF9F95338603FA579C5C78475F74
                6924D22FBCBC052C207E3031E9FAD777E1DB99D348B6B6BE8E482E6D90C4C92C
                6C8A42955041C727BD5D5A54E34EE8DA8538A96A7D1FA46AABADF876D3508C60
                CAA5197D0A939CFF00DF3FAD0ABB9BA571FF00092F0CDA5F8961724A4176AC80
                745050118FC8FE75D5DA49BA5233CF5C7B55D27EE9D0E2B525963C76FD6A0922
                E3232735A46253193EDEB51043E5A82A727A62ADEA4EC65DC424A0DA8C48EC39
                26B0FC4F7D6DA1E993DE5C94655F9234EBE639E807AF38CD69789F5DB5D12C8C
                D33EE7624471A9F9DFDC0AF0ED53C5371E22D405CDDAB44B1B15B78235CAA8EE
                71EB58D5A9C88CF57B152F2D64B89EE2FEF181D4A73E74E4F727851F4C76ED58
                7737F2413BDBB94DC1B039EB5A97B34F1DA19046E7628FBC39273D2B8A799A49
                659188F31F2DF9E411F875AE6A51752EE473D6AB28E88F53D38235A0541C0EBC
                60938CFF003A9AF220D6AD191C7CAA0038E7350E8D296B489D8A80140F4C6501
                FEB57A61F217278DC391DAA64ACEC8E7776AECF235D3D5833D9C8385DDB49E73
                BB9149A6D95C6A17B0DA5A29F3656C71CEDE7EF1F4029F2C8D6F7D771AB6D549
                58A83E99C7FF005EB5F42BE5B7D44CF1C622B8E630EBC0DB8E7F3AED6DC637DC
                CE31D4EBAC7C3D656B6E63592494A9CEE56E09C723FF00AF55EE34C844A44523
                15F76ABF0CEAD080FB4BED24543284F35B06355CF1CF51EB5E6CA4E4EF73A952
                56BB3CB6520C7B7009CF38A8773894310700E1801D3D057D2D1F80FC396F1BDB
                0D363913E56DCF92C4FD6B2A4F0278725BF854E9CAAB21CB6D761D3A77AFA08D
                192D4F423829AF7AE84F80DAA36A1E067D2677FF0049D1A4081739263939523D
                81AF478D18B8C64B0AE2F46F08E99E17D612F746F3E0947EE197CCCABA6C3C30
                EF5DFDB132C2B21E1BAF1C56AE4D6E7524E2AC105BE54B4A39153AB06257A003
                0288C02873EB532A2E071D695EE66DB1A5BE4C10303BD46EC5980419ED561A25
                0A4E3A0A8918E40C0C1E293248C45B41DEC077E0E6A5460A008D7AF534B20007
                00539188518ACDE804330CFCA0F3D73E95C878EA7CB5BE9C09032649147A63E5
                1F81E6BB58D46D0D8E4B006BCBAE6E24BAD62F259DB73F99B33ED9AE7A9AA1C5
                5D9B7A0C0376F2BCB3723DB1C5761616EB1950A3036807DF9AC3D09177818FE1
                CD7536A0647D2A5FC362657572DC6011B71C62A74055B61195C641F4A6C00799
                F85599001167BD75525A2306F523206DAC9BD6D8C72BC1F7AD490E133ED58D76
                C64976B9C8AEE4D2573A682D6E64DDB2C84AA824F7005656B7E1987C49A4AD8D
                F405626996576C7CD8049C0F4CE6BA4755850B228CD735A8EB7791C72EC65044
                8141C72057255ADFCC774AA732E548B567E1DD1343B748E0B58D1231F286193F
                FEBA6DC6AD121296D6E1CF4E4015CE4D7134CCCF2C8CEC47734D88EDC103AF5A
                E275149DD1C529A5EE9A771797F2B16489157D0018ACE9A39A6C79F099029E38
                2401DF3EB56A26C630055D8E69147CAC57E959CA0E7A5C8E6B153E1C5B3699A8
                78AC42AC91DD4104CAAE3856442A401DF3D6B7ECE762E720FA9E2A9C3753163B
                9B39DC0F1D401D0D43217368CF1CAF0B138CC6715D34A1A6A6D4E1169B3A89B5
                1B5B3B60F713220C776C62BCE7C7DF13A2D2A258EC2127CD385B971C0FA5731A
                F4938BF21EE6694E782ED9C572BE2EB686E6C0C73203B66440D9E4063CD6539E
                B631AC9415D185A9F88A6BCB5F31EE65B89CA04524962A4B74F615D659A5AD95
                8288E17470A0FCABC924807F9D733A8E8F6B67673BDBF988D14F95C375C0CF35
                D6DADCC9259EF620B796C7A7B8AC1F213879C5BD514D6F1DCCCD08520B965DE7
                A7518FD2B97D6747B99352BB6B3854C12E1908EA0951918F623F5AE8822DBE9C
                1900258BB9DDCF20B9A446DF7D33E0294C850BC01F3814AA54F671BC5138BE49
                22B5BDC4AC16274650B1C6DB738E7600467F0CD6A595FB472C6B29CC4CCBB87A
                0E78FF00C77F5AC7D7D992F34E54620397DD8EF88CD685C22C772C8A30A6343F
                8E1EB382E6B49F5334A3ECCE0756C8D6EF090C10153F77B15CFF005AECB42D33
                4F8ADA337312CB70C43BB336766E19005646B68B1EB97240C85488E0F43F22D4
                96EFE5490AA2AE0EDCE7BFCA6BA2734E3CAB43929C632958D5D7E1B8B4B39A7B
                59E444008DABD318E9591123DD428E1E67006DDCAB90715D4DE4718D39CF96A4
                95E73F4AD1D0ADA2B3D22D61850041186E79E48C9ACA9C39B43AE3855376B9FF
                D9}
              Stretch = True
            end
          end
        end
        object rbSmall: TRadioButton
          Left = 16
          Top = 272
          Width = 137
          Height = 17
          Caption = 'Small Thumbnails'
          TabOrder = 3
          OnClick = rbSmallClick
        end
        object rbMedium: TRadioButton
          Left = 16
          Top = 296
          Width = 137
          Height = 17
          Caption = 'Medium Thumbnails'
          TabOrder = 4
          OnClick = rbMediumClick
        end
        object rbLarge: TRadioButton
          Left = 16
          Top = 320
          Width = 137
          Height = 17
          Caption = 'Large Thumbnails'
          TabOrder = 5
          OnClick = rbLargeClick
        end
      end
      object GroupBox15: TGroupBox
        Left = 328
        Top = 117
        Width = 401
        Height = 44
        Caption = 'Thumbnail &Storage'
        TabOrder = 1
        object chbStoreThumbs: TCheckBox
          Left = 16
          Top = 16
          Width = 281
          Height = 17
          Caption = 'Store thumbnails with collection (file name.abt)'
          TabOrder = 0
          OnClick = OptionsChanged
        end
      end
      object GroupBox18: TGroupBox
        Left = 328
        Top = 24
        Width = 401
        Height = 89
        Caption = 'Thumbnail in-memory &compression'
        TabOrder = 2
        object rbThumbCompressNone: TRadioButton
          Left = 16
          Top = 16
          Width = 369
          Height = 17
          Caption = 'Do not compress (fastest, but needs most memory)'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = OptionsChanged
        end
        object rbThumbCompressLZW: TRadioButton
          Left = 16
          Top = 40
          Width = 377
          Height = 17
          Caption = 
            'Limpel/Ziv compression (no quality penalty and relatively effici' +
            'ent)'
          TabOrder = 1
          OnClick = OptionsChanged
        end
        object rbThumbCompressJPG: TRadioButton
          Left = 16
          Top = 64
          Width = 377
          Height = 17
          Caption = 
            'JPG compression (slowest but very efficient, slight quality pena' +
            'lty)'
          TabOrder = 2
          OnClick = OptionsChanged
        end
      end
      object GroupBox12: TGroupBox
        Left = 328
        Top = 168
        Width = 401
        Height = 57
        Caption = 'View as &List'
        TabOrder = 3
        object Label18: TLabel
          Left = 72
          Top = 24
          Width = 5
          Height = 13
          Caption = 'x'
        end
        object Label19: TLabel
          Left = 144
          Top = 24
          Width = 26
          Height = 13
          Caption = 'pixels'
        end
        object seViewListW: TRxSpinEdit
          Left = 16
          Top = 20
          Width = 49
          Height = 21
          MaxValue = 200.000000000000000000
          MinValue = 16.000000000000000000
          Value = 16.000000000000000000
          TabOrder = 0
          OnChange = OptionsChanged
        end
        object seViewListH: TRxSpinEdit
          Left = 88
          Top = 20
          Width = 49
          Height = 21
          MaxValue = 200.000000000000000000
          MinValue = 16.000000000000000000
          Value = 16.000000000000000000
          TabOrder = 1
          OnChange = OptionsChanged
        end
        object rbViewListIcons: TRadioButton
          Left = 216
          Top = 16
          Width = 177
          Height = 17
          Caption = 'Show Icons'
          TabOrder = 2
          OnClick = OptionsChanged
        end
        object RadioButton2: TRadioButton
          Left = 216
          Top = 32
          Width = 177
          Height = 17
          Caption = 'Show Thumbnails'
          Checked = True
          TabOrder = 3
          TabStop = True
          OnClick = OptionsChanged
        end
      end
      object GroupBox20: TGroupBox
        Left = 328
        Top = 232
        Width = 401
        Height = 57
        Caption = 'View as Small &Icons'
        TabOrder = 4
        object Label17: TLabel
          Left = 72
          Top = 24
          Width = 5
          Height = 13
          Caption = 'x'
        end
        object Label20: TLabel
          Left = 144
          Top = 24
          Width = 26
          Height = 13
          Caption = 'pixels'
        end
        object seViewSmallW: TRxSpinEdit
          Left = 16
          Top = 20
          Width = 49
          Height = 21
          MaxValue = 200.000000000000000000
          MinValue = 16.000000000000000000
          Value = 16.000000000000000000
          TabOrder = 0
          OnChange = OptionsChanged
        end
        object seViewSmallH: TRxSpinEdit
          Left = 88
          Top = 20
          Width = 49
          Height = 21
          MaxValue = 200.000000000000000000
          MinValue = 16.000000000000000000
          Value = 16.000000000000000000
          TabOrder = 1
          OnChange = OptionsChanged
        end
        object rbViewSmallIcons: TRadioButton
          Left = 216
          Top = 16
          Width = 177
          Height = 17
          Caption = 'Show Icons'
          Checked = True
          TabOrder = 2
          TabStop = True
          OnClick = OptionsChanged
        end
        object RadioButton4: TRadioButton
          Left = 216
          Top = 32
          Width = 177
          Height = 17
          Caption = 'Show Thumbnails'
          TabOrder = 3
          OnClick = OptionsChanged
        end
      end
      object GroupBox21: TGroupBox
        Left = 328
        Top = 296
        Width = 401
        Height = 57
        Caption = 'View as &Large Icons'
        TabOrder = 5
        object Label21: TLabel
          Left = 72
          Top = 24
          Width = 5
          Height = 13
          Caption = 'x'
        end
        object Label22: TLabel
          Left = 144
          Top = 24
          Width = 26
          Height = 13
          Caption = 'pixels'
        end
        object seViewLargeW: TRxSpinEdit
          Left = 16
          Top = 20
          Width = 49
          Height = 21
          MaxValue = 200.000000000000000000
          MinValue = 16.000000000000000000
          Value = 32.000000000000000000
          TabOrder = 0
          OnChange = OptionsChanged
        end
        object seViewLargeH: TRxSpinEdit
          Left = 88
          Top = 20
          Width = 49
          Height = 21
          MaxValue = 200.000000000000000000
          MinValue = 16.000000000000000000
          Value = 32.000000000000000000
          TabOrder = 1
          OnChange = OptionsChanged
        end
        object rbViewLargeIcons: TRadioButton
          Left = 216
          Top = 16
          Width = 177
          Height = 17
          Caption = 'Show Icons'
          Checked = True
          TabOrder = 2
          TabStop = True
          OnClick = OptionsChanged
        end
        object RadioButton6: TRadioButton
          Left = 216
          Top = 32
          Width = 177
          Height = 17
          Caption = 'Show Thumbnails'
          TabOrder = 3
          OnClick = OptionsChanged
        end
      end
      object GroupBox22: TGroupBox
        Left = 328
        Top = 360
        Width = 401
        Height = 57
        Caption = 'View &Details'
        TabOrder = 6
        object Label23: TLabel
          Left = 72
          Top = 24
          Width = 5
          Height = 13
          Caption = 'x'
        end
        object Label24: TLabel
          Left = 144
          Top = 24
          Width = 26
          Height = 13
          Caption = 'pixels'
        end
        object seViewDetailW: TRxSpinEdit
          Left = 16
          Top = 20
          Width = 49
          Height = 21
          MaxValue = 200.000000000000000000
          MinValue = 16.000000000000000000
          Value = 16.000000000000000000
          TabOrder = 0
          OnChange = OptionsChanged
        end
        object seViewDetailH: TRxSpinEdit
          Left = 88
          Top = 20
          Width = 49
          Height = 21
          MaxValue = 200.000000000000000000
          MinValue = 16.000000000000000000
          Value = 16.000000000000000000
          TabOrder = 1
          OnChange = OptionsChanged
        end
        object rbViewDetailIcons: TRadioButton
          Left = 216
          Top = 16
          Width = 177
          Height = 17
          Caption = 'Show Icons'
          Checked = True
          TabOrder = 2
          TabStop = True
          OnClick = OptionsChanged
        end
        object RadioButton8: TRadioButton
          Left = 216
          Top = 32
          Width = 177
          Height = 17
          Caption = 'Show Thumbnails'
          TabOrder = 3
          OnClick = OptionsChanged
        end
      end
      object GroupBox23: TGroupBox
        Left = 8
        Top = 376
        Width = 313
        Height = 41
        Caption = 'Quality'
        TabOrder = 7
        object chbThumbHQ: TCheckBox
          Left = 8
          Top = 16
          Width = 297
          Height = 17
          Caption = 'High-Quality Rendering (slightly slower)'
          TabOrder = 0
        end
      end
    end
    object tsGeneral: TTabSheet
      HelpContext = 135
      Caption = 'General'
      ImageIndex = 54
      object GroupBox24: TGroupBox
        Left = 8
        Top = 24
        Width = 273
        Height = 105
        Caption = 'Preferences'
        TabOrder = 0
        object chbShowTipsOnStartup: TCheckBox
          Left = 8
          Top = 24
          Width = 177
          Height = 17
          Caption = 'Show tip on startup'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = OptionsChanged
        end
      end
      object GroupBox26: TGroupBox
        Left = 8
        Top = 136
        Width = 273
        Height = 105
        Caption = 'Finding Similar Images'
        TabOrder = 1
        object Label26: TLabel
          Left = 16
          Top = 24
          Width = 33
          Height = 13
          Caption = 'Match:'
        end
        object Label29: TLabel
          Left = 144
          Top = 24
          Width = 77
          Height = 13
          Caption = 'Detail Matching:'
        end
        object Label3: TLabel
          Left = 8
          Top = 80
          Width = 233
          Height = 13
          Caption = 'Warning: changing these settings requires rescan'
        end
        object rbMatchIntensity: TRadioButton
          Left = 16
          Top = 40
          Width = 113
          Height = 17
          Caption = 'Intensity (B/W)'
          Checked = True
          TabOrder = 0
          TabStop = True
        end
        object rbMatchColors: TRadioButton
          Left = 16
          Top = 56
          Width = 113
          Height = 17
          Caption = 'Colors (RGB)'
          TabOrder = 1
        end
        object cbbGranularity: TComboBox
          Left = 144
          Top = 40
          Width = 113
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 2
          Items.Strings = (
            'Low'
            'Medium'
            'High'
            'Super High')
        end
      end
      object GroupBox27: TGroupBox
        Left = 8
        Top = 248
        Width = 273
        Height = 145
        Caption = 'Sorting Similar Images'
        TabOrder = 2
        object Label30: TLabel
          Left = 24
          Top = 48
          Width = 206
          Height = 13
          Caption = 'Use slow method except for sets larger than'
        end
        object Label31: TLabel
          Left = 112
          Top = 68
          Width = 25
          Height = 13
          Caption = 'Items'
        end
        object rbSortSimAuto: TRadioButton
          Left = 8
          Top = 24
          Width = 257
          Height = 17
          Caption = 'Choose method automatically'
          Checked = True
          TabOrder = 0
          TabStop = True
        end
        object rbSortSimSlow: TRadioButton
          Left = 8
          Top = 96
          Width = 257
          Height = 17
          Caption = 'Use the slow but accurate method'
          TabOrder = 1
        end
        object rbSortSimFast: TRadioButton
          Left = 8
          Top = 120
          Width = 257
          Height = 17
          Caption = 'Use the fast method (may cause overlooks)'
          TabOrder = 2
        end
        object seSimAutoLimit: TRxSpinEdit
          Left = 24
          Top = 64
          Width = 81
          Height = 21
          Increment = 1000.000000000000000000
          Value = 5000.000000000000000000
          TabOrder = 3
        end
      end
      inline frFolderOptions: TfrFolderOptions
        Left = 296
        Top = 24
        Width = 409
        Height = 105
        TabOrder = 3
        TabStop = True
        inherited GroupBox1: TGroupBox
          Width = 409
          Height = 105
        end
      end
    end
    object tsPlugins: TTabSheet
      Caption = 'Plugins'
      ImageIndex = 49
      object GroupBox28: TGroupBox
        Left = 8
        Top = 216
        Width = 369
        Height = 201
        Caption = 'Filter Plugins'
        TabOrder = 0
        inline frmPlugin: TfrmPlugin
          Left = 2
          Top = 15
          Width = 365
          Height = 184
          Align = alClient
          TabOrder = 0
          TabStop = True
        end
      end
      object GroupBox29: TGroupBox
        Left = 8
        Top = 8
        Width = 369
        Height = 201
        Caption = 'File format Plugins'
        TabOrder = 1
        object Label32: TLabel
          Left = 16
          Top = 24
          Width = 271
          Height = 13
          Caption = 'Installed plugins (uncheck if you do not want to use them)'
        end
        object Label33: TLabel
          Left = 8
          Top = 176
          Width = 348
          Height = 13
          Caption = 
            'You must restart ABC-View Manager in order to view newly added p' +
            'lugins!'
        end
        object chlbPlugins: TCheckListBox
          Left = 16
          Top = 40
          Width = 169
          Height = 129
          Flat = False
          ItemHeight = 13
          Items.Strings = (
            'Jpeg 2000 reader (3rd party)'
            'DXF reader (3rd party)'
            'DWG reader (3rd party)'
            'AVI first frame'
            'TTF impression'
            'SVG Graphic by SimDesign')
          TabOrder = 0
        end
        object BitBtn1: TBitBtn
          Left = 200
          Top = 40
          Width = 153
          Height = 25
          Action = dmActions.acDownloadPugins
          Caption = 'Download more plugins!'
          TabOrder = 1
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            2000000000000004000000000000000000000000000000000000FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF0000000000000000000000000000000000FF00
            FF0000000000000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF0000000000C0C0C000FFFFFF00C0C0C000FFFFFF000000
            0000FFFFFF00C0C0C000FFFFFF00C0C0C00000000000FF00FF00FF00FF00FF00
            FF00FF00FF0000000000C0C0C000000000000000000000000000000000000000
            000000000000000000000000000000000000C0C0C00000000000FF00FF00FF00
            FF00FF00FF0000000000FFFFFF00000000008080800000000000C0C0C000C0C0
            C000C0C0C000000000008080800000000000FFFFFF0000000000FF00FF00FF00
            FF00FF00FF0000000000C0C0C000000000000000000000000000000000000000
            000000000000000000000000000000000000C0C0C00000000000FF00FF00FF00
            FF00000000008000000000000000C0C0C000FFFFFF00C0C0C000FFFFFF000000
            0000FFFFFF00C0C0C000FFFFFF00C0C0C00000000000FF00FF00FF00FF000000
            0000FF000000FF000000FF000000000000000000000000000000000000008000
            000000000000000000000000000000000000FF00FF00FF00FF00808080008000
            0000FF000000FF000000FF00000000800000008000000080000000800000FF00
            00008000000080808000FF00FF00FF00FF00FF00FF00FF00FF0080808000FF00
            0000FF000000FF000000FF000000008000000080000000800000008000008080
            0000FF00000000000000FF00FF00FF00FF00FF00FF00FF00FF0080808000FF00
            0000FF000000C0C0C0000080000000800000008000000080000000800000FF00
            0000FF00000000000000FF00FF00FF00FF00FF00FF00FF00FF0080808000FF00
            0000C0C0C0000080000000800000008000000080000080000000808000008000
            00000080000000000000FF00FF00FF00FF00FF00FF00FF00FF0080808000FF00
            0000C0C0C000C0C0C000C0C0C000800000000080000000800000FF0000000080
            00000080000000000000FF00FF00FF00FF00FF00FF00FF00FF00808080008080
            8000FF000000FFFFFF00C0C0C000FF000000FF000000FF000000FF0000000080
            00000080000080808000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF008080
            8000FFFFFF00C0C0C000FFFFFF00C0C0C0000080000000800000008000000080
            000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00808080008080800080800000C0C0C000C0C0C000C0C0C000008000000000
            0000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00808080008080800080808000808080008080800080808000FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
        end
      end
    end
  end
  object btnHelp: TBitBtn
    Left = 16
    Top = 480
    Width = 75
    Height = 25
    Caption = '&Help'
    TabOrder = 3
    OnClick = btnHelpClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333336633
      3333333333333FF3333333330000333333364463333333333333388F33333333
      00003333333E66433333333333338F38F3333333000033333333E66333333333
      33338FF8F3333333000033333333333333333333333338833333333300003333
      3333446333333333333333FF3333333300003333333666433333333333333888
      F333333300003333333E66433333333333338F38F333333300003333333E6664
      3333333333338F38F3333333000033333333E6664333333333338F338F333333
      0000333333333E6664333333333338F338F3333300003333344333E666433333
      333F338F338F3333000033336664333E664333333388F338F338F33300003333
      E66644466643333338F38FFF8338F333000033333E6666666663333338F33888
      3338F3330000333333EE666666333333338FF33333383333000033333333EEEE
      E333333333388FFFFF8333330000333333333333333333333333388888333333
      0000}
    NumGlyphs = 2
  end
  object ColorDialog: TColorDialog
    Left = 236
    Top = 65529
  end
  object OpenPictureDialog: TOpenPictureDialog
    Left = 204
    Top = 65529
  end
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 280
    Top = 65528
  end
  object alOptions: TActionList
    Images = ilOptions
    Left = 312
    object BgrColor: TAction
      ImageIndex = 0
      OnExecute = BgrColorExecute
    end
    object BrgFont: TAction
      ImageIndex = 1
      OnExecute = BrgFontExecute
    end
    object ShowColor: TAction
      ImageIndex = 0
      OnExecute = ShowColorExecute
    end
  end
  object ilOptions: TImageList
    Left = 344
    Bitmap = {
      494C010102000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
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
      0000000000000000000000000000000000008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FF000000FF
      000000FF000000000000FFFF0000FFFF0000FFFF000000000000FF00FF00FF00
      FF00FF00FF000000000000000000000000008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FF000000FF
      000000FF000000000000FFFF0000FFFF0000FFFF000000000000FF00FF00FF00
      FF00FF00FF000000000000000000000000008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FF000000FF
      000000FF000000000000FFFF0000FFFF0000FFFF000000000000FF00FF00FF00
      FF00FF00FF000000000000000000000000008000000080000000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      80008080800000000000FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000080000000800000008000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      80008080800000000000FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000008000000080000000800000008000
      0000000000000000000080008000800080000000000000000000000000000000
      0000000080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      80008080800000000000FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000800000000000000000000000
      0000000080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000800000000000000000000000
      0000000080000000800000008000000080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000000000FFFF0000FFFF0000FFFF0000000000FF000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000000000FFFF0000FFFF0000FFFF0000000000FF000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800080008000800080008000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000000000FFFF0000FFFF0000FFFF0000000000FF000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080008000800080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFF00000000FFFF3FFF00000000
      80033FFF0000000080033FF70000000080031FF70000000080031FF700000000
      80033FF10000000080030CF10000000080030C77000000008003FF7000000000
      8003FF70000000008003FE3F000000008003FE3F000000008003FF7F00000000
      8003FF1F00000000FFFFFF9F0000000000000000000000000000000000000000
      000000000000}
  end
end
