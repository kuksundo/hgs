object Form3: TForm3
  Left = 0
  Top = 0
  Anchors = [akRight, akBottom]
  Caption = 'RTTI  Demo'
  ClientHeight = 284
  ClientWidth = 404
  Color = clBtnFace
  Constraints.MinHeight = 320
  Constraints.MinWidth = 420
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    404
    284)
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 218
    Height = 271
    Anchors = [akLeft, akTop, akBottom]
    Caption = 'Demo Object Data'
    TabOrder = 0
    DesignSize = (
      218
      271)
    object Label1: TLabel
      Left = 24
      Top = 24
      Width = 14
      Height = 13
      Caption = 'Str'
    end
    object Label2: TLabel
      Left = 24
      Top = 67
      Width = 14
      Height = 13
      Caption = 'Int'
    end
    object Label3: TLabel
      Left = 24
      Top = 104
      Width = 24
      Height = 13
      Caption = 'Float'
    end
    object Label4: TLabel
      Left = 24
      Top = 150
      Width = 26
      Height = 13
      Caption = 'Enum'
    end
    object edtStr: TEdit
      Left = 24
      Top = 43
      Width = 120
      Height = 21
      TabOrder = 0
    end
    object speInt: TSpinEdit
      Left = 24
      Top = 83
      Width = 120
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 0
    end
    object medFloat: TMaskEdit
      Left = 24
      Top = 123
      Width = 120
      Height = 21
      EditMask = '###.##;1;_'
      MaxLength = 6
      TabOrder = 2
      Text = '   .  '
    end
    object cbxEnum: TComboBox
      Left = 24
      Top = 163
      Width = 121
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 3
    end
    object cbBool: TCheckBox
      Left = 24
      Top = 200
      Width = 97
      Height = 17
      Caption = 'Bool'
      TabOrder = 4
    end
    object Button1: TButton
      Left = 111
      Top = 236
      Width = 97
      Height = 26
      Anchors = [akLeft, akBottom]
      Caption = 'Load From INI'
      TabOrder = 5
      OnClick = Button1Click
    end
    object Button4: TButton
      Left = 8
      Top = 237
      Width = 97
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Save To INI'
      TabOrder = 6
      OnClick = Button4Click
    end
  end
  object GroupBox2: TGroupBox
    Left = 230
    Top = 8
    Width = 168
    Height = 269
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'INI File Contents'
    TabOrder = 1
    DesignSize = (
      168
      269)
    object memDisplay: TMemo
      Left = 7
      Top = 19
      Width = 157
      Height = 210
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelKind = bkSoft
      TabOrder = 0
    end
    object Button3: TButton
      Left = 68
      Top = 235
      Width = 97
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Save Storage'
      TabOrder = 1
      OnClick = Button3Click
    end
  end
end
