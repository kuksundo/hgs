object f_dzMultiProgress: Tf_dzMultiProgress
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Progress (%d%%)'
  ClientHeight = 33
  ClientWidth = 393
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object pb_Progress: TProgressBar
    Left = 8
    Top = 8
    Width = 297
    Height = 16
    Position = 30
    TabOrder = 0
    Visible = False
  end
  object b_Abort: TButton
    Left = 312
    Top = 4
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Abort'
    TabOrder = 1
    OnClick = b_AbortClick
  end
end
