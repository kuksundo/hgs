object QRCodeFrame: TQRCodeFrame
  Left = 0
  Top = 0
  Width = 479
  Height = 461
  TabOrder = 0
  object splTop: TSplitter
    Left = 0
    Top = 155
    Width = 479
    Height = 5
    Cursor = crVSplit
    Align = alBottom
    AutoSnap = False
    Beveled = True
    ExplicitTop = 119
    ExplicitWidth = 555
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 479
    Height = 155
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 8
    FullRepaint = False
    ParentColor = True
    TabOrder = 0
    object lblText: TLabel
      Left = 8
      Top = 8
      Width = 463
      Height = 13
      Align = alTop
      Caption = '&Text'
      FocusControl = mmoText
      Transparent = True
      ExplicitWidth = 22
    end
    object mmoText: TMemo
      Left = 8
      Top = 21
      Width = 463
      Height = 126
      Align = alClient
      ScrollBars = ssVertical
      TabOrder = 0
      OnChange = mmoTextChange
    end
  end
  object pnlDetails: TPanel
    Left = 0
    Top = 160
    Width = 479
    Height = 301
    Align = alBottom
    BevelOuter = bvNone
    FullRepaint = False
    ParentColor = True
    TabOrder = 1
    object lblEncoding: TLabel
      Left = 8
      Top = 5
      Width = 43
      Height = 13
      Caption = '&Encoding'
      FocusControl = cmbEncoding
      Transparent = True
    end
    object lblQuietZone: TLabel
      Left = 8
      Top = 49
      Width = 52
      Height = 13
      Caption = '&Quiet zone'
      FocusControl = edtQuietZone
      Transparent = True
    end
    object lblErrorCorrectionLevel: TLabel
      Left = 128
      Top = 49
      Width = 100
      Height = 13
      Caption = 'Error &correction level'
      FocusControl = cbbErrorCorrectionLevel
      Transparent = True
    end
    object lblCorner: TLabel
      Left = 8
      Top = 150
      Width = 137
      Height = 13
      Caption = 'Corner &line thickness (pixels)'
      FocusControl = edtCornerThickness
      Transparent = True
    end
    object lblDrawingMode: TLabel
      Left = 8
      Top = 97
      Width = 68
      Height = 13
      Caption = '&Drawing mode'
      FocusControl = cbbDrawingMode
      Transparent = True
    end
    object cmbEncoding: TComboBox
      Left = 8
      Top = 24
      Width = 225
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 1
      Text = 'Auto'
      OnChange = cmbEncodingChange
      OnDrawItem = cmbEncodingDrawItem
      OnMeasureItem = cmbEncodingMeasureItem
      Items.Strings = (
        'Auto'
        'Numeric'
        'Alphanumeric'
        'ISO-8859-1'
        'UTF-8 without BOM'
        'UTF-8 with BOM'
        'URL encoding'
        'Windows-1251')
    end
    object edtQuietZone: TEdit
      Left = 8
      Top = 68
      Width = 73
      Height = 21
      TabOrder = 2
      Text = '4'
      OnChange = edtQuietZoneChange
    end
    object cbbErrorCorrectionLevel: TComboBox
      Left = 103
      Top = 68
      Width = 130
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 4
      Text = 'L ~7% correction'
      OnChange = cbbErrorCorrectionLevelChange
      Items.Strings = (
        'L ~7% correction'
        'M ~15% correction'
        'Q ~25% correction'
        'H ~30% correction')
    end
    object edtCornerThickness: TEdit
      Left = 168
      Top = 146
      Width = 49
      Height = 21
      TabOrder = 6
      Text = '0'
      OnChange = edtCornerThicknessChange
    end
    object udCornerThickness: TUpDown
      Left = 217
      Top = 146
      Width = 16
      Height = 21
      Associate = edtCornerThickness
      TabOrder = 7
    end
    object udQuietZone: TUpDown
      Left = 81
      Top = 68
      Width = 16
      Height = 21
      Associate = edtQuietZone
      Position = 4
      TabOrder = 3
    end
    object grpSaveToFile: TGroupBox
      Left = 8
      Top = 174
      Width = 225
      Height = 121
      Caption = '&Save / Copy'
      TabOrder = 8
      object lblScaleToSave: TLabel
        Left = 8
        Top = 24
        Width = 76
        Height = 13
        Caption = 'Dot size (pixels)'
        FocusControl = edtScaleToSave
        Transparent = True
      end
      object edtFileName: TEdit
        Left = 5
        Top = 57
        Width = 169
        Height = 21
        ReadOnly = True
        TabOrder = 2
      end
      object btnSaveToFile: TButton
        Left = 174
        Top = 57
        Width = 51
        Height = 21
        Caption = 'Save...'
        TabOrder = 3
        OnClick = btnSaveToFileClick
      end
      object edtScaleToSave: TEdit
        Left = 112
        Top = 20
        Width = 49
        Height = 21
        TabOrder = 0
        Text = '10'
      end
      object udScaleToSave: TUpDown
        Left = 161
        Top = 20
        Width = 16
        Height = 21
        Associate = edtScaleToSave
        Min = 1
        Position = 10
        TabOrder = 1
      end
      object btnCopy: TButton
        Left = 8
        Top = 93
        Width = 217
        Height = 25
        Caption = 'C&opy Bitmap to Clipboard'
        TabOrder = 4
        OnClick = btnCopyClick
      end
    end
    object cbbDrawingMode: TComboBox
      Left = 8
      Top = 116
      Width = 225
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 5
      Text = 'Bitmap proportional'
      OnChange = cbbDrawingModeChange
      Items.Strings = (
        'Bitmap proportional'
        'Bitmap non-proportional'
        'Vector: rectangles proportional'
        'Vector: rectangles non-proportional'
        'Vector: region proportional'
        'Vector: region non-proportional')
    end
    object pgcQRDetails: TPageControl
      Left = 239
      Top = 6
      Width = 233
      Height = 289
      ActivePage = tsPreview
      TabOrder = 0
      object tsPreview: TTabSheet
        Caption = '&Preview'
        object pbPreview: TPaintBox
          Left = 0
          Top = 0
          Width = 225
          Height = 187
          Align = alClient
          OnPaint = pbPreviewPaint
        end
        object lblQRMetrics: TLabel
          Left = 0
          Top = 187
          Width = 225
          Height = 13
          Align = alBottom
          Alignment = taCenter
          Caption = 'QR Metrics'
          Transparent = True
          ExplicitWidth = 52
        end
        object pnlColors: TPanel
          Left = 0
          Top = 200
          Width = 225
          Height = 61
          Align = alBottom
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          object bvlColors: TBevel
            Left = 0
            Top = 0
            Width = 225
            Height = 9
            Align = alTop
            Shape = bsBottomLine
          end
          object lblBackground: TLabel
            Left = 8
            Top = 16
            Width = 56
            Height = 13
            Caption = '&Background'
          end
          object lblForeground: TLabel
            Left = 8
            Top = 40
            Width = 56
            Height = 13
            Caption = '&Foreground'
          end
          object clrbxBackground: TColorBox
            Left = 70
            Top = 12
            Width = 121
            Height = 22
            Selected = clWhite
            Color = clWhite
            TabOrder = 0
            OnChange = clrbxBackgroundChange
          end
          object clrbxForeground: TColorBox
            Left = 70
            Top = 37
            Width = 121
            Height = 22
            TabOrder = 1
            OnChange = clrbxForegroundChange
          end
        end
      end
      object tsEncodedData: TTabSheet
        Caption = 'E&ncoded Data'
        ImageIndex = 1
        object mmoEncodedData: TMemo
          Left = 0
          Top = 0
          Width = 225
          Height = 261
          Align = alClient
          BorderStyle = bsNone
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
          OnChange = mmoEncodedDataChange
        end
      end
    end
  end
  object dlgSaveToFile: TSaveDialog
    Filter = 
      'Bitmap (*.bmp)|*.bmp|Png(*.png)|*.png|Metfile (*.emf)|*.emf|JPEG' +
      ' (*.jpeg; *.jpg)|*.jpeg;*.jpg'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing, ofDontAddToRecent]
    Left = 328
    Top = 288
  end
end
