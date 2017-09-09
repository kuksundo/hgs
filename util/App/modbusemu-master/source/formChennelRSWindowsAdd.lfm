object frmChennelRSAddWin: TfrmChennelRSAddWin
  Left = 2742
  Height = 353
  Top = 331
  Width = 393
  BorderStyle = bsDialog
  Caption = 'Добавить последовательный канал'
  ClientHeight = 353
  ClientWidth = 393
  Position = poOwnerFormCenter
  LCLVersion = '1.5'
  object btOk: TButton
    Left = 219
    Height = 25
    Top = 316
    Width = 80
    Anchors = [akRight, akBottom]
    Caption = 'Добавить'
    ModalResult = 1
    OnClick = btOkClick
    TabOrder = 0
  end
  object btCancel: TButton
    Left = 307
    Height = 25
    Top = 316
    Width = 75
    Anchors = [akRight, akBottom]
    Caption = 'Отмена'
    ModalResult = 2
    TabOrder = 1
  end
  object lbPrefix: TLabel
    Left = 8
    Height = 20
    Top = 51
    Width = 65
    Caption = 'Префикс:'
    ParentColor = False
  end
  object lbPortNum: TLabel
    Left = 8
    Height = 20
    Top = 86
    Width = 91
    Caption = 'Номер порта:'
    FocusControl = spePortNum
    ParentColor = False
  end
  object spePortNum: TSpinEdit
    Tag = 1
    Left = 112
    Height = 32
    Top = 86
    Width = 80
    MaxValue = 255
    MinValue = 1
    TabOrder = 2
    Value = 1
  end
  object lbBaudRate: TLabel
    Left = 201
    Height = 20
    Top = 86
    Width = 66
    Caption = 'Скорость:'
    FocusControl = cmbBaudRate
    ParentColor = False
  end
  object cmbBaudRate: TComboBox
    Left = 272
    Height = 28
    Top = 86
    Width = 110
    ItemHeight = 0
    ItemIndex = 9
    Items.Strings = (
      '75'
      '110'
      '150'
      '300'
      '600'
      '1200'
      '1800'
      '2400'
      '4800'
      '9600'
      '14400'
      '19200'
      '28800'
      '38400'
      '57600'
      '115200'
    )
    Style = csDropDownList
    TabOrder = 3
    Text = '9600'
  end
  object lbByteSize: TLabel
    Left = 8
    Height = 20
    Top = 126
    Width = 94
    Caption = 'Размер байта:'
    FocusControl = cmbByteSize
    ParentColor = False
  end
  object cmbByteSize: TComboBox
    Left = 112
    Height = 28
    Top = 126
    Width = 76
    ItemHeight = 0
    ItemIndex = 3
    Items.Strings = (
      '5'
      '6'
      '7'
      '8'
    )
    Style = csDropDownList
    TabOrder = 4
    Text = '8'
  end
  object lbParitet: TLabel
    Left = 201
    Height = 20
    Top = 126
    Width = 59
    Caption = 'Паритет:'
    FocusControl = cmbParitet
    ParentColor = False
  end
  object cmbParitet: TComboBox
    Left = 272
    Height = 28
    Top = 126
    Width = 110
    ItemHeight = 0
    ItemIndex = 2
    Items.Strings = (
      'NONE'
      'ODD'
      'EVEN'
      'MARK'
      'SPACE'
    )
    Style = csDropDownList
    TabOrder = 5
    Text = 'EVEN'
  end
  object lbStopBits: TLabel
    Left = 8
    Height = 20
    Top = 162
    Width = 96
    Caption = 'Стоповых бит:'
    FocusControl = cmbStopBits
    ParentColor = False
  end
  object cmbStopBits: TComboBox
    Left = 112
    Height = 28
    Top = 162
    Width = 100
    ItemHeight = 0
    ItemIndex = 0
    Items.Strings = (
      '1'
      '1,5'
      '2'
    )
    Style = csDropDownList
    TabOrder = 6
    Text = '1'
  end
  object lbName: TLabel
    Left = 8
    Height = 20
    Top = 8
    Width = 80
    Caption = 'Имя канала:'
    ParentColor = False
  end
  object edChennalName: TEdit
    Left = 96
    Height = 32
    Top = 8
    Width = 286
    TabOrder = 7
    Text = 'Последовательный канал'
  end
  object lbPrefixName: TLabel
    Left = 96
    Height = 20
    Top = 51
    Width = 52
    Caption = '\\.\COM'
    ParentColor = False
  end
  object lbPackRupt: TLabel
    Left = 8
    Height = 20
    Top = 200
    Width = 102
    Caption = 'IntervalTimeout'
    FocusControl = spIntervalTimeout
    ParentColor = False
  end
  object lbTotalMulti: TLabel
    Left = 8
    Height = 20
    Top = 236
    Width = 147
    Caption = 'TotalTimeoutMultiplier'
    FocusControl = spTotalMulti
    ParentColor = False
  end
  object lbTotalConst: TLabel
    Left = 8
    Height = 20
    Top = 272
    Width = 146
    Caption = 'TotalTimeoutConstant'
    FocusControl = spTotalConst
    ParentColor = False
  end
  object spIntervalTimeout: TSpinEdit
    Left = 168
    Height = 32
    Top = 200
    Width = 130
    MaxValue = 65535
    TabOrder = 8
    Value = 200
  end
  object spTotalMulti: TSpinEdit
    Left = 168
    Height = 32
    Top = 236
    Width = 130
    MaxValue = 65535
    TabOrder = 9
    Value = 10
  end
  object spTotalConst: TSpinEdit
    Left = 168
    Height = 32
    Top = 272
    Width = 130
    MaxValue = 65535
    TabOrder = 10
    Value = 10
  end
end
