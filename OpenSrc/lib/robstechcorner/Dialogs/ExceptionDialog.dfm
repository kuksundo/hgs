object ExceptionDlg: TExceptionDlg
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Error'
  ClientHeight = 76
  ClientWidth = 232
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    232
    76)
  PixelsPerInch = 96
  TextHeight = 13
  object lblError: TLabel
    Left = 8
    Top = 16
    Width = 69
    Height = 13
    Caption = 'Error Message'
  end
  object btnSend: TButton
    Left = 8
    Top = 43
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Send'
    ModalResult = 6
    TabOrder = 0
    ExplicitTop = 102
  end
  object btnOK: TButton
    Left = 149
    Top = 43
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
    ExplicitLeft = 309
    ExplicitTop = 102
  end
end
