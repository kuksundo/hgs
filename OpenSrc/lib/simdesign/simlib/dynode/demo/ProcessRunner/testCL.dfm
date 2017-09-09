object Form1: TForm1
  Left = 458
  Top = 241
  Width = 472
  Height = 490
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 416
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object lbRun: TLabel
    Left = 160
    Top = 416
    Width = 28
    Height = 13
    Caption = 'lbRun'
  end
  object Label2: TLabel
    Left = 64
    Top = 416
    Width = 32
    Height = 13
    Caption = 'Label2'
  end
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Test CL'
    TabOrder = 0
    OnClick = Button1Click
  end
  object mmDebug: TMemo
    Left = 8
    Top = 328
    Width = 433
    Height = 81
    TabOrder = 1
    WordWrap = False
  end
  object mmApp: TMemo
    Left = 8
    Top = 40
    Width = 433
    Height = 25
    Lines.Strings = (
      'D:\fpc\2.6.4\win32\bin\i386-win32\fpc.exe')
    TabOrder = 2
  end
  object mmInput: TMemo
    Left = 8
    Top = 104
    Width = 433
    Height = 33
    Lines.Strings = (
      'compile winhello.pp')
    TabOrder = 3
  end
  object mmOutput: TMemo
    Left = 8
    Top = 144
    Width = 433
    Height = 177
    TabOrder = 4
  end
  object btnStop: TButton
    Left = 360
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Stop app'
    TabOrder = 5
  end
  object mmCurrentDir: TMemo
    Left = 8
    Top = 72
    Width = 433
    Height = 25
    Lines.Strings = (
      'D:\fpc\2.6.4\win32\demo\win32')
    TabOrder = 6
  end
  object btnPipe: TButton
    Left = 200
    Top = 8
    Width = 89
    Height = 25
    Caption = 'Piped Process'
    TabOrder = 7
    OnClick = btnPipeClick
  end
  object btnDirect: TButton
    Left = 96
    Top = 8
    Width = 89
    Height = 25
    Caption = 'Direct Process'
    TabOrder = 8
    OnClick = btnDirectClick
  end
end
