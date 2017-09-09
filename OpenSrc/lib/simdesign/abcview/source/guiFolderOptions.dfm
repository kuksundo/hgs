object frFolderOptions: TfrFolderOptions
  Left = 0
  Top = 0
  Width = 399
  Height = 85
  TabOrder = 0
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 399
    Height = 85
    Align = alClient
    Caption = 'Folder &Options'
    TabOrder = 0
    object Image1: TImage
      Left = 8
      Top = 56
      Width = 17
      Height = 17
      Picture.Data = {
        055449636F6E0000010001001010100000000000280100001600000028000000
        10000000200000000100040000000000C0000000000000000000000000000000
        0000000000000000000080000080000000808000800000008000800080800000
        80808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
        FFFFFF000000000000000000000000000000000000033333333333000003FBBB
        BBBBB3000003F333333383000003FBBBBBBBB3000003F333333383000003FBBB
        BBBBB3000003FFFFFFFFF3000000333333333300000003033333030000000300
        0003000000000300000300000000030000330000000000300030000000000003
        33300000FFFF0000E0030000E0010000E0010000E0010000E0010000E0010000
        E0010000E0010000F0010000F8030000F9E70000F9E70000FAC70000FD0F0000
        FE1F0000}
    end
    object chkDeleteProtected: TCheckBox
      Left = 32
      Top = 56
      Width = 201
      Height = 17
      Caption = 'Protect Folder (no files can be deleted)'
      TabOrder = 0
    end
    object chkGraphicsFilesOnly: TCheckBox
      Left = 248
      Top = 24
      Width = 137
      Height = 17
      Caption = 'Add graphics files only'
      TabOrder = 1
    end
    object chkAddHidden: TCheckBox
      Left = 248
      Top = 40
      Width = 137
      Height = 17
      Caption = 'Add hidden files'
      TabOrder = 2
    end
    object chkAddSystem: TCheckBox
      Left = 248
      Top = 56
      Width = 137
      Height = 17
      Caption = 'Add system files'
      TabOrder = 3
    end
    object chkInclSubdirs: TCheckBox
      Left = 32
      Top = 24
      Width = 193
      Height = 17
      Caption = 'Include subdirectories'
      TabOrder = 4
    end
  end
end
