object f_IsAdminTest: Tf_IsAdminTest
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Is Admin Test'
  ClientHeight = 65
  ClientWidth = 386
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object l_Result: TLabel
    Left = 16
    Top = 8
    Width = 118
    Height = 13
    Caption = 'Result (do not translate)'
  end
  object b_Exit: TButton
    Left = 304
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Exit'
    TabOrder = 0
    OnClick = b_ExitClick
  end
end
