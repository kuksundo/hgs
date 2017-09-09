object PingDialog: TPingDialog
  Left = 243
  Top = 117
  BorderStyle = bsDialog
  Caption = 'Ping %s'
  ClientHeight = 361
  ClientWidth = 337
  Color = clBtnFace
  ParentFont = True
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblResults: TLabel
    Left = 8
    Top = 142
    Width = 57
    Height = 13
    Caption = 'Ping &results:'
    FocusControl = Memo
  end
  object btnStart: TButton
    Left = 174
    Top = 328
    Width = 75
    Height = 25
    Caption = '&Start'
    Default = True
    TabOrder = 0
    OnClick = btnStartClick
  end
  object btnCancel: TButton
    Left = 254
    Top = 328
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object GroupBox: TGroupBox
    Left = 8
    Top = 4
    Width = 321
    Height = 136
    Caption = 'Ping options'
    TabOrder = 2
    object lblBytes: TLabel
      Left = 9
      Top = 19
      Width = 113
      Height = 13
      Caption = 'Send &buffer size (bytes):'
      FocusControl = edtBytes
    end
    object lblNumber: TLabel
      Left = 9
      Top = 51
      Width = 160
      Height = 13
      Caption = 'Number of &echo requests to send:'
      FocusControl = edtNumber
    end
    object lblTimeOut: TLabel
      Left = 9
      Top = 82
      Width = 164
      Height = 13
      Caption = '&Timeout to wait for each reply (ms):'
      FocusControl = edtTimeOut
    end
    object edtBytes: TMaskEdit
      Left = 234
      Top = 18
      Width = 75
      Height = 21
      EditMask = '99999;1; '
      MaxLength = 5
      TabOrder = 0
      Text = '32   '
    end
    object edtNumber: TMaskEdit
      Left = 234
      Top = 50
      Width = 75
      Height = 21
      EditMask = '99;1; '
      MaxLength = 2
      TabOrder = 1
      Text = '4 '
    end
    object edtTimeOut: TMaskEdit
      Left = 234
      Top = 81
      Width = 75
      Height = 21
      EditMask = '99999;1; '
      MaxLength = 5
      TabOrder = 2
      Text = '1000 '
    end
    object chkFragment: TCheckBox
      Left = 9
      Top = 114
      Width = 308
      Height = 13
      Caption = 'Set don'#39't &fragment flag in packet'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
  end
  object Memo: TMemo
    Left = 8
    Top = 158
    Width = 321
    Height = 162
    Color = clBtnFace
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 3
    WordWrap = False
  end
end
