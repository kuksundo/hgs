object SammlungRepairForm: TSammlungRepairForm
  Left = 350
  Top = 311
  Caption = 'Repair Broken Links'
  ClientHeight = 416
  ClientWidth = 575
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  DesignSize = (
    575
    416)
  PixelsPerInch = 96
  TextHeight = 13
  object ObjectListLabel: TLabel
    Left = 8
    Top = 8
    Width = 59
    Height = 13
    Caption = '&Broken Links'
    FocusControl = ObjectListGrid
  end
  object Label2: TLabel
    Left = 224
    Top = 296
    Width = 31
    Height = 13
    Caption = 'Label2'
  end
  object OkButton: TBitBtn
    Left = 8
    Top = 384
    Width = 97
    Height = 25
    HelpContext = 908
    Anchors = [akLeft, akBottom]
    Caption = '&OK'
    TabOrder = 2
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 112
    Top = 384
    Width = 97
    Height = 25
    HelpContext = 909
    Anchors = [akLeft, akBottom]
    Caption = '&Cancel'
    TabOrder = 3
    Kind = bkCancel
  end
  object HelpButton: TBitBtn
    Left = 472
    Top = 384
    Width = 97
    Height = 25
    Hint = 'Open the help file'
    HelpContext = 35
    Anchors = [akRight, akBottom]
    Enabled = False
    TabOrder = 4
    Kind = bkHelp
  end
  object ObjectListGrid: TStringGrid
    Left = 8
    Top = 24
    Width = 561
    Height = 177
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 4
    DefaultColWidth = 100
    DefaultRowHeight = 18
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect, goThumbTracking]
    TabOrder = 0
    OnSelectCell = ObjectListGridSelectCell
  end
  object ProcedurePages: TPageControl
    Left = 8
    Top = 209
    Width = 561
    Height = 169
    ActivePage = ReplacePathSheet
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 1
    OnChanging = ProcedurePagesChanging
    object ReplacePathSheet: TTabSheet
      Caption = '&Replace Path'
      object SourcePathLabel: TLabel
        Left = 8
        Top = 8
        Width = 66
        Height = 13
        Caption = '&Previous Path'
        FocusControl = SourcePathEdit
      end
      object DestPathLabel: TLabel
        Left = 8
        Top = 56
        Width = 46
        Height = 13
        Caption = '&New Path'
        FocusControl = DestPathEdit
      end
      object SourcePathEdit: TEdit
        Left = 8
        Top = 24
        Width = 449
        Height = 21
        TabOrder = 0
      end
      object DestPathEdit: TEdit
        Left = 8
        Top = 72
        Width = 449
        Height = 21
        TabOrder = 2
      end
      object DestPathButton: TButton
        Left = 464
        Top = 72
        Width = 25
        Height = 21
        Caption = '...'
        TabOrder = 3
        OnClick = DestPathButtonClick
      end
      object ReplaceButton: TButton
        Left = 8
        Top = 104
        Width = 75
        Height = 25
        Caption = '&Replace'
        TabOrder = 4
        OnClick = ReplaceButtonClick
      end
      object TakeObjectButton: TButton
        Left = 464
        Top = 24
        Width = 81
        Height = 21
        Caption = 'From &List'
        TabOrder = 1
        OnClick = TakeObjectButtonClick
      end
    end
    object SearchSheet: TTabSheet
      Caption = '&Search'
      ImageIndex = 2
      DesignSize = (
        553
        141)
      object SearchProgressLabel: TLabel
        Left = 8
        Top = 95
        Width = 78
        Height = 13
        Caption = 'Search Progress'
        Visible = False
      end
      object SearchResultLabel: TLabel
        Left = 8
        Top = 114
        Width = 66
        Height = 13
        Caption = 'Search Result'
        Visible = False
      end
      object SearchPathEdit: TLabeledEdit
        Left = 8
        Top = 24
        Width = 505
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 49
        EditLabel.Height = 13
        EditLabel.Caption = 'Start &Path'
        TabOrder = 0
        OnChange = SearchPathEditChange
      end
      object SearchPathButton: TButton
        Left = 519
        Top = 24
        Width = 25
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 1
        OnClick = SearchPathButtonClick
      end
      object StartSearchButton: TButton
        Left = 8
        Top = 56
        Width = 75
        Height = 25
        Caption = '&Start'
        Enabled = False
        TabOrder = 2
        OnClick = StartSearchButtonClick
      end
      object StopSearchButton: TButton
        Left = 88
        Top = 56
        Width = 75
        Height = 25
        Caption = '&Stop'
        Enabled = False
        TabOrder = 3
        OnClick = StopSearchButtonClick
      end
    end
    object RemoveObjSheet: TTabSheet
      Caption = 'R&emove Items'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object RemoveObjLabel1: TLabel
        Left = 14
        Top = 13
        Width = 222
        Height = 13
        Caption = 'Removes the broken items from the collection.'
      end
      object RemoveObjLabel2: TLabel
        Left = 14
        Top = 32
        Width = 152
        Height = 13
        Caption = 'The image files are not deleted.'
      end
      object RemoveObjButton: TButton
        Left = 14
        Top = 64
        Width = 75
        Height = 25
        Caption = 'R&emove'
        TabOrder = 0
        OnClick = RemoveObjButtonClick
      end
    end
  end
  object DestPathDialog: TOpenPictureDialog
    Filter = 
      'All Files (*.png;*.jpg;*.jpeg;*.bmp;*.ico;*.emf;*.wmf)|*.png;*.j' +
      'pg;*.jpeg;*.bmp;*.ico;*.emf;*.wmf|Portable Network Graphics (*.p' +
      'ng)|*.png|JPEG Image (*.jpg)|*.jpg|JPEG Image (*.jpeg)|*.jpeg|Bi' +
      'tmaps (*.bmp)|*.bmp|Icons (*.ico)|*.ico|Enhanced Metafiles (*.em' +
      'f)|*.emf|Windows Metafiles (*.wmf)|*.wmf'
    Options = [ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Select a File From the Destination Folder'
    Left = 200
    Top = 8
  end
  object SearchPathDialog: TJvBrowseForFolderDialog
    Options = [odFileSystemDirectoryOnly, odStatusAvailable, odEditBox, odNewDialogStyle, odNoNewButtonFolder, odValidate]
    Title = 'Select Search Start'
    Left = 232
    Top = 8
  end
  object SearchProcessTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = SearchProcessTimerTimer
    Left = 264
    Top = 8
  end
end
