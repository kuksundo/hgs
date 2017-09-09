object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 677
  ClientWidth = 1110
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1110
    Height = 145
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 64
      Top = 16
      Width = 88
      Height = 16
      Caption = 'Folder Select : '
    end
    object Label2: TLabel
      Left = 600
      Top = 16
      Width = 94
      Height = 16
      Caption = 'PDF To Folder : '
      Enabled = False
    end
    object JvDirectoryEdit1: TJvDirectoryEdit
      Left = 152
      Top = 13
      Width = 393
      Height = 24
      DialogKind = dkWin32
      ImeName = 'Microsoft IME 2010'
      TabOrder = 0
      Text = 'E:\pjh\project\util\HiMECS\Application\Bin\Doc\Manual\H35DF '#50896#48376
    end
    object Button1: TButton
      Left = 64
      Top = 56
      Width = 257
      Height = 25
      Caption = #54260#45908#50640#49436' Manual '#51221#48372' '#44032#51256#50724#44592
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button3: TButton
      Left = 64
      Top = 87
      Width = 257
      Height = 25
      Caption = 'Manual '#51221#48372' '#44032#51256#50724#44592
      TabOrder = 2
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 495
      Top = 56
      Width = 162
      Height = 25
      Caption = 'Save As .info'
      TabOrder = 3
      OnClick = Button4Click
    end
    object JvDirectoryEdit2: TJvDirectoryEdit
      Left = 688
      Top = 13
      Width = 393
      Height = 24
      DialogKind = dkWin32
      ImeName = 'Microsoft IME 2010'
      Enabled = False
      TabOrder = 4
      Text = 'E:\pjh\project\util\HiMECS\Application\Bin\Doc\Manual\pdf'
    end
    object CheckBox1: TCheckBox
      Left = 688
      Top = 43
      Width = 97
      Height = 17
      Caption = 'Save PDF'
      TabOrder = 5
      OnClick = CheckBox1Click
    end
  end
  object ListView1: TListView
    Left = 0
    Top = 145
    Width = 1110
    Height = 532
    Align = alClient
    Columns = <
      item
        Caption = #54028#51068#51060#47492
        Width = 200
      end
      item
        Caption = 'Section No'
        Width = 80
      end
      item
        Caption = 'Rev No'
      end
      item
        Caption = 'System Desc (Eng)'
        Width = 200
      end
      item
        Caption = 'System Desc (Kor)'
        Width = 200
      end
      item
        Caption = 'Part Desc (Eng)'
        Width = 200
      end
      item
        Caption = 'Part Desc (Kor)'
        Width = 200
      end
      item
        Caption = 'File Path'
        Width = 100
      end>
    MultiSelect = True
    PopupMenu = PopupMenu1
    TabOrder = 1
    ViewStyle = vsReport
  end
  object Button2: TButton
    Left = 327
    Top = 56
    Width = 162
    Height = 25
    Caption = 'From File .info'
    TabOrder = 2
    OnClick = Button2Click
  end
  object SaveDialog1: TSaveDialog
    Left = 344
    Top = 88
  end
  object OpenDialog1: TOpenDialog
    Left = 384
    Top = 88
  end
  object PopupMenu1: TPopupMenu
    Left = 32
    Top = 24
    object ChangeManualFilePath1: TMenuItem
      Caption = 'Change Manual File Path'
      OnClick = ChangeManualFilePath1Click
    end
    object FileText1: TMenuItem
      Caption = 'File Test'
      OnClick = FileText1Click
    end
  end
end
