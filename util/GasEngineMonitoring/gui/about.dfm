object AboutF: TAboutF
  Left = 200
  Top = 223
  Caption = 'About'
  ClientHeight = 186
  ClientWidth = 433
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 72
    Top = 24
    Width = 249
    Height = 80
    Caption = 
      'Program Name; Gas Engine Monitoring.'#13#10#13#10'Author: JH Park'#13#10#13#10'Creat' +
      'ed Date:  2010.06.18'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object VersionLavel: TLabel
    Left = 72
    Top = 128
    Width = 94
    Height = 16
    Caption = 'Version: 0.0.1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object BitBtn1: TBitBtn
    Left = 296
    Top = 128
    Width = 121
    Height = 33
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Kind = bkClose
  end
end
