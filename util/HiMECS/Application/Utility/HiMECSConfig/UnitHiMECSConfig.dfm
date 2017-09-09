object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'HiMECS Config(Make Option File)'
  ClientHeight = 294
  ClientWidth = 438
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 438
    Height = 89
    Align = alTop
    TabOrder = 0
    object Button1: TButton
      Left = 72
      Top = 8
      Width = 137
      Height = 33
      Caption = 'New Configuration'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 239
      Top = 8
      Width = 137
      Height = 33
      Caption = 'Open Configuration'
      TabOrder = 1
      OnClick = Button2Click
    end
    object EncryptOpenCB: TCheckBox
      Left = 72
      Top = 64
      Width = 193
      Height = 17
      Caption = 'Encrypt Option File when open'
      TabOrder = 2
    end
    object EncryptSaveCB: TCheckBox
      Left = 72
      Top = 47
      Width = 193
      Height = 17
      Caption = 'Encrypt Option File when save'
      TabOrder = 3
    end
  end
  object ProjectItemLB: TListBox
    Left = 0
    Top = 89
    Width = 438
    Height = 205
    Align = alClient
    ImeName = 'Microsoft Office IME 2007'
    ItemHeight = 13
    TabOrder = 1
  end
  object JvOpenDialog1: TJvOpenDialog
    Filter = 'Option File|*.option|All Files(*.*)|*.*'
    Height = 0
    Width = 0
    Left = 16
    Top = 8
  end
  object JvSaveDialog1: TJvSaveDialog
    Filter = 'Option File|*.option|All Files(*.*)|*.*'
    Height = 0
    Width = 0
    Left = 48
    Top = 8
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 16
    Top = 56
  end
end
