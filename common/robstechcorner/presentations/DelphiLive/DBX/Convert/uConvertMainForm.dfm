object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'BDE to DBX Component Conversion Tool'
  ClientHeight = 300
  ClientWidth = 675
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    675
    300)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 20
    Width = 74
    Height = 13
    Caption = 'Files to Process'
  end
  object Label2: TLabel
    Left = 176
    Top = 188
    Width = 443
    Height = 13
    Caption = 
      'This will replace the existing files, with converted Code so mak' +
      'e a Backup First!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 176
    Top = 216
    Width = 435
    Height = 13
    Caption = 
      'Filename.CONVERTLOG will be produced with things that will need ' +
      'to be manually reviewed'
  end
  object Label4: TLabel
    Left = 176
    Top = 232
    Width = 459
    Height = 13
    Caption = 
      'DIR_MASTER.CONVERTLOG will be produced with messages  from conve' +
      'rsion of files in that dir.'
  end
  object lstFilesToProcess: TListBox
    Left = 8
    Top = 39
    Width = 659
    Height = 138
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 0
    ExplicitWidth = 639
  end
  object Button1: TButton
    Left = 516
    Top = 8
    Width = 151
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Select Files to Process'
    TabOrder = 1
    OnClick = Button1Click
    ExplicitLeft = 496
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 264
    Width = 659
    Height = 17
    TabOrder = 2
  end
  object btnProcessFiles: TButton
    Left = 8
    Top = 183
    Width = 153
    Height = 25
    Caption = 'Process Files'
    TabOrder = 3
    OnClick = btnProcessFilesClick
  end
  object dlgOpen: TOpenDialog
    Filter = 'Delphi Files (*.PAS)|*.PAS|All Files (*.*)|*.*'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofFileMustExist, ofEnableSizing]
    Left = 456
    Top = 8
  end
end
