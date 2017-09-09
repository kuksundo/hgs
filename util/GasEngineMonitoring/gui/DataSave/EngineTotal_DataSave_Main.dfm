object DataSaveMain: TDataSaveMain
  Left = 0
  Top = 0
  Caption = 'Engine Total DataSaveMain'
  ClientHeight = 444
  ClientWidth = 313
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesigned
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 16
    Top = 248
    Width = 280
    Height = 96
    Caption = 'Save To'
    TabOrder = 0
    object CB_DBlogging: TCheckBox
      Left = 18
      Top = 16
      Width = 97
      Height = 17
      Caption = 'Database'
      TabOrder = 0
    end
    object CB_CSVlogging: TCheckBox
      Left = 18
      Top = 39
      Width = 97
      Height = 17
      Caption = 'CSV File'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object ED_csv: TEdit
      Left = 96
      Top = 62
      Width = 169
      Height = 21
      Enabled = False
      ImeName = 'Microsoft Office IME 2007'
      TabOrder = 2
    end
    object RB_bydate: TRadioButton
      Left = 96
      Top = 39
      Width = 65
      Height = 17
      Caption = 'By Date'
      Checked = True
      TabOrder = 3
      TabStop = True
      OnClick = RB_bydateClick
    end
    object RB_byfilename: TRadioButton
      Left = 167
      Top = 39
      Width = 82
      Height = 17
      Caption = 'By Filename'
      TabOrder = 4
      OnClick = RB_byfilenameClick
    end
  end
  object Protocol: TMemo
    Left = 16
    Top = 31
    Width = 280
    Height = 211
    ImeName = 'Microsoft Office IME 2007'
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 425
    Width = 313
    Height = 19
    Panels = <>
  end
  object CB_Active: TCheckBox
    Left = 16
    Top = 8
    Width = 97
    Height = 17
    Caption = 'Start Datasave'
    TabOrder = 3
    OnClick = CB_ActiveClick
  end
  object GroupBox2: TGroupBox
    Left = 16
    Top = 350
    Width = 280
    Height = 64
    Caption = 'Save Interval'
    TabOrder = 4
    object Label1: TLabel
      Left = 152
      Top = 40
      Width = 24
      Height = 13
      Caption = 'msec'
    end
    object RB_byevent: TRadioButton
      Left = 18
      Top = 16
      Width = 113
      Height = 17
      Caption = 'By Event'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = RB_byeventClick
    end
    object RB_byinterval: TRadioButton
      Left = 18
      Top = 39
      Width = 113
      Height = 17
      Caption = 'By Interval'
      TabOrder = 1
      OnClick = RB_byintervalClick
    end
    object ED_interval: TEdit
      Left = 96
      Top = 37
      Width = 49
      Height = 21
      BiDiMode = bdRightToLeft
      Enabled = False
      ImeName = 'Microsoft Office IME 2007'
      ParentBiDiMode = False
      TabOrder = 2
    end
  end
  object MainMenu1: TMainMenu
    Left = 131
    object FILE1: TMenuItem
      Caption = 'File'
      object Connect1: TMenuItem
        Caption = 'Connect'
        OnClick = Connect1Click
      end
      object Disconnect1: TMenuItem
        Caption = 'Disconnect'
        GroupIndex = 1
        OnClick = Disconnect1Click
      end
      object N1: TMenuItem
        Caption = '-'
        GroupIndex = 1
      end
      object Close1: TMenuItem
        Caption = 'Close'
        GroupIndex = 1
        OnClick = Close1Click
      end
    end
    object HELP1: TMenuItem
      Caption = 'Setting'
      object Option1: TMenuItem
        Caption = 'Option'
        OnClick = Option1Click
      end
    end
    object Help2: TMenuItem
      Caption = 'Help'
      object About1: TMenuItem
        Caption = 'About'
        OnClick = About1Click
      end
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 163
  end
  object Timer2: TTimer
    Enabled = False
    Left = 200
  end
end
