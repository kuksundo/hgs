inherited PidlFrame: TPidlFrame
  object pcPidl: TPageControl
    Left = 8
    Top = 8
    Width = 545
    Height = 361
    ActivePage = tsOptions
    TabOrder = 0
    object tsOptions: TTabSheet
      Caption = '&Options'
      object chbShowSubItems: TCheckBox
        Left = 8
        Top = 16
        Width = 297
        Height = 17
        Caption = 'Show items in subfolders even when expanded'
        TabOrder = 0
      end
    end
    object tsProperties: TTabSheet
      Caption = '&Properties'
      ImageIndex = 1
    end
  end
end
