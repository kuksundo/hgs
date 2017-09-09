object SetMatrixConfigF: TSetMatrixConfigF
  Left = 0
  Top = 0
  Caption = 'Matrix Config'
  ClientHeight = 271
  ClientWidth = 257
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object AdvGroupBox1: TAdvGroupBox
    Left = 16
    Top = 16
    Width = 217
    Height = 225
    RoundEdges = True
    TabOrder = 0
    object LowAlarmGroup: TAdvGroupBox
      Left = 16
      Top = 24
      Width = 185
      Height = 185
      CaptionPosition = cpTopCenter
      TabOrder = 0
      object Label1: TLabel
        Left = 13
        Top = 24
        Width = 82
        Height = 13
        Caption = 'Color Resolution:'
      end
      object Label2: TLabel
        Left = 17
        Top = 68
        Width = 56
        Height = 13
        Caption = 'From Color:'
      end
      object Label3: TLabel
        Left = 17
        Top = 108
        Width = 44
        Height = 13
        Caption = 'To Color:'
      end
      object ColorResolutionEdit: TEdit
        Left = 97
        Top = 22
        Width = 82
        Height = 19
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 0
      end
      object FromColorSelector: TAdvOfficeColorSelector
        Left = 79
        Top = 65
        Width = 74
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
        Version = '1.4.2.0'
        TabOrder = 1
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
        SelectionAppearance.TextColorHot = clWhite
        SelectionAppearance.TextColorDown = clWhite
        SelectionAppearance.TextColor = clBlack
        SelectionAppearance.TextColorChecked = clBlack
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
        Left = 13
        Top = 151
        Width = 124
        Height = 14
        Caption = 'Use Write Confirm'
        TabOrder = 2
      end
      object ToColorSelector: TAdvOfficeColorSelector
        Left = 79
        Top = 105
        Width = 74
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
        Version = '1.4.2.0'
        TabOrder = 3
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
        SelectionAppearance.TextColorHot = clWhite
        SelectionAppearance.TextColorDown = clWhite
        SelectionAppearance.TextColor = clBlack
        SelectionAppearance.TextColorChecked = clBlack
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
    end
  end
end
