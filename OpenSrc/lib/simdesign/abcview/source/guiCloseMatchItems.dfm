inherited CloseMatchFrame: TCloseMatchFrame
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 129
    Height = 18
    Caption = 'Similar Images'
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -16
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 8
    Top = 32
    Width = 537
    Height = 81
    AutoSize = False
    Caption = 
      'ABC-View Manager can detect similar images for you. This process' +
      ' is lengthy but can be accellerated by pre-calculating the image' +
      ' metrics (Options -> Browser -> Background Processes).'
    WordWrap = True
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 120
    Width = 545
    Height = 81
    Caption = 'Automatic Actions'
    TabOrder = 0
    object chbNotify: TCheckBox
      Left = 8
      Top = 24
      Width = 529
      Height = 17
      Caption = 'Notify me when the duplicates check is finished'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object chbSortOnDupes: TCheckBox
      Left = 8
      Top = 48
      Width = 529
      Height = 17
      Caption = 'Sort on Duplicate Group when finished'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 208
    Width = 545
    Height = 113
    Caption = 'Filter Settings'
    TabOrder = 1
    object Label30: TLabel
      Left = 8
      Top = 24
      Width = 51
      Height = 13
      Caption = 'Tolerance:'
    end
    object Label31: TLabel
      Left = 8
      Top = 72
      Width = 20
      Height = 13
      Caption = 'Low'
    end
    object Label32: TLabel
      Left = 72
      Top = 72
      Width = 22
      Height = 13
      Caption = 'High'
    end
    object lblTolVal: TLabel
      Left = 64
      Top = 24
      Width = 50
      Height = 13
      Caption = 'lblTolVal'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object chbMatchDims: TCheckBox
      Left = 200
      Top = 24
      Width = 201
      Height = 17
      Caption = 'Match Image Dimensions exactly'
      TabOrder = 0
    end
    object chbMatchAspect: TCheckBox
      Left = 200
      Top = 48
      Width = 201
      Height = 17
      Caption = 'Match Aspect Ratio'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object slTolerance: TRxSlider
      Left = 8
      Top = 40
      Width = 81
      Height = 32
      Increment = 1
      MaxValue = 7
      TabOrder = 2
      OnChange = slToleranceChange
    end
  end
  object chbDisplayDialog: TCheckBox
    Left = 8
    Top = 344
    Width = 201
    Height = 17
    Caption = 'Display this dialog upon filter startup'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
end
