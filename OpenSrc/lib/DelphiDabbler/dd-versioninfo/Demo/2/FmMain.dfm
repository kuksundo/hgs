object MainForm: TMainForm
  Left = 293
  Top = 113
  BorderStyle = bsDialog
  ClientHeight = 194
  ClientWidth = 297
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 15
  object lblDesc: TLabel
    Left = 10
    Top = 10
    Width = 261
    Height = 15
    Caption = 'Click the button to display the required example.'
  end
  object btnEg1: TButton
    Left = 10
    Top = 39
    Width = 277
    Height = 31
    Caption = 'Example 1: Translation, char set && language'
    TabOrder = 0
    OnClick = btnEg1Click
  end
  object btnEg2: TButton
    Left = 10
    Top = 79
    Width = 277
    Height = 31
    Caption = 'Example 2: String information properties'
    TabOrder = 1
    OnClick = btnEg2Click
  end
  object btnEg3: TButton
    Left = 10
    Top = 118
    Width = 277
    Height = 31
    Caption = 'Example 3: Fixed file information properties'
    TabOrder = 2
    OnClick = btnEg3Click
  end
  object btnEg4: TButton
    Left = 10
    Top = 158
    Width = 277
    Height = 30
    Caption = 'Example 4: FixedFileInfo property'
    TabOrder = 3
    OnClick = btnEg4Click
  end
end
