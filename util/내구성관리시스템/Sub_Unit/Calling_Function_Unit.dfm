object Calling_Function_Frm: TCalling_Function_Frm
  Left = 0
  Top = 0
  Caption = 'Calling_Function_Frm'
  ClientHeight = 247
  ClientWidth = 543
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object AdvScrollBox1: TAdvScrollBox
    Left = 0
    Top = 0
    Width = 543
    Height = 247
    Align = alClient
    DoubleBuffered = True
    Color = clBtnFace
    Ctl3D = False
    ParentColor = False
    ParentCtl3D = False
    ParentDoubleBuffered = False
    TabOrder = 0
    object Label2: TLabel
      Left = 31
      Top = 395
      Width = 6
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edit1: TEdit
      Left = 27
      Top = 70
      Width = 480
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ImeName = 'Microsoft Office IME 2007'
      ParentFont = False
      TabOrder = 0
    end
    object Panel28: TPanel
      Left = 25
      Top = 36
      Width = 192
      Height = 33
      BevelOuter = bvNone
      Caption = 'Messenger Contant :'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'HY'#54756#46300#46972#51064'M'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object Button1: TButton
      Left = 434
      Top = 165
      Width = 73
      Height = 41
      Caption = 'Send'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
  end
  object IdTCPServer1: TIdTCPServer
    Bindings = <>
    DefaultPort = 0
    Left = 120
    Top = 160
  end
  object IdThreadComponent1: TIdThreadComponent
    Active = False
    Loop = False
    Priority = tpNormal
    StopMode = smTerminate
    Left = 216
    Top = 160
  end
end
