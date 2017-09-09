object frmAddDevice: TfrmAddDevice
  Left = 2903
  Height = 258
  Top = 265
  Width = 487
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Добавить устройство'
  ClientHeight = 258
  ClientWidth = 487
  Position = poMainFormCenter
  LCLVersion = '1.5'
  object lbDevNumber: TLabel
    Left = 8
    Height = 20
    Top = 8
    Width = 127
    Caption = 'Номер устройства:'
    ParentColor = False
  end
  object btOk: TButton
    Left = 313
    Height = 25
    Top = 224
    Width = 75
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 0
  end
  object btCancel: TButton
    Left = 401
    Height = 25
    Top = 224
    Width = 75
    Anchors = [akRight, akBottom]
    Caption = 'Отмена'
    ModalResult = 2
    TabOrder = 1
  end
  object speDevNumber: TSpinEdit
    Left = 144
    Height = 32
    Top = 8
    Width = 64
    MaxValue = 255
    MinValue = 1
    TabOrder = 2
    Value = 1
  end
  object cgFunctions: TCheckGroup
    Left = 8
    Height = 165
    Top = 48
    Width = 216
    AutoFill = True
    Caption = 'Поддерживаемые функции'
    ChildSizing.LeftRightSpacing = 6
    ChildSizing.TopBottomSpacing = 6
    ChildSizing.EnlargeHorizontal = crsHomogenousChildResize
    ChildSizing.EnlargeVertical = crsHomogenousChildResize
    ChildSizing.ShrinkHorizontal = crsScaleChilds
    ChildSizing.ShrinkVertical = crsScaleChilds
    ChildSizing.Layout = cclLeftToRightThenTopToBottom
    ChildSizing.ControlsPerLine = 3
    ClientHeight = 144
    ClientWidth = 214
    Columns = 3
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '15'
      '16'
      '23'
    )
    TabOrder = 3
    Data = {
      09000000020203020203020202
    }
  end
  object gbDefVlaues: TGroupBox
    Left = 232
    Height = 165
    Top = 48
    Width = 245
    Caption = 'Значения "по умолчанию"'
    ClientHeight = 144
    ClientWidth = 243
    TabOrder = 4
    object lbCoils: TLabel
      Left = 7
      Height = 20
      Top = 3
      Width = 94
      Caption = 'Coil регистры:'
      ParentColor = False
    end
    object lbDiscret: TLabel
      Left = 7
      Height = 20
      Top = 35
      Width = 115
      Caption = 'Discret регистры:'
      ParentColor = False
    end
    object lbHolding: TLabel
      Left = 7
      Height = 20
      Top = 67
      Width = 119
      Caption = 'Holding регистры:'
      ParentColor = False
    end
    object lbInput: TLabel
      Left = 7
      Height = 20
      Top = 103
      Width = 103
      Caption = 'Input регистры:'
      ParentColor = False
    end
    object cbCoilsDefValue: TComboBox
      Left = 135
      Height = 28
      Top = 3
      Width = 100
      ItemHeight = 0
      ItemIndex = 0
      Items.Strings = (
        'False'
        'True'
      )
      Style = csDropDownList
      TabOrder = 0
      Text = 'False'
    end
    object cbDiscretDefValue: TComboBox
      Left = 135
      Height = 28
      Top = 35
      Width = 100
      ItemHeight = 0
      ItemIndex = 0
      Items.Strings = (
        'False'
        'True'
      )
      Style = csDropDownList
      TabOrder = 1
      Text = 'False'
    end
    object speHoldingDefValue: TSpinEdit
      Left = 135
      Height = 32
      Top = 67
      Width = 98
      MaxValue = 65535
      TabOrder = 2
    end
    object speInputDefValue: TSpinEdit
      Left = 135
      Height = 32
      Top = 103
      Width = 98
      MaxValue = 65535
      TabOrder = 3
    end
  end
end
