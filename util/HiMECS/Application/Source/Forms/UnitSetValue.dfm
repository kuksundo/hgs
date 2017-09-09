object SetCalarValueF: TSetCalarValueF
  Left = 0
  Top = 0
  Caption = 'Set Scalar Value'
  ClientHeight = 160
  ClientWidth = 378
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    378
    160)
  PixelsPerInch = 96
  TextHeight = 13
  object XLabel: TLabel
    Left = 60
    Top = 38
    Width = 37
    Height = 16
    Caption = 'Value:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object XCurValueEdit: TAdvEdit
    Left = 103
    Top = 35
    Width = 170
    Height = 24
    EmptyText = '(None)'
    EmptyTextStyle = [fsItalic]
    LabelFont.Charset = DEFAULT_CHARSET
    LabelFont.Color = clWindowText
    LabelFont.Height = -11
    LabelFont.Name = 'Tahoma'
    LabelFont.Style = []
    Lookup.Separator = ';'
    Color = clWindow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ImeName = 'Microsoft Office IME 2007'
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    Transparent = True
    Visible = True
    Version = '2.9.4.1'
  end
  object BitBtn1: TBitBtn
    Left = 103
    Top = 79
    Width = 170
    Height = 33
    Anchors = [akLeft, akBottom]
    Caption = 'Apply to Controller'
    TabOrder = 1
  end
end
