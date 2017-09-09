object frmPropEvents: TfrmPropEvents
  Left = 0
  Top = 0
  Caption = 'Property, Events and Methods'
  ClientHeight = 468
  ClientWidth = 591
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 21
    Width = 32
    Height = 13
    Caption = 'Object'
  end
  object Label2: TLabel
    Left = 160
    Top = 21
    Width = 42
    Height = 13
    Caption = 'Property'
  end
  object Label3: TLabel
    Left = 320
    Top = 24
    Width = 26
    Height = 13
    Caption = 'Value'
  end
  object Label4: TLabel
    Left = 24
    Top = 71
    Width = 33
    Height = 13
    Caption = 'Events'
  end
  object Label5: TLabel
    Left = 175
    Top = 71
    Width = 66
    Height = 13
    Caption = 'Method Name'
  end
  object Label6: TLabel
    Left = 25
    Top = 131
    Width = 39
    Height = 13
    Caption = 'Address'
  end
  object Label7: TLabel
    Left = 25
    Top = 117
    Width = 32
    Height = 13
    Caption = 'Object'
  end
  object lblObject: TLabel
    Left = 81
    Top = 117
    Width = 12
    Height = 13
    Caption = '---'
  end
  object lblAddress: TLabel
    Left = 81
    Top = 131
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label8: TLabel
    Left = 175
    Top = 117
    Width = 46
    Height = 13
    Caption = 'Signature'
  end
  object lblSig: TLabel
    Left = 175
    Top = 136
    Width = 12
    Height = 13
    Caption = '---'
  end
  object Edit1: TEdit
    Left = 24
    Top = 192
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'Edit1'
  end
  object Edit2: TEdit
    Left = 24
    Top = 227
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'Edit2'
  end
  object Edit3: TEdit
    Left = 24
    Top = 256
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'Edit3'
  end
  object Edit4: TEdit
    Left = 24
    Top = 291
    Width = 121
    Height = 21
    TabOrder = 3
    Text = 'Edit4'
  end
  object Button1: TButton
    Left = 24
    Top = 328
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 4
  end
  object CheckBox1: TCheckBox
    Left = 24
    Top = 376
    Width = 97
    Height = 17
    Caption = 'CheckBox1'
    TabOrder = 5
  end
  object cbxObjectList: TComboBox
    Left = 24
    Top = 40
    Width = 130
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 6
    OnChange = cbxObjectListChange
  end
  object RadioGroup1: TRadioGroup
    Left = 256
    Top = 192
    Width = 185
    Height = 105
    Caption = 'RadioGroup1'
    Items.Strings = (
      'One'
      'Two'
      'Three')
    TabOrder = 7
  end
  object Memo1: TMemo
    Left = 256
    Top = 303
    Width = 185
    Height = 89
    Lines.Strings = (
      'Memo1')
    TabOrder = 8
  end
  object edtValue: TEdit
    Left = 320
    Top = 40
    Width = 121
    Height = 21
    TabOrder = 9
  end
  object cbxProperty: TComboBox
    Left = 160
    Top = 40
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 10
    OnChange = cbxPropertyChange
  end
  object btnChangePropValue: TButton
    Left = 447
    Top = 38
    Width = 75
    Height = 25
    Caption = 'Change'
    TabOrder = 11
    OnClick = btnChangePropValueClick
  end
  object cbxEvents: TComboBox
    Left = 24
    Top = 90
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 12
    OnChange = cbxEventsChange
  end
  object cbxMethods: TComboBox
    Left = 175
    Top = 90
    Width = 130
    Height = 21
    ItemHeight = 13
    TabOrder = 13
    OnChange = cbxMethodsChange
  end
  object btnChangeMethod: TButton
    Left = 311
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Change'
    TabOrder = 14
    OnClick = btnChangeMethodClick
  end
  object btnExecute: TButton
    Left = 392
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Execute'
    TabOrder = 15
    OnClick = btnExecuteClick
  end
end
