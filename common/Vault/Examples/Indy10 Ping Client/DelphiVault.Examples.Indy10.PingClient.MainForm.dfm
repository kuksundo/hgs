object frmThreadedPingSample: TfrmThreadedPingSample
  Left = 0
  Top = 0
  Caption = 
    'Ping Client Example  (Reminder: requires Admin rights for raw so' +
    'cket access)'
  ClientHeight = 185
  ClientWidth = 569
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
  object edtHost: TEdit
    Left = 18
    Top = 13
    Width = 121
    Height = 21
    TabOrder = 0
    Text = '127.0.0.1'
  end
  object butPING: TButton
    Left = 20
    Top = 40
    Width = 103
    Height = 25
    Cursor = crHandPoint
    Hint = 'Ping using a callback procedure'
    Caption = 'Ping With Callback'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = butPINGClick
  end
  object Memo1: TMemo
    Left = 145
    Top = 13
    Width = 401
    Height = 156
    TabOrder = 3
  end
  object butStartPing: TButton
    Left = 20
    Top = 144
    Width = 103
    Height = 25
    Cursor = crHandPoint
    Hint = 'Threaded Ping calls using a custom TThreadedPing descendant'
    Caption = 'Threaded Pings'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = butStartPingClick
  end
end
