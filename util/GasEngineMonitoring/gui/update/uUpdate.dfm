object fmUpdate: TfmUpdate
  Left = 0
  Top = 0
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsDialog
  Caption = 'File Update'
  ClientHeight = 118
  ClientWidth = 319
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 10
    Top = 10
    Width = 300
    Height = 100
  end
  object Info: TLabel
    Left = 18
    Top = 18
    Width = 20
    Height = 13
    Caption = 'Info'
  end
  object Panel1: TPanel
    Left = 20
    Top = 50
    Width = 280
    Height = 50
    TabOrder = 0
    object MSG_1: TLabel
      Left = 10
      Top = 5
      Width = 33
      Height = 13
      Caption = 'MSG_1'
    end
    object pb1: TProgressBar
      Left = 5
      Top = 20
      Width = 270
      Height = 10
      Smooth = True
      TabOrder = 0
    end
    object pb2: TProgressBar
      Left = 5
      Top = 32
      Width = 270
      Height = 10
      Smooth = True
      TabOrder = 1
    end
  end
end
