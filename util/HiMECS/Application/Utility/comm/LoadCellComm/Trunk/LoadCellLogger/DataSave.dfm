object Form1: TForm1
  Left = 189
  Top = 116
  Width = 341
  Height = 354
  Caption = #54788#45824#51473#44277#50629' '#50644#51652#49884#54744#44592#49696#48512
  Color = 7978239
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 20
  object MsgLed: TSCLED
    Left = 0
    Top = 0
    Width = 333
    Height = 58
    Lines.Strings = (
      'LoadCell Logger')
    ForeColor = 7972351
    BackColor = clBlack
    LEDCountX = 111
    LEDCountY = 19
    AlignmentH = schaCenter
    AlignmentV = scvaCenter
    Caption = 'MsgLed'
    Color = 867650
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 8
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ParentColor = False
    Align = alTop
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 296
    Width = 333
    Height = 24
    Panels = <>
    SimplePanel = False
    SimpleText = #45824#44592#51473
  end
  object GroupBox3: TGroupBox
    Left = 12
    Top = 65
    Width = 308
    Height = 121
    Caption = #47196#44536#49444#51221'('#49884#51089' '#51204' '#49464#54021')'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 8
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Label2: TLabel
      Left = 7
      Top = 49
      Width = 63
      Height = 13
      Caption = #44592#47197#49884#44036' :   '
    end
    object Label4: TLabel
      Left = 193
      Top = 49
      Width = 12
      Height = 13
      Caption = #52488
    end
    object Label6: TLabel
      Left = 150
      Top = 49
      Width = 12
      Height = 13
      Caption = #48516
    end
    object Label7: TLabel
      Left = 95
      Top = 49
      Width = 27
      Height = 13
      Caption = #49884#44036' '
    end
    object Label1: TLabel
      Left = 9
      Top = 25
      Width = 59
      Height = 13
      Caption = #47196#46300#49472'ID :  '
    end
    object Label11: TLabel
      Left = 7
      Top = 97
      Width = 63
      Height = 13
      Caption = #44592#47197#48169#48277' :   '
    end
    object Label3: TLabel
      Left = 151
      Top = 75
      Width = 12
      Height = 13
      Caption = #52488
    end
    object Label10: TLabel
      Left = 7
      Top = 74
      Width = 63
      Height = 13
      Caption = #51200#51109#51452#44592' :   '
    end
    object Label9: TLabel
      Left = 95
      Top = 75
      Width = 12
      Height = 13
      Caption = #48516
    end
    object ed_LogSec: TEdit
      Left = 166
      Top = 45
      Width = 24
      Height = 21
      ImeName = 'Microsoft IME 2003'
      TabOrder = 0
      Text = '00'
    end
    object ed_LogMin: TEdit
      Left = 123
      Top = 45
      Width = 24
      Height = 21
      ImeName = 'Microsoft IME 2003'
      TabOrder = 1
      Text = '10'
    end
    object ed_LogHour: TEdit
      Left = 68
      Top = 45
      Width = 24
      Height = 21
      ImeName = 'Microsoft IME 2003'
      TabOrder = 2
      Text = '00'
    end
    object cb_LoadCellID: TComboBox
      Left = 68
      Top = 21
      Width = 123
      Height = 21
      ImeName = 'Microsoft IME 2003'
      ItemHeight = 13
      TabOrder = 3
      Text = #47196#46300#49472' '#49440#53469
      Items.Strings = (
        'HFO1'
        'HFO2'
        'MDO1'
        'MDO2'
        'LDO'
        'BIO')
    end
    object cb_ExcelLog: TCheckBox
      Left = 68
      Top = 94
      Width = 52
      Height = 17
      Caption = 'Excel'
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
    object cb_DBLog: TCheckBox
      Left = 123
      Top = 94
      Width = 52
      Height = 17
      Caption = 'DB'
      Checked = True
      State = cbChecked
      TabOrder = 5
    end
    object ed_InterSec: TEdit
      Left = 123
      Top = 71
      Width = 24
      Height = 21
      ImeName = 'Microsoft IME 2003'
      TabOrder = 6
      Text = '01'
    end
    object ed_InterMin: TEdit
      Left = 68
      Top = 71
      Width = 24
      Height = 21
      ImeName = 'Microsoft IME 2003'
      TabOrder = 7
      Text = '00'
    end
  end
  object GroupBox1: TGroupBox
    Left = 12
    Top = 192
    Width = 308
    Height = 98
    Caption = #47196#44536
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 8
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object Label5: TLabel
      Left = 150
      Top = 67
      Width = 7
      Height = 13
      Caption = '~'
    end
    object Label8: TLabel
      Left = 6
      Top = 19
      Width = 63
      Height = 13
      Caption = #54788#51116#49345#53468' :   '
    end
    object lb_status: TLabel
      Left = 70
      Top = 19
      Width = 42
      Height = 13
      HelpType = htKeyword
      Caption = #45824#44592#51473'  '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = 8
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object bt_LogStart: TButton
      Left = 162
      Top = 14
      Width = 70
      Height = 42
      HelpType = htKeyword
      Caption = #44592#47197#49884#51089' '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 8
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = bt_LogStartClick
    end
    object bt_LogEnd: TButton
      Left = 232
      Top = 14
      Width = 70
      Height = 42
      Caption = #44592#47197#51333#47308
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 8
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = bt_LogEndClick
    end
    object Edit1: TEdit
      Left = 4
      Top = 36
      Width = 140
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ImeName = 'Microsoft IME 2003'
      ParentFont = False
      TabOrder = 2
      Text = #54788#51116#49884#44036' :'
    end
    object Edit2: TEdit
      Left = 4
      Top = 60
      Width = 140
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ImeName = 'Microsoft IME 2003'
      ParentFont = False
      TabOrder = 3
      Text = #49884#51089#49884#44036' :'
    end
    object ed_LogEndTime: TEdit
      Left = 161
      Top = 60
      Width = 140
      Height = 21
      ImeName = 'Microsoft IME 2003'
      TabOrder = 4
      Text = #47785#54364#49884#44036' :'
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 280
    Top = 24
  end
  object PopupMenu1: TPopupMenu
    Left = 248
    Top = 24
    object N1: TMenuItem
      Caption = #54872#44221#49444#51221
      OnClick = N1Click
    end
  end
  object Timer2: TTimer
    OnTimer = Timer2Timer
    Left = 215
    Top = 24
  end
end
