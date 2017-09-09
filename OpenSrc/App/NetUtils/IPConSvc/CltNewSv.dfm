object NewServerDialog: TNewServerDialog
  Left = 275
  Top = 157
  BorderStyle = bsDialog
  Caption = 'New Server'
  ClientHeight = 113
  ClientWidth = 313
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object lblIpAddress: TLabel
    Left = 8
    Top = 11
    Width = 54
    Height = 13
    Caption = '&IP Address:'
    FocusControl = edtIpAddress
  end
  object lblPort: TLabel
    Left = 8
    Top = 43
    Width = 22
    Height = 13
    Caption = '&Port:'
    FocusControl = edtPort
  end
  object btnOk: TButton
    Left = 149
    Top = 80
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 230
    Top = 80
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object edtIpAddress: TEdit
    Left = 120
    Top = 8
    Width = 129
    Height = 21
    MaxLength = 15
    TabOrder = 0
  end
  object edtPort: TEdit
    Left = 120
    Top = 40
    Width = 129
    Height = 21
    MaxLength = 5
    TabOrder = 1
  end
end
