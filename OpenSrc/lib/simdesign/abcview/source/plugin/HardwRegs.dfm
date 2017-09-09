object frmAuthorise: TfrmAuthorise
  Left = 300
  Top = 103
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Authorise plugin'
  ClientHeight = 293
  ClientWidth = 338
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000380000000000000380B00000
    000000B80BB0000000033380BB0000333B03B80BB000033BBBBB80BB000003BB
    3BB80BB0000003BBB3BB3B0000007770BB3BB30000000B080BB3BB00000003B0
    70BBBB000000003B07BBB30000000003B7BB300000000000070000000000FFFF
    0000FFE10000FFE00000FF800000FE000000C00100008003000000070000000F
    0000001F0000001F0000001F0000001F0000801F0000C03F0000E07F0000}
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 321
    Height = 241
    Caption = 'Please authorise this plugin'
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 32
      Width = 90
      Height = 13
      Caption = 'Registration Name:'
    end
    object Label2: TLabel
      Left = 16
      Top = 80
      Width = 80
      Height = 13
      Caption = 'Your client code:'
      Visible = False
    end
    object lblClientCode: TLabel
      Left = 16
      Top = 94
      Width = 169
      Height = 16
      Caption = '0123-4567-ABCD-EF89'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
    end
    object Label3: TLabel
      Left = 16
      Top = 112
      Width = 289
      Height = 41
      AutoSize = False
      Caption = 
        'Please send this code along with your registration name by email' +
        ' to the plugin vendor. After receiving payment you will obtain y' +
        'our registration key as soon as possible.'
      Visible = False
      WordWrap = True
    end
    object Label4: TLabel
      Left = 16
      Top = 160
      Width = 79
      Height = 13
      Caption = 'Registration key:'
      Visible = False
    end
    object lblStatus: TLabel
      Left = 16
      Top = 208
      Width = 131
      Height = 13
      Caption = 'This plugin is not authorised'
    end
    object edRegName: TEdit
      Left = 16
      Top = 48
      Width = 209
      Height = 21
      TabOrder = 0
    end
    object btnCalc: TButton
      Left = 232
      Top = 46
      Width = 75
      Height = 25
      Caption = 'Calculate'
      TabOrder = 1
      OnClick = btnCalcClick
    end
    object edRegCode: TEdit
      Left = 16
      Top = 176
      Width = 209
      Height = 21
      TabOrder = 2
      Visible = False
    end
    object btnRegister: TButton
      Left = 232
      Top = 174
      Width = 75
      Height = 25
      Caption = 'Register'
      TabOrder = 3
      Visible = False
      OnClick = btnRegisterClick
    end
  end
  object BitBtn2: TBitBtn
    Left = 72
    Top = 256
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkHelp
  end
  object BitBtn1: TBitBtn
    Left = 168
    Top = 256
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkOK
  end
end
