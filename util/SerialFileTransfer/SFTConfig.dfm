object SFTConfigF: TSFTConfigF
  Left = 339
  Top = 152
  Caption = 'Serial File Transfer Configuration'
  ClientHeight = 295
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
    Height = 254
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
      Caption = 'SFT Comm'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      object Label1: TLabel
        Left = 23
        Top = 50
        Width = 85
        Height = 16
        Caption = 'Query Interval:'
        ParentShowHint = False
        ShowHint = False
      end
      object Label2: TLabel
        Left = 19
        Top = 74
        Width = 79
        Height = 16
        Caption = #51025#45813' Timeout:'
      end
      object Label3: TLabel
        Left = 234
        Top = 50
        Width = 35
        Height = 16
        Caption = 'mSec'
        ParentShowHint = False
        ShowHint = False
      end
      object Label4: TLabel
        Left = 236
        Top = 74
        Width = 35
        Height = 16
        Caption = 'mSec'
      end
      object Label5: TLabel
        Left = 19
        Top = 114
        Width = 88
        Height = 16
        Caption = 'DownLoad Dir:'
      end
      object QueryIntervalEdit: TEdit
        Left = 111
        Top = 46
        Width = 121
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 0
      end
      object ResponseWaitTimeOutEdit: TEdit
        Left = 111
        Top = 71
        Width = 121
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 1
      end
      object DownLoadDirEdit: TJvDirectoryEdit
        Left = 113
        Top = 111
        Width = 184
        Height = 24
        DialogKind = dkWin32
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 2
        Text = 'DownLoadDirEdit'
      end
      object DontAskDnLdConfirmCB: TJvCheckBox
        Left = 23
        Top = 152
        Width = 190
        Height = 17
        BiDiMode = bdRightToLeft
        Caption = 'Don'#39't Ask Download Confirm'
        ParentBiDiMode = False
        TabOrder = 3
        LinkedControls = <>
        HotTrackFont.Charset = DEFAULT_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -13
        HotTrackFont.Name = 'MS Sans Serif'
        HotTrackFont.Style = []
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
    Top = 254
    Width = 350
    Height = 41
    Align = alBottom
    TabOrder = 1
    object BitBtn1: TBitBtn
      Left = 48
      Top = 8
      Width = 75
      Height = 25
      Caption = #54869' '#51064
      DoubleBuffered = True
      Kind = bkOK
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
      ParentDoubleBuffered = False
      TabOrder = 1
    end
  end
end
