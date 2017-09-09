object OptionsDialog: TOptionsDialog
  Left = 261
  Top = 154
  BorderStyle = bsDialog
  Caption = 'SNMP Options'
  ClientHeight = 145
  ClientWidth = 289
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object btnOk: TButton
    Left = 126
    Top = 112
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 206
    Top = 112
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
    Height = 94
    Caption = 'SnmpMgrOpen settings'
    TabOrder = 0
    object lblTimeOut: TLabel
      Left = 16
      Top = 26
      Width = 137
      Height = 13
      Caption = 'Communication &timeout (ms): '
      FocusControl = edtTimeOut
    end
    object lblRetries: TLabel
      Left = 16
      Top = 61
      Width = 128
      Height = 13
      Caption = 'Communication &retry count:'
      FocusControl = edtRetries
    end
    object edtTimeOut: TEdit
      Left = 181
      Top = 22
      Width = 60
      Height = 21
      MaxLength = 5
      ReadOnly = True
      TabOrder = 0
      Text = '1000'
    end
    object edtRetries: TEdit
      Left = 181
      Top = 57
      Width = 60
      Height = 21
      MaxLength = 1
      ReadOnly = True
      TabOrder = 1
      Text = '1'
    end
    object udTimeOut: TUpDown
      Left = 241
      Top = 22
      Width = 15
      Height = 21
      Associate = edtTimeOut
      Min = 1000
      Max = 32000
      Increment = 1000
      Position = 1000
      TabOrder = 2
      Thousands = False
    end
    object udRetries: TUpDown
      Left = 241
      Top = 57
      Width = 15
      Height = 21
      Associate = edtRetries
      Min = 1
      Max = 9
      Position = 1
      TabOrder = 3
      Thousands = False
    end
  end
end
