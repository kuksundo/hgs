inherited StandardFrame: TStandardFrame
  object pcFilter: TPageControl
    Left = 8
    Top = 8
    Width = 545
    Height = 361
    ActivePage = tsByType
    TabOrder = 0
    object tsByType: TTabSheet
      Caption = 'By &Type'
      ImageIndex = 8
      object GroupBox8: TGroupBox
        Left = 8
        Top = 8
        Width = 521
        Height = 193
        Caption = 'File Type'
        TabOrder = 0
        object Label10: TLabel
          Left = 256
          Top = 24
          Width = 60
          Height = 13
          Caption = 'files that are:'
        end
        object Label11: TLabel
          Left = 8
          Top = 176
          Width = 317
          Height = 13
          Caption = 
            'Type extensions starting with a dot; separate them with a semico' +
            'lon'
        end
        object chFilterFileType: TCheckBox
          Left = 16
          Top = 24
          Width = 113
          Height = 17
          Caption = 'Filter by File Type:'
          TabOrder = 0
        end
        object cbbAllowFileType: TComboBox
          Left = 136
          Top = 22
          Width = 113
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 1
          Items.Strings = (
            'Allow'
            'Deny')
        end
        object chFileTypeImages: TCheckBox
          Left = 32
          Top = 56
          Width = 105
          Height = 17
          Caption = 'Image Files'
          TabOrder = 2
          OnClick = chFileTypeImagesClick
        end
        object edFileTypeImages: TEdit
          Left = 136
          Top = 54
          Width = 297
          Height = 21
          TabOrder = 3
        end
        object btnFileTypeImages: TButton
          Left = 440
          Top = 52
          Width = 57
          Height = 25
          Caption = 'Default'
          TabOrder = 4
          OnClick = btnFileTypeImagesClick
        end
        object chFileTypeAudio: TCheckBox
          Left = 32
          Top = 88
          Width = 105
          Height = 17
          Caption = 'Audio Files'
          TabOrder = 5
          OnClick = chFileTypeAudioClick
        end
        object edFileTypeAudio: TEdit
          Left = 136
          Top = 86
          Width = 297
          Height = 21
          TabOrder = 6
        end
        object btnFileTypeAudio: TButton
          Left = 440
          Top = 84
          Width = 57
          Height = 25
          Caption = 'Default'
          TabOrder = 7
          OnClick = btnFileTypeAudioClick
        end
        object chFileTypeVideo: TCheckBox
          Left = 32
          Top = 120
          Width = 105
          Height = 17
          Caption = 'Video Files'
          TabOrder = 8
          OnClick = chFileTypeVideoClick
        end
        object edFileTypeVideo: TEdit
          Left = 136
          Top = 118
          Width = 297
          Height = 21
          TabOrder = 9
        end
        object btnFileTypeVideo: TButton
          Left = 440
          Top = 116
          Width = 57
          Height = 25
          Caption = 'Default'
          TabOrder = 10
          OnClick = btnFileTypeVideoClick
        end
        object chFileTypeCustom: TCheckBox
          Left = 32
          Top = 152
          Width = 105
          Height = 17
          Caption = 'Custom:'
          TabOrder = 11
          OnClick = chFileTypeCustomClick
        end
        object edFileTypeCustom: TEdit
          Left = 136
          Top = 150
          Width = 297
          Height = 21
          TabOrder = 12
        end
        object btnFileTypeCustom: TButton
          Left = 440
          Top = 148
          Width = 57
          Height = 25
          Caption = 'Default'
          TabOrder = 13
          OnClick = btnFileTypeCustomClick
        end
      end
      object GroupBox9: TGroupBox
        Left = 8
        Top = 208
        Width = 521
        Height = 113
        Caption = 'File Mask'
        TabOrder = 1
        object Label12: TLabel
          Left = 256
          Top = 24
          Width = 116
          Height = 13
          Caption = 'files that have this mask:'
        end
        object Label13: TLabel
          Left = 8
          Top = 96
          Width = 395
          Height = 13
          Caption = 
            'You can use wildcards (*, ?) or # for numbers, separate each mas' +
            'k with a semicolon'
        end
        object chFilterFileMask: TCheckBox
          Left = 16
          Top = 24
          Width = 113
          Height = 17
          Caption = 'Filter by File Mask:'
          TabOrder = 0
        end
        object cbbAllowFileMask: TComboBox
          Left = 136
          Top = 22
          Width = 113
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 1
          Items.Strings = (
            'Allow'
            'Deny')
        end
        object cbbFilterFileMask: TComboBox
          Left = 32
          Top = 56
          Width = 401
          Height = 21
          ItemHeight = 13
          TabOrder = 2
          Text = 'dscf####.jpg'
        end
      end
    end
    object tsBySize: TTabSheet
      Caption = 'By &Size'
      ImageIndex = 4
      object Label6: TLabel
        Left = 8
        Top = 312
        Width = 464
        Height = 13
        Caption = 
          'Hint: you can type in "K" or "KB", "M" or "MB" or "G" or "GB" to' +
          ' specify Kilo-, Mega- or Gigabytes'
      end
      object GroupBox1: TGroupBox
        Left = 8
        Top = 8
        Width = 521
        Height = 145
        Caption = 'File Size'
        TabOrder = 0
        object Label1: TLabel
          Left = 256
          Top = 24
          Width = 60
          Height = 13
          Caption = 'files that are:'
        end
        object Label2: TLabel
          Left = 272
          Top = 106
          Width = 18
          Height = 13
          Alignment = taCenter
          Caption = 'and'
        end
        object chFilterFileSize: TCheckBox
          Left = 16
          Top = 24
          Width = 113
          Height = 17
          Caption = 'Filter by File Size:'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object cbbAllowFileSize: TComboBox
          Left = 136
          Top = 22
          Width = 113
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 1
          Items.Strings = (
            'Allow'
            'Deny')
        end
        object rbFileSizeBigger: TRadioButton
          Left = 48
          Top = 56
          Width = 121
          Height = 17
          Caption = 'bigger than:'
          TabOrder = 2
        end
        object rbFileSizeInbetween: TRadioButton
          Left = 48
          Top = 104
          Width = 121
          Height = 17
          Caption = 'inbetween'
          Checked = True
          TabOrder = 3
          TabStop = True
        end
        object cbbFileSizeBigger: TComboBox
          Left = 176
          Top = 56
          Width = 81
          Height = 21
          ItemHeight = 13
          TabOrder = 4
          Text = '100K'
          Items.Strings = (
            '10K'
            '20K'
            '50K'
            '100K'
            '200K'
            '500K'
            '1M'
            '2M'
            '5M'
            '10M')
        end
        object cbbFileSizeLower: TComboBox
          Left = 176
          Top = 104
          Width = 81
          Height = 21
          ItemHeight = 13
          TabOrder = 5
          Text = '10K'
          Items.Strings = (
            '10K'
            '20K'
            '50K'
            '100K'
            '200K'
            '500K'
            '1M'
            '2M'
            '5M'
            '10M')
        end
        object cbbFileSizeUpper: TComboBox
          Left = 304
          Top = 104
          Width = 81
          Height = 21
          ItemHeight = 13
          TabOrder = 6
          Text = '200K'
          Items.Strings = (
            '10K'
            '20K'
            '50K'
            '100K'
            '200K'
            '500K'
            '1M'
            '2M'
            '5M'
            '10M')
        end
        object rbFileSizeSmaller: TRadioButton
          Left = 48
          Top = 80
          Width = 121
          Height = 17
          Caption = 'smaller than:'
          TabOrder = 7
        end
        object cbbFileSizeSmaller: TComboBox
          Left = 176
          Top = 80
          Width = 81
          Height = 21
          ItemHeight = 13
          TabOrder = 8
          Text = '100K'
          Items.Strings = (
            '10K'
            '20K'
            '50K'
            '100K'
            '200K'
            '500K'
            '1M'
            '2M'
            '5M'
            '10M')
        end
      end
      object GroupBox2: TGroupBox
        Left = 8
        Top = 160
        Width = 521
        Height = 137
        Caption = 'Folder Total Size'
        TabOrder = 1
        object Label4: TLabel
          Left = 256
          Top = 24
          Width = 127
          Height = 13
          Caption = 'folders that contain in total:'
        end
        object Label5: TLabel
          Left = 272
          Top = 106
          Width = 18
          Height = 13
          Alignment = taCenter
          Caption = 'and'
        end
        object chFilterFolderSize: TCheckBox
          Left = 16
          Top = 24
          Width = 113
          Height = 17
          Caption = 'Filter by Folder Size:'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object cbbAllowFolderSize: TComboBox
          Left = 136
          Top = 22
          Width = 113
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 1
          Items.Strings = (
            'Allow'
            'Deny')
        end
        object rbFolderSizeBigger: TRadioButton
          Left = 48
          Top = 56
          Width = 121
          Height = 17
          Caption = 'more than:'
          TabOrder = 2
        end
        object rbFolderSizeInbetween: TRadioButton
          Left = 48
          Top = 104
          Width = 121
          Height = 17
          Caption = 'inbetween'
          Checked = True
          TabOrder = 3
          TabStop = True
        end
        object cbbFolderSizeBigger: TComboBox
          Left = 176
          Top = 56
          Width = 81
          Height = 21
          ItemHeight = 13
          TabOrder = 4
          Text = '100K'
          Items.Strings = (
            '10K'
            '20K'
            '50K'
            '100K'
            '200K'
            '500K'
            '1M'
            '2M'
            '5M'
            '10M')
        end
        object cbbFolderSizeLower: TComboBox
          Left = 176
          Top = 104
          Width = 81
          Height = 21
          ItemHeight = 13
          TabOrder = 5
          Text = '10K'
          Items.Strings = (
            '10K'
            '20K'
            '50K'
            '100K'
            '200K'
            '500K'
            '1M'
            '2M'
            '5M'
            '10M')
        end
        object cbbFolderSizeUpper: TComboBox
          Left = 304
          Top = 104
          Width = 81
          Height = 21
          ItemHeight = 13
          TabOrder = 6
          Text = '200K'
          Items.Strings = (
            '10K'
            '20K'
            '50K'
            '100K'
            '200K'
            '500K'
            '1M'
            '2M'
            '5M'
            '10M')
        end
        object rbFolderSizeSmaller: TRadioButton
          Left = 48
          Top = 80
          Width = 121
          Height = 17
          Caption = 'less than:'
          TabOrder = 7
        end
        object cbbFolderSizeSmaller: TComboBox
          Left = 176
          Top = 80
          Width = 81
          Height = 21
          ItemHeight = 13
          TabOrder = 8
          Text = '100K'
          Items.Strings = (
            '10K'
            '20K'
            '50K'
            '100K'
            '200K'
            '500K'
            '1M'
            '2M'
            '5M'
            '10M')
        end
      end
    end
    object tsByDate: TTabSheet
      Caption = 'By &Date'
      ImageIndex = 7
      object GroupBox7: TGroupBox
        Left = 8
        Top = 8
        Width = 521
        Height = 177
        Caption = 'File Date'
        TabOrder = 0
        object Label8: TLabel
          Left = 256
          Top = 24
          Width = 60
          Height = 13
          Caption = 'files that are:'
        end
        object Label9: TLabel
          Left = 288
          Top = 106
          Width = 18
          Height = 13
          Alignment = taCenter
          Caption = 'and'
        end
        object chFilterFileDate: TCheckBox
          Left = 16
          Top = 24
          Width = 113
          Height = 17
          Caption = 'Filter by File Date:'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object cbbAllowFileDate: TComboBox
          Left = 136
          Top = 22
          Width = 113
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 1
          Items.Strings = (
            'Allow'
            'Deny')
        end
        object rbFileDateAfter: TRadioButton
          Left = 48
          Top = 56
          Width = 121
          Height = 17
          Caption = 'from after:'
          TabOrder = 2
        end
        object rbFileDateBetween: TRadioButton
          Left = 48
          Top = 104
          Width = 121
          Height = 17
          Caption = 'from between'
          TabOrder = 3
        end
        object rbFileDateBefore: TRadioButton
          Left = 48
          Top = 80
          Width = 121
          Height = 17
          Caption = 'from before:'
          TabOrder = 4
        end
        object deFileDateAfter: TDateEdit
          Left = 176
          Top = 56
          Width = 97
          Height = 21
          NumGlyphs = 2
          YearDigits = dyFour
          TabOrder = 5
        end
        object deFileDateBefore: TDateEdit
          Left = 176
          Top = 80
          Width = 97
          Height = 21
          NumGlyphs = 2
          YearDigits = dyFour
          TabOrder = 6
        end
        object deFileDateLower: TDateEdit
          Left = 176
          Top = 104
          Width = 97
          Height = 21
          NumGlyphs = 2
          YearDigits = dyFour
          TabOrder = 7
        end
        object deFileDateUpper: TDateEdit
          Left = 320
          Top = 104
          Width = 97
          Height = 21
          NumGlyphs = 2
          YearDigits = dyFour
          TabOrder = 8
        end
        object seFileDateLast: TRxSpinEdit
          Left = 176
          Top = 136
          Width = 65
          Height = 21
          MaxValue = 1000.000000000000000000
          Value = 5.000000000000000000
          TabOrder = 9
        end
        object rbFileDateLast: TRadioButton
          Left = 48
          Top = 136
          Width = 121
          Height = 17
          Caption = 'from the last'
          TabOrder = 10
        end
        object cbbFileDateLast: TComboBox
          Left = 248
          Top = 136
          Width = 89
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 11
          Items.Strings = (
            'minutes'
            'hours'
            'days'
            'weeks'
            'months'
            'years')
        end
      end
    end
    object tsImage: TTabSheet
      Caption = 'By &Image'
      ImageIndex = 9
      object GroupBox10: TGroupBox
        Left = 8
        Top = 8
        Width = 521
        Height = 153
        Caption = 'Image Properties'
        TabOrder = 0
        object Label14: TLabel
          Left = 280
          Top = 24
          Width = 69
          Height = 13
          Caption = 'files that have:'
        end
        object Label15: TLabel
          Left = 280
          Top = 84
          Width = 64
          Height = 13
          Caption = 'Square Pixels'
        end
        object lbSquarePixels: TLabel
          Left = 352
          Top = 84
          Width = 48
          Height = 13
          Caption = '(lbSquare)'
        end
        object Label16: TLabel
          Left = 360
          Top = 116
          Width = 51
          Height = 13
          Caption = 'bytes/pixel'
        end
        object chFilterImage: TCheckBox
          Left = 16
          Top = 24
          Width = 161
          Height = 17
          Caption = 'Filter by Image properties:'
          TabOrder = 0
        end
        object cbbAllowImage: TComboBox
          Left = 160
          Top = 22
          Width = 113
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 1
          Items.Strings = (
            'Allow'
            'Deny')
        end
        object rbImageSquare: TRadioButton
          Left = 32
          Top = 56
          Width = 121
          Height = 17
          Caption = 'Image Square Area'
          TabOrder = 2
        end
        object cbbImageSquare: TComboBox
          Left = 160
          Top = 56
          Width = 113
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 3
          Items.Strings = (
            'Exceeding'
            'Exactly equal to'
            'Smaller than')
        end
        object cbbSquarePixels: TComboBox
          Left = 160
          Top = 80
          Width = 113
          Height = 21
          ItemHeight = 13
          TabOrder = 4
          Text = '640x480'
          OnChange = cbbSquarePixelsChange
          Items.Strings = (
            '320x200'
            '600x400'
            '640x480'
            '800x600'
            '1024x768')
        end
        object rbImageCompress: TRadioButton
          Left = 32
          Top = 112
          Width = 121
          Height = 17
          Caption = 'Compression Factor'
          TabOrder = 5
        end
        object cbbImageCompress: TComboBox
          Left = 160
          Top = 112
          Width = 113
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 6
          Items.Strings = (
            'Larger than'
            'Smaller than')
        end
        object seCompression: TRxSpinEdit
          Left = 288
          Top = 112
          Width = 65
          Height = 21
          Increment = 0.020000000000000000
          MaxValue = 100.000000000000000000
          ValueType = vtFloat
          Value = 0.300000000000000000
          TabOrder = 7
        end
      end
    end
  end
end
