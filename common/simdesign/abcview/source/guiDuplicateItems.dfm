inherited DupeFrame: TDupeFrame
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 183
    Height = 18
    Caption = 'Exact Duplicate Files '
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -16
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 8
    Top = 32
    Width = 537
    Height = 81
    AutoSize = False
    Caption = 
      'Exact duplicate files are files that are identical when looking ' +
      'at them byte for byte. Consequently, they'#39're equal in file size.' +
      ' '#13#10#13#10'ABC-View Manager uses this: it first sorts the files by siz' +
      'e then it compares the equally sized files'#39' CRC32 value. The com' +
      'bination of size equality and CRC32 equality is a highly  fullpr' +
      'oof guaratee that the files are completely identical. '
    WordWrap = True
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 120
    Width = 545
    Height = 81
    Caption = 'Automatic Actions'
    TabOrder = 0
    object chbNotify: TCheckBox
      Left = 8
      Top = 24
      Width = 529
      Height = 17
      Caption = 'Notify me when the duplicates check is finished'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object chbSortOnDupes: TCheckBox
      Left = 8
      Top = 48
      Width = 529
      Height = 17
      Caption = 'Sort on Duplicate Group when finished'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 208
    Width = 545
    Height = 113
    Caption = 'Limit the filter set'
    TabOrder = 1
    object Label6: TLabel
      Left = 8
      Top = 92
      Width = 464
      Height = 13
      Caption = 
        'Hint: you can type in "K" or "KB", "M" or "MB" or "G" or "GB" to' +
        ' specify Kilo-, Mega- or Gigabytes'
    end
    object chbFilterSmallerThan: TCheckBox
      Left = 8
      Top = 24
      Width = 217
      Height = 17
      Caption = 'Only check files that are smaller than'
      TabOrder = 0
    end
    object chbFilterBiggerThan: TCheckBox
      Left = 8
      Top = 48
      Width = 217
      Height = 17
      Caption = 'Only check files that are bigger than'
      TabOrder = 1
    end
    object chbFilterZeroByte: TCheckBox
      Left = 8
      Top = 72
      Width = 209
      Height = 17
      Caption = 'Skip zero-byte files'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object cbbSmallerThan: TComboBox
      Left = 240
      Top = 22
      Width = 145
      Height = 21
      ItemHeight = 13
      TabOrder = 3
      Items.Strings = (
        '100 KB'
        '500 KB'
        '1 MB'
        '5 MB'
        '10 MB'
        '100 MB'
        '1 GB')
    end
    object cbbBiggerThan: TComboBox
      Left = 240
      Top = 46
      Width = 145
      Height = 21
      ItemHeight = 13
      TabOrder = 4
      Items.Strings = (
        '10 bytes'
        '1 Kb'
        '5 Kb'
        '10 Kb'
        '50 Kb')
    end
  end
  object chbDisplayDialog: TCheckBox
    Left = 8
    Top = 344
    Width = 201
    Height = 17
    Caption = 'Display this dialog upon filter startup'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
end
