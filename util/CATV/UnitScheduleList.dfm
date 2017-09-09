object ScheduleListF: TScheduleListF
  Left = 0
  Top = 0
  Caption = 'Task Scheduler'
  ClientHeight = 314
  ClientWidth = 470
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object taskListView: TListView
    Left = 0
    Top = 0
    Width = 470
    Height = 247
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Align = alClient
    Columns = <
      item
        AutoSize = True
        Caption = 'Task Name'
        MinWidth = 250
      end
      item
        AutoSize = True
        Caption = 'Last Run Time'
      end
      item
        AutoSize = True
        Caption = 'Next Run Time'
      end
      item
        AutoSize = True
        Caption = 'State'
      end>
    GridLines = True
    PopupMenu = PopupMenu1
    TabOrder = 0
    ViewStyle = vsReport
    OnSelectItem = taskListViewSelectItem
  end
  object DescriptionMemo: TMemo
    Left = 0
    Top = 247
    Width = 470
    Height = 67
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Align = alBottom
    ImeName = 'Microsoft IME 2010'
    TabOrder = 1
  end
  object PopupMenu1: TPopupMenu
    Left = 16
    Top = 56
    object CreateNewTask1: TMenuItem
      Caption = 'Create New Task'
      OnClick = CreateNewTask1Click
    end
  end
end
