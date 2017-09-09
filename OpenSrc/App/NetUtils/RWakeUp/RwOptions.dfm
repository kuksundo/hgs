object OptionsDialog: TOptionsDialog
  Left = 276
  Top = 163
  BorderStyle = bsDialog
  Caption = 'Wakeup Options'
  ClientHeight = 290
  ClientWidth = 275
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object grbDays: TGroupBox
    Left = 8
    Top = 121
    Width = 174
    Height = 160
    Caption = 'Wakeup Days'
    TabOrder = 2
    object chkMonday: TCheckBox
      Tag = 1
      Left = 10
      Top = 21
      Width = 76
      Height = 15
      Caption = '&Monday'
      TabOrder = 0
    end
    object chkTuesday: TCheckBox
      Tag = 2
      Left = 10
      Top = 40
      Width = 76
      Height = 15
      Caption = '&Tuesday'
      TabOrder = 1
    end
    object chkWednesday: TCheckBox
      Tag = 3
      Left = 10
      Top = 59
      Width = 76
      Height = 15
      Caption = '&Wednesday'
      TabOrder = 2
    end
    object chkThursday: TCheckBox
      Tag = 4
      Left = 10
      Top = 78
      Width = 76
      Height = 15
      Caption = 'Thu&rsday'
      TabOrder = 3
    end
    object chkFriday: TCheckBox
      Tag = 5
      Left = 10
      Top = 97
      Width = 76
      Height = 15
      Caption = '&Friday'
      TabOrder = 4
    end
    object chkSaturday: TCheckBox
      Tag = 6
      Left = 10
      Top = 116
      Width = 76
      Height = 15
      Caption = '&Saturday'
      TabOrder = 5
    end
    object chkSunday: TCheckBox
      Tag = 7
      Left = 10
      Top = 135
      Width = 76
      Height = 15
      Caption = 'S&unday'
      TabOrder = 6
    end
  end
  object btnOk: TButton
    Left = 192
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object btnCancel: TButton
    Left = 192
    Top = 40
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object grbTime: TGroupBox
    Left = 8
    Top = 62
    Width = 174
    Height = 54
    Caption = 'Wakeup Time'
    TabOrder = 1
    object lblHour: TLabel
      Left = 7
      Top = 24
      Width = 26
      Height = 13
      Caption = '&Hour:'
      FocusControl = edtHour
    end
    object lblMinute: TLabel
      Left = 81
      Top = 24
      Width = 35
      Height = 13
      Caption = 'Mi&nute:'
      FocusControl = edtMinute
    end
    object edtHour: TEdit
      Left = 39
      Top = 21
      Width = 23
      Height = 21
      ReadOnly = True
      TabOrder = 0
      Text = '0'
    end
    object udHour: TUpDown
      Left = 62
      Top = 21
      Width = 15
      Height = 21
      Associate = edtHour
      Max = 23
      TabOrder = 1
    end
    object edtMinute: TEdit
      Left = 124
      Top = 21
      Width = 23
      Height = 21
      ReadOnly = True
      TabOrder = 2
      Text = '0'
    end
    object udMinute: TUpDown
      Left = 147
      Top = 21
      Width = 15
      Height = 21
      Associate = edtMinute
      Max = 59
      TabOrder = 3
    end
  end
  object grbIP: TGroupBox
    Left = 8
    Top = 3
    Width = 174
    Height = 54
    Caption = '&IP Broadcast Address and Port'
    TabOrder = 0
    object edtIpAddress: TEdit
      Left = 10
      Top = 21
      Width = 106
      Height = 21
      MaxLength = 15
      TabOrder = 0
    end
    object edtPort: TEdit
      Left = 124
      Top = 21
      Width = 39
      Height = 21
      MaxLength = 5
      TabOrder = 1
    end
  end
end
