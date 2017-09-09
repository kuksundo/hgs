object frmChennelRSAdd: TfrmChennelRSAdd
  Left = 2407
  Height = 278
  Top = 258
  Width = 395
  BorderStyle = bsDialog
  Caption = 'Добавить последовательный канал'
  ClientHeight = 278
  ClientWidth = 395
  Position = poOwnerFormCenter
  LCLVersion = '1.5'
  object btOk: TButton
    Left = 221
    Height = 25
    Top = 241
    Width = 80
    Anchors = [akRight, akBottom]
    Caption = 'Добавить'
    ModalResult = 1
    OnClick = btOkClick
    TabOrder = 8
  end
  object btCancel: TButton
    Left = 309
    Height = 25
    Top = 241
    Width = 75
    Anchors = [akRight, akBottom]
    Caption = 'Отмена'
    ModalResult = 2
    TabOrder = 9
  end
  object lbPrefix: TLabel
    Left = 8
    Height = 20
    Top = 46
    Width = 65
    Caption = 'Префикс:'
    FocusControl = cmbPrefix
    ParentColor = False
  end
  object cmbPrefix: TComboBox
    Left = 80
    Height = 28
    Top = 46
    Width = 104
    ItemHeight = 0
    ItemIndex = 0
    Items.Strings = (
      '/dev/ttyS'
      'Other'
    )
    OnChange = cmbPrefixChange
    Style = csDropDownList
    TabOrder = 1
    Text = '/dev/ttyS'
  end
  object edPrefixOther: TEdit
    Left = 192
    Height = 32
    Top = 46
    Width = 192
    ReadOnly = True
    TabOrder = 2
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
    Left = 112
    Height = 32
    Top = 86
    Width = 80
    MaxValue = 255
    TabOrder = 3
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
    Width = 112
    ItemHeight = 0
    ItemIndex = 12
    Items.Strings = (
      '50'
      '75'
      '110'
      '134'
      '150'
      '200'
      '300'
      '600'
      '1200'
      '1800'
      '2400'
      '4800'
      '9600'
      '19200'
      '38400'
      '57600'
      '115200'
      '230400'
      '460800'
      '500000'
      '576000'
      '921600'
      '1000000'
      '1152000'
      '1500000'
      '2000000'
      '2500000'
      '3000000'
      '3500000'
      '4000000'
    )
    Style = csDropDownList
    TabOrder = 4
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
    TabOrder = 5
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
    Width = 112
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
    TabOrder = 6
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
    TabOrder = 7
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
    Width = 288
    TabOrder = 0
    Text = 'Последовательный канал'
  end
  object lbPackRuptureTime: TLabel
    Left = 7
    Height = 20
    Top = 200
    Width = 102
    Caption = 'IntervalTimeout'
    FocusControl = spIntervalTimeout
    ParentColor = False
  end
  object spIntervalTimeout: TSpinEdit
    Left = 112
    Height = 32
    Top = 200
    Width = 102
    MaxValue = 65535
    TabOrder = 10
    Value = 200
  end
end
