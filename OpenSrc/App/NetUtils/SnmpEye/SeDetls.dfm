object DetailsDialog: TDetailsDialog
  Left = 262
  Top = 106
  BorderStyle = bsDialog
  Caption = 'Object Details'
  ClientHeight = 321
  ClientWidth = 337
  Color = clBtnFace
  ParentFont = True
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblOid: TLabel
    Left = 8
    Top = 2
    Width = 76
    Height = 13
    Caption = '&Object identifier:'
    FocusControl = edtOid
  end
  object lblName: TLabel
    Left = 8
    Top = 82
    Width = 31
    Height = 13
    Caption = 'Na&me:'
    FocusControl = edtName
  end
  object lblType: TLabel
    Left = 8
    Top = 162
    Width = 27
    Height = 13
    Caption = '&Type:'
    FocusControl = edtType
  end
  object lblValue: TLabel
    Left = 8
    Top = 202
    Width = 30
    Height = 13
    Caption = '&Value:'
    FocusControl = edtValue
  end
  object btnPrev: TButton
    Tag = -1
    Left = 94
    Top = 288
    Width = 75
    Height = 25
    Caption = '< &Previous'
    TabOrder = 4
    OnClick = ButtonClick
  end
  object btnNext: TButton
    Tag = 1
    Left = 169
    Top = 288
    Width = 75
    Height = 25
    Caption = '&Next >'
    TabOrder = 5
    OnClick = ButtonClick
  end
  object edtOid: TMemo
    Left = 8
    Top = 18
    Width = 321
    Height = 63
    Color = clBtnFace
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object edtValue: TMemo
    Left = 8
    Top = 218
    Width = 321
    Height = 63
    Color = clBtnFace
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object edtType: TMemo
    Left = 8
    Top = 178
    Width = 321
    Height = 23
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 2
    WordWrap = False
  end
  object edtName: TMemo
    Left = 8
    Top = 98
    Width = 321
    Height = 63
    Color = clBtnFace
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object btnClose: TButton
    Left = 254
    Top = 288
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Close'
    ModalResult = 1
    TabOrder = 6
  end
end
