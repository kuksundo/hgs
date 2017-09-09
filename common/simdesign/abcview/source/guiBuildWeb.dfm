object frmBuildWeb: TfrmBuildWeb
  Left = 309
  Top = 166
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Build-a-Web Wizard'
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
  object nbBuildWeb: TNotebook
    Left = 178
    Top = 0
    Width = 367
    Height = 305
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
          'With this wizard you can build a professionally looking web page' +
          ' in minutes. Just follow the instructions below .'
        WordWrap = True
      end
      object Label2: TLabel
        Left = 8
        Top = 8
        Width = 241
        Height = 18
        Caption = 'Welcome to "Build-a-Web"!'
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
        Height = 97
        Caption = 'Which items do you want to show on the webpage?'
        TabOrder = 0
        object rbSelected: TRadioButton
          Left = 16
          Top = 16
          Width = 329
          Height = 17
          Caption = 'The selected items'
          TabOrder = 0
        end
        object rbCurrentView: TRadioButton
          Left = 16
          Top = 40
          Width = 329
          Height = 17
          Caption = 'The current view'
          Checked = True
          TabOrder = 1
          TabStop = True
        end
        object rbAllItems: TRadioButton
          Left = 16
          Top = 64
          Width = 329
          Height = 17
          Caption = 'All items in the catalog'
          TabOrder = 2
        end
      end
      object GroupBox2: TGroupBox
        Left = 8
        Top = 176
        Width = 353
        Height = 65
        Caption = 'Where do you want to view the web-page?'
        TabOrder = 1
        Visible = False
        object rbViewLocal: TRadioButton
          Left = 16
          Top = 16
          Width = 329
          Height = 17
          Caption = 'Just locally on my computer'
          Checked = True
          TabOrder = 0
          TabStop = True
        end
        object rbViewWWW: TRadioButton
          Left = 16
          Top = 40
          Width = 329
          Height = 17
          Caption = 'On the World-Wide-Web (WWW) '
          TabOrder = 1
        end
      end
      object GroupBox3: TGroupBox
        Left = 8
        Top = 248
        Width = 353
        Height = 57
        Caption = 'Title of your web page'
        TabOrder = 2
        object edWebTitle: TEdit
          Left = 16
          Top = 24
          Width = 321
          Height = 21
          TabOrder = 0
          Text = 'My webpage made with ABC-View Manager'
        end
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Step2'
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Step3'
      object Label4: TLabel
        Left = 8
        Top = 8
        Width = 168
        Height = 18
        Caption = 'Select HTML Folder'
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
        Height = 41
        AutoSize = False
        Caption = 
          'All generated *.html files will be placed in a folder of your ch' +
          'oice. Later on you can provide folder names for thumbnail and im' +
          'age folders.'
        WordWrap = True
      end
      object Label6: TLabel
        Left = 8
        Top = 96
        Width = 62
        Height = 13
        Caption = 'HTML Folder'
      end
      object deHtmlFolder: TDirectoryEdit
        Left = 8
        Top = 112
        Width = 345
        Height = 21
        DialogKind = dkWin32
        NumGlyphs = 1
        TabOrder = 0
        Text = 'C:\ABCWeb\MyWeb1\'
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Step4'
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Step5'
      object Label7: TLabel
        Left = 8
        Top = 8
        Width = 284
        Height = 18
        Caption = 'Ready to generate with defaults'
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
        Height = 105
        AutoSize = False
        Caption = 
          'ABC-View Manager has gathered enough information now to generate' +
          ' your web pages. '#13#10' '#13#10'After you have finished this wizard, you w' +
          'ill have to click  the "Generate" button to generate the pages. ' +
          'You can still change options on the other tabs. '
        WordWrap = True
      end
    end
  end
  object fsExport: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Export Items'
  end
end
