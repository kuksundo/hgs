object AddInModule: TAddInModule
  OldCreateOrder = True
  OnCreate = adxCOMAddInModuleCreate
  OnDestroy = adxCOMAddInModuleDestroy
  AddInName = 'Mail2IPCAddIn'
  Description = #49688#49888' '#47700#51068#51012' IPC'#47196' '#49569#48512#54632
  SupportedApps = [ohaOutlook]
  OnAddInInitialize = adxCOMAddInModuleAddInInitialize
  TaskPanes = <>
  Height = 400
  Width = 380
  object adxContextMenu1: TadxContextMenu
    CommandBarName = 'ItemContextMenu'
    SupportedApp = ohaOutlook
    OnBeforeAddControls = adxContextMenu1BeforeAddControls
    Left = 48
    Top = 24
    ButtonTypes = {020000000400000004000000}
    Buttons = <
      item
        Caption = 'DPMS'
        OfficeTag = '{8E13A718-16E8-4667-8888-31E3B319F76A}'
        olExplorerItemTypes = [adxOLAppointmentItem]
        olInspectorItemTypes = [adxOLAppointment]
        Temporary = True
        PropertyChanged = 2
        ButtonTypes = {050000000000000000000000000000000000000000000000}
        Buttons = <
          item
            Caption = 'Add To DPMS To-Do List'
            OfficeTag = '{E6A0D626-028E-45F9-A07C-EC036307CCE8}'
            olExplorerItemTypes = [adxOLMailItem]
            olInspectorItemTypes = [adxOLMail]
            Temporary = True
            OnClick = adxContextMenu1Controls0Controls0Click
            PropertyChanged = 1
          end
          item
            Caption = 'Show IPCClient Connect Count'
            OfficeTag = '{EBCEB152-A6DF-4D8C-B3E9-C1C5274FACDD}'
            olExplorerItemTypes = [adxOLMailItem]
            olInspectorItemTypes = [adxOLMail]
            Temporary = True
            OnClick = adxContextMenu1Controls0Controls1Click
            PropertyChanged = 1
          end
          item
            Caption = 'Show EntryIdList(no send) Count'
            OfficeTag = '{E6A32370-C9DD-4F28-BCEC-78A119F7392B}'
            olExplorerItemTypes = [adxOLMailItem]
            olInspectorItemTypes = [adxOLMail]
            Temporary = True
            OnClick = adxContextMenu1Controls0Controls2Click
            PropertyChanged = 2
          end
          item
            Caption = 'Show EntryID and StoreID'
            OfficeTag = '{A69F62DB-3882-42A9-BE5F-0717FE1B787C}'
            olExplorerItemTypes = [adxOLMailItem]
            olInspectorItemTypes = [adxOLMail]
            Temporary = True
            OnClick = adxContextMenu1Controls0Controls3Click
            PropertyChanged = 1
          end
          item
            Caption = 'Show Mail Contents'
            OfficeTag = '{1518F9CC-5523-44D0-947A-55F0B42C8810}'
            olExplorerItemTypes = [adxOLMailItem]
            olInspectorItemTypes = [adxOLMail]
            Temporary = True
            OnClick = adxContextMenu1Controls0Controls4Click
            PropertyChanged = 1
          end>
      end
      item
        Caption = 'Send Mail 2 IPC'
        OfficeTag = '{29A59CC1-EEF9-4C8C-81C6-19E5B5AE2DD2}'
        olExplorerItemTypes = [adxOLMailItem]
        olInspectorItemTypes = [adxOLMail]
        Temporary = True
        PropertyChanged = 1
        ButtonTypes = {0400000000000000050000000000000000000000}
        Buttons = <
          item
            Caption = 'Send Mail To IPC'
            OfficeTag = '{90391A77-F69B-4FB8-A8D4-B22ABA2E9EAE}'
            olExplorerItemTypes = [adxOLMailItem]
            olInspectorItemTypes = [adxOLMail]
            Temporary = True
            OnClick = adxContextMenu1Controls1Controls0Click
            PropertyChanged = 7
          end
          item
            Caption = '-'
            OfficeTag = '{4D2F999B-F161-4A0E-9DC0-B3A70AA2F146}'
            olExplorerItemTypes = [adxOLMailItem]
            olInspectorItemTypes = [adxOLMail]
            Temporary = True
            PropertyChanged = 5
          end
          item
            Caption = 'Set Auto Send'
            OfficeTag = '{93DA8329-74E7-44A9-AA31-7799D40A949F}'
            olExplorerItemTypes = [adxOLMailItem]
            olInspectorItemTypes = [adxOLMail]
            Temporary = True
            OnClick = adxContextMenu1Controls1Controls2Click
            PropertyChanged = 6
          end
          item
            Caption = 'Reset Auto Send'
            OfficeTag = '{B7CFA5C6-9CBE-41AC-AEBB-6F84319397CC}'
            olExplorerItemTypes = [adxOLMailItem]
            olInspectorItemTypes = [adxOLMail]
            Temporary = True
            OnClick = adxContextMenu1Controls1Controls3Click
            PropertyChanged = 6
          end>
      end>
    PropertyChanged = 0
  end
  object adxOutlookAppEvents1: TadxOutlookAppEvents
    OnNewMailEx = adxOutlookAppEvents1NewMailEx
    Left = 144
    Top = 24
  end
  object AdvAlertWindow1: TAdvAlertWindow
    AlertMessages = <>
    AlwaysOnTop = False
    AutoHide = True
    AutoSize = False
    AutoDelete = False
    BorderColor = 9841920
    BtnHoverColor = 14483455
    BtnHoverColorTo = 6013175
    BtnDownColor = 557032
    BtnDownColorTo = 8182519
    CaptionColor = 14059353
    CaptionColorTo = 9841920
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    GradientDirection = gdVertical
    HintNextBtn = 'Next'
    HintPrevBtn = 'Previous'
    HintCloseBtn = 'Close'
    HintDeleteBtn = 'Delete'
    HintPopupBtn = 'Popup'
    Hover = False
    MarginX = 4
    MarginY = 1
    PopupLeft = 0
    PopupTop = 0
    PopupWidth = 300
    PopupHeight = 100
    PositionFormat = '%d of %d'
    WindowColor = 16440004
    WindowColorTo = 16105376
    ShowScrollers = False
    ShowDelete = True
    ShowPopup = False
    AlphaEnd = 180
    AlphaStart = 0
    DisplayTime = 5000
    FadeStep = 2
    WindowPosition = wpRightBottom
    Version = '1.8.3.0'
    Left = 40
    Top = 88
  end
  object adxContextMenu2: TadxContextMenu
    CommandBarName = 'FolderContextMenu'
    SupportedApp = ohaOutlook
    Left = 96
    Top = 24
    ButtonTypes = {0100000004000000}
    Buttons = <
      item
        Caption = 'HGS Task'
        OfficeTag = '{4B5B7534-3DEE-4A6A-A6EF-26C1D81A72DA}'
        olExplorerItemTypes = [adxOLMailItem]
        olInspectorItemTypes = [adxOLMail]
        Temporary = True
        PropertyChanged = 1
        ButtonTypes = {03000000000000000000000000000000}
        Buttons = <
          item
            Caption = 'Send Folder Name 2 IPC'
            OfficeTag = '{09FEB9C8-5F68-4220-97FA-A1627BC30404}'
            olExplorerItemTypes = [adxOLMailItem]
            olInspectorItemTypes = [adxOLMail]
            Temporary = True
            OnClick = adxContextMenu2Controls0Click
            PropertyChanged = 1
          end
          item
            Caption = '-'
            OfficeTag = '{0FEF1D0D-B6E9-4D96-9978-A25F96E18146}'
            olExplorerItemTypes = [adxOLMailItem]
            olInspectorItemTypes = [adxOLMail]
            Temporary = True
            PropertyChanged = 1
          end
          item
            Caption = 'Show StoreID'
            OfficeTag = '{D6786D8C-2C12-4397-A19F-682A3FC2E0E0}'
            olExplorerItemTypes = [adxOLMailItem]
            olInspectorItemTypes = [adxOLMail]
            Temporary = True
            OnClick = adxContextMenu2Controls0Controls2Click
            PropertyChanged = 1
          end>
      end>
    PropertyChanged = 1
  end
end
