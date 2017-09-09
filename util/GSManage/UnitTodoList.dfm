object ToDoListF: TToDoListF
  Left = 0
  Top = 0
  Caption = 'To-Do List'
  ClientHeight = 337
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 635
    Height = 41
    Align = alTop
    TabOrder = 0
    object Button1: TButton
      Left = 16
      Top = 10
      Width = 81
      Height = 25
      Caption = #49352#47196' '#47564#46308#44592
      TabOrder = 0
      OnClick = Button1Click
    end
    object BitBtn1: TBitBtn
      Left = 504
      Top = 8
      Width = 97
      Height = 25
      Caption = #45803#44592
      Kind = bkClose
      NumGlyphs = 2
      TabOrder = 1
    end
    object Button3: TButton
      Left = 118
      Top = 10
      Width = 81
      Height = 25
      Caption = #49325#51228
      TabOrder = 2
      OnClick = Button3Click
    end
  end
  object TodoList1: TTodoList
    Left = 0
    Top = 41
    Width = 635
    Height = 296
    ActiveColumnColor = clWhite
    ActiveItemColor = clNone
    ActiveItemColorTo = clNone
    Align = alClient
    AutoAdvanceEdit = False
    AutoInsertItem = False
    AutoDeleteItem = False
    Color = clWindow
    Columns = <
      item
        Alignment = taLeftJustify
        Color = clWindow
        Editable = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ImageIndex = -1
        Tag = False
        TodoData = tdHandle
        Width = 32
        MaxLength = 0
      end
      item
        Alignment = taCenter
        Caption = 'HullNo'
        Color = clWindow
        Editable = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ImageIndex = -1
        Tag = False
        TodoData = tdProject
        Width = 100
        MaxLength = 0
      end
      item
        Alignment = taCenter
        Caption = #51228#47785
        Color = clWindow
        Editable = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ImageIndex = -1
        Tag = False
        TodoData = tdSubject
        Width = 200
        MaxLength = 0
      end
      item
        Alignment = taCenter
        Caption = #49884#51089#49884#44036
        Color = clWindow
        Editable = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ImageIndex = -1
        Tag = False
        TodoData = tdCreationDate
        Width = 100
        MaxLength = 0
      end
      item
        Alignment = taCenter
        Caption = #51333#47308#49884#44036
        Color = clWindow
        Editable = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ImageIndex = -1
        Tag = False
        TodoData = tdDueDate
        Width = 100
        MaxLength = 0
      end
      item
        Alignment = taCenter
        Caption = #48120#47532#50508#47548
        Color = clWindow
        Editable = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ImageIndex = -1
        Tag = False
        TodoData = tdCategory
        Width = 100
        MaxLength = 0
      end
      item
        Alignment = taCenter
        Caption = #50756#47308
        Color = clWindow
        Editable = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ImageIndex = -1
        Tag = False
        TodoData = tdComplete
        Width = 50
        MaxLength = 0
      end>
    CompleteCheck.CheckType = ctCheckBox
    CompletionFont.Charset = DEFAULT_CHARSET
    CompletionFont.Color = clGray
    CompletionFont.Height = -11
    CompletionFont.Name = 'Tahoma'
    CompletionFont.Style = [fsStrikeOut]
    DateFormat = 'yyyy/MM/dd hh:mm'
    DragCursor = crDrag
    DragMode = dmManual
    DragKind = dkDrag
    Editable = False
    EditColors.StringEditor.FontColor = clWindowText
    EditColors.StringEditor.BackColor = clWindow
    EditColors.MemoEditor.FontColor = clWindowText
    EditColors.MemoEditor.BackColor = clWindow
    EditColors.IntegerEditor.FontColor = clWindowText
    EditColors.IntegerEditor.BackColor = clWindow
    EditColors.PriorityEditor.FontColor = clWindowText
    EditColors.PriorityEditor.BackColor = clWindow
    EditColors.StatusEditor.FontColor = clWindowText
    EditColors.StatusEditor.BackColor = clWindow
    EditColors.DateEditor.BackColor = clWindow
    EditColors.DateEditor.FontColor = clWindowText
    EditSelectAll = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    GridLineColor = clSilver
    HeaderActiveColor = 9758459
    HeaderActiveColorTo = 1414638
    HeaderColor = 16572875
    HeaderColorTo = 14722429
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -11
    HeaderFont.Name = 'Tahoma'
    HeaderFont.Style = []
    HeaderHeight = 22
    ItemHeight = 22
    Items = <>
    NullDate = 'None'
    MultiSelect = False
    PopupMenu = PopupMenu1
    Preview = False
    PreviewFont.Charset = DEFAULT_CHARSET
    PreviewFont.Color = clBlack
    PreviewFont.Height = -11
    PreviewFont.Name = 'Tahoma'
    PreviewFont.Style = []
    PreviewColor = clNone
    PreviewColorTo = clNone
    PreviewHeight = 0
    PriorityFont.Charset = DEFAULT_CHARSET
    PriorityFont.Color = clRed
    PriorityFont.Height = -11
    PriorityFont.Name = 'Tahoma'
    PriorityFont.Style = []
    PriorityStrings.Lowest = 'Lowest'
    PriorityStrings.Low = 'Low'
    PriorityStrings.Normal = 'Normal'
    PriorityStrings.High = 'High'
    PriorityStrings.Highest = 'Highest'
    PriorityListWidth = -1
    ProgressLook.CompleteColor = clRed
    ProgressLook.CompleteFontColor = clBlue
    ProgressLook.UnCompleteColor = clNone
    ProgressLook.UnCompleteFontColor = clWindowText
    ProgressLook.Level0Color = clLime
    ProgressLook.Level0ColorTo = 14811105
    ProgressLook.Level1Color = clYellow
    ProgressLook.Level1ColorTo = 13303807
    ProgressLook.Level2Color = 5483007
    ProgressLook.Level2ColorTo = 11064319
    ProgressLook.Level3Color = clRed
    ProgressLook.Level3ColorTo = 13290239
    ProgressLook.Level1Perc = 70
    ProgressLook.Level2Perc = 90
    ProgressLook.BorderColor = clBlack
    ProgressLook.ShowBorder = False
    ProgressLook.Stacked = False
    ProgressLook.ShowPercentage = True
    ProgressLook.CompletionSmooth = True
    ProgressLook.ShowGradient = True
    ProgressLook.Steps = 11
    ScrollHorizontal = False
    SelectionColor = clHighlight
    SelectionColorTo = clNone
    SelectionFontColor = clHighlightText
    ShowPriorityText = True
    ShowSelection = True
    Sorted = False
    SortDirection = sdAscending
    SortColumn = 0
    StatusStrings.Deferred = 'Deferred'
    StatusStrings.NotStarted = 'Not started'
    StatusStrings.Completed = 'Completed'
    StatusStrings.InProgress = 'In progress'
    StatusListWidth = -1
    StretchLastColumn = True
    TabOrder = 2
    TabStop = False
    UseTab = False
    OnDblClick = TodoList1DblClick
    Version = '1.5.1.0'
    TotalTimeSuffix = 'h'
    ExplicitLeft = 56
    ExplicitTop = 80
    ExplicitWidth = 250
    ExplicitHeight = 200
  end
  object PopupMenu1: TPopupMenu
    Left = 16
    Top = 80
    object Edit1: TMenuItem
      Caption = 'Edit'
      OnClick = Edit1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object AddtoOutlookAppointment1: TMenuItem
      Caption = 'Add to Outlook Appointment'
      OnClick = AddtoOutlookAppointment1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object SetComplete1: TMenuItem
      Caption = 'Set Complete'
      OnClick = SetComplete1Click
    end
    object ResetComplete1: TMenuItem
      Caption = 'Reset Complete'
      OnClick = ResetComplete1Click
    end
  end
end
