object frmEmail: TfrmEmail
  Left = 377
  Top = 130
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsSingle
  Caption = 'Email-a-Friend'
  ClientHeight = 509
  ClientWidth = 542
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
    00C4CC00000000000C4CC6C0000000000400C66C0400700000000C6E44007FFB
    FFBFFFCEE4F07FFFFBFBFBCEE4B07FFFFFFFFCCCC4F07FFFFBFBFBFBFFB07FFF
    FFFFFBFFBFF07F44444BFBFB91B07FCCC4FFFFFF99F07FCC64FBFFBFBFB077CC
    66477777777000C0C6E40040000000000CEE447000000000000EEE000000FC3F
    0000F81F0000FB0B000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000D0DF0000F81F0000FE3F0000}
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 529
    Height = 73
    Caption = 'Email Program - which program do you want to use?'
    TabOrder = 0
    object rbMAPI: TRadioButton
      Left = 16
      Top = 24
      Width = 305
      Height = 17
      Caption = 'Try my &default program using MAPI (e.g. Outlook Express)'
      TabOrder = 0
    end
    object rbStandard: TRadioButton
      Left = 16
      Top = 48
      Width = 217
      Height = 17
      Caption = 'Write &Standard .eml file'
      Checked = True
      TabOrder = 1
      TabStop = True
    end
  end
  object gbAttach: TGroupBox
    Left = 8
    Top = 144
    Width = 529
    Height = 273
    Caption = 'Attachments that will be added to the email'
    TabOrder = 1
    object Label1: TLabel
      Left = 16
      Top = 248
      Width = 384
      Height = 13
      Caption = 
        'Note: Temporary files will be created, your original pictures wi' +
        'll remain unchanged.'
    end
    object Label2: TLabel
      Left = 320
      Top = 176
      Width = 95
      Height = 13
      Caption = 'Maximum resolution:'
    end
    object Label3: TLabel
      Left = 208
      Top = 192
      Width = 5
      Height = 13
      Caption = 'x'
    end
    object Label4: TLabel
      Left = 152
      Top = 176
      Width = 47
      Height = 13
      Caption = 'Horizontal'
    end
    object Label5: TLabel
      Left = 224
      Top = 176
      Width = 35
      Height = 13
      Caption = 'Vertical'
    end
    object Label7: TLabel
      Left = 184
      Top = 226
      Width = 62
      Height = 13
      Caption = 'JPeg Quality:'
      Enabled = False
    end
    object Label8: TLabel
      Left = 296
      Top = 226
      Width = 20
      Height = 13
      Caption = 'Low'
      Color = clBtnFace
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object Label9: TLabel
      Left = 488
      Top = 226
      Width = 22
      Height = 13
      Caption = 'High'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label10: TLabel
      Left = 256
      Top = 200
      Width = 14
      Height = 16
      Caption = '75'
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbReduced: TLabel
      Left = 462
      Top = 168
      Width = 51
      Height = 13
      Caption = '* Reduced'
      Visible = False
    end
    object lvFiles: TListView
      Left = 16
      Top = 24
      Width = 497
      Height = 137
      Columns = <
        item
          Caption = 'File'
          Width = 150
        end
        item
          Caption = 'Folder'
          Width = 195
        end
        item
          Caption = 'Dimensions'
          Width = 130
        end>
      MultiSelect = True
      OwnerData = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnData = lvFilesData
    end
    object chbReduceSize: TCheckBox
      Left = 16
      Top = 192
      Width = 129
      Height = 17
      Caption = 'Reduce Image Size'
      TabOrder = 1
      OnClick = chbReduceSizeClick
    end
    object chbReduceQual: TCheckBox
      Left = 16
      Top = 224
      Width = 129
      Height = 17
      Caption = 'Reduce Image Quality'
      Enabled = False
      TabOrder = 2
    end
    object cbbMaxResolution: TComboBox
      Left = 320
      Top = 192
      Width = 169
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 3
      OnChange = cbbMaxResolutionChange
      Items.Strings = (
        '500x500 pixels'
        '400x400 pixels'
        '300x300 pixels'
        '200x200 pixels'
        '100x100 pixels')
    end
    object edWidth: TEdit
      Left = 152
      Top = 192
      Width = 49
      Height = 21
      TabOrder = 4
      Text = '500'
    end
    object edHeight: TEdit
      Left = 224
      Top = 192
      Width = 49
      Height = 21
      TabOrder = 5
      Text = '500'
      OnExit = edHeightExit
    end
    object DelaySlider: TRxSlider
      Left = 320
      Top = 216
      Width = 169
      Height = 25
      Enabled = False
      TabOrder = 6
      Value = 75
    end
    object Button1: TButton
      Left = 280
      Top = 192
      Width = 33
      Height = 17
      Caption = '--->'
      TabOrder = 7
      OnClick = Button1Click
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 424
    Width = 529
    Height = 49
    Caption = 'Options'
    TabOrder = 2
    object chbSizeLimit: TCheckBox
      Left = 16
      Top = 16
      Width = 209
      Height = 17
      Caption = 'Split large emails, at approximate size:'
      TabOrder = 0
    end
    object cbbSizeLimit: TComboBox
      Left = 232
      Top = 12
      Width = 89
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      Text = '500KB'
    end
  end
  object BitBtn1: TBitBtn
    Left = 400
    Top = 480
    Width = 99
    Height = 25
    TabOrder = 3
    Kind = bkCancel
  end
  object btnNext: TBitBtn
    Left = 288
    Top = 480
    Width = 99
    Height = 25
    Caption = 'OK, Next'
    TabOrder = 4
    Kind = bkOK
  end
  object BitBtn3: TBitBtn
    Left = 8
    Top = 480
    Width = 97
    Height = 25
    TabOrder = 5
    Kind = bkHelp
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 88
    Width = 529
    Height = 49
    Caption = 'Enter the &subject of your email here'
    TabOrder = 6
    object edSubject: TEdit
      Left = 16
      Top = 17
      Width = 497
      Height = 21
      TabOrder = 0
    end
  end
end
