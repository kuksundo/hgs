object AlarmConfigF: TAlarmConfigF
  Left = 0
  Top = 0
  Caption = 'Alarm Config'
  ClientHeight = 322
  ClientWidth = 386
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 386
    Height = 281
    ActivePage = Tabsheet2
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Tabsheet2: TTabSheet
      Caption = 'File'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      object Label1: TLabel
        Left = 48
        Top = 34
        Width = 96
        Height = 16
        Caption = 'Alarm DB Driver:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
      end
      object Label3: TLabel
        Left = 25
        Top = 61
        Width = 119
        Height = 16
        Caption = 'Alarm DB File Name:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
      end
      object AlarmDBFilenameEdit: TJvFilenameEdit
        Left = 149
        Top = 61
        Width = 204
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 0
      end
      object DBDriverEdit: TJvFilenameEdit
        Left = 150
        Top = 31
        Width = 204
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 1
      end
      object GroupBox1: TGroupBox
        Left = 39
        Top = 105
        Width = 280
        Height = 120
        Caption = 'Create Alarm DB in'
        TabOrder = 2
        object RB_bydate: TRadioButton
          Left = 96
          Top = 23
          Width = 89
          Height = 17
          Caption = 'every Day'
          TabOrder = 0
        end
        object RB_byfilename: TRadioButton
          Left = 96
          Top = 62
          Width = 113
          Height = 17
          Caption = 'Fixed Filename'
          TabOrder = 1
        end
        object RadioButton1: TRadioButton
          Left = 96
          Top = 42
          Width = 113
          Height = 17
          Caption = 'every Month'
          Checked = True
          TabOrder = 2
          TabStop = True
        end
        object ED_csv: TEdit
          Left = 96
          Top = 85
          Width = 169
          Height = 24
          Enabled = False
          ImeName = 'Microsoft Office IME 2007'
          TabOrder = 3
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 281
    Width = 386
    Height = 41
    Align = alBottom
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object BitBtn1: TBitBtn
      Left = 66
      Top = 6
      Width = 75
      Height = 25
      Caption = #54869' '#51064
      DoubleBuffered = True
      Kind = bkOK
      NumGlyphs = 2
      ParentDoubleBuffered = False
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 198
      Top = 6
      Width = 75
      Height = 25
      Caption = #52712' '#49548
      DoubleBuffered = True
      Kind = bkCancel
      NumGlyphs = 2
      ParentDoubleBuffered = False
      TabOrder = 1
    end
  end
end
