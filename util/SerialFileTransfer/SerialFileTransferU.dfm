object formSerial: TformSerial
  Left = 316
  Top = 119
  Caption = 'Serial File Transfer'
  ClientHeight = 320
  ClientWidth = 273
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 8
    Top = 144
    Width = 82
    Height = 13
    Caption = 'Serial port name:'
    Color = clBtnFace
    ParentColor = False
  end
  object Label3: TLabel
    Left = 13
    Top = 176
    Width = 34
    Height = 13
    Caption = 'Act as:'
    Color = clBtnFace
    ParentColor = False
  end
  object Label4: TLabel
    Left = 11
    Top = 205
    Width = 45
    Height = 13
    Caption = 'File path:'
    Color = clBtnFace
    ParentColor = False
  end
  object Label5: TLabel
    Left = -1
    Top = 8
    Width = 240
    Height = 24
    Alignment = taCenter
    AutoSize = False
    Caption = 'Serial File Transfer'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object btnConnect: TButton
    Left = 49
    Top = 264
    Width = 135
    Height = 25
    Caption = 'Connect'
    TabOrder = 0
    OnClick = btnConnectClick
  end
  object comboClientServer: TComboBox
    Left = 120
    Top = 176
    Width = 108
    Height = 21
    ImeName = 'Microsoft Office IME 2007'
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 1
    Text = 'Server'
    Items.Strings = (
      'Server'
      'Client')
  end
  object editDevice: TEdit
    Left = 120
    Top = 144
    Width = 108
    Height = 21
    ImeName = 'Microsoft Office IME 2007'
    TabOrder = 2
    Text = 'COM1'
  end
  object ScrollBox1: TScrollBox
    Left = 8
    Top = 32
    Width = 227
    Height = 102
    TabOrder = 3
    object Label1: TLabel
      Left = 0
      Top = 0
      Width = 216
      Height = 160
      AutoSize = False
      Caption = 
        'Serial client-server communication test. Two instances of this p' +
        'rogram should be running. One in a client machine and another in' +
        ' a server machine. The server will send a file to the client. Bo' +
        'th should specify the correct serial port name, a file path (of ' +
        'the file to be sent or where to place the received file) and bot' +
        'h should connect to each other within 10 seconds in order for th' +
        'e communication to occur.'
      Color = clBtnFace
      ParentColor = False
      WordWrap = True
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 297
    Width = 273
    Height = 23
    Panels = <>
  end
  object editFileName: TJvFilenameEdit
    Left = 120
    Top = 208
    Width = 121
    Height = 21
    ImeName = 'Microsoft Office IME 2007'
    TabOrder = 5
    Text = 'editFileName'
  end
  object timerServerConnect: TTimer
    Enabled = False
    OnTimer = timerServerConnectTimer
    Left = 16
    Top = 40
  end
  object timerClientConnect: TTimer
    Enabled = False
    OnTimer = timerClientConnectTimer
    Left = 16
    Top = 8
  end
end
