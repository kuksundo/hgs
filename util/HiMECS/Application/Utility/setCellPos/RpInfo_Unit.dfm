object RpInfo_Frm: TRpInfo_Frm
  Left = 0
  Top = 0
  Caption = #48372#44256#49436' '#51221#48372
  ClientHeight = 174
  ClientWidth = 473
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 38
    Top = 32
    Width = 84
    Height = 16
    Caption = #48372#44256#49436' '#51228#47785
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #47569#51008' '#44256#46357
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 74
    Top = 63
    Width = 48
    Height = 16
    Caption = #45812#45817#51088
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #47569#51008' '#44256#46357
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 38
    Top = 96
    Width = 84
    Height = 16
    Caption = #53580#49828#53944' '#44148#49688
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #47569#51008' '#44256#46357
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 176
    Top = 96
    Width = 116
    Height = 16
    Caption = #48372#44256#49436' '#49884#51089#48264#54840
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #47569#51008' '#44256#46357
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 38
    Top = 126
    Width = 261
    Height = 14
    Caption = #8251'. '#48372#44256#49436' '#49884#51089#48264#54840#45716' "0" '#51060#49345' '#46104#50612#50556' '#54633#45768#45796'.'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = #47569#51008' '#44256#46357
    Font.Style = [fsBold]
    ParentFont = False
  end
  object TestNm: TNxComboBox
    Left = 128
    Top = 30
    Width = 321
    Height = 23
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #47569#51008' '#44256#46357
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    HideFocus = False
    AutoCompleteDelay = 0
    Items.Strings = (
      'Continuous Running Test'
      'Performance Test'
      'Cylinder Balancing Test'
      'Heat Balance Test'
      'Spark Plug Test'
      'Running In Test')
  end
  object Testm: TNxComboBox
    Left = 128
    Top = 59
    Width = 158
    Height = 23
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #47569#51008' '#44256#46357
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    HideFocus = False
    AutoCompleteDelay = 0
    Items.Strings = (
      'SMH'
      'PSN'
      'KTH')
  end
  object testcnt: TNxNumberEdit
    Left = 121
    Top = 94
    Width = 49
    Height = 23
    Alignment = taCenter
    Color = 8158460
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #47569#51008' '#44256#46357
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    Text = '0'
    ReadOnly = True
    Precision = 0
  end
  object startnum: TNxNumberEdit
    Left = 298
    Top = 94
    Width = 49
    Height = 23
    Alignment = taCenter
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #47569#51008' '#44256#46357
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    Text = '1'
    Precision = 0
    Value = 1.000000000000000000
  end
  object Panel1: TPanel
    Left = 0
    Top = 143
    Width = 473
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 4
    ExplicitLeft = -24
    ExplicitTop = 146
    object BitBtn1: TBitBtn
      Left = 88
      Top = 3
      Width = 145
      Height = 25
      DoubleBuffered = True
      Kind = bkOK
      NumGlyphs = 2
      ParentDoubleBuffered = False
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 289
      Top = 3
      Width = 128
      Height = 25
      DoubleBuffered = True
      Kind = bkCancel
      NumGlyphs = 2
      ParentDoubleBuffered = False
      TabOrder = 1
    end
  end
end
