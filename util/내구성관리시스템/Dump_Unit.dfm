object Dump_Frm: TDump_Frm
  Left = 0
  Top = 0
  Caption = #48177#50629' '#54532#47196#44536#47016
  ClientHeight = 131
  ClientWidth = 458
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 458
    Height = 131
    Align = alClient
    TabOrder = 0
    object Button1: TButton
      Left = 372
      Top = 91
      Width = 75
      Height = 25
      Caption = 'Back Up'
      TabOrder = 0
      OnClick = Button1Click
    end
    object tablelist: TAdvComboBox
      Left = 302
      Top = 8
      Width = 145
      Height = 21
      Color = clWindow
      Version = '1.4.0.0'
      Visible = True
      DropWidth = 0
      Enabled = True
      ImeName = 'Microsoft Office IME 2007'
      ItemIndex = -1
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
      TabOrder = 1
      Text = 'HITEMS_TMS_ATTFILES'
      OnSelect = tablelistSelect
    end
    object DateTimePicker2: TDateTimePicker
      Left = 296
      Top = 50
      Width = 154
      Height = 21
      Date = 41435.496994710650000000
      Time = 41435.496994710650000000
      ImeName = 'Microsoft Office IME 2007'
      TabOrder = 2
    end
    object DateTimePicker1: TDateTimePicker
      Left = 136
      Top = 50
      Width = 137
      Height = 21
      Date = 41435.496887106480000000
      Time = 41435.496887106480000000
      ImeName = 'Microsoft Office IME 2007'
      TabOrder = 3
    end
    object Panel1: TPanel
      Left = 24
      Top = 50
      Width = 89
      Height = 21
      Caption = #44592' '#44036' '
      TabOrder = 4
    end
  end
end
