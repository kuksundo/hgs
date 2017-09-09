object NewHostDialog: TNewHostDialog
  Left = 275
  Top = 157
  BorderStyle = bsDialog
  Caption = 'New Host'
  ClientHeight = 113
  ClientWidth = 313
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object lblHostName: TLabel
    Left = 8
    Top = 11
    Width = 56
    Height = 13
    Caption = '&Host Name:'
    FocusControl = edtHostName
  end
  object lblMacAddress: TLabel
    Left = 8
    Top = 43
    Width = 67
    Height = 13
    Caption = '&MAC Address:'
    FocusControl = edtMacAddress
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
  object edtHostName: TEdit
    Left = 120
    Top = 8
    Width = 129
    Height = 21
    MaxLength = 255
    TabOrder = 0
  end
  object edtMacAddress: TEdit
    Left = 120
    Top = 40
    Width = 129
    Height = 21
    MaxLength = 17
    TabOrder = 1
  end
end
