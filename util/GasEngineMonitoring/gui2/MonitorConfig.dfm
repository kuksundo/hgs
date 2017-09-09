object ModbusConfigF: TModbusConfigF
  Left = 339
  Top = 152
  Caption = 'Configuration'
  ClientHeight = 295
  ClientWidth = 350
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = [fsBold]
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 254
    Width = 350
    Height = 41
    Align = alBottom
    TabOrder = 0
    object BitBtn1: TBitBtn
      Left = 48
      Top = 8
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
      Left = 160
      Top = 8
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
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 350
    Height = 254
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Setting'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ImageIndex = 1
      ParentFont = False
      DesignSize = (
        342
        223)
      object Label8: TLabel
        Left = 32
        Top = 26
        Width = 152
        Height = 16
        Caption = 'Modbus Map File Name1'
        ParentShowHint = False
        ShowHint = False
      end
      object Label10: TLabel
        Left = 127
        Top = 90
        Width = 91
        Height = 16
        Anchors = [akRight, akBottom]
        Caption = 'Average Size:'
      end
      object MapFilenameEdit: TJvFilenameEdit
        Left = 32
        Top = 45
        Width = 241
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 0
      end
      object AvgEdit: TEdit
        Left = 232
        Top = 87
        Width = 41
        Height = 24
        Anchors = [akRight, akBottom]
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 1
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Run Hour'
      ImageIndex = 1
      DesignSize = (
        342
        223)
      object Label1: TLabel
        Left = 129
        Top = 25
        Width = 89
        Height = 16
        Anchors = [akRight, akBottom]
        Caption = 'Running RPM:'
      end
      object Label2: TLabel
        Left = 103
        Top = 55
        Width = 115
        Height = 16
        Anchors = [akRight, akBottom]
        Caption = 'Not Running RPM:'
      end
      object Label3: TLabel
        Left = 52
        Top = 185
        Width = 156
        Height = 16
        Anchors = [akRight, akBottom]
        Caption = 'Run Hour(do not input):'
      end
      object Label4: TLabel
        Left = 277
        Top = 185
        Width = 14
        Height = 16
        Anchors = [akRight, akBottom]
        Caption = 'hr'
      end
      object RunRPMEdit: TEdit
        Left = 232
        Top = 23
        Width = 41
        Height = 24
        Anchors = [akRight, akBottom]
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 0
      end
      object NotRunRPMEdit: TEdit
        Left = 232
        Top = 53
        Width = 41
        Height = 24
        Anchors = [akRight, akBottom]
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 1
      end
      object UseECUSignalCB: TCheckBox
        Left = 24
        Top = 83
        Width = 225
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Use ECU Engine Running Signal'
        TabOrder = 2
      end
      object RunHourEdit: TEdit
        Left = 214
        Top = 183
        Width = 57
        Height = 24
        Anchors = [akRight, akBottom]
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 3
      end
    end
  end
end
