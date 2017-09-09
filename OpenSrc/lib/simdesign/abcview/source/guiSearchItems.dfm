inherited SearchFrame: TSearchFrame
  object pcSearch: TPageControl
    Left = 8
    Top = 8
    Width = 545
    Height = 361
    ActivePage = tsSearch
    TabOrder = 0
    object tsSearch: TTabSheet
      Caption = 'Search &Strings'
      ImageIndex = 2
      object Label7: TLabel
        Left = 16
        Top = 8
        Width = 370
        Height = 13
        Caption = 
          'Enter one or more search strings here: click on "More..." to add' +
          ' multiple criteria'
      end
      object Label1: TLabel
        Left = 8
        Top = 256
        Width = 521
        Height = 73
        AutoSize = False
        Caption = 
          'N.B. For each individual search phrase you may specify multiple ' +
          'words. Each of these words must be present at least one time in ' +
          'the search item. '#13#10'If you want to search for a sentence or conse' +
          'cutive words then enclose in quotes (e.g. "pink floyd")'
        WordWrap = True
      end
      object cbbCond1: TComboBox
        Left = 16
        Top = 32
        Width = 121
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        Items.Strings = (
          'Contains'
          'Does not contain')
      end
      object cbbTerm1: TComboBox
        Left = 152
        Top = 32
        Width = 297
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ItemHeight = 13
        ParentFont = False
        TabOrder = 1
      end
      object cbbCond2: TComboBox
        Left = 16
        Top = 64
        Width = 121
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 2
        Visible = False
        Items.Strings = (
          'AND'
          'OR'
          'AND NOT'
          'OR NOT')
      end
      object cbbTerm2: TComboBox
        Left = 152
        Top = 64
        Width = 297
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ItemHeight = 13
        ParentFont = False
        TabOrder = 3
        Visible = False
      end
      object cbbCond3: TComboBox
        Left = 16
        Top = 96
        Width = 121
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 4
        Visible = False
        Items.Strings = (
          'AND'
          'OR'
          'AND NOT'
          'OR NOT')
      end
      object cbbTerm3: TComboBox
        Left = 152
        Top = 96
        Width = 297
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ItemHeight = 13
        ParentFont = False
        TabOrder = 5
        Visible = False
      end
      object btnMore1: TButton
        Left = 456
        Top = 29
        Width = 75
        Height = 25
        Caption = 'More...'
        TabOrder = 6
        OnClick = btnMore1Click
      end
      object btnMore2: TButton
        Left = 456
        Top = 61
        Width = 75
        Height = 25
        Caption = 'More...'
        TabOrder = 7
        Visible = False
        OnClick = btnMore2Click
      end
    end
    object tsOptions: TTabSheet
      Caption = 'Search &Options'
      ImageIndex = 5
      object chCaseSensitive: TCheckBox
        Left = 16
        Top = 16
        Width = 97
        Height = 17
        Caption = 'Case &Sensitive'
        TabOrder = 0
      end
      object CheckBox13: TCheckBox
        Left = 16
        Top = 40
        Width = 297
        Height = 17
        Caption = 'Include Files in found Folders, Series, or Groups'
        Enabled = False
        TabOrder = 1
      end
      object chSearchExpandSel: TCheckBox
        Left = 16
        Top = 64
        Width = 297
        Height = 17
        Caption = 'Include Folders, Series, Groups belonging to found Files'
        TabOrder = 2
      end
    end
    object tsFields: TTabSheet
      Caption = 'Search &Fields'
      ImageIndex = 6
      object GroupBox3: TGroupBox
        Left = 8
        Top = 8
        Width = 257
        Height = 313
        Caption = 'Search File Fields'
        TabOrder = 0
        object Label17: TLabel
          Left = 8
          Top = 160
          Width = 185
          Height = 13
          Caption = 'NB Content search is truncated to 1MB'
        end
        object Bevel1: TBevel
          Left = 8
          Top = 97
          Width = 241
          Height = 7
          Shape = bsBottomLine
        end
        object Bevel2: TBevel
          Left = 8
          Top = 177
          Width = 241
          Height = 7
          Shape = bsBottomLine
        end
        object chSearchFileName: TCheckBox
          Left = 8
          Top = 24
          Width = 145
          Height = 17
          Caption = 'File Name'
          TabOrder = 0
        end
        object chSearchDescription: TCheckBox
          Left = 8
          Top = 72
          Width = 145
          Height = 17
          Caption = 'Description'
          TabOrder = 1
        end
        object chSearchContent: TCheckBox
          Left = 8
          Top = 120
          Width = 97
          Height = 17
          Caption = 'Content'
          TabOrder = 2
        end
        object rbTextualContent: TRadioButton
          Left = 96
          Top = 120
          Width = 113
          Height = 17
          Caption = 'Textual Files'
          TabOrder = 3
        end
        object rbAllContent: TRadioButton
          Left = 96
          Top = 136
          Width = 113
          Height = 17
          Caption = 'All Files'
          TabOrder = 4
        end
        object chSearchUserFields: TCheckBox
          Left = 8
          Top = 224
          Width = 97
          Height = 17
          Caption = 'User Fields'
          Enabled = False
          TabOrder = 5
        end
        object chSearchPathName: TCheckBox
          Left = 8
          Top = 48
          Width = 97
          Height = 17
          Caption = 'Path Name'
          TabOrder = 6
        end
        object chSearchEncaps: TCheckBox
          Left = 8
          Top = 200
          Width = 241
          Height = 17
          Caption = 'Encapsulated data in files (EXIF, ID3)'
          Enabled = False
          TabOrder = 7
        end
      end
      object GroupBox4: TGroupBox
        Left = 272
        Top = 88
        Width = 257
        Height = 73
        Caption = 'Search Groups'
        Enabled = False
        TabOrder = 1
        object chSearchGroupsName: TCheckBox
          Left = 8
          Top = 24
          Width = 97
          Height = 17
          Caption = 'Names'
          TabOrder = 0
        end
        object chSearchGroupsDescr: TCheckBox
          Left = 8
          Top = 48
          Width = 97
          Height = 17
          Caption = 'Descriptions'
          TabOrder = 1
        end
      end
      object GroupBox5: TGroupBox
        Left = 272
        Top = 168
        Width = 257
        Height = 73
        Caption = 'Search Series'
        Enabled = False
        TabOrder = 2
        object chSearchSeriesName: TCheckBox
          Left = 8
          Top = 24
          Width = 97
          Height = 17
          Caption = 'Names'
          TabOrder = 0
        end
        object chSearchSeriesDescr: TCheckBox
          Left = 8
          Top = 48
          Width = 97
          Height = 17
          Caption = 'Descriptions'
          TabOrder = 1
        end
      end
      object GroupBox6: TGroupBox
        Left = 272
        Top = 8
        Width = 257
        Height = 73
        Caption = 'Search Folders'
        TabOrder = 3
        object chSearchFoldersName: TCheckBox
          Left = 8
          Top = 24
          Width = 97
          Height = 17
          Caption = 'Names'
          TabOrder = 0
        end
        object chSearchFoldersDescr: TCheckBox
          Left = 8
          Top = 48
          Width = 97
          Height = 17
          Caption = 'Descriptions'
          TabOrder = 1
        end
      end
    end
  end
end
