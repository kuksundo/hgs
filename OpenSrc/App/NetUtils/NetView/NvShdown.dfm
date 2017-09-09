object ShutdownDialog: TShutdownDialog
  Left = 242
  Top = 103
  BorderStyle = bsDialog
  Caption = 'Shutdown %s'
  ClientHeight = 281
  ClientWidth = 305
  Color = clBtnFace
  ParentFont = True
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblMessage: TLabel
    Left = 8
    Top = 95
    Width = 46
    Height = 13
    Caption = '&Message:'
    FocusControl = Memo
  end
  object grbOptions: TGroupBox
    Left = 8
    Top = 4
    Width = 289
    Height = 90
    Caption = 'Options'
    TabOrder = 0
    object lblTimeOut: TLabel
      Left = 84
      Top = 60
      Width = 90
      Height = 13
      Caption = '&Timeout (seconds):'
      FocusControl = edtTimeout
    end
    object chkForce: TCheckBox
      Left = 84
      Top = 17
      Width = 137
      Height = 13
      Caption = '&Force application closed'
      TabOrder = 0
    end
    object chkReboot: TCheckBox
      Left = 84
      Top = 38
      Width = 130
      Height = 13
      Caption = '&Reboot after shutdown'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object edtTimeout: TEdit
      Left = 190
      Top = 58
      Width = 33
      Height = 21
      ReadOnly = True
      TabOrder = 2
      Text = '30'
    end
    object udTimeout: TUpDown
      Left = 223
      Top = 58
      Width = 15
      Height = 21
      Associate = edtTimeout
      Max = 32767
      Position = 30
      TabOrder = 3
    end
  end
  object btnOk: TButton
    Left = 8
    Top = 248
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 2
    OnClick = btnOkClick
  end
  object btnAbort: TButton
    Left = 115
    Top = 248
    Width = 75
    Height = 25
    Caption = '&Abort'
    Enabled = False
    TabOrder = 3
    OnClick = btnAbortClick
  end
  object btnCancel: TButton
    Left = 222
    Top = 248
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object Memo: TMemo
    Left = 8
    Top = 110
    Width = 289
    Height = 130
    MaxLength = 127
    ScrollBars = ssVertical
    TabOrder = 1
  end
end
