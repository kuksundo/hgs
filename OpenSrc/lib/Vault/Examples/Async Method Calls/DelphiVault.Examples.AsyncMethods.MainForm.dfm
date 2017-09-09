object frmAsyncExample: TfrmAsyncExample
  Left = 0
  Top = 0
  Caption = 'Basic Async Method Call Example'
  ClientHeight = 446
  ClientWidth = 668
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object labClickMultiple: TLabel
    Left = 17
    Top = 155
    Width = 139
    Height = 26
    Caption = 'Click multiple times quickly to fire off a handful of threads'
    WordWrap = True
  end
  object labThreadPayload: TLabel
    Left = 172
    Top = 127
    Width = 75
    Height = 13
    Caption = 'Thread Payload'
  end
  object labAndreas: TLabel
    Left = 8
    Top = 400
    Width = 371
    Height = 13
    Caption = 
      'More powerful Asynch Method Calls available from Andreas Hauslad' +
      'en (MPL):'
  end
  object labPrimoz: TLabel
    Left = 8
    Top = 419
    Width = 402
    Height = 13
    Caption = 
      'Much more powerful threading platform available from Primoz Gabr' +
      'ijelcic (New BSD):'
  end
  object butExample1: TButton
    Left = 8
    Top = 13
    Width = 154
    Height = 25
    Cursor = crHandPoint
    Caption = 'Async Method Call'
    TabOrder = 0
    OnClick = butExample1Click
  end
  object memTaskStatus1: TMemo
    Left = 168
    Top = 15
    Width = 480
    Height = 89
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object memTaskStatus2: TMemo
    Left = 168
    Top = 155
    Width = 480
    Height = 227
    ScrollBars = ssVertical
    TabOrder = 5
  end
  object butExample2: TButton
    Left = 8
    Top = 124
    Width = 154
    Height = 25
    Cursor = crHandPoint
    Caption = 'Async Method with Callback'
    TabOrder = 2
    OnClick = butExample2Click
  end
  object edtPayload: TEdit
    Left = 256
    Top = 126
    Width = 270
    Height = 21
    Enabled = False
    TabOrder = 3
  end
  object chkAutoGen: TCheckBox
    Left = 532
    Top = 128
    Width = 122
    Height = 17
    Caption = 'AutoGen Unique Id'
    Checked = True
    State = cbChecked
    TabOrder = 4
    OnClick = chkAutoGenClick
  end
  object linkAsyncCalls: TLinkLabel
    Left = 387
    Top = 400
    Width = 55
    Height = 17
    Caption = 
      '<a href="http://andy.jgknet.de/blog/bugfix-units/asynccalls-29-a' +
      'synchronous-function-calls/">AsyncCalls</a>'
    TabOrder = 6
    OnLinkClick = LinkClick
  end
  object linkOTL: TLinkLabel
    Left = 416
    Top = 419
    Width = 101
    Height = 17
    Caption = 
      '<a href="http://code.google.com/p/omnithreadlibrary/">Omni Threa' +
      'd Library</a>'
    TabOrder = 7
    OnLinkClick = LinkClick
  end
end
