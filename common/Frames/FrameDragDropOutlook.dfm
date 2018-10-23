object DragOutlookFrame: TDragOutlookFrame
  Left = 0
  Top = 0
  Width = 350
  Height = 98
  TabOrder = 0
  object DropEmptyTarget1: TDropEmptyTarget
    DragTypes = [dtCopy, dtLink]
    OnDrop = DropEmptyTarget1Drop
    Left = 20
    Top = 6
  end
  object DataFormatAdapterOutlook: TDataFormatAdapter
    DragDropComponent = DropEmptyTarget1
    DataFormatName = 'TOutlookDataFormat'
    Left = 52
    Top = 6
  end
  object DataFormatAdapterTarget: TDataFormatAdapter
    DragDropComponent = DropEmptyTarget1
    DataFormatName = 'TVirtualFileStreamDataFormat'
    Left = 88
    Top = 6
  end
  object DataFormatAdapter1: TDataFormatAdapter
    DragDropComponent = DropEmptyTarget1
    DataFormatName = 'TFileDataFormat'
    Left = 122
    Top = 6
  end
  object DropEmptySource1: TDropEmptySource
    DragTypes = [dtCopy, dtMove]
    Left = 20
    Top = 46
  end
  object DataFormatAdapter2: TDataFormatAdapter
    DragDropComponent = DropEmptySource1
    DataFormatName = 'TVirtualFileStreamDataFormat'
    Left = 52
    Top = 46
  end
end
