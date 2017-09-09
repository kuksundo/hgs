object FolderSelectF: TFolderSelectF
  Left = 0
  Top = 0
  Caption = 'Folder Select'
  ClientHeight = 198
  ClientWidth = 633
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 72
    Top = 56
    Width = 88
    Height = 16
    Caption = 'Folder Select : '
  end
  object JvDirectoryEdit1: TJvDirectoryEdit
    Left = 160
    Top = 53
    Width = 393
    Height = 24
    DialogKind = dkWin32
    TabOrder = 0
    Text = 
      'E:\pjh\project\util\HiMECS\Application\Utility\HiMECSManualInfo\' +
      'Manual'
  end
  object BitBtn1: TBitBtn
    Left = 104
    Top = 104
    Width = 137
    Height = 57
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object BitBtn2: TBitBtn
    Left = 392
    Top = 104
    Width = 137
    Height = 57
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
