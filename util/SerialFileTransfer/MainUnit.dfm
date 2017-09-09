object SerialFileTransferF: TSerialFileTransferF
  Left = 204
  Top = 223
  Caption = 'Serial File Transfer'
  ClientHeight = 389
  ClientWidth = 730
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 41
    Height = 322
    ExplicitTop = 47
    ExplicitHeight = 349
  end
  object JvSplitter1: TJvSplitter
    Left = 353
    Top = 41
    Height = 322
    ExplicitLeft = 368
    ExplicitTop = 240
    ExplicitHeight = 100
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 730
    Height = 41
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label3: TLabel
      Left = 529
      Top = 19
      Width = 113
      Height = 16
      AutoSize = False
      Caption = #53685#49888#50640#47084' '#44148#49688':'
    end
    object Label4: TLabel
      Left = 648
      Top = 19
      Width = 73
      Height = 16
      AutoSize = False
      Caption = '0'
    end
    object Label2: TLabel
      Left = 340
      Top = 19
      Width = 37
      Height = 16
      AutoSize = False
      Caption = #49688#49888
    end
    object Button1: TButton
      Left = 16
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Connect'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 178
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Config'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 97
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Send'
      TabOrder = 2
      OnClick = Button3Click
    end
  end
  object ModBusRecvComMemo: TMemo
    Left = 356
    Top = 41
    Width = 374
    Height = 322
    Align = alClient
    ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object StatusBarPro1: TStatusBarPro
    Left = 0
    Top = 363
    Width = 730
    Height = 26
    Panels = <
      item
        Bevel = pbRaised
        Width = 50
      end
      item
        Control = JvLED1
        Width = 30
      end
      item
        Width = 100
      end
      item
        Width = 200
      end
      item
        Alignment = taRightJustify
        Text = 'Transfer(%)'
        Width = 200
      end
      item
        Control = JvProgressBar1
        Width = 50
      end>
    SimplePanel = False
    object JvLED1: TJvLED
      Left = 53
      Top = 3
      Width = 26
      Height = 22
      Active = True
      Interval = 0
      ParentShowHint = False
      ShowHint = True
      Status = False
    end
    object JvProgressBar1: TJvProgressBar
      Left = 583
      Top = 3
      Width = 130
      Height = 22
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 3
    Top = 41
    Width = 350
    Height = 322
    Align = alLeft
    Caption = 'Panel2'
    TabOrder = 3
    object JvSplitter2: TJvSplitter
      Left = 1
      Top = 233
      Width = 348
      Height = 4
      Cursor = crVSplit
      Align = alBottom
      ExplicitTop = 285
    end
    object ModBusSendComMemo: TMemo
      Left = 1
      Top = 1
      Width = 348
      Height = 232
      Align = alClient
      ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object lstviewData: TListView
      Left = 1
      Top = 237
      Width = 348
      Height = 84
      Align = alBottom
      Columns = <
        item
          MaxWidth = 20
          MinWidth = 20
          Width = 20
        end
        item
          AutoSize = True
          Caption = 'Clipboard Data'
        end>
      HotTrack = True
      HotTrackStyles = [htHandPoint]
      ReadOnly = True
      RowSelect = True
      PopupMenu = popList
      TabOrder = 1
      ViewStyle = vsReport
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 384
    Top = 8
  end
  object MainMenu1: TMainMenu
    Left = 352
    Top = 8
    object File1: TMenuItem
      Caption = 'File'
      object SendFile1: TMenuItem
        Caption = 'Send File'
        OnClick = SendFile1Click
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object Close1: TMenuItem
        Caption = 'Close'
        OnClick = Close1Click
      end
    end
    object View1: TMenuItem
      Caption = 'View'
      object CurrentState1: TMenuItem
        Caption = 'Current State'
        OnClick = CurrentState1Click
      end
      object Flush1: TMenuItem
        Caption = 'Flush'
        OnClick = Flush1Click
      end
    end
    object N1: TMenuItem
      Caption = #49444#51221
      object N2: TMenuItem
        Caption = #54872#44221#49444#51221
        OnClick = N2Click
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object ResetState1: TMenuItem
        Caption = 'Reset'
        OnClick = ResetState1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object N4: TMenuItem
        Caption = #51333#47308
        OnClick = N4Click
      end
    end
    object About1: TMenuItem
      Caption = 'About'
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 416
    Top = 8
  end
  object DataFormatAdapterFile: TDataFormatAdapter
    DragDropComponent = DropTextTarget1
    DataFormatName = 'TFileDataFormat'
    Left = 476
    Top = 8
  end
  object DataFormatAdapterURL: TDataFormatAdapter
    DragDropComponent = DropTextTarget1
    DataFormatName = 'TURLDataFormat'
    Left = 516
    Top = 8
  end
  object DropTextTarget1: TDropTextTarget
    DragTypes = [dtCopy, dtLink]
    OnDrop = DropTextTarget1Drop
    Target = ModBusSendComMemo
    Left = 568
    Top = 8
  end
  object popList: TPopupMenu
    Left = 448
    Top = 8
    object mnuItemInfo: TMenuItem
      Caption = '&Data information'
      ImageIndex = 5
      OnClick = mnuItemInfoClick
    end
    object mnuItemSend: TMenuItem
      Caption = '&Send to Clipboard'
      ImageIndex = 6
      OnClick = mnuItemSendClick
    end
    object MenuItem1: TMenuItem
      Caption = '-'
    end
    object SendtoCOMPort1: TMenuItem
      Caption = 'Send to COM Port'
      OnClick = SendtoCOMPort1Click
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object mnuItemDelete: TMenuItem
      Caption = 'D&elete'
      ImageIndex = 7
      ShortCut = 46
      OnClick = mnuItemDeleteClick
    end
  end
end
