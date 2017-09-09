object frmFuzzyText: TfrmFuzzyText
  Left = 483
  Top = 256
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'FuzzyText Filter Setup Dialog'
  ClientHeight = 317
  ClientWidth = 431
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000001000000080000000010000080000000000
    1000800000000000010800000000000000800000000000000801000000000000
    8000100003000000000001000330000000000003300000000000003330000000
    000000333000000000003300000000000000000000000000000000000000FFFF
    00009FCF00008F8F0000C71F0000E23F0000F07F0000F8FF0000F07B00000231
    00000700000067810000E7830000C7030000FC070000FE1F0000FFFF0000}
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 16
    Top = 8
    Width = 201
    Height = 65
    Caption = 'When to index'
    TabOrder = 0
    object rbIndexBackgr: TRadioButton
      Left = 8
      Top = 16
      Width = 177
      Height = 17
      Caption = 'Auto-Index in background'
      TabOrder = 0
    end
    object rbIndexFilter: TRadioButton
      Left = 8
      Top = 40
      Width = 185
      Height = 17
      Caption = 'Index files when filtering'
      Checked = True
      TabOrder = 1
      TabStop = True
    end
  end
  object GroupBox2: TGroupBox
    Left = 224
    Top = 8
    Width = 193
    Height = 185
    Caption = 'File type filter'
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 136
      Width = 177
      Height = 41
      AutoSize = False
      Caption = 
        'Enter a list of file extensions, type the dot and separate them ' +
        'with a semicolon. Example: .txt;.exe;.html'
      WordWrap = True
    end
    object rbProcessAll: TRadioButton
      Left = 8
      Top = 16
      Width = 113
      Height = 17
      Caption = 'Process all files'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object rbProcessOnly: TRadioButton
      Left = 8
      Top = 40
      Width = 177
      Height = 17
      Caption = 'Process only these types:'
      TabOrder = 1
    end
    object rbProcessExcept: TRadioButton
      Left = 8
      Top = 88
      Width = 177
      Height = 17
      Caption = 'Process all except these:'
      TabOrder = 2
    end
    object edProcessOnly: TEdit
      Left = 24
      Top = 56
      Width = 153
      Height = 21
      TabOrder = 3
    end
    object edProcessExcept: TEdit
      Left = 24
      Top = 104
      Width = 153
      Height = 21
      TabOrder = 4
      Text = '.exe;.dll;'
    end
  end
  object GroupBox3: TGroupBox
    Left = 16
    Top = 80
    Width = 201
    Height = 113
    Caption = 'Max file size difference'
    TabOrder = 2
    object rbDiffNone: TRadioButton
      Left = 8
      Top = 16
      Width = 185
      Height = 17
      Caption = 'Do not check'
      TabOrder = 0
    end
    object rbDiffAsLimit: TRadioButton
      Left = 8
      Top = 40
      Width = 185
      Height = 17
      Caption = 'Use same as tolerance limits'
      TabOrder = 1
    end
    object rbDiffSelect: TRadioButton
      Left = 8
      Top = 64
      Width = 185
      Height = 17
      Caption = 'Use this setting as limit:'
      TabOrder = 2
    end
    object seDiffLimit: TRxSpinEdit
      Left = 24
      Top = 80
      Width = 81
      Height = 21
      Increment = 5.000000000000000000
      MaxValue = 5000.000000000000000000
      TabOrder = 3
    end
  end
  object GroupBox4: TGroupBox
    Left = 16
    Top = 200
    Width = 401
    Height = 73
    Caption = 'Limits per tolerance level (# different characters)'
    TabOrder = 3
  end
  object BitBtn1: TBitBtn
    Left = 256
    Top = 280
    Width = 75
    Height = 25
    TabOrder = 4
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 344
    Top = 280
    Width = 75
    Height = 25
    TabOrder = 5
    Kind = bkCancel
  end
  object BitBtn3: TBitBtn
    Left = 16
    Top = 280
    Width = 75
    Height = 25
    TabOrder = 6
    Kind = bkHelp
  end
end
