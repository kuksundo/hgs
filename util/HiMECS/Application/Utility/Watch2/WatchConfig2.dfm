object WatchConfigF: TWatchConfigF
  Left = 143
  Top = 244
  Caption = 'Confiauration'
  ClientHeight = 424
  ClientWidth = 398
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 383
    Width = 398
    Height = 41
    Align = alBottom
    TabOrder = 0
    object BitBtn1: TBitBtn
      Left = 74
      Top = 6
      Width = 75
      Height = 25
      Caption = #54869' '#51064
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 224
      Top = 6
      Width = 75
      Height = 25
      Caption = #52712' '#49548
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 398
    Height = 383
    ActivePage = TabSheet4
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object TabSheet4: TTabSheet
      Caption = 'Simple'
      ImageIndex = 3
      object GroupBox1: TGroupBox
        Left = 16
        Top = 19
        Width = 321
        Height = 150
        Caption = 'For Simple Watch'
        TabOrder = 0
        object Label12: TLabel
          Left = 66
          Top = 25
          Width = 133
          Height = 19
          Caption = 'Name Font Size:'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label13: TLabel
          Left = 67
          Top = 58
          Width = 132
          Height = 19
          Caption = 'Value Font Size:'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label10: TLabel
          Left = 84
          Top = 90
          Width = 113
          Height = 19
          Caption = 'Average Size:'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object NameFontSizeEdit: TEdit
          Left = 205
          Top = 22
          Width = 41
          Height = 27
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ImeName = 'Microsoft Office IME 2007'
          ParentFont = False
          TabOrder = 0
        end
        object ValueFontSizeEdit: TEdit
          Left = 205
          Top = 55
          Width = 41
          Height = 27
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ImeName = 'Microsoft Office IME 2007'
          ParentFont = False
          TabOrder = 1
        end
        object ViewAvgValueCB: TCheckBox
          Left = 38
          Top = 121
          Width = 187
          Height = 26
          Alignment = taLeftJustify
          Caption = 'View Average Value'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
        object AvgEdit: TEdit
          Left = 205
          Top = 88
          Width = 41
          Height = 27
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ImeName = 'Microsoft Office IME 2007'
          ParentFont = False
          TabOrder = 3
        end
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Trend'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label17: TLabel
        Left = 52
        Top = 73
        Width = 137
        Height = 19
        Caption = 'Ring Buffer Size:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object ZoomToFitCB: TCheckBox
        Left = 43
        Top = 34
        Width = 238
        Height = 26
        Alignment = taLeftJustify
        Caption = 'Zoom To Fit In EveryTime:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      object RingBufSizeEdit: TEdit
        Left = 191
        Top = 70
        Width = 90
        Height = 27
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ImeName = 'Microsoft Office IME 2007'
        ParentFont = False
        TabOrder = 1
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Etc.'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ImageIndex = 1
      ParentFont = False
      object Label2: TLabel
        Left = 3
        Top = 64
        Width = 91
        Height = 19
        Caption = 'Watch File:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label14: TLabel
        Left = 238
        Top = 160
        Width = 71
        Height = 19
        Caption = 'Interval:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label1: TLabel
        Left = 11
        Top = 253
        Width = 95
        Height = 16
        Caption = 'Map File Name:'
      end
      object Label18: TLabel
        Left = 3
        Top = 25
        Width = 115
        Height = 19
        Caption = 'Form Caption:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label19: TLabel
        Left = 3
        Top = 104
        Width = 162
        Height = 19
        Caption = 'Alive Send Interval:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label20: TLabel
        Left = 255
        Top = 104
        Width = 43
        Height = 19
        Caption = 'mSec'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object WatchFileNameEdit: TEdit
        Left = 96
        Top = 61
        Width = 260
        Height = 27
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ImeName = 'Microsoft Office IME 2007'
        ParentFont = False
        TabOrder = 0
      end
      object IntervalRG: TRadioGroup
        Left = 24
        Top = 138
        Width = 208
        Height = 46
        Caption = 'Display Value Interval'
        Columns = 2
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        Items.Strings = (
          'By Event'
          'By Timer')
        ParentFont = False
        TabOrder = 1
        OnClick = SelAlarmValueRGClick
      end
      object IntervalEdit: TEdit
        Left = 315
        Top = 157
        Width = 41
        Height = 27
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ImeName = 'Microsoft Office IME 2007'
        ParentFont = False
        TabOrder = 2
      end
      object SubWatchCloseCB: TCheckBox
        Left = 173
        Top = 226
        Width = 198
        Height = 26
        Caption = 'Close Subwatch form:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
      end
      object MapFilenameEdit: TJvFilenameEdit
        Left = 11
        Top = 272
        Width = 345
        Height = 24
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 4
        Text = ''
      end
      object CaptionEdit: TEdit
        Left = 124
        Top = 22
        Width = 232
        Height = 27
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ImeName = 'Microsoft Office IME 2007'
        ParentFont = False
        TabOrder = 5
      end
      object ConfFileFormatRG: TRadioGroup
        Left = 24
        Top = 190
        Width = 129
        Height = 57
        Caption = 'Param File Format'
        Columns = 2
        Items.Strings = (
          'XML'
          'JSON')
        TabOrder = 6
      end
      object EngParamEncryptCB: TCheckBox
        Left = 173
        Top = 203
        Width = 159
        Height = 17
        Caption = 'Parameter File Encrypt'
        TabOrder = 7
      end
      object AliveIntervalEdit: TEdit
        Left = 171
        Top = 101
        Width = 78
        Height = 27
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ImeName = 'Microsoft Office IME 2007'
        ParentFont = False
        TabOrder = 8
      end
      object MonDataFromRG: TRadioGroup
        Left = 11
        Top = 302
        Width = 208
        Height = 46
        Caption = 'Monitoring Data Source'
        Columns = 3
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ItemIndex = 0
        Items.Strings = (
          'By IPC'
          'By DB'
          'By MQ')
        ParentFont = False
        TabOrder = 9
      end
      object DispAvgValueCB: TCheckBox
        Left = 225
        Top = 302
        Width = 198
        Height = 26
        Caption = 'Display Average Value'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 10
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Alarm'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label11: TLabel
        Left = 15
        Top = 234
        Width = 171
        Height = 16
        Caption = 'Default Sound File:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = #44404#47548#52404
        Font.Style = [fsBold]
        ParentFont = False
      end
      object SelAlarmValueRG: TRadioGroup
        Left = 15
        Top = 3
        Width = 250
        Height = 46
        Caption = 'Select Alarm Value'
        Columns = 3
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        Items.Strings = (
          'Not Use'
          'Original'
          'This')
        ParentFont = False
        TabOrder = 0
        OnClick = SelAlarmValueRGClick
      end
      object AlarmValueGB: TAdvGroupBox
        Left = 15
        Top = 64
        Width = 354
        Height = 152
        CaptionPosition = cpTopCenter
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object Label3: TLabel
          Left = 7
          Top = 38
          Width = 144
          Height = 16
          Caption = 'Min Alarm Value:'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = #44404#47548#52404
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label4: TLabel
          Left = 7
          Top = 65
          Width = 144
          Height = 16
          Caption = 'Max Alarm Value:'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = #44404#47548#52404
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label5: TLabel
          Left = 7
          Top = 92
          Width = 144
          Height = 16
          Caption = 'Min Fault Value:'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = #44404#47548#52404
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label6: TLabel
          Left = 7
          Top = 119
          Width = 144
          Height = 16
          Caption = 'Max Fault Value:'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = #44404#47548#52404
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label7: TLabel
          Left = 164
          Top = 16
          Width = 45
          Height = 16
          Caption = 'Value'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = #44404#47548#52404
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label8: TLabel
          Left = 242
          Top = 16
          Width = 45
          Height = 16
          Caption = 'Color'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = #44404#47548#52404
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label9: TLabel
          Left = 293
          Top = 16
          Width = 45
          Height = 16
          Caption = 'Blink'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = #44404#47548#52404
          Font.Style = [fsBold]
          ParentFont = False
        end
        object MinAlarmEdit: TEdit
          Left = 157
          Top = 38
          Width = 60
          Height = 22
          ImeName = 'Microsoft Office IME 2007'
          TabOrder = 0
        end
        object MaxAlarmEdit: TEdit
          Left = 157
          Top = 65
          Width = 60
          Height = 22
          ImeName = 'Microsoft Office IME 2007'
          TabOrder = 1
        end
        object MinFaultEdit: TEdit
          Left = 157
          Top = 92
          Width = 60
          Height = 22
          ImeName = 'Microsoft Office IME 2007'
          TabOrder = 2
        end
        object MaxFaultEdit: TEdit
          Left = 157
          Top = 119
          Width = 60
          Height = 22
          ImeName = 'Microsoft Office IME 2007'
          TabOrder = 3
        end
        object MinAlarmColorSelector: TAdvOfficeColorSelector
          Left = 242
          Top = 38
          Width = 45
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          NotesFont.Charset = DEFAULT_CHARSET
          NotesFont.Color = clWindowText
          NotesFont.Height = -11
          NotesFont.Name = 'Tahoma'
          NotesFont.Style = []
          ParentFont = False
          Version = '1.4.7.0'
          TabOrder = 4
          AllowFloating = False
          CloseOnSelect = False
          CaptionAppearance.BorderColor = clNone
          CaptionAppearance.Color = 13198890
          CaptionAppearance.ColorTo = clNone
          CaptionAppearance.Direction = gdHorizontal
          CaptionAppearance.TextColor = clWhite
          CaptionAppearance.TextColorHot = clBlack
          CaptionAppearance.TextColorDown = clBlack
          CaptionAppearance.ButtonAppearance.ColorChecked = 16111818
          CaptionAppearance.ButtonAppearance.ColorCheckedTo = 16367008
          CaptionAppearance.ButtonAppearance.ColorDisabled = 15921906
          CaptionAppearance.ButtonAppearance.ColorDisabledTo = 15921906
          CaptionAppearance.ButtonAppearance.ColorDown = 16111818
          CaptionAppearance.ButtonAppearance.ColorDownTo = 16367008
          CaptionAppearance.ButtonAppearance.ColorHot = 16117985
          CaptionAppearance.ButtonAppearance.ColorHotTo = 16372402
          CaptionAppearance.ButtonAppearance.ColorMirrorHot = 16107693
          CaptionAppearance.ButtonAppearance.ColorMirrorHotTo = 16775412
          CaptionAppearance.ButtonAppearance.ColorMirrorDown = 16102556
          CaptionAppearance.ButtonAppearance.ColorMirrorDownTo = 16768988
          CaptionAppearance.ButtonAppearance.ColorMirrorChecked = 16102556
          CaptionAppearance.ButtonAppearance.ColorMirrorCheckedTo = 16768988
          CaptionAppearance.ButtonAppearance.ColorMirrorDisabled = 11974326
          CaptionAppearance.ButtonAppearance.ColorMirrorDisabledTo = 15921906
          DragGripAppearance.BorderColor = clGray
          DragGripAppearance.Color = clWhite
          DragGripAppearance.ColorTo = clWhite
          DragGripAppearance.ColorMirror = clSilver
          DragGripAppearance.ColorMirrorTo = clWhite
          DragGripAppearance.Gradient = ggVertical
          DragGripAppearance.GradientMirror = ggVertical
          DragGripAppearance.BorderColorHot = clBlue
          DragGripAppearance.ColorHot = 16117985
          DragGripAppearance.ColorHotTo = 16372402
          DragGripAppearance.ColorMirrorHot = 16107693
          DragGripAppearance.ColorMirrorHotTo = 16775412
          DragGripAppearance.GradientHot = ggRadial
          DragGripAppearance.GradientMirrorHot = ggRadial
          DragGripPosition = gpTop
          Appearance.ColorChecked = 16111818
          Appearance.ColorCheckedTo = 16367008
          Appearance.ColorDisabled = 15921906
          Appearance.ColorDisabledTo = 15921906
          Appearance.ColorDown = 16111818
          Appearance.ColorDownTo = 16367008
          Appearance.ColorHot = 16117985
          Appearance.ColorHotTo = 16372402
          Appearance.ColorMirrorHot = 16107693
          Appearance.ColorMirrorHotTo = 16775412
          Appearance.ColorMirrorDown = 16102556
          Appearance.ColorMirrorDownTo = 16768988
          Appearance.ColorMirrorChecked = 16102556
          Appearance.ColorMirrorCheckedTo = 16768988
          Appearance.ColorMirrorDisabled = 11974326
          Appearance.ColorMirrorDisabledTo = 15921906
          SelectedColor = clNone
          ShowRGBHint = True
          ColorDropDown = 16251129
          ColorDropDownFloating = 16374724
          SelectionAppearance.ColorChecked = 16111818
          SelectionAppearance.ColorCheckedTo = 16367008
          SelectionAppearance.ColorDisabled = 15921906
          SelectionAppearance.ColorDisabledTo = 15921906
          SelectionAppearance.ColorDown = 16111818
          SelectionAppearance.ColorDownTo = 16367008
          SelectionAppearance.ColorHot = 16117985
          SelectionAppearance.ColorHotTo = 16372402
          SelectionAppearance.ColorMirrorHot = 16107693
          SelectionAppearance.ColorMirrorHotTo = 16775412
          SelectionAppearance.ColorMirrorDown = 16102556
          SelectionAppearance.ColorMirrorDownTo = 16768988
          SelectionAppearance.ColorMirrorChecked = 16102556
          SelectionAppearance.ColorMirrorCheckedTo = 16768988
          SelectionAppearance.ColorMirrorDisabled = 11974326
          SelectionAppearance.ColorMirrorDisabledTo = 15921906
          SelectionAppearance.TextColorChecked = clBlack
          SelectionAppearance.TextColorDown = clWhite
          SelectionAppearance.TextColorHot = clWhite
          SelectionAppearance.TextColor = clBlack
          SelectionAppearance.TextColorDisabled = clGray
          SelectionAppearance.Rounded = False
          Tools = <
            item
              BackGroundColor = clBlack
              Caption = 'Automatic'
              CaptionAlignment = taCenter
              ImageIndex = -1
              Hint = 'Automatic'
              Enable = True
              ItemType = itFullWidthButton
            end
            item
              BackGroundColor = clBlack
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 13209
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 13107
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 13056
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 6697728
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clNavy
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 3486515
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 3355443
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clMaroon
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 26367
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clOlive
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clGreen
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clTeal
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clBlue
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 10053222
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clGray
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clRed
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 39423
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 52377
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 6723891
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 13421619
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 16737843
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clPurple
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 10066329
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clFuchsia
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 52479
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clYellow
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clLime
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clAqua
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 16763904
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 6697881
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clSilver
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 13408767
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 10079487
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 10092543
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 13434828
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 16777164
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 16764057
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 16751052
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clWhite
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              Caption = 'More Colors...'
              CaptionAlignment = taCenter
              ImageIndex = -1
              Hint = 'More Colors'
              Enable = True
              ItemType = itFullWidthButton
            end>
        end
        object MaxAlarmColorSelector: TAdvOfficeColorSelector
          Left = 242
          Top = 66
          Width = 45
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          NotesFont.Charset = DEFAULT_CHARSET
          NotesFont.Color = clWindowText
          NotesFont.Height = -11
          NotesFont.Name = 'Tahoma'
          NotesFont.Style = []
          ParentFont = False
          Version = '1.4.7.0'
          TabOrder = 5
          AllowFloating = False
          CloseOnSelect = False
          CaptionAppearance.BorderColor = clNone
          CaptionAppearance.Color = 13198890
          CaptionAppearance.ColorTo = clNone
          CaptionAppearance.Direction = gdHorizontal
          CaptionAppearance.TextColor = clWhite
          CaptionAppearance.TextColorHot = clBlack
          CaptionAppearance.TextColorDown = clBlack
          CaptionAppearance.ButtonAppearance.ColorChecked = 16111818
          CaptionAppearance.ButtonAppearance.ColorCheckedTo = 16367008
          CaptionAppearance.ButtonAppearance.ColorDisabled = 15921906
          CaptionAppearance.ButtonAppearance.ColorDisabledTo = 15921906
          CaptionAppearance.ButtonAppearance.ColorDown = 16111818
          CaptionAppearance.ButtonAppearance.ColorDownTo = 16367008
          CaptionAppearance.ButtonAppearance.ColorHot = 16117985
          CaptionAppearance.ButtonAppearance.ColorHotTo = 16372402
          CaptionAppearance.ButtonAppearance.ColorMirrorHot = 16107693
          CaptionAppearance.ButtonAppearance.ColorMirrorHotTo = 16775412
          CaptionAppearance.ButtonAppearance.ColorMirrorDown = 16102556
          CaptionAppearance.ButtonAppearance.ColorMirrorDownTo = 16768988
          CaptionAppearance.ButtonAppearance.ColorMirrorChecked = 16102556
          CaptionAppearance.ButtonAppearance.ColorMirrorCheckedTo = 16768988
          CaptionAppearance.ButtonAppearance.ColorMirrorDisabled = 11974326
          CaptionAppearance.ButtonAppearance.ColorMirrorDisabledTo = 15921906
          DragGripAppearance.BorderColor = clGray
          DragGripAppearance.Color = clWhite
          DragGripAppearance.ColorTo = clWhite
          DragGripAppearance.ColorMirror = clSilver
          DragGripAppearance.ColorMirrorTo = clWhite
          DragGripAppearance.Gradient = ggVertical
          DragGripAppearance.GradientMirror = ggVertical
          DragGripAppearance.BorderColorHot = clBlue
          DragGripAppearance.ColorHot = 16117985
          DragGripAppearance.ColorHotTo = 16372402
          DragGripAppearance.ColorMirrorHot = 16107693
          DragGripAppearance.ColorMirrorHotTo = 16775412
          DragGripAppearance.GradientHot = ggRadial
          DragGripAppearance.GradientMirrorHot = ggRadial
          DragGripPosition = gpTop
          Appearance.ColorChecked = 16111818
          Appearance.ColorCheckedTo = 16367008
          Appearance.ColorDisabled = 15921906
          Appearance.ColorDisabledTo = 15921906
          Appearance.ColorDown = 16111818
          Appearance.ColorDownTo = 16367008
          Appearance.ColorHot = 16117985
          Appearance.ColorHotTo = 16372402
          Appearance.ColorMirrorHot = 16107693
          Appearance.ColorMirrorHotTo = 16775412
          Appearance.ColorMirrorDown = 16102556
          Appearance.ColorMirrorDownTo = 16768988
          Appearance.ColorMirrorChecked = 16102556
          Appearance.ColorMirrorCheckedTo = 16768988
          Appearance.ColorMirrorDisabled = 11974326
          Appearance.ColorMirrorDisabledTo = 15921906
          SelectedColor = clNone
          ShowRGBHint = True
          ColorDropDown = 16251129
          ColorDropDownFloating = 16374724
          SelectionAppearance.ColorChecked = 16111818
          SelectionAppearance.ColorCheckedTo = 16367008
          SelectionAppearance.ColorDisabled = 15921906
          SelectionAppearance.ColorDisabledTo = 15921906
          SelectionAppearance.ColorDown = 16111818
          SelectionAppearance.ColorDownTo = 16367008
          SelectionAppearance.ColorHot = 16117985
          SelectionAppearance.ColorHotTo = 16372402
          SelectionAppearance.ColorMirrorHot = 16107693
          SelectionAppearance.ColorMirrorHotTo = 16775412
          SelectionAppearance.ColorMirrorDown = 16102556
          SelectionAppearance.ColorMirrorDownTo = 16768988
          SelectionAppearance.ColorMirrorChecked = 16102556
          SelectionAppearance.ColorMirrorCheckedTo = 16768988
          SelectionAppearance.ColorMirrorDisabled = 11974326
          SelectionAppearance.ColorMirrorDisabledTo = 15921906
          SelectionAppearance.TextColorChecked = clBlack
          SelectionAppearance.TextColorDown = clWhite
          SelectionAppearance.TextColorHot = clWhite
          SelectionAppearance.TextColor = clBlack
          SelectionAppearance.TextColorDisabled = clGray
          SelectionAppearance.Rounded = False
          Tools = <
            item
              BackGroundColor = clBlack
              Caption = 'Automatic'
              CaptionAlignment = taCenter
              ImageIndex = -1
              Hint = 'Automatic'
              Enable = True
              ItemType = itFullWidthButton
            end
            item
              BackGroundColor = clBlack
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 13209
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 13107
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 13056
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 6697728
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clNavy
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 3486515
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 3355443
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clMaroon
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 26367
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clOlive
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clGreen
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clTeal
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clBlue
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 10053222
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clGray
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clRed
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 39423
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 52377
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 6723891
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 13421619
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 16737843
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clPurple
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 10066329
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clFuchsia
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 52479
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clYellow
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clLime
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clAqua
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 16763904
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 6697881
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clSilver
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 13408767
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 10079487
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 10092543
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 13434828
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 16777164
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 16764057
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 16751052
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clWhite
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              Caption = 'More Colors...'
              CaptionAlignment = taCenter
              ImageIndex = -1
              Hint = 'More Colors'
              Enable = True
              ItemType = itFullWidthButton
            end>
        end
        object MinFaultColorSelector: TAdvOfficeColorSelector
          Left = 242
          Top = 94
          Width = 45
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          NotesFont.Charset = DEFAULT_CHARSET
          NotesFont.Color = clWindowText
          NotesFont.Height = -11
          NotesFont.Name = 'Tahoma'
          NotesFont.Style = []
          ParentFont = False
          Version = '1.4.7.0'
          TabOrder = 6
          AllowFloating = False
          CloseOnSelect = False
          CaptionAppearance.BorderColor = clNone
          CaptionAppearance.Color = 13198890
          CaptionAppearance.ColorTo = clNone
          CaptionAppearance.Direction = gdHorizontal
          CaptionAppearance.TextColor = clWhite
          CaptionAppearance.TextColorHot = clBlack
          CaptionAppearance.TextColorDown = clBlack
          CaptionAppearance.ButtonAppearance.ColorChecked = 16111818
          CaptionAppearance.ButtonAppearance.ColorCheckedTo = 16367008
          CaptionAppearance.ButtonAppearance.ColorDisabled = 15921906
          CaptionAppearance.ButtonAppearance.ColorDisabledTo = 15921906
          CaptionAppearance.ButtonAppearance.ColorDown = 16111818
          CaptionAppearance.ButtonAppearance.ColorDownTo = 16367008
          CaptionAppearance.ButtonAppearance.ColorHot = 16117985
          CaptionAppearance.ButtonAppearance.ColorHotTo = 16372402
          CaptionAppearance.ButtonAppearance.ColorMirrorHot = 16107693
          CaptionAppearance.ButtonAppearance.ColorMirrorHotTo = 16775412
          CaptionAppearance.ButtonAppearance.ColorMirrorDown = 16102556
          CaptionAppearance.ButtonAppearance.ColorMirrorDownTo = 16768988
          CaptionAppearance.ButtonAppearance.ColorMirrorChecked = 16102556
          CaptionAppearance.ButtonAppearance.ColorMirrorCheckedTo = 16768988
          CaptionAppearance.ButtonAppearance.ColorMirrorDisabled = 11974326
          CaptionAppearance.ButtonAppearance.ColorMirrorDisabledTo = 15921906
          DragGripAppearance.BorderColor = clGray
          DragGripAppearance.Color = clWhite
          DragGripAppearance.ColorTo = clWhite
          DragGripAppearance.ColorMirror = clSilver
          DragGripAppearance.ColorMirrorTo = clWhite
          DragGripAppearance.Gradient = ggVertical
          DragGripAppearance.GradientMirror = ggVertical
          DragGripAppearance.BorderColorHot = clBlue
          DragGripAppearance.ColorHot = 16117985
          DragGripAppearance.ColorHotTo = 16372402
          DragGripAppearance.ColorMirrorHot = 16107693
          DragGripAppearance.ColorMirrorHotTo = 16775412
          DragGripAppearance.GradientHot = ggRadial
          DragGripAppearance.GradientMirrorHot = ggRadial
          DragGripPosition = gpTop
          Appearance.ColorChecked = 16111818
          Appearance.ColorCheckedTo = 16367008
          Appearance.ColorDisabled = 15921906
          Appearance.ColorDisabledTo = 15921906
          Appearance.ColorDown = 16111818
          Appearance.ColorDownTo = 16367008
          Appearance.ColorHot = 16117985
          Appearance.ColorHotTo = 16372402
          Appearance.ColorMirrorHot = 16107693
          Appearance.ColorMirrorHotTo = 16775412
          Appearance.ColorMirrorDown = 16102556
          Appearance.ColorMirrorDownTo = 16768988
          Appearance.ColorMirrorChecked = 16102556
          Appearance.ColorMirrorCheckedTo = 16768988
          Appearance.ColorMirrorDisabled = 11974326
          Appearance.ColorMirrorDisabledTo = 15921906
          SelectedColor = clNone
          ShowRGBHint = True
          ColorDropDown = 16251129
          ColorDropDownFloating = 16374724
          SelectionAppearance.ColorChecked = 16111818
          SelectionAppearance.ColorCheckedTo = 16367008
          SelectionAppearance.ColorDisabled = 15921906
          SelectionAppearance.ColorDisabledTo = 15921906
          SelectionAppearance.ColorDown = 16111818
          SelectionAppearance.ColorDownTo = 16367008
          SelectionAppearance.ColorHot = 16117985
          SelectionAppearance.ColorHotTo = 16372402
          SelectionAppearance.ColorMirrorHot = 16107693
          SelectionAppearance.ColorMirrorHotTo = 16775412
          SelectionAppearance.ColorMirrorDown = 16102556
          SelectionAppearance.ColorMirrorDownTo = 16768988
          SelectionAppearance.ColorMirrorChecked = 16102556
          SelectionAppearance.ColorMirrorCheckedTo = 16768988
          SelectionAppearance.ColorMirrorDisabled = 11974326
          SelectionAppearance.ColorMirrorDisabledTo = 15921906
          SelectionAppearance.TextColorChecked = clBlack
          SelectionAppearance.TextColorDown = clWhite
          SelectionAppearance.TextColorHot = clWhite
          SelectionAppearance.TextColor = clBlack
          SelectionAppearance.TextColorDisabled = clGray
          SelectionAppearance.Rounded = False
          Tools = <
            item
              BackGroundColor = clBlack
              Caption = 'Automatic'
              CaptionAlignment = taCenter
              ImageIndex = -1
              Hint = 'Automatic'
              Enable = True
              ItemType = itFullWidthButton
            end
            item
              BackGroundColor = clBlack
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 13209
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 13107
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 13056
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 6697728
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clNavy
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 3486515
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 3355443
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clMaroon
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 26367
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clOlive
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clGreen
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clTeal
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clBlue
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 10053222
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clGray
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clRed
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 39423
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 52377
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 6723891
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 13421619
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 16737843
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clPurple
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 10066329
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clFuchsia
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 52479
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clYellow
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clLime
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clAqua
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 16763904
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 6697881
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clSilver
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 13408767
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 10079487
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 10092543
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 13434828
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 16777164
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 16764057
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 16751052
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clWhite
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              Caption = 'More Colors...'
              CaptionAlignment = taCenter
              ImageIndex = -1
              Hint = 'More Colors'
              Enable = True
              ItemType = itFullWidthButton
            end>
        end
        object MaxFaultColorSelector: TAdvOfficeColorSelector
          Left = 242
          Top = 122
          Width = 45
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          NotesFont.Charset = DEFAULT_CHARSET
          NotesFont.Color = clWindowText
          NotesFont.Height = -11
          NotesFont.Name = 'Tahoma'
          NotesFont.Style = []
          ParentFont = False
          Version = '1.4.7.0'
          TabOrder = 7
          AllowFloating = False
          CloseOnSelect = False
          CaptionAppearance.BorderColor = clNone
          CaptionAppearance.Color = 13198890
          CaptionAppearance.ColorTo = clNone
          CaptionAppearance.Direction = gdHorizontal
          CaptionAppearance.TextColor = clWhite
          CaptionAppearance.TextColorHot = clBlack
          CaptionAppearance.TextColorDown = clBlack
          CaptionAppearance.ButtonAppearance.ColorChecked = 16111818
          CaptionAppearance.ButtonAppearance.ColorCheckedTo = 16367008
          CaptionAppearance.ButtonAppearance.ColorDisabled = 15921906
          CaptionAppearance.ButtonAppearance.ColorDisabledTo = 15921906
          CaptionAppearance.ButtonAppearance.ColorDown = 16111818
          CaptionAppearance.ButtonAppearance.ColorDownTo = 16367008
          CaptionAppearance.ButtonAppearance.ColorHot = 16117985
          CaptionAppearance.ButtonAppearance.ColorHotTo = 16372402
          CaptionAppearance.ButtonAppearance.ColorMirrorHot = 16107693
          CaptionAppearance.ButtonAppearance.ColorMirrorHotTo = 16775412
          CaptionAppearance.ButtonAppearance.ColorMirrorDown = 16102556
          CaptionAppearance.ButtonAppearance.ColorMirrorDownTo = 16768988
          CaptionAppearance.ButtonAppearance.ColorMirrorChecked = 16102556
          CaptionAppearance.ButtonAppearance.ColorMirrorCheckedTo = 16768988
          CaptionAppearance.ButtonAppearance.ColorMirrorDisabled = 11974326
          CaptionAppearance.ButtonAppearance.ColorMirrorDisabledTo = 15921906
          DragGripAppearance.BorderColor = clGray
          DragGripAppearance.Color = clWhite
          DragGripAppearance.ColorTo = clWhite
          DragGripAppearance.ColorMirror = clSilver
          DragGripAppearance.ColorMirrorTo = clWhite
          DragGripAppearance.Gradient = ggVertical
          DragGripAppearance.GradientMirror = ggVertical
          DragGripAppearance.BorderColorHot = clBlue
          DragGripAppearance.ColorHot = 16117985
          DragGripAppearance.ColorHotTo = 16372402
          DragGripAppearance.ColorMirrorHot = 16107693
          DragGripAppearance.ColorMirrorHotTo = 16775412
          DragGripAppearance.GradientHot = ggRadial
          DragGripAppearance.GradientMirrorHot = ggRadial
          DragGripPosition = gpTop
          Appearance.ColorChecked = 16111818
          Appearance.ColorCheckedTo = 16367008
          Appearance.ColorDisabled = 15921906
          Appearance.ColorDisabledTo = 15921906
          Appearance.ColorDown = 16111818
          Appearance.ColorDownTo = 16367008
          Appearance.ColorHot = 16117985
          Appearance.ColorHotTo = 16372402
          Appearance.ColorMirrorHot = 16107693
          Appearance.ColorMirrorHotTo = 16775412
          Appearance.ColorMirrorDown = 16102556
          Appearance.ColorMirrorDownTo = 16768988
          Appearance.ColorMirrorChecked = 16102556
          Appearance.ColorMirrorCheckedTo = 16768988
          Appearance.ColorMirrorDisabled = 11974326
          Appearance.ColorMirrorDisabledTo = 15921906
          SelectedColor = clNone
          ShowRGBHint = True
          ColorDropDown = 16251129
          ColorDropDownFloating = 16374724
          SelectionAppearance.ColorChecked = 16111818
          SelectionAppearance.ColorCheckedTo = 16367008
          SelectionAppearance.ColorDisabled = 15921906
          SelectionAppearance.ColorDisabledTo = 15921906
          SelectionAppearance.ColorDown = 16111818
          SelectionAppearance.ColorDownTo = 16367008
          SelectionAppearance.ColorHot = 16117985
          SelectionAppearance.ColorHotTo = 16372402
          SelectionAppearance.ColorMirrorHot = 16107693
          SelectionAppearance.ColorMirrorHotTo = 16775412
          SelectionAppearance.ColorMirrorDown = 16102556
          SelectionAppearance.ColorMirrorDownTo = 16768988
          SelectionAppearance.ColorMirrorChecked = 16102556
          SelectionAppearance.ColorMirrorCheckedTo = 16768988
          SelectionAppearance.ColorMirrorDisabled = 11974326
          SelectionAppearance.ColorMirrorDisabledTo = 15921906
          SelectionAppearance.TextColorChecked = clBlack
          SelectionAppearance.TextColorDown = clWhite
          SelectionAppearance.TextColorHot = clWhite
          SelectionAppearance.TextColor = clBlack
          SelectionAppearance.TextColorDisabled = clGray
          SelectionAppearance.Rounded = False
          Tools = <
            item
              BackGroundColor = clBlack
              Caption = 'Automatic'
              CaptionAlignment = taCenter
              ImageIndex = -1
              Hint = 'Automatic'
              Enable = True
              ItemType = itFullWidthButton
            end
            item
              BackGroundColor = clBlack
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 13209
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 13107
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 13056
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 6697728
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clNavy
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 3486515
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 3355443
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clMaroon
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 26367
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clOlive
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clGreen
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clTeal
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clBlue
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 10053222
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clGray
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clRed
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 39423
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 52377
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 6723891
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 13421619
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 16737843
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clPurple
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 10066329
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clFuchsia
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 52479
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clYellow
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clLime
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clAqua
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 16763904
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 6697881
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clSilver
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 13408767
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 10079487
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 10092543
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 13434828
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 16777164
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 16764057
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = 16751052
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              BackGroundColor = clWhite
              CaptionAlignment = taCenter
              ImageIndex = -1
              Enable = True
            end
            item
              Caption = 'More Colors...'
              CaptionAlignment = taCenter
              ImageIndex = -1
              Hint = 'More Colors'
              Enable = True
              ItemType = itFullWidthButton
            end>
        end
        object MinAlarmBlinkCB: TCheckBox
          Left = 320
          Top = 41
          Width = 17
          Height = 14
          TabOrder = 8
        end
        object MaxAlarmBlinkCB: TCheckBox
          Left = 320
          Top = 70
          Width = 17
          Height = 14
          TabOrder = 9
        end
        object MinFaultBlinkCB: TCheckBox
          Left = 320
          Top = 97
          Width = 17
          Height = 14
          TabOrder = 10
        end
        object MaxFaultBlinkCB: TCheckBox
          Left = 320
          Top = 126
          Width = 17
          Height = 14
          TabOrder = 11
        end
      end
      object DefaultSoundEdit: TJvFilenameEdit
        Left = 192
        Top = 231
        Width = 177
        Height = 21
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 2
        Text = ''
      end
    end
    object AlarmListTabSheet: TTabSheet
      Caption = 'Alarm List'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label15: TLabel
        Left = 48
        Top = 26
        Width = 96
        Height = 16
        Caption = 'Alarm DB Driver:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
      end
      object Label16: TLabel
        Left = 25
        Top = 53
        Width = 119
        Height = 16
        Caption = 'Alarm DB File Name:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
      end
      object DBDriverEdit: TJvFilenameEdit
        Left = 150
        Top = 23
        Width = 204
        Height = 21
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 0
        Text = ''
      end
      object AlarmDBFilenameEdit: TJvFilenameEdit
        Left = 149
        Top = 53
        Width = 204
        Height = 21
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 1
        Text = ''
      end
      object GroupBox2: TGroupBox
        Left = 48
        Top = 121
        Width = 280
        Height = 120
        Caption = 'Create Alarm DB in'
        TabOrder = 2
        object RB_bydate: TRadioButton
          Left = 96
          Top = 19
          Width = 89
          Height = 17
          Caption = 'every Day'
          TabOrder = 0
        end
        object RB_byfilename: TRadioButton
          Left = 96
          Top = 62
          Width = 113
          Height = 17
          Caption = 'Fixed Filename'
          TabOrder = 1
        end
        object RadioButton1: TRadioButton
          Left = 96
          Top = 42
          Width = 113
          Height = 17
          Caption = 'every Month'
          Checked = True
          TabOrder = 2
          TabStop = True
        end
        object ED_csv: TEdit
          Left = 96
          Top = 85
          Width = 169
          Height = 21
          Enabled = False
          ImeName = 'Microsoft Office IME 2007'
          TabOrder = 3
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'MQ Server'
      ImageIndex = 5
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label21: TLabel
        Left = 72
        Top = 80
        Width = 63
        Height = 13
        Caption = 'Port Num:'
        ParentShowHint = False
        ShowHint = False
      end
      object Label22: TLabel
        Left = 56
        Top = 40
        Width = 77
        Height = 13
        Caption = 'IP Address:'
        ParentShowHint = False
        ShowHint = False
      end
      object Label23: TLabel
        Left = 256
        Top = 80
        Width = 35
        Height = 13
        Caption = 'STOMP'
      end
      object Label24: TLabel
        Left = 77
        Top = 117
        Width = 56
        Height = 13
        Caption = 'User ID:'
      end
      object Label25: TLabel
        Left = 84
        Top = 155
        Width = 49
        Height = 13
        Caption = 'Passwd:'
      end
      object Label26: TLabel
        Left = 21
        Top = 194
        Width = 112
        Height = 13
        Caption = 'Subscribe Topic:'
      end
      object MQIPAddress: TJvIPAddress
        Left = 140
        Top = 39
        Width = 150
        Height = 24
        Hint = 'MQ Server;MQ Server IP'
        Address = 168695157
        ParentColor = False
        TabOrder = 0
      end
      object MQPortEdit: TEdit
        Left = 140
        Top = 76
        Width = 111
        Height = 21
        Hint = 'MQ Server;MQ Server Port'
        Alignment = taRightJustify
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 1
        Text = '61613'
      end
      object MQUserEdit: TEdit
        Left = 140
        Top = 114
        Width = 187
        Height = 21
        Hint = 'MQ Server;MQ Server UserId'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 2
      end
      object MQPasswdEdit: TEdit
        Left = 140
        Top = 152
        Width = 187
        Height = 21
        Hint = 'MQ Server;MQ Server Passwd'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 3
      end
      object MQTopicLB: TListBox
        Left = 139
        Top = 194
        Width = 222
        Height = 91
        ImeName = 'Microsoft IME 2010'
        ItemHeight = 13
        MultiSelect = True
        TabOrder = 4
      end
      object Button1: TButton
        Left = 139
        Top = 288
        Width = 100
        Height = 25
        Caption = 'Add Topic'
        TabOrder = 5
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 139
        Top = 319
        Width = 100
        Height = 25
        Caption = 'Delete Topic'
        TabOrder = 6
        OnClick = Button2Click
      end
      object Edit1: TEdit
        Left = 240
        Top = 288
        Width = 121
        Height = 21
        ImeName = 'Microsoft IME 2010'
        TabOrder = 7
      end
    end
  end
end
