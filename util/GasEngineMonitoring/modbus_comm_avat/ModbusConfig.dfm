object ModbusConfigF: TModbusConfigF
  Left = 339
  Top = 152
  Caption = 'Modbus Communication Config'
  ClientHeight = 344
  ClientWidth = 350
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 350
    Height = 303
    ActivePage = Tabsheet2
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Tabsheet2: TTabSheet
      Caption = 'Modbus Config'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      object Label1: TLabel
        Left = 16
        Top = 207
        Width = 85
        Height = 16
        Caption = 'Query Interval:'
        ParentShowHint = False
        ShowHint = False
      end
      object Label2: TLabel
        Left = 12
        Top = 231
        Width = 91
        Height = 16
        Caption = 'Resp. Timeout:'
      end
      object Label3: TLabel
        Left = 227
        Top = 207
        Width = 35
        Height = 16
        Caption = 'mSec'
        ParentShowHint = False
        ShowHint = False
      end
      object Label4: TLabel
        Left = 229
        Top = 231
        Width = 35
        Height = 16
        Caption = 'mSec'
      end
      object Label5: TLabel
        Left = 10
        Top = 174
        Width = 89
        Height = 16
        Caption = 'Base Address:'
        ParentShowHint = False
        ShowHint = False
      end
      object Label11: TLabel
        Left = 120
        Top = 151
        Width = 25
        Height = 16
        Caption = 'First'
      end
      object Label12: TLabel
        Left = 170
        Top = 151
        Width = 47
        Height = 16
        Caption = 'Second'
      end
      object ModbusModeRG: TRadioGroup
        Left = 16
        Top = 3
        Width = 233
        Height = 142
        Caption = #53685#49888' '#47784#46300
        ItemIndex = 0
        Items.Strings = (
          'ACSII Mode'
          'RTU(Remote Terminal Unit) Mode'
          'TCP(Wago PLC) Mode'
          'Simulate Mode'
          'ModbusTCP Mode')
        TabOrder = 0
        OnClick = ModbusModeRGClick
      end
      object QueryIntervalEdit: TEdit
        Left = 104
        Top = 203
        Width = 121
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 1
      end
      object ResponseWaitTimeOutEdit: TEdit
        Left = 104
        Top = 228
        Width = 121
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 2
      end
      object BaseAddrEdit: TEdit
        Left = 104
        Top = 170
        Width = 65
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 3
        Text = '5000'
      end
      object BaseAddrEdit2: TEdit
        Left = 171
        Top = 170
        Width = 65
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 4
        Text = '5000'
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Message Format'
      ImageIndex = 1
      object Label6: TLabel
        Left = 49
        Top = 31
        Width = 59
        Height = 16
        Caption = 'Slave No:'
        ParentShowHint = False
        ShowHint = False
      end
      object Label7: TLabel
        Left = 18
        Top = 66
        Width = 89
        Height = 16
        Caption = 'Function Code:'
        ParentShowHint = False
        ShowHint = False
      end
      object Label8: TLabel
        Left = 10
        Top = 98
        Width = 151
        Height = 16
        Caption = 'Modbus Map File Name1'
        ParentShowHint = False
        ShowHint = False
      end
      object Label9: TLabel
        Left = 120
        Top = 8
        Width = 25
        Height = 16
        Caption = 'First'
      end
      object Label10: TLabel
        Left = 170
        Top = 8
        Width = 47
        Height = 16
        Caption = 'Second'
      end
      object Label13: TLabel
        Left = 11
        Top = 140
        Width = 151
        Height = 16
        Caption = 'Modbus Map File Name2'
        ParentShowHint = False
        ShowHint = False
      end
      object SlaveNoEdit: TEdit
        Left = 112
        Top = 27
        Width = 49
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 0
        Text = '1'
      end
      object FuncCodeEdit: TEdit
        Left = 112
        Top = 62
        Width = 49
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 1
        Text = '3'
      end
      object SlaveNoEdit2: TEdit
        Left = 168
        Top = 27
        Width = 49
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 2
        Text = '1'
      end
      object FuncCodeEdit2: TEdit
        Left = 168
        Top = 62
        Width = 49
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 3
        Text = '3'
      end
      object FilenameEdit: TJvFilenameEdit
        Left = 8
        Top = 116
        Width = 249
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 4
      end
      object FilenameEdit2: TJvFilenameEdit
        Left = 8
        Top = 160
        Width = 249
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 5
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'RS232'
      ImageIndex = 2
      object Button1: TButton
        Left = 85
        Top = 69
        Width = 129
        Height = 41
        Caption = 'RS232 Config'
        TabOrder = 0
        OnClick = Button1Click
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'TCP'
      ImageIndex = 3
      object Label14: TLabel
        Left = 49
        Top = 31
        Width = 69
        Height = 16
        Caption = 'IP Address:'
        ParentShowHint = False
        ShowHint = False
      end
      object Label15: TLabel
        Left = 60
        Top = 71
        Width = 58
        Height = 16
        Caption = 'Port Num:'
        ParentShowHint = False
        ShowHint = False
      end
      object PortNumEdit: TEdit
        Left = 124
        Top = 68
        Width = 111
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 0
        Text = '1'
      end
      object JvIPAddress1: TJvIPAddress
        Left = 124
        Top = 31
        Width = 150
        Height = 24
        AddressValues.Address = 0
        AddressValues.Value1 = 0
        AddressValues.Value2 = 0
        AddressValues.Value3 = 0
        AddressValues.Value4 = 0
        ParentColor = False
        TabOrder = 1
        Text = '0.0.0.0'
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 303
    Width = 350
    Height = 41
    Align = alBottom
    TabOrder = 1
    object BitBtn1: TBitBtn
      Left = 74
      Top = 6
      Width = 75
      Height = 25
      Caption = #54869' '#51064
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 207
      Top = 6
      Width = 75
      Height = 25
      Caption = #52712' '#49548
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
  end
end
