object f_dzInputDialog: Tf_dzInputDialog
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'InputQuery'
  ClientHeight = 89
  ClientWidth = 402
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    402
    89)
  PixelsPerInch = 96
  TextHeight = 13
  object l_Query: TLabel
    Left = 8
    Top = 8
    Width = 81
    Height = 13
    Caption = 'Query goes here'
  end
  object ed_Input: TEdit
    Left = 8
    Top = 24
    Width = 385
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    OnChange = ed_InputChange
  end
  object b_Ok: TButton
    Left = 240
    Top = 56
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object b_Cancel: TButton
    Left = 320
    Top = 56
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
