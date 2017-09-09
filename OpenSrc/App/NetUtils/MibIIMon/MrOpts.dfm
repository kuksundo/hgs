object OptionsDialog: TOptionsDialog
  Left = 260
  Top = 153
  BorderStyle = bsDialog
  Caption = 'SNMP Options'
  ClientHeight = 171
  ClientWidth = 289
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object btnOk: TButton
    Left = 126
    Top = 138
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 206
    Top = 138
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
    Height = 121
    Caption = 'SnmpMgrOpen settings'
    TabOrder = 0
    object lblTimeOut: TLabel
      Left = 16
      Top = 56
      Width = 137
      Height = 13
      Caption = 'Communication &timeout (ms): '
      FocusControl = edtTimeOut
    end
    object lblRetries: TLabel
      Left = 16
      Top = 86
      Width = 128
      Height = 13
      Caption = 'Communication &retry count:'
      FocusControl = edtRetries
    end
    object lblCommunity: TLabel
      Left = 16
      Top = 25
      Width = 83
      Height = 13
      Caption = 'Community na&me:'
      FocusControl = edtCommunity
    end
    object edtTimeOut: TEdit
      Left = 180
      Top = 53
      Width = 60
      Height = 21
      MaxLength = 5
      ReadOnly = True
      TabOrder = 1
      Text = '1000'
    end
    object edtRetries: TEdit
      Left = 180
      Top = 83
      Width = 60
      Height = 21
      Ctl3D = True
      MaxLength = 1
      ParentCtl3D = False
      ReadOnly = True
      TabOrder = 2
      Text = '1'
    end
    object edtCommunity: TEdit
      Left = 121
      Top = 22
      Width = 135
      Height = 21
      TabOrder = 0
      Text = '1'
    end
    object udTimeOut: TUpDown
      Left = 240
      Top = 53
      Width = 15
      Height = 21
      Associate = edtTimeOut
      Min = 1000
      Max = 32000
      Increment = 1000
      Position = 1000
      TabOrder = 3
      Thousands = False
    end
    object udRetries: TUpDown
      Left = 240
      Top = 83
      Width = 15
      Height = 21
      Associate = edtRetries
      Min = 1
      Max = 99
      Position = 1
      TabOrder = 4
      Thousands = False
    end
  end
end
