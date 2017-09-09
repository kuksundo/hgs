object SaveConfigF: TSaveConfigF
  Left = 624
  Top = 334
  Caption = #54872#44221#49444#51221' '#54868#47732
  ClientHeight = 241
  ClientWidth = 286
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 200
    Width = 286
    Height = 41
    Align = alBottom
    TabOrder = 0
    object BitBtn1: TBitBtn
      Left = 56
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
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 286
    Height = 200
    ActivePage = TabSheet4
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = #51200#51109#51068#49884
      TabVisible = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 196
      object Label1: TLabel
        Left = 131
        Top = 61
        Width = 12
        Height = 16
        Caption = #49884
      end
      object Label2: TLabel
        Left = 195
        Top = 61
        Width = 12
        Height = 16
        Caption = #48516
      end
      object Label3: TLabel
        Left = 67
        Top = 117
        Width = 12
        Height = 16
        Caption = #50900
      end
      object Label4: TLabel
        Left = 131
        Top = 117
        Width = 12
        Height = 16
        Caption = #51068
      end
      object Label5: TLabel
        Left = 24
        Top = 8
        Width = 195
        Height = 48
        Caption = #49444#51221#54620' '#49884#44036#48324#47196' '#46608#45716' '#45216#51676', '#49884#44036#48324#47196#13#10#13#10#45936#51060#53440#47484'  '#51200#51109#54632
      end
      object ampm_combo: TComboBox
        Left = 24
        Top = 57
        Width = 57
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        ItemHeight = 0
        TabOrder = 0
        Text = #50724#51204
        Items.Strings = (
          #50724#51204
          #50724#54980)
      end
      object Hour_SpinEdit: TSpinEdit
        Left = 88
        Top = 57
        Width = 41
        Height = 26
        MaxValue = 12
        MinValue = 0
        TabOrder = 1
        Value = 0
      end
      object Minute_SpinEdit: TSpinEdit
        Left = 152
        Top = 57
        Width = 41
        Height = 26
        MaxValue = 59
        MinValue = 0
        TabOrder = 2
        Value = 0
      end
      object UseDate_ChkBox: TCheckBox
        Left = 24
        Top = 89
        Width = 129
        Height = 17
        Caption = #45216#51676' '#49324#50857#54616#44592
        TabOrder = 3
      end
      object Month_SpinEdit: TSpinEdit
        Left = 24
        Top = 113
        Width = 41
        Height = 26
        MaxValue = 12
        MinValue = 1
        TabOrder = 4
        Value = 1
      end
      object Date_SpinEdit: TSpinEdit
        Left = 88
        Top = 113
        Width = 41
        Height = 26
        MaxValue = 31
        MinValue = 1
        TabOrder = 5
        Value = 1
      end
      object Repeat_ChkBox: TCheckBox
        Left = 24
        Top = 145
        Width = 129
        Height = 17
        Caption = #48152#48373' '#51652#54665
        TabOrder = 6
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'ETC'
      ImageIndex = 3
      object Label11: TLabel
        Left = 3
        Top = 3
        Width = 96
        Height = 16
        Caption = 'Shared Memory'
      end
      object Label12: TLabel
        Left = 3
        Top = 53
        Width = 111
        Height = 16
        Caption = 'Oracle Host Name'
      end
      object Ed_sharedmemory: TEdit
        Left = 3
        Top = 25
        Width = 270
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 0
      end
      object Ed_hostname: TEdit
        Left = 3
        Top = 71
        Width = 270
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 1
      end
    end
    object TabSheet2: TTabSheet
      Caption = #51200#51109#51452#44592
      Enabled = False
      ImageIndex = 1
      object Label6: TLabel
        Left = 59
        Top = 80
        Width = 24
        Height = 13
        Caption = #49884#44036
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label7: TLabel
        Left = 134
        Top = 80
        Width = 12
        Height = 13
        Caption = #48516
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label8: TLabel
        Left = 16
        Top = 8
        Width = 162
        Height = 39
        Caption = #49444#51221#54620' '#49884#44036#51012' '#52852#50868#53944#45796#50868#54616#50668#13#10' '#13#10#39'0'#39' '#51060' '#46104#47732' '#45936#51060#53440#47484'  '#51200#51109#54632
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label10: TLabel
        Left = 198
        Top = 80
        Width = 12
        Height = 13
        Caption = #52488
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object HourCnt_SpinEdit: TSpinEdit
        Left = 16
        Top = 73
        Width = 41
        Height = 26
        Enabled = False
        MaxValue = 0
        MinValue = 0
        TabOrder = 0
        Value = 0
      end
      object MinuteCnt_SpinEdit: TSpinEdit
        Left = 91
        Top = 73
        Width = 41
        Height = 26
        Enabled = False
        MaxValue = 0
        MinValue = 0
        TabOrder = 1
        Value = 0
      end
      object RepeatCnt_ChkBox: TCheckBox
        Left = 16
        Top = 113
        Width = 129
        Height = 17
        Caption = #48152#48373' '#51652#54665
        Enabled = False
        TabOrder = 2
      end
      object SecondCnt_SpinEdit: TSpinEdit
        Left = 155
        Top = 73
        Width = 41
        Height = 26
        Enabled = False
        MaxValue = 0
        MinValue = 0
        TabOrder = 3
        Value = 1
      end
    end
    object TabSheet3: TTabSheet
      Caption = #51200#51109' '#47588#52404
      ImageIndex = 2
      object Label9: TLabel
        Left = 8
        Top = 8
        Width = 180
        Height = 39
        Caption = #45936#51060#53440#47484' '#51200#51109#54624' '#47588#52404#47484' '#49440#53469#54632'.'#13#10#48373#49688#44060' '#49440#53469#51060' '#44032#45733#54616#47728' '#50500#47924#44163#46020' '#13#10#49440#53469#51012' '#50504#54616#47732' '#51200#51109#51012' '#54616#51648' '#50506#51020
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object SaveDB_ChkBox: TCheckBox
        Left = 16
        Top = 57
        Width = 129
        Height = 17
        Caption = #45936#51060#53440#48288#51060#49828
        Enabled = False
        TabOrder = 0
      end
      object SaveFile_ChkBox: TCheckBox
        Left = 16
        Top = 80
        Width = 129
        Height = 17
        Caption = #54028#51068
        Enabled = False
        TabOrder = 1
      end
      object FNameType_RG: TRadioGroup
        Left = 16
        Top = 99
        Width = 249
        Height = 57
        Enabled = False
        Items.Strings = (
          #54028#51068#51060#47492' '#51088#46041#48320#44221'(yyyymmdd.txt)'
          #44256#51221#46108'  '#54028#51068#51060#47492)
        TabOrder = 2
      end
    end
  end
end
