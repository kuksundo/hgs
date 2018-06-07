object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'MAPS'#51032' '#44277#49324#51221#48372#54788#54889' '#54028#51068#50640#49436' '#51204#51204' Hull No '#48143' ProjNo'#47484'  Intras'#51032' '#48156#51204#44592' '#54028#51068#50640' '#47588#54609#54632
  ClientHeight = 229
  ClientWidth = 607
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 56
    Top = 80
    Width = 89
    Height = 13
    Caption = 'Hull No File Name :'
  end
  object Label1: TLabel
    Left = 336
    Top = 80
    Width = 91
    Height = 13
    Caption = 'Proj No File Name :'
  end
  object Label3: TLabel
    Left = 287
    Top = 102
    Width = 24
    Height = 13
    Caption = '==>'
  end
  object JvFilenameEdit1: TJvFilenameEdit
    Left = 56
    Top = 99
    Width = 201
    Height = 21
    ImeName = 'Microsoft IME 2010'
    TabOrder = 0
    Text = ''
  end
  object JvFilenameEdit2: TJvFilenameEdit
    Left = 336
    Top = 99
    Width = 201
    Height = 21
    ImeName = 'Microsoft IME 2010'
    TabOrder = 1
    Text = ''
  end
  object Button1: TButton
    Left = 224
    Top = 144
    Width = 169
    Height = 41
    Caption = 'Transfer Hull No'
    TabOrder = 2
    OnClick = Button1Click
  end
end
