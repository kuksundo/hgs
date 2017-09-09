object WT1600SelectF: TWT1600SelectF
  Left = 0
  Top = 0
  Caption = 'WT1600SelectF'
  ClientHeight = 103
  ClientWidth = 618
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object RadioGroup1: TRadioGroup
    Left = 0
    Top = 0
    Width = 543
    Height = 70
    Caption = 'Select Display Power Meter No.'
    Columns = 9
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ItemIndex = 0
    Items.Strings = (
      '#1'
      '#2'
      '#3'
      '#4'
      '#5'
      '#6'
      '#7'
      '#8'
      '#9')
    ParentFont = False
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 543
    Top = 0
    Width = 75
    Height = 103
    Align = alRight
    Caption = #54869#51064
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = BitBtn1Click
    ExplicitHeight = 70
  end
  object IPAddrEdit: TEdit
    Left = 94
    Top = 76
    Width = 145
    Height = 21
    ImeName = 'Microsoft Office IME 2007'
    TabOrder = 2
    Text = '192.168.0.55'
  end
  object UseIPCB: TCheckBox
    Left = 15
    Top = 77
    Width = 73
    Height = 17
    Caption = 'IP Address:'
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
end
