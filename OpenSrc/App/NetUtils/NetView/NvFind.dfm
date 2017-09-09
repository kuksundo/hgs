object FindDialog: TFindDialog
  Left = 242
  Top = 117
  ActiveControl = cboName
  BorderStyle = bsDialog
  Caption = 'Find Network Resource'
  ClientHeight = 129
  ClientWidth = 398
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: TPageControl
    Left = 10
    Top = 10
    Width = 293
    Height = 109
    ActivePage = Page1
    TabOrder = 0
    object Page1: TTabSheet
      Caption = 'Resource'
      object lblName: TLabel
        Left = 20
        Top = 12
        Width = 31
        Height = 13
        Caption = '&Name:'
        FocusControl = cboName
      end
      object cboName: TComboBox
        Left = 59
        Top = 9
        Width = 218
        Height = 21
        ItemHeight = 13
        TabOrder = 0
      end
    end
  end
  object btnOk: TButton
    Left = 314
    Top = 30
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 314
    Top = 62
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
