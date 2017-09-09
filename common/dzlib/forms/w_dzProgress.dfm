object f_dzProgress: Tf_dzProgress
  Left = 402
  Top = 269
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Progress (%d%%)'
  ClientHeight = 49
  ClientWidth = 393
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object l_Action: TLabel
    Left = 8
    Top = 0
    Width = 30
    Height = 13
    Caption = 'Action'
    Layout = tlCenter
  end
  object pb_Progress: TProgressBar
    Left = 8
    Top = 24
    Width = 297
    Height = 16
    Position = 30
    TabOrder = 0
  end
  object b_Abort: TButton
    Left = 312
    Top = 20
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Abort'
    TabOrder = 1
    OnClick = b_AbortClick
  end
end
