object fMain: TfMain
  Left = 0
  Top = 0
  Caption = 'IPC Client'
  ClientHeight = 394
  ClientWidth = 615
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lbServerName: TLabel
    Left = 10
    Top = 16
    Width = 62
    Height = 13
    Caption = 'Server Name'
  end
  object lbComputerName: TLabel
    Left = 8
    Top = 62
    Width = 77
    Height = 13
    Caption = 'Computer Name'
  end
  object eServerName: TEdit
    Left = 8
    Top = 35
    Width = 135
    Height = 21
    TabOrder = 0
    Text = 'TestServer'
  end
  object ListBox1: TListBox
    Left = 149
    Top = 16
    Width = 458
    Height = 370
    ItemHeight = 13
    TabOrder = 1
  end
  object btnSendSynchronous: TButton
    Left = 8
    Top = 118
    Width = 135
    Height = 25
    Caption = 'Send Synchronous'
    TabOrder = 2
    OnClick = btnSendSynchronousClick
  end
  object eComputerName: TEdit
    Left = 8
    Top = 83
    Width = 135
    Height = 21
    TabOrder = 3
  end
  object btnSendASynchronous: TButton
    Left = 8
    Top = 149
    Width = 135
    Height = 25
    Caption = 'Send Asynchronous'
    TabOrder = 4
    OnClick = btnSendASynchronousClick
  end
  object Button1: TButton
    Left = 8
    Top = 180
    Width = 135
    Height = 25
    Caption = 'Send File'
    TabOrder = 5
    OnClick = Button1Click
  end
  object OpenDialog1: TOpenDialog
    Left = 72
    Top = 224
  end
end
