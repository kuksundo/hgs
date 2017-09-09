object S7ConfigF: TS7ConfigF
  Left = 339
  Top = 152
  Caption = 'Modbus Communication Config'
  ClientHeight = 357
  ClientWidth = 355
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 355
    Height = 316
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
      Caption = 'S7  Config'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      object Label1: TLabel
        Left = 20
        Top = 65
        Width = 53
        Height = 16
        Caption = 'Protocol:'
        FocusControl = Protocol
      end
      object Label2: TLabel
        Left = 16
        Top = 102
        Width = 67
        Height = 16
        Caption = 'CPU-Rack:'
        FocusControl = CPURack
      end
      object Label3: TLabel
        Left = 184
        Top = 102
        Width = 26
        Height = 16
        Caption = 'Slot:'
        FocusControl = CPUSlot
      end
      object Label4: TLabel
        Left = 12
        Top = 129
        Width = 70
        Height = 16
        Caption = 'IP-Address:'
        FocusControl = IPAddress
      end
      object Label5: TLabel
        Left = 21
        Top = 221
        Width = 52
        Height = 16
        Caption = 'Timeout:'
        FocusControl = Timeout
      end
      object Label11: TLabel
        Left = 12
        Top = 253
        Width = 61
        Height = 16
        Caption = 'COM-Port:'
      end
      object Label12: TLabel
        Left = 12
        Top = 159
        Width = 71
        Height = 16
        Caption = 'MPI-Speed:'
        FocusControl = MPISpeed
      end
      object Label17: TLabel
        Left = 21
        Top = 193
        Width = 63
        Height = 16
        Caption = 'MPI-Local:'
        FocusControl = MPILocal
      end
      object Label18: TLabel
        Left = 159
        Top = 193
        Width = 51
        Height = 16
        Caption = 'Remote:'
        FocusControl = MPIRemote
      end
      object Label21: TLabel
        Left = 159
        Top = 221
        Width = 46
        Height = 16
        Caption = 'Interval:'
        FocusControl = Interval
      end
      object Label6: TLabel
        Left = 42
        Top = 3
        Width = 40
        Height = 16
        Caption = 'Name:'
        FocusControl = Connection
      end
      object Label7: TLabel
        Left = 11
        Top = 33
        Width = 71
        Height = 16
        Caption = 'Description:'
        FocusControl = Description
      end
      object Protocol: TComboBox
        Left = 88
        Top = 62
        Width = 246
        Height = 24
        Hint = 'Used protocol for the connection'
        Style = csDropDownList
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 0
        OnChange = ProtocolChange
        Items.Strings = (
          'MPI-Protocol'
          'MPI-Protocol (Andrew'#39's Version without STX)'
          'MPI-Protocol (Step7 Version)'
          'MPI-Protocol (Andrew'#39's Version with STX)'
          'PPI-Protocol'
          'ISO over TCP '
          'ISO over TCP (CP-243)'
          'IBH-Link'
          'IBH-Link (PPI)'
          'S7Onlinx.dll'
          'AS-511'
          'Deltalogic NetLink PRO')
      end
      object MPILocal: TSpinEdit
        Left = 90
        Top = 186
        Width = 46
        Height = 26
        Hint = 'Local (PC-side) MPI-Address'
        MaxValue = 127
        MinValue = 0
        TabOrder = 1
        Value = 0
      end
      object MPIRemote: TSpinEdit
        Left = 216
        Top = 186
        Width = 46
        Height = 26
        Hint = 'Remote (PLC-side) MPI-Address'
        MaxValue = 127
        MinValue = 0
        TabOrder = 2
        Value = 2
      end
      object CPURack: TSpinEdit
        Left = 89
        Top = 97
        Width = 46
        Height = 26
        Hint = 'Number of the rack containing the CPU'
        MaxValue = 0
        MinValue = 0
        TabOrder = 3
        Value = 0
      end
      object CPUSlot: TSpinEdit
        Left = 214
        Top = 97
        Width = 46
        Height = 26
        Hint = 'Number of the slot containing the CPU'
        MaxValue = 32
        MinValue = 1
        TabOrder = 4
        Value = 2
      end
      object MPISpeed: TComboBox
        Left = 89
        Top = 156
        Width = 146
        Height = 24
        Hint = 'Connection-speed of the MPI-connection'
        Style = csDropDownList
        ImeName = 'Microsoft Office IME 2007'
        ItemIndex = 2
        TabOrder = 5
        Text = '187.5 kBit/s'
        Items.Strings = (
          '9.6 kBit/s'
          '19.2 kBit/s'
          '187.5 kBit/s'
          '500 kBit/s'
          '1.5 MBit/s'
          '45.45 kBit/s'
          '93.75 kBit/s')
      end
      object Timeout: TSpinEdit
        Left = 89
        Top = 218
        Width = 61
        Height = 26
        Hint = 'Timeout for the connection in milliseconds'
        Increment = 10
        MaxValue = 120000
        MinValue = 0
        TabOrder = 6
        Value = 100
      end
      object IPAddress: TEdit
        Left = 88
        Top = 129
        Width = 171
        Height = 24
        Hint = 'IP-Address of the CPU / CP or the IBH-Link at the PLC'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 7
      end
      object Interval: TSpinEdit
        Left = 211
        Top = 218
        Width = 61
        Height = 26
        Hint = 'Configured refresh-cycle for the connection in milliseconds'
        Increment = 10
        MaxValue = 60000
        MinValue = 0
        TabOrder = 8
        Value = 1000
      end
      object COMPort: TEdit
        Left = 91
        Top = 250
        Width = 141
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 9
        Text = 'COMPort'
      end
      object Connection: TEdit
        Left = 88
        Top = 3
        Width = 71
        Height = 24
        Hint = 'Symbolic name of the connection'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 10
      end
      object Description: TEdit
        Left = 88
        Top = 30
        Width = 246
        Height = 24
        Hint = 'Long description of the connection'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 11
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Message Format'
      ImageIndex = 1
      object Label8: TLabel
        Left = 10
        Top = 26
        Width = 151
        Height = 16
        Caption = 'Modbus Map File Name1'
        ParentShowHint = False
        ShowHint = False
      end
      object Label16: TLabel
        Left = 3
        Top = 91
        Width = 111
        Height = 16
        Caption = 'IPC Shared Name:'
        ParentShowHint = False
        ShowHint = False
      end
      object FilenameEdit: TJvFilenameEdit
        Left = 8
        Top = 44
        Width = 289
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 0
      end
      object SharedNameEdit: TComboBox
        Left = 120
        Top = 88
        Width = 177
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 1
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 316
    Width = 355
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
      OnClick = BitBtn1Click
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
