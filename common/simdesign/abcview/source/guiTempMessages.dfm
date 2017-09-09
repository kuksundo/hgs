object dlgTempMessage: TdlgTempMessage
  Left = 566
  Top = 153
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Information'
  ClientHeight = 102
  ClientWidth = 356
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    356
    102)
  PixelsPerInch = 96
  TextHeight = 13
  object lblMessage: TLabel
    Left = 8
    Top = 16
    Width = 345
    Height = 33
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Message'
  end
  object btnOK: TBitBtn
    Left = 152
    Top = 52
    Width = 75
    Height = 25
    TabOrder = 0
    Kind = bkOK
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 80
    Width = 345
    Height = 17
    Caption = 'Do &not show in future'
    TabOrder = 1
  end
end
