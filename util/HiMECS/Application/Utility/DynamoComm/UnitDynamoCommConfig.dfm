object DynamoConfigF: TDynamoConfigF
  Left = 0
  Top = 0
  Caption = 'Dynamo Comm Config'
  ClientHeight = 259
  ClientWidth = 324
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 218
    Width = 324
    Height = 41
    Align = alBottom
    TabOrder = 0
    object BitBtn1: TBitBtn
      Left = 48
      Top = 8
      Width = 75
      Height = 25
      Caption = #54869' '#51064
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 160
      Top = 8
      Width = 75
      Height = 25
      Caption = #52712' '#49548
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 324
    Height = 218
    ActivePage = Tabsheet2
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Tabsheet2: TTabSheet
      Caption = 'UDP'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      object Label5: TLabel
        Left = 32
        Top = 45
        Width = 97
        Height = 16
        Caption = 'Destination Port:'
        ParentShowHint = False
        ShowHint = False
      end
      object Label1: TLabel
        Left = 44
        Top = 13
        Width = 85
        Height = 16
        Caption = 'Destination IP:'
        ParentShowHint = False
        ShowHint = False
      end
      object Label2: TLabel
        Left = 32
        Top = 109
        Width = 96
        Height = 16
        Caption = 'My Binding Port:'
        ParentShowHint = False
        ShowHint = False
      end
      object Label3: TLabel
        Left = 44
        Top = 77
        Width = 84
        Height = 16
        Caption = 'My Binding IP:'
        ParentShowHint = False
        ShowHint = False
      end
      object Bevel1: TBevel
        Left = 8
        Top = 69
        Width = 297
        Height = 5
      end
      object Label4: TLabel
        Left = 44
        Top = 146
        Width = 85
        Height = 16
        Caption = 'Query Interval:'
        ParentShowHint = False
        ShowHint = False
      end
      object Bevel2: TBevel
        Left = 8
        Top = 135
        Width = 297
        Height = 5
      end
      object Label6: TLabel
        Left = 262
        Top = 148
        Width = 35
        Height = 16
        Caption = 'mSec'
        ParentShowHint = False
        ShowHint = False
      end
      object PortEdit: TEdit
        Left = 135
        Top = 41
        Width = 121
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 0
        Text = '5002'
      end
      object HostIPEdit: TEdit
        Left = 135
        Top = 11
        Width = 121
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 1
        Text = '192.168.1.2'
      end
      object MyPortEdit: TEdit
        Left = 135
        Top = 105
        Width = 121
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 2
        Text = '5001'
      end
      object MyIPEdit: TEdit
        Left = 135
        Top = 75
        Width = 121
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 3
        Text = '192.168.1.1'
      end
      object IntervalEdit: TEdit
        Left = 135
        Top = 145
        Width = 121
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 4
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'File'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label7: TLabel
        Left = 24
        Top = 18
        Width = 131
        Height = 16
        Caption = 'Parameter File Name:'
        ParentShowHint = False
        ShowHint = False
      end
      object ParaFilenameEdit: TJvFilenameEdit
        Left = 24
        Top = 40
        Width = 257
        Height = 24
        TabOrder = 0
        Text = ''
      end
    end
  end
end
