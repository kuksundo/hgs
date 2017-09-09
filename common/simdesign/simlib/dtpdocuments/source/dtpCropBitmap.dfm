object frmCropBitmap: TfrmCropBitmap
  Left = 384
  Top = 170
  Width = 452
  Height = 423
  Caption = 'Select Crop Area'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnlButtons: TPanel
    Left = 0
    Top = 317
    Width = 444
    Height = 72
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object lbWarning: TLabel
      Left = 32
      Top = 8
      Width = 385
      Height = 13
      Caption = 
        'You cannot reduce the size any furter because it wouldn'#39't have e' +
        'nough resolution'
      Visible = False
    end
    object btnOK: TButton
      Left = 184
      Top = 32
      Width = 75
      Height = 25
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
    end
  end
end
