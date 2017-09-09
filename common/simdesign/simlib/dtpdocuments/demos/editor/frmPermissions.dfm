object dlgPermissions: TdlgPermissions
  Left = 622
  Top = 287
  Width = 298
  Height = 334
  Caption = 'Edit Permissions'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 40
    Top = 136
    Width = 233
    Height = 33
    AutoSize = False
    Caption = 'Warning: If checked you cannot select the shape(s) later'
    WordWrap = True
  end
  object chbAllowMove: TCheckBox
    Left = 16
    Top = 16
    Width = 177
    Height = 17
    Caption = 'Allow Shape Move'
    TabOrder = 0
  end
  object chbAllowResize: TCheckBox
    Left = 16
    Top = 64
    Width = 177
    Height = 17
    Caption = 'Allow Shape Resize'
    TabOrder = 1
  end
  object chbAllowRotate: TCheckBox
    Left = 16
    Top = 88
    Width = 177
    Height = 17
    Caption = 'Allow Shape Rotate'
    TabOrder = 2
  end
  object chbAllowSelect: TCheckBox
    Left = 16
    Top = 120
    Width = 177
    Height = 17
    Caption = 'Allow Shape Select'
    TabOrder = 3
  end
  object chbPreserveAspect: TCheckBox
    Left = 16
    Top = 176
    Width = 177
    Height = 17
    Caption = 'Preserve Aspect Ratio'
    TabOrder = 4
  end
  object btnOK: TButton
    Left = 56
    Top = 272
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 5
  end
  object btnCancel: TButton
    Left = 152
    Top = 272
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 6
  end
  object chbAllowDelete: TCheckBox
    Left = 16
    Top = 40
    Width = 177
    Height = 17
    Caption = 'Allow Shape Delete'
    TabOrder = 7
  end
end
