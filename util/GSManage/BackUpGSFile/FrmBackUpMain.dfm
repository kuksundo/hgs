object BackUpGSFile: TBackUpGSFile
  Left = 0
  Top = 0
  Caption = 'Back-Up GSFile'
  ClientHeight = 505
  ClientWidth = 619
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
    Top = 0
    Width = 619
    Height = 65
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 770
  end
  inline DOFrame: TDragOutlookFrame
    Left = 392
    Top = 368
    Width = 350
    Height = 98
    TabOrder = 1
    ExplicitLeft = 392
    ExplicitTop = 368
  end
  object fileGrid: TNextGrid
    Left = 0
    Top = 65
    Width = 619
    Height = 440
    Margins.Left = 40
    Margins.Top = 0
    Touch.InteractiveGestures = [igPan, igPressAndTap]
    Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
    Align = alClient
    Caption = ''
    Options = [goGrid, goHeader, goSelectFullRow]
    SelectionColor = 12615680
    TabOrder = 2
    TabStop = True
    ExplicitWidth = 770
    object NxIncrementColumn3: TNxIncrementColumn
      Alignment = taCenter
      DefaultWidth = 32
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      Header.Caption = 'No'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 0
      SortType = stAlphabetic
      Width = 32
    end
    object FilePath: TNxTextColumn
      DefaultWidth = 500
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Path'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 1
      SortType = stAlphabetic
      Width = 500
    end
    object Files: TNxButtonColumn
      Alignment = taCenter
      Header.Caption = 'Files'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Position = 2
      SortType = stAlphabetic
      OnButtonClick = FilesButtonClick
    end
    object FileSize: TNxTextColumn
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      Header.Caption = 'File Size'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 3
      SortType = stAlphabetic
      Visible = False
    end
    object DocType: TNxTextColumn
      Alignment = taCenter
      DefaultWidth = 120
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      Header.Caption = 'Item Type'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 4
      SortType = stAlphabetic
      Visible = False
      Width = 120
    end
  end
end
