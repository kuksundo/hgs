object frmProperties: TfrmProperties
  Left = 0
  Top = 0
  Caption = 'Properties'
  ClientHeight = 369
  ClientWidth = 482
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
    Top = 24
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
  object Edit1: TEdit
    Left = 24
    Top = 112
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'Edit1'
  end
  object Edit2: TEdit
    Left = 24
    Top = 147
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'Edit2'
  end
  object Edit3: TEdit
    Left = 24
    Top = 176
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'Edit3'
  end
  object Edit4: TEdit
    Left = 24
    Top = 211
    Width = 121
    Height = 21
    TabOrder = 3
    Text = 'Edit4'
  end
  object Button1: TButton
    Left = 24
    Top = 248
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 4
  end
  object CheckBox1: TCheckBox
    Left = 24
    Top = 296
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
    Top = 112
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
    Top = 224
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
  object Button2: TButton
    Left = 366
    Top = 67
    Width = 75
    Height = 25
    Caption = 'Change'
    TabOrder = 11
    OnClick = Button2Click
  end
end
