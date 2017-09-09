object SendDialog: TSendDialog
  Left = 286
  Top = 168
  BorderStyle = bsDialog
  Caption = 'Wakeup One Host'
  ClientHeight = 145
  ClientWidth = 241
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
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
  object lblMacAddress: TLabel
    Left = 8
    Top = 43
    Width = 67
    Height = 13
    Caption = '&MAC Address:'
    FocusControl = edtMacAddress
  end
  object btnSend: TButton
    Left = 77
    Top = 112
    Width = 75
    Height = 25
    Caption = '&Send'
    Default = True
    TabOrder = 2
    OnClick = btnSendClick
  end
  object btnClose: TButton
    Left = 158
    Top = 112
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Close'
    ModalResult = 2
    TabOrder = 3
  end
  object edtIpAddress: TEdit
    Left = 104
    Top = 8
    Width = 129
    Height = 21
    MaxLength = 15
    TabOrder = 0
  end
  object edtMacAddress: TEdit
    Left = 104
    Top = 40
    Width = 129
    Height = 21
    MaxLength = 17
    TabOrder = 1
  end
  object StaticText: TStaticText
    Left = 8
    Top = 72
    Width = 225
    Height = 21
    AutoSize = False
    BorderStyle = sbsSunken
    TabOrder = 4
  end
end
