object frmExport: TfrmExport
  Left = 309
  Top = 166
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Export Wizard'
  ClientHeight = 342
  ClientWidth = 546
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 169
    Height = 297
    BevelOuter = bvLowered
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 8
    Top = 312
    Width = 89
    Height = 25
    TabOrder = 1
    Kind = bkHelp
  end
  object btnPrev: TButton
    Left = 232
    Top = 312
    Width = 89
    Height = 25
    Caption = '< Prev'
    TabOrder = 2
  end
  object btnNext: TButton
    Left = 328
    Top = 312
    Width = 89
    Height = 25
    Caption = 'Next >'
    TabOrder = 3
  end
  object BitBtn2: TBitBtn
    Left = 448
    Top = 312
    Width = 89
    Height = 25
    TabOrder = 4
    Kind = bkCancel
  end
  object nbExport: TNotebook
    Left = 178
    Top = 0
    Width = 367
    Height = 305
    PageIndex = 4
    TabOrder = 5
    object TPage
      Left = 0
      Top = 0
      Caption = 'Step1'
      object Label1: TLabel
        Left = 8
        Top = 32
        Width = 353
        Height = 25
        AutoSize = False
        Caption = 
          'Welcome to the ABC-View Export Wizard. This wizard will help you' +
          ' to determine what data to export and in which format.'
        WordWrap = True
      end
      object Label2: TLabel
        Left = 8
        Top = 8
        Width = 268
        Height = 18
        Caption = 'Welcome to the Export Wizard'
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -16
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object GroupBox1: TGroupBox
        Left = 8
        Top = 72
        Width = 353
        Height = 105
        Caption = 'What do you want to export?'
        TabOrder = 0
        object rbSelected: TRadioButton
          Left = 16
          Top = 24
          Width = 329
          Height = 17
          Caption = 'The selected items'
          TabOrder = 0
        end
        object rbCurrentView: TRadioButton
          Left = 16
          Top = 48
          Width = 329
          Height = 17
          Caption = 'The current view'
          Checked = True
          TabOrder = 1
          TabStop = True
        end
        object rbAllItems: TRadioButton
          Left = 16
          Top = 72
          Width = 329
          Height = 17
          Caption = 'All items in the catalog'
          TabOrder = 2
        end
      end
      object GroupBox2: TGroupBox
        Left = 8
        Top = 184
        Width = 353
        Height = 121
        Caption = 'In what format do you want to export data?'
        TabOrder = 1
        object Label3: TLabel
          Left = 16
          Top = 24
          Width = 35
          Height = 13
          Caption = 'Format:'
        end
        object lbSubFormat: TLabel
          Left = 16
          Top = 72
          Width = 54
          Height = 13
          Caption = 'Sub-format:'
        end
        object cbbFormat: TComboBox
          Left = 16
          Top = 40
          Width = 305
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
          OnChange = cbbFormatChange
          Items.Strings = (
            'ABC-View Format (*.abc)'
            'Comma Separated Values (*.csv)'
            'Extensible Markup Language (*.xml)')
        end
        object cbbSubFormat: TComboBox
          Left = 16
          Top = 88
          Width = 305
          Height = 21
          Style = csDropDownList
          ItemHeight = 0
          TabOrder = 1
        end
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'SelectFields'
      object Label9: TLabel
        Left = 8
        Top = 8
        Width = 286
        Height = 18
        Caption = 'Please select the fields to export'
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -16
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label10: TLabel
        Left = 8
        Top = 32
        Width = 353
        Height = 25
        AutoSize = False
        Caption = 
          'Here you specify what information will be written to the export ' +
          'document. You can select the fields by clicking on the checkmark' +
          's.'
        WordWrap = True
      end
      object clbFiles: TRxCheckListBox
        Left = 8
        Top = 88
        Width = 153
        Height = 89
        CheckKind = ckCheckMarks
        ItemHeight = 13
        TabOrder = 0
        InternalVersion = 202
        Strings = (
          'Name'
          1
          True
          'Size'
          1
          True
          'Type'
          1
          True
          'Modified'
          1
          True
          'Folder Reference'
          0
          True
          'Folder'
          1
          True
          'Status'
          1
          True
          'Series'
          0
          True
          'Rating'
          1
          True
          'Groups'
          0
          True
          'CRC32'
          1
          True
          'Dimensions'
          1
          True
          'Compression'
          1
          True
          'Original Name'
          1
          True
          'Description'
          1
          True
          'User Fields'
          1
          True)
      end
      object RxCheckListBox2: TRxCheckListBox
        Left = 192
        Top = 88
        Width = 145
        Height = 89
        CheckKind = ckCheckMarks
        ItemHeight = 13
        TabOrder = 1
        InternalVersion = 202
        Strings = (
          'Name'
          1
          True
          'Path'
          1
          True
          'Type'
          1
          True
          'Modified'
          1
          True
          'Volumelabel'
          1
          True
          'Status'
          1
          True
          'File Count'
          1
          True
          'Total Size'
          1
          True
          'Auto-Update'
          1
          True
          'Attributes'
          1
          True
          'Filter'
          1
          True
          'Protection'
          1
          True)
      end
      object RxCheckListBox3: TRxCheckListBox
        Left = 8
        Top = 208
        Width = 153
        Height = 89
        CheckKind = ckCheckMarks
        Enabled = False
        ItemHeight = 13
        TabOrder = 2
        Visible = False
        InternalVersion = 202
      end
      object RxCheckListBox4: TRxCheckListBox
        Left = 192
        Top = 208
        Width = 153
        Height = 89
        CheckKind = ckCheckMarks
        Enabled = False
        ItemHeight = 13
        TabOrder = 3
        Visible = False
        InternalVersion = 202
      end
      object chbFiles: TCheckBox
        Left = 8
        Top = 71
        Width = 153
        Height = 17
        Caption = 'Files'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        State = cbChecked
        TabOrder = 4
      end
      object chbFolders: TCheckBox
        Left = 192
        Top = 71
        Width = 153
        Height = 17
        Caption = 'Folders'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
      end
      object chbSeries: TCheckBox
        Left = 8
        Top = 191
        Width = 153
        Height = 17
        Caption = 'Series'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
        Visible = False
      end
      object chbGroups: TCheckBox
        Left = 192
        Top = 191
        Width = 153
        Height = 17
        Caption = 'Groups'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 7
        Visible = False
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Step3'
      object Label4: TLabel
        Left = 8
        Top = 8
        Width = 161
        Height = 18
        Caption = 'Select Base Folder'
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -16
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label5: TLabel
        Left = 8
        Top = 32
        Width = 353
        Height = 25
        AutoSize = False
        Caption = 
          'In the CSV format the folder names are exported as relative path' +
          's. Please select the folder you want to use as a base folder. '
        WordWrap = True
      end
      object Label6: TLabel
        Left = 8
        Top = 72
        Width = 56
        Height = 13
        Caption = 'Base Folder'
      end
      object deBaseFolder: TDirectoryEdit
        Left = 8
        Top = 88
        Width = 345
        Height = 21
        DialogKind = dkWin32
        NumGlyphs = 1
        TabOrder = 0
        Text = 'C:\'
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Step4'
      object Label7: TLabel
        Left = 8
        Top = 8
        Width = 200
        Height = 18
        Caption = 'Export was successful!'
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -16
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label8: TLabel
        Left = 8
        Top = 32
        Width = 353
        Height = 25
        AutoSize = False
        Caption = 
          'All data was exported and saved successfully. You can now termin' +
          'ate this wizard by pushing the "Finish" button.'
        WordWrap = True
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Delimiters'
      object Label11: TLabel
        Left = 8
        Top = 8
        Width = 146
        Height = 18
        Caption = 'Specify Delimiter'
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -16
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label12: TLabel
        Left = 8
        Top = 32
        Width = 353
        Height = 25
        AutoSize = False
        Caption = 
          'The delimiter character is placed after each value so that the v' +
          'alues can be separated easily in the application that imports th' +
          'e file.'
        WordWrap = True
      end
      object Label13: TLabel
        Left = 8
        Top = 184
        Width = 111
        Height = 18
        Caption = 'Quoted Text'
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -16
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label14: TLabel
        Left = 6
        Top = 208
        Width = 353
        Height = 25
        AutoSize = False
        Caption = 
          'Select "Create Quoted Text" to force all fields to be enclosed i' +
          'n " chars. This will avoid errors when encountering the delimite' +
          'rs in the fields'
        WordWrap = True
      end
      object rbDelimComma: TRadioButton
        Left = 8
        Top = 80
        Width = 217
        Height = 17
        Caption = 'Use a Comma (standard)'
        Checked = True
        TabOrder = 0
        TabStop = True
      end
      object rbDelimTab: TRadioButton
        Left = 8
        Top = 104
        Width = 345
        Height = 17
        Caption = 'Use a TAB (#9), works best for Microsoft Excel'
        TabOrder = 1
      end
      object rbDelimCustom: TRadioButton
        Left = 8
        Top = 128
        Width = 305
        Height = 17
        Caption = 'Use this character (or multiple):'
        TabOrder = 2
      end
      object edDelimiter: TEdit
        Left = 24
        Top = 152
        Width = 113
        Height = 21
        TabOrder = 3
        Text = ';'
      end
      object chbUseQuotes: TCheckBox
        Left = 8
        Top = 240
        Width = 345
        Height = 17
        Caption = 'Create quoted text'
        TabOrder = 4
      end
    end
  end
  object fsExport: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Export Items'
  end
end
