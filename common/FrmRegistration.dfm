object RegistrationF: TRegistrationF
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Product Registration'
  ClientHeight = 433
  ClientWidth = 375
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object MachineIDLabel: TLabel
    Left = 330
    Top = 21
    Width = 39
    Height = 13
    Caption = 'Mach ID'
    Visible = False
  end
  object Memo1: TMemo
    Left = 10
    Top = 8
    Width = 314
    Height = 49
    TabStop = False
    BorderStyle = bsNone
    Color = clBtnFace
    ImeName = 'Microsoft IME 2010'
    Lines.Strings = (
      'Thank you for registering our product.  '
      'To complete your registration, please send e-mail '
      'with attached the *.iif file to us at kuksundo@gmail.com.')
    ReadOnly = True
    TabOrder = 0
  end
  object btnSave: TButton
    Left = 8
    Top = 391
    Width = 129
    Height = 32
    Caption = 'Create Intall Info File(.iif)'
    TabOrder = 1
    OnClick = btnSaveClick
  end
  object btnReadme: TButton
    Left = 255
    Top = 391
    Width = 111
    Height = 32
    Caption = 'Registration'
    TabOrder = 2
    OnClick = btnReadmeClick
  end
  object GroupBox2: TGroupBox
    Left = -8
    Top = 63
    Width = 377
    Height = 322
    Caption = ' Registration Code Verification'
    TabOrder = 3
    object Label4: TLabel
      Left = 48
      Top = 29
      Width = 49
      Height = 13
      Alignment = taRightJustify
      Caption = 'Company:'
    end
    object Label2: TLabel
      Left = 41
      Top = 56
      Width = 56
      Height = 13
      Alignment = taRightJustify
      Caption = 'User Name:'
    end
    object Label5: TLabel
      Left = 23
      Top = 83
      Width = 74
      Height = 13
      Alignment = taRightJustify
      Caption = 'E-Mail Address:'
    end
    object Label1: TLabel
      Left = 23
      Top = 106
      Width = 133
      Height = 13
      Caption = 'Enter Product serial number'
    end
    object Label3: TLabel
      Left = 20
      Top = 263
      Width = 215
      Height = 13
      Caption = 'Enter the release code you were given by us'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object CompanyEdit: TEdit
      Left = 106
      Top = 25
      Width = 233
      Height = 21
      ImeName = 'Microsoft IME 2010'
      TabOrder = 0
    end
    object UserNameEdit: TEdit
      Left = 106
      Top = 52
      Width = 233
      Height = 21
      ImeName = 'Microsoft IME 2010'
      TabOrder = 1
    end
    object EmailEdit: TEdit
      Left = 106
      Top = 79
      Width = 233
      Height = 21
      ImeName = 'Microsoft IME 2010'
      TabOrder = 2
    end
    object edtSerial: TEdit
      Left = 23
      Top = 122
      Width = 316
      Height = 21
      ImeName = 'Microsoft IME 2010'
      MaxLength = 19
      TabOrder = 3
    end
    object edtReleaseCode: TEdit
      Left = 18
      Top = 282
      Width = 318
      Height = 21
      TabStop = False
      Enabled = False
      ImeName = 'Microsoft IME 2010'
      ReadOnly = True
      TabOrder = 4
    end
    object spdReleaseCode: TBitBtn
      Left = 311
      Top = 282
      Width = 25
      Height = 21
      Glyph.Data = {
        42010000424D4201000000000000760000002800000011000000110000000100
        040000000000CC00000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        8888800000008888888888888888800000008888888888888888800000008888
        8888888888888000000088888888888888888000000088880008888888888000
        0000888000008808888080000000880098900808008080000000880089800000
        0000800000008800898000000000800000008800989008888888800000008880
        0000888888888000000088880008888888888000000088888888888888888000
        0000888888888888888880000000888888888888888880000000888888888888
        888880000000}
      TabOrder = 5
      OnClick = spdReleaseCodeClick
    end
    object Memo2: TMemo
      Left = 16
      Top = 159
      Width = 358
      Height = 98
      TabStop = False
      BorderStyle = bsNone
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold, fsItalic]
      ImeName = 'Microsoft IME 2010'
      Lines.Strings = (
        'Fill in above all items,'
        'then Click the "Create Install Info File(*.iif)"button.'
        'And Send the .iif file to us by e-mail'
        '--------------------------------------------------------------'
        'You will receive the regstration file(*.hjp) from us by email.'
        'Open received file by click the below key button and'
        'Click the "Registration" Button.')
      ParentFont = False
      ReadOnly = True
      TabOrder = 6
    end
  end
  object Button1: TButton
    Left = 147
    Top = 392
    Width = 97
    Height = 33
    Caption = 'Register Later'
    TabOrder = 4
    OnClick = Button1Click
  end
  object OpenDialog1: TOpenDialog
    Left = 320
    Top = 216
  end
end
