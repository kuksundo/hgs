object ModbusConfigF: TModbusConfigF
  Left = 339
  Top = 152
  Width = 298
  Height = 290
  Caption = #47784#46300#48260#49828' '#53685#49888' '#54872#44221' '#49444#51221' '#54868#47732
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
    Width = 290
    Height = 215
    ActivePage = Tabsheet2
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabIndex = 0
    TabOrder = 0
    object Tabsheet2: TTabSheet
      Caption = 'Modbus '#54872#44221#49444#51221
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      object Label1: TLabel
        Left = 16
        Top = 135
        Width = 85
        Height = 16
        Caption = 'Query Interval:'
        ParentShowHint = False
        ShowHint = False
      end
      object Label2: TLabel
        Left = 12
        Top = 159
        Width = 79
        Height = 16
        Caption = #51025#45813' Timeout:'
      end
      object Label3: TLabel
        Left = 227
        Top = 135
        Width = 35
        Height = 16
        Caption = 'mSec'
        ParentShowHint = False
        ShowHint = False
      end
      object Label4: TLabel
        Left = 229
        Top = 159
        Width = 35
        Height = 16
        Caption = 'mSec'
      end
      object Label5: TLabel
        Left = 10
        Top = 102
        Width = 89
        Height = 16
        Caption = 'Base Address:'
        ParentShowHint = False
        ShowHint = False
      end
      object Label11: TLabel
        Left = 120
        Top = 79
        Width = 25
        Height = 16
        Caption = 'First'
      end
      object Label12: TLabel
        Left = 170
        Top = 79
        Width = 47
        Height = 16
        Caption = 'Second'
      end
      object ModbusModeRG: TRadioGroup
        Left = 16
        Top = 8
        Width = 233
        Height = 57
        Caption = #53685#49888' '#47784#46300
        ItemIndex = 0
        Items.Strings = (
          'ACSII '#47784#46300
          'RTU(Remote Terminal Unit) '#47784#46300)
        TabOrder = 0
      end
      object QueryIntervalEdit: TEdit
        Left = 104
        Top = 131
        Width = 121
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 1
      end
      object ResponseWaitTimeOutEdit: TEdit
        Left = 104
        Top = 156
        Width = 121
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 2
      end
      object BaseAddrEdit: TEdit
        Left = 104
        Top = 98
        Width = 65
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 3
        Text = '5000'
      end
      object BaseAddrEdit2: TEdit
        Left = 171
        Top = 98
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
      object FilenameEdit: TFilenameEdit
        Left = 8
        Top = 118
        Width = 249
        Height = 21
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        NumGlyphs = 1
        TabOrder = 2
      end
      object SlaveNoEdit2: TEdit
        Left = 168
        Top = 27
        Width = 49
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 3
        Text = '1'
      end
      object FuncCodeEdit2: TEdit
        Left = 168
        Top = 62
        Width = 49
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 4
        Text = '3'
      end
      object FilenameEdit2: TFilenameEdit
        Left = 8
        Top = 160
        Width = 249
        Height = 21
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        NumGlyphs = 1
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
        Caption = 'RS232 '#53685#49888#49444#51221
        TabOrder = 0
        OnClick = Button1Click
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 215
    Width = 290
    Height = 41
    Align = alBottom
    TabOrder = 1
    object BitBtn1: TBitBtn
      Left = 48
      Top = 8
      Width = 75
      Height = 25
      Caption = #54869' '#51064
      TabOrder = 0
      Kind = bkOK
    end
    object BitBtn2: TBitBtn
      Left = 160
      Top = 8
      Width = 75
      Height = 25
      Caption = #52712' '#49548
      TabOrder = 1
      Kind = bkCancel
    end
  end
end
