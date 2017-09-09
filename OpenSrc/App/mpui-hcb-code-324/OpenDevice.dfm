object OpenDevicesForm: TOpenDevicesForm
  Left = 245
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Dialog'
  ClientHeight = 484
  ClientWidth = 438
  Color = clBtnFace
  DefaultMonitor = dmMainForm
  ParentFont = True
  FormStyle = fsStayOnTop
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = TntFormCreate
  OnShow = FormShow
  DesignSize = (
    438
    484)
  PixelsPerInch = 96
  TextHeight = 13
  object CVideoDevices: TTntComboBox
    Left = 96
    Top = 16
    Width = 252
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 0
  end
  object CAudioDevices: TTntComboBox
    Left = 96
    Top = 48
    Width = 252
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 1
  end
  object CCountryCode: TTntComboBox
    Left = 96
    Top = 80
    Width = 252
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 2
    Text = 'us-bcast'
    Items.Strings = (
      'us-bcast'
      'russia'
      'argentina'
      'japan-bcast'
      'china-bcast'
      'southafrica'
      'australia'
      'ireland'
      'france'
      'italy'
      'newzealand'
      'europe-east'
      'europe-west'
      'us-cable'
      'us-cable-hrc'
      'japan-cable')
  end
  object LVideoDevices: TTntStaticText
    Left = 12
    Top = 18
    Width = 67
    Height = 17
    Caption = 'VideoDevices'
    TabOrder = 3
  end
  object LCountryCode: TTntStaticText
    Left = 12
    Top = 82
    Width = 68
    Height = 17
    Caption = 'CountryCode'
    TabOrder = 4
  end
  object LAudioDevices: TTntStaticText
    Left = 12
    Top = 50
    Width = 68
    Height = 17
    Caption = 'AudioDevices'
    TabOrder = 5
  end
  object HK: TTntListView
    Left = 4
    Top = 108
    Width = 429
    Height = 300
    Columns = <
      item
        Caption = 'Channel'
        Width = 152
      end
      item
        Caption = 'Freq'
        Width = 196
      end>
    ColumnClick = False
    GridLines = True
    HideSelection = False
    RowSelect = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    ViewStyle = vsReport
    OnDblClick = TViewClick
  end
  object TScan: TTntButton
    Left = 3
    Top = 415
    Width = 75
    Height = 25
    Anchors = [akLeft]
    Caption = 'Scan'
    TabOrder = 7
    OnClick = TScanClick
  end
  object TView: TTntButton
    Left = 179
    Top = 415
    Width = 75
    Height = 25
    Anchors = [akLeft]
    Caption = 'View'
    TabOrder = 8
    OnClick = TViewClick
  end
  object TClear: TTntButton
    Left = 3
    Top = 451
    Width = 75
    Height = 25
    Anchors = [akLeft]
    Caption = 'Clear'
    TabOrder = 9
    OnClick = TClearClick
  end
  object TLoad: TTntButton
    Left = 179
    Top = 451
    Width = 75
    Height = 25
    Anchors = [akLeft]
    Caption = 'Load List'
    TabOrder = 10
    OnClick = TLoadClick
  end
  object TStop: TTntButton
    Left = 91
    Top = 415
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 11
    OnClick = TStopClick
  end
  object TSave: TTntButton
    Left = 355
    Top = 451
    Width = 75
    Height = 25
    Anchors = [akLeft]
    Caption = 'Save List'
    TabOrder = 12
    OnClick = TSaveClick
  end
  object TPrev: TTntButton
    Tag = -1
    Left = 267
    Top = 415
    Width = 75
    Height = 25
    Anchors = [akLeft]
    Caption = 'Prev'
    TabOrder = 13
    OnClick = TPrevClick
  end
  object TNext: TTntButton
    Tag = 1
    Left = 355
    Top = 415
    Width = 75
    Height = 25
    Anchors = [akLeft]
    Caption = 'Next'
    TabOrder = 14
    OnClick = TPrevClick
  end
  object TOpen: TTntButton
    Left = 355
    Top = 15
    Width = 75
    Height = 82
    Caption = 'OPen'
    TabOrder = 15
    OnClick = TOpenClick
  end
end
