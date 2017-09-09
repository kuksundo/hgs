object OptionsDialog: TOptionsDialog
  Left = 260
  Top = 153
  BorderStyle = bsDialog
  Caption = 'Options'
  ClientHeight = 153
  ClientWidth = 289
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object btnOk: TButton
    Left = 126
    Top = 120
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 206
    Top = 120
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object GroupBox: TGroupBox
    Left = 8
    Top = 8
    Width = 273
    Height = 106
    Caption = 'WNetStat settings'
    TabOrder = 0
    object lblInterval: TLabel
      Left = 16
      Top = 20
      Width = 130
      Height = 13
      Caption = 'Pausing &interval (seconds): '
      FocusControl = edtInterval
    end
    object edtInterval: TEdit
      Left = 218
      Top = 16
      Width = 28
      Height = 21
      MaxLength = 5
      ReadOnly = True
      TabOrder = 0
      Text = '1'
    end
    object udInterval: TUpDown
      Left = 246
      Top = 16
      Width = 15
      Height = 21
      Associate = edtInterval
      Min = 1
      Position = 1
      TabOrder = 3
      Thousands = False
    end
    object chkAppendStatistics: TCheckBox
      Left = 16
      Top = 41
      Width = 253
      Height = 17
      Caption = 'A&ppend statistics to the end of the file'
      TabOrder = 1
    end
    object chkAutoSave: TCheckBox
      Left = 16
      Top = 60
      Width = 253
      Height = 17
      Caption = '&Save to file when AutoRefresh mode enabled'
      TabOrder = 2
    end
    object chkCloseToTray: TCheckBox
      Left = 16
      Top = 79
      Width = 253
      Height = 17
      Caption = 'Close to &tray'
      TabOrder = 4
    end
  end
end
