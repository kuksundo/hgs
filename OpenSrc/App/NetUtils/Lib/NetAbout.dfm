object AboutDialog: TAboutDialog
  Left = 257
  Top = 155
  BorderStyle = bsDialog
  Caption = 'About'
  ClientHeight = 89
  ClientWidth = 361
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object imgProgram: TImage
    Left = 16
    Top = 17
    Width = 48
    Height = 48
    Transparent = True
    IsControl = True
  end
  object lblVersion: TLabel
    Left = 80
    Top = 29
    Width = 99
    Height = 13
    Caption = 'Version %s (Build %s)'
    IsControl = True
  end
  object lblCopyright: TLabel
    Left = 80
    Top = 48
    Width = 154
    Height = 13
    Caption = 'Copyright '#169' 1999-%s Vadim Crits'
    IsControl = True
  end
  object lblName: TLabel
    Left = 80
    Top = 9
    Width = 28
    Height = 13
    Caption = 'Name'
  end
  object btnOk: TButton
    Left = 276
    Top = 10
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
end
