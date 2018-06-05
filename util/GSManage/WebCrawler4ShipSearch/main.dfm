object MainForm: TMainForm
  Left = 276
  Top = 194
  Caption = 'Chromium Embedded'
  ClientHeight = 652
  ClientWidth = 864
  Color = clBtnFace
  TransparentColor = True
  TransparentColorValue = clFuchsia
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter: TSplitter
    Left = 0
    Top = 533
    Width = 864
    Height = 6
    Cursor = crVSplit
    Align = alBottom
    Visible = False
    ExplicitTop = 532
  end
  object crm: TChromium
    Left = 0
    Top = 25
    Width = 864
    Height = 508
    Align = alClient
    DefaultUrl = 'http://www.google.com'
    TabOrder = 0
    OnProcessMessageReceived = crmProcessMessageReceived
    OnLoadStart = crmLoadStart
    OnLoadEnd = crmLoadEnd
    OnBeforeContextMenu = crmBeforeContextMenu
    OnContextMenuCommand = crmContextMenuCommand
    OnAddressChange = crmAddressChange
    OnTitleChange = crmTitleChange
    OnStatusMessage = crmStatusMessage
    OnBeforeDownload = crmBeforeDownload
    OnDownloadUpdated = crmDownloadUpdated
    OnBeforePopup = crmBeforePopup
    OnBeforeResourceLoad = crmBeforeResourceLoad
    OnCertificateError = crmCertificateError
  end
  object DevTools: TChromiumDevTools
    Left = 0
    Top = 592
    Width = 864
    Height = 44
    Visible = False
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 633
    Width = 864
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Bevel = pbRaised
        Text = #52376#47532#44148#49688
        Width = 100
      end
      item
        Alignment = taCenter
        Width = 100
      end
      item
        Width = 50
      end
      item
        Width = 50
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 864
    Height = 25
    Align = alTop
    TabOrder = 2
    DesignSize = (
      864
      25)
    object SpeedButton1: TSpeedButton
      Left = 0
      Top = 0
      Width = 23
      Height = 22
      Action = actPrev
    end
    object SpeedButton2: TSpeedButton
      Left = 24
      Top = 0
      Width = 23
      Height = 22
      Action = actNext
    end
    object SpeedButton3: TSpeedButton
      Left = 48
      Top = 0
      Width = 23
      Height = 22
      Action = actHome
    end
    object SpeedButton4: TSpeedButton
      Left = 72
      Top = 0
      Width = 23
      Height = 22
      Action = actReload
    end
    object SpeedButton5: TSpeedButton
      Left = 841
      Top = 0
      Width = 23
      Height = 22
      Action = actGoTo
      Anchors = [akTop, akRight]
    end
    object edAddress: TEdit
      Left = 95
      Top = 0
      Width = 744
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ImeName = 'Microsoft IME 2010'
      TabOrder = 0
      Text = 'http://www.google.com'
      OnKeyPress = edAddressKeyPress
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 539
    Width = 864
    Height = 94
    Align = alBottom
    ImeName = 'Microsoft IME 2010'
    ScrollBars = ssVertical
    TabOrder = 4
  end
  object ActionList: TActionList
    Left = 624
    Top = 112
    object actPrev: TAction
      Caption = '<-'
      Enabled = False
      OnExecute = actPrevExecute
      OnUpdate = actPrevUpdate
    end
    object actNext: TAction
      Caption = '->'
      Enabled = False
      OnExecute = actNextExecute
      OnUpdate = actNextUpdate
    end
    object actHome: TAction
      Caption = 'H'
      OnExecute = actHomeExecute
      OnUpdate = actHomeUpdate
    end
    object actReload: TAction
      Caption = 'R'
      OnExecute = actReloadExecute
      OnUpdate = actReloadUpdate
    end
    object actGoTo: TAction
      Caption = '>'
      OnExecute = actGoToExecute
    end
    object actGetSource: TAction
      Caption = 'Get source'
      OnExecute = actGetSourceExecute
    end
    object actGetText: TAction
      Caption = 'Get text'
      OnExecute = actGetTextExecute
    end
    object actZoomIn: TAction
      Caption = 'Zoom in'
      OnExecute = actZoomInExecute
    end
    object actZoomOut: TAction
      Caption = 'Zoom out'
      OnExecute = actZoomOutExecute
    end
    object actZoomReset: TAction
      Caption = 'Zoom reset'
      OnExecute = actZoomResetExecute
    end
    object actExecuteJS: TAction
      Caption = 'Execute JavaScript'
      OnExecute = actExecuteJSExecute
    end
    object actDom: TAction
      Caption = 'Hook DOM'
      OnExecute = actDomExecute
    end
    object actDevTool: TAction
      AutoCheck = True
      Caption = 'Show DevTools'
      OnExecute = actDevToolExecute
    end
    object actDoc: TAction
      Caption = 'Documentation'
      OnExecute = actDocExecute
    end
    object actGroup: TAction
      Caption = 'Google group'
      OnExecute = actGroupExecute
    end
    object actFileScheme: TAction
      Caption = 'File Scheme'
      OnExecute = actFileSchemeExecute
    end
    object actPrint: TAction
      Caption = 'Print'
      OnExecute = actPrintExecute
    end
  end
  object MainMenu: TMainMenu
    Left = 624
    Top = 56
    object File1: TMenuItem
      Caption = '&File'
      object Print1: TMenuItem
        Action = actPrint
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        ShortCut = 16465
        OnClick = Exit1Click
      end
    end
    object est1: TMenuItem
      Caption = '&Test'
      object mGetsource: TMenuItem
        Action = actGetSource
      end
      object mGetText: TMenuItem
        Action = actGetText
      end
      object ExecuteJavaScript1: TMenuItem
        Action = actExecuteJS
      end
      object Zoomin1: TMenuItem
        Action = actZoomIn
      end
      object Zoomout1: TMenuItem
        Action = actZoomOut
      end
      object Zoomreset1: TMenuItem
        Action = actZoomReset
      end
      object actFileScheme1: TMenuItem
        Action = actFileScheme
      end
      object VisitDOM1: TMenuItem
        Action = actDom
      end
      object DevelopperTools1: TMenuItem
        Action = actDevTool
        AutoCheck = True
        ShortCut = 123
      end
    end
    object Hgs1: TMenuItem
      Caption = 'HGS'
      object GetVesselInfofromIMONo1: TMenuItem
        Caption = 'Get Vessel Info from VesselMaster'
        OnClick = GetVesselInfofromIMONo1Click
      end
      object GetVesselInfofromIMONo2: TMenuItem
        Caption = 'Get Vessel Info from IMO No.'
        OnClick = GetVesselInfofromIMONo2Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object GotoSeaweb1: TMenuItem
        Caption = 'Go to Sea web'
        OnClick = GotoSeaweb1Click
      end
      object GetVesselInfofromhtml1: TMenuItem
        Caption = 'Get Vessel Info from html'
        OnClick = GetVesselInfofromhtml1Click
      end
      object GetVesselInfoFromText1: TMenuItem
        Caption = 'Get Vessel Info From Text File(VesselList'#50640#49436' '#53580#49828#53944#54632')'
        Visible = False
      end
      object ShowHtmlSource1: TMenuItem
        Caption = 'Show Html Source'
        OnClick = ShowHtmlSource1Click
      end
      object ShowTextSource1: TMenuItem
        Caption = 'Show Text Source'
        OnClick = ShowTextSource1Click
      end
      object GetVesselInfofromhtmlwithMQ1: TMenuItem
        Caption = 'Get Vessel Info from html with MQ'
        OnClick = GetVesselInfofromhtmlwithMQ1Click
      end
      object DisplayMsgTest1: TMenuItem
        Caption = 'Url Enque Test'
        OnClick = DisplayMsgTest1Click
      end
      object UrlDequeueSignal1: TMenuItem
        Caption = 'Url Dequeue Signal Test'
        OnClick = UrlDequeueSignal1Click
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object Documentation1: TMenuItem
        Action = actDoc
      end
      object Googlegroup1: TMenuItem
        Action = actGroup
      end
    end
  end
  object SaveDialog: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 624
    Top = 176
  end
  object OpenDialog1: TOpenDialog
    Left = 624
    Top = 208
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = Timer1Timer
    Left = 32
    Top = 56
  end
end
