object OptionsForm: TOptionsForm
  Left = 349
  Top = 111
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'OptionsForm'
  ClientHeight = 499
  ClientWidth = 565
  Color = clBtnFace
  DefaultMonitor = dmMainForm
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    565
    499)
  PixelsPerInch = 96
  TextHeight = 13
  object LParams: TTntLabel
    Left = 6
    Top = 425
    Width = 55
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Parameters'
  end
  object LHelp: TTntLabel
    Left = 537
    Top = 425
    Width = 21
    Height = 13
    Cursor = crHandPoint
    Alignment = taRightJustify
    Anchors = [akRight, akBottom]
    Caption = 'Help'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = LHelpClick
  end
  object BOK: TTntButton
    Left = 9
    Top = 469
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'OK'
    TabOrder = 0
    OnClick = BOKClick
  end
  object BApply: TTntButton
    Left = 163
    Top = 469
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Apply'
    TabOrder = 1
    OnClick = BApplyClick
  end
  object BSave: TTntButton
    Left = 322
    Top = 469
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Save'
    TabOrder = 2
    OnClick = BSaveClick
  end
  object BClose: TTntButton
    Left = 482
    Top = 469
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Close'
    TabOrder = 4
    OnClick = BCloseClick
  end
  object EParams: TTntEdit
    Left = 6
    Top = 441
    Width = 555
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 3
  end
  object Tab: TTntPageControl
    Left = 5
    Top = 6
    Width = 555
    Height = 417
    ActivePage = TOther
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 5
    OnChange = TabChange
    object TSystem: TTntTabSheet
      Caption = 'System'
      DesignSize = (
        547
        389)
      object LLanguage: TTntLabel
        Left = 8
        Top = 9
        Width = 47
        Height = 13
        Caption = 'Language'
      end
      object TseekL: TTntLabel
        Left = 319
        Top = 298
        Width = 25
        Height = 13
        Caption = 'Jump'
      end
      object TUnit: TTntLabel
        Left = 464
        Top = 298
        Width = 66
        Height = 13
        Caption = 'seconds/Seek'
      end
      object CLanguage: TTntComboBox
        Left = 120
        Top = 5
        Width = 177
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 13
        TabOrder = 0
        Items.Strings = (
          ''
          ''
          '')
      end
      object CRFScr: TTntCheckBox
        Left = 12
        Top = 56
        Width = 261
        Height = 17
        Caption = 'Click MBR to FullScreen'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
      end
      object nfconf: TTntCheckBox
        Left = 12
        Top = 32
        Width = 253
        Height = 17
        Caption = 'Use nofontconfig option'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
      end
      object EMplayerLocation: TTntEdit
        Left = 192
        Top = 344
        Width = 322
        Height = 21
        Anchors = [akLeft, akRight, akBottom]
        TabOrder = 2
      end
      object BMplayer: TTntButton
        Left = 515
        Top = 344
        Width = 28
        Height = 21
        Anchors = [akRight, akBottom]
        Caption = '...'
        TabOrder = 3
        OnClick = BMplayerClick
      end
      object CWid: TTntCheckBox
        Left = 283
        Top = 370
        Width = 330
        Height = 17
        Anchors = [akLeft, akRight, akBottom]
        Caption = 'Use WID'
        TabOrder = 5
      end
      object CNi: TTntCheckBox
        Left = 12
        Top = 104
        Width = 261
        Height = 17
        Caption = 'Use non-interleaved AVI parser'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 15
      end
      object CDnav: TTntCheckBox
        Left = 318
        Top = 152
        Width = 229
        Height = 17
        Anchors = [akTop, akRight]
        Caption = 'Use DVDNav'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 16
      end
      object CLavf: TTntCheckBox
        Left = 12
        Top = 80
        Width = 261
        Height = 17
        Caption = 'Use lavf Demuxer'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 17
      end
      object RCMplayer: TTntRadioButton
        Left = 4
        Top = 370
        Width = 269
        Height = 17
        Anchors = [akLeft, akBottom]
        Caption = 'Current Directory'
        TabOrder = 9
        OnClick = RCMplayerClick
      end
      object RMplayer: TTntRadioButton
        Left = 4
        Top = 347
        Width = 181
        Height = 17
        Anchors = [akLeft, akBottom]
        Caption = 'Mplayer location'
        TabOrder = 10
        OnClick = RMplayerClick
      end
      object CFd: TTntCheckBox
        Left = 318
        Top = 32
        Width = 229
        Height = 17
        Anchors = [akTop, akRight]
        Caption = 'Framedrop'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 11
      end
      object CAsync: TTntCheckBox
        Left = 318
        Top = 104
        Width = 173
        Height = 17
        Anchors = [akTop, akRight]
        Caption = 'Autosync'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 12
        OnClick = CAsyncClick
      end
      object EAsync: TTntEdit
        Left = 495
        Top = 102
        Width = 34
        Height = 21
        Anchors = [akTop, akRight]
        TabOrder = 13
        Text = '100'
      end
      object UAsync: TTntUpDown
        Left = 529
        Top = 102
        Width = 17
        Height = 21
        Anchors = [akTop, akRight]
        Associate = EAsync
        Min = 1
        Max = 1000
        Position = 100
        TabOrder = 14
        Thousands = False
      end
      object CCache: TTntCheckBox
        Left = 318
        Top = 128
        Width = 173
        Height = 17
        Anchors = [akTop, akRight]
        Caption = 'Cache'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
        OnClick = CCacheClick
      end
      object ECache: TTntEdit
        Left = 495
        Top = 126
        Width = 34
        Height = 21
        Anchors = [akTop, akRight]
        TabOrder = 7
        Text = '512'
      end
      object UCache: TTntUpDown
        Left = 529
        Top = 126
        Width = 17
        Height = 21
        Anchors = [akTop, akRight]
        Associate = ECache
        Min = 1
        Max = 10000
        Position = 512
        TabOrder = 8
        Thousands = False
      end
      object CPriorityBoost: TTntCheckBox
        Left = 318
        Top = 80
        Width = 229
        Height = 17
        Anchors = [akTop, akRight]
        Caption = 'Priority boost'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 18
      end
      object CISub: TTntCheckBox
        Left = 12
        Top = 272
        Width = 290
        Height = 17
        Caption = 'Include Subtitles on Screenshot'
        ParentShowHint = False
        ShowHint = False
        TabOrder = 19
      end
      object SSF: TTntStaticText
        Left = 8
        Top = 325
        Width = 92
        Height = 17
        Anchors = [akLeft, akBottom]
        Caption = 'ScreenShot Folder'
        TabOrder = 20
      end
      object BSsf: TTntButton
        Left = 515
        Top = 319
        Width = 28
        Height = 21
        Anchors = [akRight, akBottom]
        Caption = '...'
        TabOrder = 21
        OnClick = BSsfClick
      end
      object ESsf: TTntEdit
        Left = 192
        Top = 320
        Width = 322
        Height = 21
        Anchors = [akLeft, akRight, akBottom]
        TabOrder = 22
      end
      object Cone: TTntCheckBox
        Left = 12
        Top = 152
        Width = 261
        Height = 17
        Caption = 'Use only one instance of MPUI'
        ParentShowHint = False
        ShowHint = False
        TabOrder = 23
      end
      object CGUI: TTntCheckBox
        Left = 318
        Top = 200
        Width = 229
        Height = 17
        Anchors = [akTop, akRight]
        Caption = 'No GUI of Mplayer'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 24
      end
      object CNobps: TTntCheckBox
        Left = 12
        Top = 128
        Width = 261
        Height = 17
        Caption = 'Don'#39't use avg b/s for A-V sync'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 25
      end
      object CFilter: TTntCheckBox
        Left = 318
        Top = 224
        Width = 229
        Height = 17
        Anchors = [akTop, akRight]
        Caption = 'Filter DropFiles'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 26
      end
      object CRS: TTntCheckBox
        Left = 12
        Top = 176
        Width = 290
        Height = 17
        Caption = 'Start MPUI with last size'
        ParentShowHint = False
        ShowHint = False
        TabOrder = 27
      end
      object CSP: TTntCheckBox
        Left = 318
        Top = 56
        Width = 229
        Height = 17
        Anchors = [akTop, akRight]
        Caption = 'Click video to pause'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 28
      end
      object CTime: TTntCheckBox
        Left = 12
        Top = 224
        Width = 229
        Height = 17
        Anchors = [akTop, akRight]
        Caption = 'Display OS Time in status bar'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 32
      end
      object CRP: TTntCheckBox
        Left = 12
        Top = 200
        Width = 290
        Height = 17
        Caption = 'Start MPUI with last postion'
        ParentShowHint = False
        ShowHint = False
        TabOrder = 30
      end
      object CDs: TTntCheckBox
        Left = 318
        Top = 176
        Width = 229
        Height = 17
        Anchors = [akTop, akRight]
        Caption = 'Show logo when play audio'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 31
      end
      object Eseek: TTntEdit
        Left = 408
        Top = 294
        Width = 49
        Height = 21
        TabOrder = 29
      end
      object nmsgm: TTntCheckBox
        Left = 318
        Top = 8
        Width = 229
        Height = 17
        Anchors = [akTop, akRight]
        Caption = 'Use nomsgmodule option'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 33
      end
      object CAddsfiles: TTntCheckBox
        Left = 12
        Top = 248
        Width = 290
        Height = 17
        Caption = 'Add sequence files'
        ParentShowHint = False
        ShowHint = False
        TabOrder = 34
      end
      object CLS: TTntCheckBox
        Left = 318
        Top = 248
        Width = 229
        Height = 17
        Caption = 'Popup Download Lyric/Subtitle dialog'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 35
      end
      object EAV: TTntEdit
        Left = 495
        Top = 270
        Width = 34
        Height = 21
        Anchors = [akTop, akRight]
        TabOrder = 36
        Text = '1'
      end
      object UDAV: TTntUpDown
        Left = 529
        Top = 270
        Width = 15
        Height = 21
        Anchors = [akTop, akRight]
        Associate = EAV
        Min = 1
        Max = 8
        Position = 1
        TabOrder = 37
        Thousands = False
      end
      object CAV: TTntCheckBox
        Left = 318
        Top = 272
        Width = 173
        Height = 17
        Anchors = [akTop, akRight]
        Caption = 'libavcodec decoding threads'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 38
        OnClick = CAVClick
      end
      object ads: TTntCheckBox
        Left = 12
        Top = 296
        Width = 290
        Height = 17
        Caption = 'Auto download subtitle as playing a video'
        ParentShowHint = False
        ShowHint = False
        TabOrder = 39
      end
    end
    object TVideo: TTntTabSheet
      Caption = 'Video'
      ImageIndex = 1
      DesignSize = (
        547
        389)
      object LPostproc: TTntLabel
        Left = 10
        Top = 104
        Width = 72
        Height = 13
        Caption = 'Postprocessing'
      end
      object LAspect: TTntLabel
        Left = 10
        Top = 32
        Width = 58
        Height = 13
        Caption = 'Aspect ratio'
      end
      object LDeinterlace: TTntLabel
        Left = 10
        Top = 80
        Width = 54
        Height = 13
        Caption = 'Deinterlace'
      end
      object LMAspect: TTntLabel
        Left = 10
        Top = 56
        Width = 97
        Height = 13
        Caption = 'Monitor Aspect ratio'
      end
      object LVideoout: TTntLabel
        Left = 10
        Top = 8
        Width = 61
        Height = 13
        Caption = 'Video output'
      end
      object CIndex: TTntCheckBox
        Left = 8
        Top = 130
        Width = 305
        Height = 17
        Caption = 'Re-Index file if needed'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
      end
      object CYuy2: TTntCheckBox
        Left = 368
        Top = 174
        Width = 179
        Height = 17
        Anchors = [akTop, akRight]
        Caption = 'Use YUY2 colorspace'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
      end
      object CPostproc: TTntComboBox
        Left = 256
        Top = 100
        Width = 288
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 0
        TabOrder = 8
      end
      object CAspect: TTntComboBox
        Left = 256
        Top = 28
        Width = 288
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 0
        TabOrder = 1
      end
      object CDeinterlace: TTntComboBox
        Left = 256
        Top = 76
        Width = 288
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 0
        TabOrder = 2
      end
      object CDr: TTntCheckBox
        Left = 368
        Top = 152
        Width = 179
        Height = 17
        Anchors = [akTop, akRight]
        Caption = 'Direct rendering'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
      end
      object CMAspect: TComboBox
        Tag = -1
        Left = 256
        Top = 52
        Width = 288
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 0
        TabOrder = 4
      end
      object double: TTntCheckBox
        Left = 8
        Top = 152
        Width = 307
        Height = 17
        Caption = 'Double buffer'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
      end
      object CFlip: TTntCheckBox
        Left = 8
        Top = 196
        Width = 305
        Height = 17
        Caption = 'Flip Video'
        TabOrder = 3
      end
      object CEq2: TTntCheckBox
        Left = 8
        Top = 174
        Width = 305
        Height = 17
        Caption = 'Use Software video Equalizer'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
      end
      object CMir: TTntCheckBox
        Left = 368
        Top = 196
        Width = 179
        Height = 17
        Anchors = [akTop, akRight]
        Caption = 'Mirror Video'
        TabOrder = 10
      end
      object LRot: TTntStaticText
        Left = 356
        Top = 220
        Width = 37
        Height = 17
        Alignment = taCenter
        Anchors = [akTop, akRight]
        BevelInner = bvNone
        BevelOuter = bvNone
        Caption = 'Rotate'
        TabOrder = 12
      end
      object CVSync: TTntCheckBox
        Left = 368
        Top = 130
        Width = 179
        Height = 17
        Anchors = [akTop, akRight]
        Caption = 'VSync'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 13
      end
      object CRot: TComboBox
        Left = 485
        Top = 216
        Width = 54
        Height = 21
        Style = csDropDownList
        Anchors = [akTop, akRight]
        ItemHeight = 13
        TabOrder = 11
        Items.Strings = (
          '0'
          '90'
          '-90')
      end
      object CVideoOut: TComboBox
        Tag = -1
        Left = 256
        Top = 4
        Width = 288
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 13
        TabOrder = 14
        OnChange = CDDXAClick
        Items.Strings = (
          'novideo'
          'null'
          'Auto'
          'directx'
          'directx:noaccel'
          'direct3d'
          'gl'
          'gl:nomanyfmts'
          'gl:yuv=2:force-pbo'
          'gl:yuv=2:force-pbo:ati-hack'
          'gl:yuv=3'
          'gl2'
          'gl2:yuv=3'
          'matrixview')
      end
    end
    object TAudio: TTntTabSheet
      Caption = 'Audio'
      ImageIndex = 2
      DesignSize = (
        547
        389)
      object LAudioOut: TTntLabel
        Left = 10
        Top = 8
        Width = 62
        Height = 13
        Caption = 'Audio output'
      end
      object LAudioDev: TTntLabel
        Left = 10
        Top = 32
        Width = 61
        Height = 13
        Caption = 'Audio device'
      end
      object LCh: TTntStaticText
        Left = 354
        Top = 84
        Width = 65
        Height = 17
        Alignment = taRightJustify
        Anchors = [akTop, akRight]
        BevelInner = bvNone
        Caption = 'Stereo Mode'
        TabOrder = 9
      end
      object CAudioOut: TTntComboBox
        Left = 256
        Top = 4
        Width = 288
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 13
        TabOrder = 4
        OnChange = CAudioOutChange
        Items.Strings = (
          'don'#39't decode'
          'dont'#39'play'
          'Auto'
          'Win32'
          'DirectSound')
      end
      object CVolnorm: TTntCheckBox
        Left = 355
        Top = 58
        Width = 184
        Height = 17
        Anchors = [akTop, akRight]
        Caption = 'CVolnorm'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
      end
      object CAudioDev: TComboBox
        Left = 256
        Top = 28
        Width = 288
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 0
        TabOrder = 1
      end
      object CSPDIF: TTntCheckBox
        Left = 12
        Top = 82
        Width = 245
        Height = 17
        Caption = 'Passthrough S/PDIF'
        TabOrder = 3
      end
      object CCh: TComboBox
        Left = 493
        Top = 80
        Width = 51
        Height = 21
        Style = csDropDownList
        Anchors = [akTop, akRight]
        ItemHeight = 13
        TabOrder = 5
        Items.Strings = (
          '2'
          '4'
          '5.1'
          '7.1')
      end
      object CSoftVol: TTntCheckBox
        Left = 12
        Top = 58
        Width = 245
        Height = 17
        Caption = 'Software volume control'
        TabOrder = 2
      end
      object EWadsp: TTntEdit
        Left = 176
        Top = 362
        Width = 338
        Height = 21
        Anchors = [akLeft, akRight, akBottom]
        TabOrder = 6
      end
      object BWadsp: TTntButton
        Left = 515
        Top = 362
        Width = 28
        Height = 21
        Anchors = [akRight, akBottom]
        Caption = '...'
        TabOrder = 7
        OnClick = BWadspClick
      end
      object CWadsp: TTntCheckBox
        Left = 4
        Top = 340
        Width = 546
        Height = 17
        Anchors = [akLeft, akRight, akBottom]
        Caption = 'Use Winamp DSP plugin'
        ParentShowHint = False
        ShowHint = False
        TabOrder = 8
        OnClick = CWadspClick
      end
      object TLyric: TTntGroupBox
        Left = 1
        Top = 224
        Width = 544
        Height = 108
        Anchors = [akLeft, akRight, akBottom]
        Caption = 'Lyric'
        TabOrder = 10
        DesignSize = (
          544
          108)
        object LTCL: TTntLabel
          Left = 46
          Top = 49
          Width = 48
          Height = 13
          Alignment = taRightJustify
          Anchors = [akLeft, akBottom]
          Caption = 'Text color'
        end
        object LHCL: TTntLabel
          Left = 226
          Top = 49
          Width = 39
          Height = 13
          Alignment = taRightJustify
          Anchors = [akLeft, akBottom]
          Caption = 'Hg color'
        end
        object LBCL: TTntLabel
          Left = 399
          Top = 49
          Width = 38
          Height = 13
          Alignment = taRightJustify
          Anchors = [akLeft, akBottom]
          Caption = 'bg color'
        end
        object SLyric: TTntLabel
          Left = 8
          Top = 82
          Width = 55
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = 'Lyric Folder'
        end
        object PLTC: TPanel
          Left = 120
          Top = 44
          Width = 36
          Height = 25
          Cursor = crHandPoint
          Anchors = [akLeft, akBottom]
          BevelInner = bvRaised
          BevelOuter = bvLowered
          BorderWidth = 1
          Color = clWindowText
          ParentBackground = False
          TabOrder = 0
          OnClick = SetColor
        end
        object PLBC: TPanel
          Left = 484
          Top = 44
          Width = 36
          Height = 25
          Cursor = crHandPoint
          Anchors = [akRight, akBottom]
          BevelInner = bvRaised
          BevelOuter = bvLowered
          BorderWidth = 1
          Color = clWindow
          ParentBackground = False
          TabOrder = 3
          OnClick = SetColor
        end
        object PLHC: TPanel
          Left = 286
          Top = 44
          Width = 36
          Height = 25
          Cursor = crHandPoint
          Anchors = [akLeft, akBottom]
          BevelInner = bvRaised
          BevelOuter = bvLowered
          BorderWidth = 1
          Color = clRed
          ParentBackground = False
          TabOrder = 1
          OnClick = SetColor
        end
        object ELyric: TTntEdit
          Left = 176
          Top = 78
          Width = 334
          Height = 21
          Anchors = [akLeft, akRight, akBottom]
          TabOrder = 2
        end
        object BLyric: TTntButton
          Tag = 1
          Left = 511
          Top = 78
          Width = 28
          Height = 21
          Anchors = [akRight, akBottom]
          Caption = '...'
          TabOrder = 4
          OnClick = BSsfClick
        end
        object Ldlod: TTntCheckBox
          Left = 8
          Top = 18
          Width = 368
          Height = 17
          Anchors = [akLeft, akRight, akBottom]
          Caption = 'Display lyric on desktop'
          ParentShowHint = False
          ShowHint = False
          TabOrder = 5
        end
        object BFont: TButton
          Left = 378
          Top = 13
          Width = 161
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = 'font'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = 0
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 6
          OnClick = BFontClick
        end
      end
      object Cconfig: TTntCheckBox
        Left = 4
        Top = 364
        Width = 168
        Height = 17
        Anchors = [akLeft, akRight, akBottom]
        Caption = 'Show config window while play'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 11
      end
    end
    object TSub: TTntTabSheet
      Caption = 'Subtitle'
      ImageIndex = 5
      DesignSize = (
        547
        389)
      object BSubfont: TTntButton
        Left = 514
        Top = 32
        Width = 28
        Height = 22
        Anchors = [akTop, akRight]
        Caption = '...'
        ParentShowHint = False
        ShowHint = False
        TabOrder = 0
        OnClick = BSubfontClick
      end
      object CUni: TTntCheckBox
        Left = 313
        Top = 246
        Width = 236
        Height = 17
        Anchors = [akRight, akBottom]
        Caption = 'unicode'
        ParentShowHint = False
        ShowHint = False
        TabOrder = 2
      end
      object CUtf: TTntCheckBox
        Left = 4
        Top = 246
        Width = 241
        Height = 17
        Anchors = [akLeft, akBottom]
        Caption = 'utf8'
        ParentShowHint = False
        ShowHint = False
        TabOrder = 3
      end
      object SSubcode: TTntStaticText
        Left = 4
        Top = 10
        Width = 86
        Height = 17
        Caption = 'Subtitle encoding'
        TabOrder = 7
      end
      object SSubfont: TTntStaticText
        Left = 4
        Top = 36
        Width = 65
        Height = 17
        Caption = 'Subtitle Font'
        TabOrder = 8
      end
      object SFsize: TTntStaticText
        Left = 4
        Top = 323
        Width = 57
        Height = 17
        Anchors = [akLeft, akBottom]
        Caption = 'Sufont size'
        TabOrder = 9
      end
      object SFB: TTntStaticText
        Left = 4
        Top = 345
        Width = 77
        Height = 17
        Anchors = [akLeft, akBottom]
        Caption = 'font blur radius'
        TabOrder = 10
      end
      object SFol: TTntStaticText
        Left = 4
        Top = 367
        Width = 106
        Height = 17
        Anchors = [akLeft, akBottom]
        Caption = 'font outline thickness'
        TabOrder = 11
      end
      object BOsdfont: TButton
        Left = 514
        Top = 60
        Width = 28
        Height = 22
        Anchors = [akTop, akRight]
        Caption = '...'
        ParentShowHint = False
        ShowHint = False
        TabOrder = 15
        OnClick = BOsdfontClick
      end
      object SFontColor: TTntStaticText
        Left = 4
        Top = 296
        Width = 52
        Height = 17
        Anchors = [akLeft, akBottom]
        Caption = 'Text color'
        TabOrder = 16
      end
      object SOutline: TTntStaticText
        Left = 282
        Top = 296
        Width = 64
        Height = 17
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'Outline color'
        TabOrder = 17
      end
      object PTc: TPanel
        Left = 133
        Top = 291
        Width = 60
        Height = 25
        Cursor = crHandPoint
        Anchors = [akLeft, akBottom]
        BevelInner = bvRaised
        BevelOuter = bvLowered
        BorderWidth = 1
        Color = clYellow
        ParentBackground = False
        TabOrder = 18
        OnClick = SetColor
      end
      object POc: TPanel
        Left = 431
        Top = 291
        Width = 60
        Height = 25
        Cursor = crHandPoint
        Anchors = [akRight, akBottom]
        BevelInner = bvRaised
        BevelOuter = bvLowered
        BorderWidth = 1
        Color = clBlack
        ParentBackground = False
        TabOrder = 19
        OnClick = SetColor
      end
      object CAss: TTntCheckBox
        Left = 4
        Top = 270
        Width = 245
        Height = 17
        Anchors = [akLeft, akBottom]
        Caption = 'Use libass for SubRender'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 20
        OnClick = CAssClick
      end
      object CEfont: TTntCheckBox
        Left = 313
        Top = 270
        Width = 236
        Height = 17
        Anchors = [akRight, akBottom]
        Caption = 'Use embedded fonts'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 21
      end
      object SOsdfont: TTntCheckBox
        Left = 4
        Top = 64
        Width = 229
        Height = 17
        Caption = 'OSD font'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 22
        OnClick = SOsdfontClick
      end
      object CSubcp: TComboBox
        Tag = -1
        Left = 240
        Top = 6
        Width = 302
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 13
        TabOrder = 1
        Items.Strings = (
          'GBK'
          'CP936 (SimChinese)'
          'GB18030'
          'BIG5 (TraChinese)'
          'BIG5-HKSCS'
          'HZ'
          ''
          'ISO-2022-CN'
          'ISO-2022-CN-EXT'
          'EUC-CN'
          'EUC-TW'
          ''
          'ISO-2022-KR'
          'EUC-KR'
          ''
          'ASCII'
          'UNICODE'
          'UTF-8'
          'UTF-7'
          'UTF-16'
          'UTF-16BE'
          'UTF-16LE'
          'UTF-32'
          'UTF-32BE'
          'UTF-32LE'
          'C99'
          'JAVA'
          'UCS-2'
          'UCS-2BE'
          'UCS-2LE'
          'UCS-4'
          'UCS-4BE'
          'UCS-4LE'
          ''
          'ISO-8859-1 (Western European)'
          'CP1252'
          'MacRoman'
          'MacIceland'
          'ISO-8859-15 (Western European with Euro)'
          ''
          'ISO-8859-2 (Slavic/Central European)'
          'CP1250 (Slavic/Central European Windows)'
          'MacCentrlEurope'
          'MacCroatian'
          'MacRomania'
          ''
          'ISO-8859-5 (Cyrillic)'
          'CP1251 (Cyrillic Windows)'
          'MacCyrillic'
          'MacUkraine'
          'KOI8-R (Russian)'
          'KOI8-U (Ukrainian)'
          'KOI8-RU (Belarusian)'
          ''
          'ISO-8859-6 (Arabic)'
          'CP1256'
          'MacArabic'
          ''
          'ISO-8859-7 (Modern Greek)'
          'CP1253'
          'MacGreek'
          ''
          'ISO-8859-8 (Hebrew)'
          'CP1255'
          'MacHebrew'
          ''
          'ISO-8859-9 (Turkish)'
          'CP1254'
          'MacTurkish'
          ''
          'ISO-8859-13 (Baltic)'
          'CP1257'
          ''
          'Macintosh'
          ''
          'ISO-2022-JP'
          'ISO-2022-JP-1'
          'ISO-2022-JP-2'
          'EUC-JP'
          'SHIFT_JIS (Japanese)'
          ''
          'MacThai'
          'KOI8-T'
          ''
          'ISO-8859-3 (Esperanto,Galician,Maltese,Turkish)'
          'ISO-8859-4 (Old Baltic)'
          'ISO-8859-10'
          'ISO-8859-14 (Celtic)'
          'ISO-8859-16'
          ''
          'CP850'
          'CP862'
          'CP866'
          'CP874 (Thai)'
          'CP932'
          'CP949 (Korean)'
          'CP950'
          'CP1133'
          'CP1258'
          ''
          'JOHAB'
          'ARMSCII-8'
          'Georgian-Academy'
          'Georgian-PS'
          'TIS-620'
          'MuleLao-1'
          'VISCII'
          'TCVN'
          'HPROMAN8'
          'NEXTSTEP')
      end
      object TFsize: TTrackBar
        Left = 232
        Top = 321
        Width = 281
        Height = 20
        Anchors = [akLeft, akRight, akBottom]
        Max = 100
        Min = 1
        Position = 45
        TabOrder = 4
        ThumbLength = 15
        TickMarks = tmBoth
        TickStyle = tsNone
        OnChange = TFsizeChange
      end
      object TFB: TTrackBar
        Left = 232
        Top = 343
        Width = 281
        Height = 20
        Anchors = [akLeft, akRight, akBottom]
        Max = 80
        Min = 1
        Position = 20
        TabOrder = 6
        ThumbLength = 15
        TickMarks = tmBoth
        TickStyle = tsNone
        OnChange = TFBChange
      end
      object TFol: TTrackBar
        Left = 232
        Top = 365
        Width = 281
        Height = 20
        Anchors = [akLeft, akRight, akBottom]
        Max = 80
        Min = 1
        Position = 20
        TabOrder = 5
        ThumbLength = 15
        TickMarks = tmBoth
        TickStyle = tsNone
        OnChange = TFolChange
      end
      object SFsP: TTntStaticText
        Left = 512
        Top = 323
        Width = 31
        Height = 17
        Anchors = [akRight, akBottom]
        Caption = '4.5%'
        TabOrder = 12
      end
      object SFBl: TTntStaticText
        Left = 512
        Top = 344
        Width = 20
        Height = 17
        Anchors = [akRight, akBottom]
        Caption = '2.0'
        TabOrder = 13
      end
      object SFo: TTntStaticText
        Left = 512
        Top = 366
        Width = 20
        Height = 17
        Anchors = [akRight, akBottom]
        Caption = '2.0'
        TabOrder = 14
      end
      object CSubfont: TTntComboBox
        Left = 240
        Top = 32
        Width = 274
        Height = 21
        Style = csOwnerDrawVariable
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemHeight = 15
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 24
        OnChange = CSubfontChange
        OnDrawItem = CSubfontDrawItem
        OnDropDown = CSubfontDropDown
        OnMeasureItem = CSubfontMeasureItem
      end
      object Esubfont: TTntEdit
        Left = 240
        Top = 32
        Width = 256
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 23
        OnChange = FontChange
      end
      object Cosdfont: TTntComboBox
        Left = 240
        Top = 60
        Width = 274
        Height = 21
        Style = csOwnerDrawVariable
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemHeight = 15
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 25
        OnChange = CSubfontChange
        OnDrawItem = CosdfontDrawItem
        OnDropDown = CSubfontDropDown
        OnMeasureItem = CosdfontMeasureItem
      end
      object Eosdfont: TTntEdit
        Left = 240
        Top = 60
        Width = 256
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 26
        OnChange = FontChange
      end
    end
    object TOther: TTntTabSheet
      Caption = 'Other'
      DesignSize = (
        547
        389)
      object TFass: TCheckListBox
        Left = 4
        Top = 4
        Width = 161
        Height = 259
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemHeight = 16
        ParentFont = False
        TabOrder = 0
      end
      object TFadd: TTntButton
        Left = 3
        Top = 327
        Width = 75
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'Add'
        TabOrder = 1
        OnClick = TFaddClick
      end
      object TEAss: TTntEdit
        Left = 4
        Top = 299
        Width = 163
        Height = 21
        Anchors = [akLeft, akBottom]
        TabOrder = 2
      end
      object TFSet: TTntButton
        Left = 3
        Top = 359
        Width = 164
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'Associate'
        TabOrder = 3
        OnClick = TFSetClick
      end
      object TFdel: TTntButton
        Left = 91
        Top = 327
        Width = 75
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'delete'
        TabOrder = 4
        OnClick = TFdelClick
      end
      object TBa: TTntButton
        Left = 3
        Top = 269
        Width = 75
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'Select All'
        TabOrder = 5
        OnClick = TBaClick
      end
      object TBn: TTntButton
        Left = 91
        Top = 269
        Width = 75
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'None'
        TabOrder = 6
        OnClick = TBnClick
      end
      object HK: TTntListView
        Left = 172
        Top = 4
        Width = 372
        Height = 348
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <
          item
            Caption = 'Shortcut'
            Width = 152
          end
          item
            Caption = 'Action'
            Width = 196
          end>
        ColumnClick = False
        GridLines = True
        HideSelection = False
        Items.Data = {
          741000006700000000000000FFFFFFFFFFFFFFFF010000000000000007437472
          6C2B555018696E63726561736520686569676874206F6620766964656F000000
          00FFFFFFFFFFFFFFFF0100000000000000094374726C2B446F776E1864656372
          6561736520686569676874206F6620766964656F00000000FFFFFFFFFFFFFFFF
          0100000000000000094374726C2B4C6566741764656372656174652077696474
          68206F6620766964656F00000000FFFFFFFFFFFFFFFF01000000000000000A43
          74726C2B526967687417696E637265617365207769647468206F662076696465
          6F00000000FFFFFFFFFFFFFFFF0100000000000000064374726C2B3D107A6F6F
          6D20696E207375627469746C6500000000FFFFFFFFFFFFFFFF01000000000000
          00064374726C2B2D117A6F6F6D206F7574207375627469746C6500000000FFFF
          FFFFFFFFFFFF010000000000000005416C742B330B437573746F6D2073697A65
          00000000FFFFFFFFFFFFFFFF010000000000000005416C742B600948616C6620
          73697A6500000000FFFFFFFFFFFFFFFF010000000000000005416C742B310D4F
          726967696E616C2073697A6500000000FFFFFFFFFFFFFFFF0100000000000000
          05416C742B320B446F75626C652073697A6500000000FFFFFFFFFFFFFFFF0100
          0000000000000753686966742B410A4E65787420416E676C6500000000FFFFFF
          FFFFFFFFFF01000000000000000753686966742B4509457175616C697A657200
          000000FFFFFFFFFFFFFFFF01000000000000000753686966742B600B52657365
          74205363616C6500000000FFFFFFFFFFFFFFFF01000000000000000753686966
          742B530D73657175656E63652073686F7400000000FFFFFFFFFFFFFFFF010000
          00000000000753686966742B5A0E52657365742053756264656C617900000000
          FFFFFFFFFFFFFFFF0100000000000000012D1564656372656173652061756469
          6F2064656C61792000000000FFFFFFFFFFFFFFFF0100000000000000012B1469
          6E63726561736520617564696F2064656C617900000000FFFFFFFFFFFFFFFF01
          00000000000000014F0A746F67676C65204F534400000000FFFFFFFFFFFFFFFF
          010000000000000001600F526573657420457175616C697A657200000000FFFF
          FFFFFFFFFFFF0100000000000000012712746F67676C65206465696E7465726C
          61636500000000FFFFFFFFFFFFFFFF010000000000000001450D7A6F6F6D2069
          6E20766964656F00000000FFFFFFFFFFFFFFFF010000000000000001570E7A6F
          6F6D206F757420766964656F00000000FFFFFFFFFFFFFFFF0100000000000000
          013111646563726561736520636F6E747261737400000000FFFFFFFFFFFFFFFF
          0100000000000000013211696E63726561736520636F6E747261737400000000
          FFFFFFFFFFFFFFFF010000000000000001331364656372656173652062726967
          68746E65737300000000FFFFFFFFFFFFFFFF0100000000000000013414696E63
          7265617365206272696768746E6573732000000000FFFFFFFFFFFFFFFF010000
          000000000001350C64656372656173652068756500000000FFFFFFFFFFFFFFFF
          010000000000000001360C696E6372656173652068756500000000FFFFFFFFFF
          FFFFFF010000000000000001371364656372656173652073617475726174696F
          6E00000000FFFFFFFFFFFFFFFF0100000000000000013813696E637265617365
          2073617475726174696F6E00000000FFFFFFFFFFFFFFFF010000000000000001
          390F646563726561736520766F6C756D6500000000FFFFFFFFFFFFFFFF010000
          000000000001300F696E63726561736520766F6C756D6500000000FFFFFFFFFF
          FFFFFF01000000000000000644656C6574650E64656372656173652067616D6D
          6100000000FFFFFFFFFFFFFFFF010000000000000006496E736572740E696E63
          72656173652067616D6D6100000000FFFFFFFFFFFFFFFF010000000000000001
          440A64726F70206672616D6500000000FFFFFFFFFFFFFFFF0100000000000000
          01460A66756C6C53637265656E00000000FFFFFFFFFFFFFFFF01000000000000
          0001430D73756220616C69676E6D656E7400000000FFFFFFFFFFFFFFFF010000
          0000000000015414696E6372656173652073756220706F7374696F6E00000000
          FFFFFFFFFFFFFFFF010000000000000001521464656372656173652073756220
          706F7374696F6E00000000FFFFFFFFFFFFFFFF0100000000000000015615746F
          67676C6520737562207669736962696C69747900000000FFFFFFFFFFFFFFFF01
          0000000000000001530B53686F742053637265656E00000000FFFFFFFFFFFFFF
          FF01000000000000000159117375622073746570206261636B776F7264000000
          00FFFFFFFFFFFFFFFF0100000000000000015510737562207374657020666F72
          776F726400000000FFFFFFFFFFFFFFFF0100000000000000015A136465637265
          617365207375622064656C61792000000000FFFFFFFFFFFFFFFF010000000000
          0000015812696E637265617365207375622064656C617900000000FFFFFFFFFF
          FFFFFF010000000000000001470B4456446E6176206D656E7500000000FFFFFF
          FFFFFFFFFF010000000000000001480D4456446E61762073656C656374000000
          00FFFFFFFFFFFFFFFF01000000000000000149094456446E6176205550000000
          00FFFFFFFFFFFFFFFF0100000000000000014B0B4456446E617620446F776E00
          000000FFFFFFFFFFFFFFFF0100000000000000014A0B4456446E6176204C6566
          7400000000FFFFFFFFFFFFFFFF0100000000000000014C0C4456446E61762052
          6967687400000000FFFFFFFFFFFFFFFF0100000000000000013B0B4456446E61
          76207072657600000000FFFFFFFFFFFFFFFF01000000000000000246320B4B65
          65702061737065637400000000FFFFFFFFFFFFFFFF0100000000000000024633
          0D48696465206D656E752062617200000000FFFFFFFFFFFFFFFF010000000000
          0000024634124869646520636F6E74726F6C2070616E656C00000000FFFFFFFF
          FFFFFFFF01000000000000000246350C436F6D70616374206D6F646500000000
          FFFFFFFFFFFFFFFF0100000000000000024636154E6578742053756274696C65
          20436F64655061676500000000FFFFFFFFFFFFFFFF0100000000000000035461
          621C546F67676C65204D656E7520616E6420436F6E74726F6C50616E656C0000
          0000FFFFFFFFFFFFFFFF010000000000000005456E7465720D4D6178696D697A
          65207669657700000000FFFFFFFFFFFFFFFF0100000000000000064374726C2B
          4F0A4F70656E2066696C657300000000FFFFFFFFFFFFFFFF0100000000000000
          064374726C2B4C084F70656E2055524C00000000FFFFFFFFFFFFFFFF01000000
          00000000064374726C2B5705436C6F736500000000FFFFFFFFFFFFFFFF010000
          0000000000064374726C2B530453746F7000000000FFFFFFFFFFFFFFFF010000
          0000000000064374726C2B600D52657365742062616C616E636500000000FFFF
          FFFFFFFFFFFF0100000000000000064374726C2B51045175697400000000FFFF
          FFFFFFFFFFFF0100000000000000064374726C2B440E4F70656E206469726563
          746F727900000000FFFFFFFFFFFFFFFF01000000000000000E4374726C2B4261
          636B537061636511526573657420617564696F2064656C617900000000FFFFFF
          FFFFFFFFFF010000000000000006416C742B4634045175697400000000FFFFFF
          FFFFFFFFFF01000000000000000753686966742B440653746572656F00000000
          FFFFFFFFFFFFFFFF01000000000000000753686966742B4C0C6C656674206368
          616E6E656C00000000FFFFFFFFFFFFFFFF01000000000000000753686966742B
          520D5269676874206368616E6E656C00000000FFFFFFFFFFFFFFFF0100000000
          000000044C6566740F4261636B776172642031302073656300000000FFFFFFFF
          FFFFFFFF01000000000000000552696768740E466F7277617264203130207365
          6300000000FFFFFFFFFFFFFFFF01000000000000000255500D466F7277617264
          2031206D696E00000000FFFFFFFFFFFFFFFF010000000000000004446F776E0E
          4261636B776172642031206D696E00000000FFFFFFFFFFFFFFFF010000000000
          000007506167652055500E466F7277617264203130206D696E00000000FFFFFF
          FFFFFFFFFF0100000000000000095061676520446F776E0F4261636B77617264
          203130206D696E00000000FFFFFFFFFFFFFFFF010000000000000004486F6D65
          0F4368617074657220666F727761726400000000FFFFFFFFFFFFFFFF01000000
          0000000003456E641043686170746572206261636B7761726400000000FFFFFF
          FFFFFFFFFF0100000000000000094261636B53706163650B5265736574207370
          65656400000000FFFFFFFFFFFFFFFF0100000000000000012D0E646563726561
          736520737065656400000000FFFFFFFFFFFFFFFF0100000000000000012B0E69
          6E63726561736520737065656400000000FFFFFFFFFFFFFFFF01000000000000
          00014D044D75746500000000FFFFFFFFFFFFFFFF0100000000000000014E0B4E
          6578742061737065637400000000FFFFFFFFFFFFFFFF01000000000000000142
          0D4E657874207375627469746C6500000000FFFFFFFFFFFFFFFF010000000000
          00000151104E65787420766964656F20747261636B00000000FFFFFFFFFFFFFF
          FF010000000000000001500C4E6578742070726F6772616D00000000FFFFFFFF
          FFFFFFFF0100000000000000012C0962616C616E6365202D00000000FFFFFFFF
          FFFFFFFF0100000000000000012E0962616C616E6365202B00000000FFFFFFFF
          FFFFFFFF01000000000000000141104E65787420617564696F20747261636B00
          000000FFFFFFFFFFFFFFFF01000000000000000246310A4E657874204F6E746F
          7000000000FFFFFFFFFFFFFFFF01000000000000000246390D53686F7720506C
          61796C69737400000000FFFFFFFFFFFFFFFF0100000000000000034631300C53
          686F77204F7074696F6E7300000000FFFFFFFFFFFFFFFF010000000000000003
          4631310F53686F77206D6564696120696E666F00000000FFFFFFFFFFFFFFFF01
          00000000000000034631320853686F77206C6F6700000000FFFFFFFFFFFFFFFF
          0100000000000000015B0A53657420696E74726F2000000000FFFFFFFFFFFFFF
          FF0100000000000000015D0753657420656E6400000000FFFFFFFFFFFFFFFF01
          00000000000000015C11536B697020496E74726F20456E64696E6700000000FF
          FFFFFFFFFFFFFF0100000000000000012F0A4672616D65207374657000000000
          FFFFFFFFFFFFFFFF010000000000000005537061636505506175736500000000
          FFFFFFFFFFFFFFFF010000000000000002463709507265762066696C65000000
          00FFFFFFFFFFFFFFFF0100000000000000024638094E6578742066696C650000
          0000FFFFFFFFFFFFFFFF0100000000000000064374726C2B410C4E657874204D
          6F6E69746F72FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        RowSelect = True
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        ViewStyle = vsReport
        OnClick = HKClick
        OnDblClick = HKDblClick
        OnKeyDown = HKKeyDown
        OnKeyPress = HKKeyPress
      end
      object RHK: TTntButton
        Left = 448
        Top = 359
        Width = 94
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'Reset HotKey'
        TabOrder = 8
        OnClick = RHKClick
      end
    end
    object TLog: TTntTabSheet
      Caption = 'Log'
      ImageIndex = 6
      DesignSize = (
        547
        389)
      object TheLog: TTntMemo
        Left = 2
        Top = 2
        Width = 542
        Height = 358
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Lucida Console'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object Command: TTntEdit
        Left = 2
        Top = 365
        Width = 542
        Height = 21
        Anchors = [akLeft, akRight, akBottom]
        TabOrder = 1
        OnKeyPress = CommandKeyPress
        OnKeyUp = CommandKeyUp
      end
    end
    object THelp: TTntTabSheet
      Caption = 'Help'
      ImageIndex = 4
      DesignSize = (
        547
        389)
      object HelpText: TTntMemo
        Left = 2
        Top = 2
        Width = 542
        Height = 384
        Cursor = crArrow
        Anchors = [akLeft, akTop, akRight, akBottom]
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
        WantReturns = False
        WordWrap = False
      end
    end
    object TAbout: TTntTabSheet
      Caption = 'About'
      ImageIndex = 3
      DesignSize = (
        547
        389)
      object LURL: TLabel
        Left = 8
        Top = 118
        Width = 108
        Height = 13
        Cursor = crHandPoint
        Caption = 'http://mpui-hcb.sf.net'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsUnderline]
        ParentFont = False
        OnClick = LURLClick
      end
      object MTitle: TTntLabel
        Left = 148
        Top = 4
        Width = 38
        Height = 16
        Caption = 'MTitle'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LVersionMPUI: TTntLabel
        Left = 168
        Top = 24
        Width = 72
        Height = 13
        Caption = 'VersionMPUI'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object VersionMPUI: TTntLabel
        Left = 188
        Top = 38
        Width = 60
        Height = 13
        Caption = 'VersionMPUI'
      end
      object LVersionMPlayer: TTntLabel
        Left = 168
        Top = 56
        Width = 88
        Height = 13
        Caption = 'VersionMPlayer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object VersionMPlayer: TTntLabel
        Left = 188
        Top = 70
        Width = 73
        Height = 13
        Caption = 'VersionMPlayer'
      end
      object FY: TTntLabel
        Left = 148
        Top = 103
        Width = 29
        Height = 13
        Caption = #20316#32773':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object HCB: TTntLabel
        Left = 200
        Top = 101
        Width = 88
        Height = 16
        Caption = 'Huang chen bin'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object MCredits: TMemo
        Left = 4
        Top = 134
        Width = 538
        Height = 251
        Cursor = crArrow
        Anchors = [akLeft, akTop, akRight, akBottom]
        BevelInner = bvNone
        BevelOuter = bvNone
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Lines.Strings = (
          'This is free software, licensed under the terms of the'
          'GNU General Public License, Version 2.'
          ''
          '(C) 2006-2013 Huang Chen Bin <hcb428@foxmail.com>'
          'based on work by Martin J. Fiedler <martin.fiedler@gmx.net>'
          ''
          'Code contributions and hints:'
          'Joackim Pennerup <joackim@pennerup.net>'
          'Vasily Khoruzhick <fenix-fen@mail.ru>'
          'Maxim Usov <UsovMV@kms.cctpu.edu.ru>'
          'TDFUnRar <dfrischalowski@del-net.com>'
          'TSevenZipVCL <http://www.rg-software.de>'
          'Interface to 7-zip32.dll <dominic@psas.co.za>'
          'GDI+ Lyric <yuanfen3287@vip.qq.com>'
          ''
          'Contibuted translations:'
          'French by Francois Gagne <frenchfrog@gmail.com>'
          'Spanish by Alex Fu <alexfu@nerdshack.com>'
          'Italian by Andres Zanzani <azanzani@gmail.com>'
          'Esperanto by Kristjan Schmidt <Kristjan@yandex.ru>'
          'Romanian by Florin Valcu <florin.valcu@gmail.com>'
          'Hungarian by MrG <mrguba@gmail.com>'
          'Polish by Wojciech Ga?ecki <kamikazeepl@gmail.com>'
          'Czech by Antonin Fujera <fujera@seznam.cz>'
          'Belarusian and Russian by Vasily Khoruzhick <fenix-fen@mail.ru>'
          'Ukrainian by <vadim-l@foxtrot.kiev.ua>'
          '                     and Andriy Zhouck <juksoft@ukr.net>'
          'Bulgarian by Boyan Boychev <boyan7640@gmail.com>'
          'Korean by Ken Jun <dalbaragi@gmail.com>')
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
        WordWrap = False
      end
      object PLogo: TPanel
        Left = 8
        Top = 6
        Width = 132
        Height = 110
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        ParentBackground = False
        TabOrder = 1
        object ILogo: TImage
          Left = 0
          Top = 0
          Width = 128
          Height = 106
          Picture.Data = {
            0A544A504547496D6167653D610000FFD8FFE000104A46494600010201012C01
            2C0000FFE10F0C4578696600004D4D002A000000080007011200030000000100
            010000011A00050000000100000062011B0005000000010000006A0128000300
            0000010002000001310002000000140000007201320002000000140000008687
            690004000000010000009C000000C80000012C000000010000012C0000000141
            646F62652050686F746F73686F7020372E3000323030393A30373A3038203136
            3A31333A33360000000003A001000300000001FFFF0000A00200040000000100
            000080A0030004000000010000006A0000000000000006010300030000000100
            060000011A00050000000100000116011B0005000000010000011E0128000300
            00000100020000020100040000000100000126020200040000000100000DDE00
            00000000000048000000010000004800000001FFD8FFE000104A464946000102
            01004800480000FFED000C41646F62655F434D0002FFEE000E41646F62650064
            8000000001FFDB0084000C08080809080C09090C110B0A0B11150F0C0C0F1518
            131315131318110C0C0C0C0C0C110C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
            0C0C0C0C0C0C0C0C0C0C010D0B0B0D0E0D100E0E10140E0E0E14140E0E0E0E14
            110C0C0C0C0C11110C0C0C0C0C0C110C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
            0C0C0C0C0C0C0C0C0C0C0CFFC0001108006A008003012200021101031101FFDD
            00040008FFC4013F000001050101010101010000000000000003000102040506
            0708090A0B010001050101010101010000000000000001000203040506070809
            0A0B1000010401030204020507060805030C3301000211030421123105415161
            1322718132061491A1B14223241552C16233347282D14307259253F0E1F16373
            3516A2B283264493546445C2A3743617D255E265F2B384C3D375E3F3462794A4
            85B495C4D4E4F4A5B5C5D5E5F55666768696A6B6C6D6E6F637475767778797A7
            B7C7D7E7F7110002020102040403040506070706053501000211032131120441
            51617122130532819114A1B14223C152D1F0332462E1728292435315637334F1
            250616A2B283072635C2D2449354A317644555367465E2F2B384C3D375E3F346
            94A485B495C4D4E4F4A5B5C5D5E5F55666768696A6B6C6D6E6F6273747576777
            8797A7B7C7FFDA000C03010002110311003F00F2A493B5AE7B83580B9C74006A
            495D174EFF0017BF5B7A8C1A304B1A44EEB9CDAE07896BCEFF00FA295141206E
            7779C497A363FF00893EB8F00E46763553C86EF791FF0042B5A547F892A1B1EB
            E7BAC3DF680C1F8B6C4692F93A4BDA71FF00C51F48A39636E3E36BDE7F066C6A
            BD47F8BEC5C6FE8F8D86C3E2585C7FCE7B1CE44447EF053E175517DC62AADD61
            F06B4BBFEA55FA3EADF5EC8FE6B06E20F7734B47DF66D5EDE3EABF52608AACA1
            83C06E1F918A0FFAADD64F19147FD3FF00C8270843ACD167B3E474FD41FAC364
            6F655483DDF60FFD17BD6853FE2E2FD3ED19F5B3C431A5DFF546B5E8AFFAA1D7
            1DFF006AA8FF00A7FF0090417FD49EBAEFFB578FFF004FFF00209E218BAC9167
            B3C753F507A1D5FD232AEB8FF276B07E47AB74FD5AFAA98C67ECDEB1F1B5EE77
            FD196B5742EFA85D75DFF6AF1FFE9FFE410CFF008BCEB87FED5E3FFD3FFC8278
            1807E9057A9CC60E878DFCC61D0C238218D9FF003A152EA4DE9999596DD456E9
            FCEDA03BE4E1EE5BA7FC5C75A3FF006AF1FF00E9FF00E4145FFE2DFAD6D27ED5
            8E4F87BFFF0020A40707EF047A9F2BEABD38615B3512EA5E7DA4F23F925505D8
            7D68E89D47A6D56539D496CEB5BC1DCC716FEE3DAB8F55B3463197A7E53A85C0
            E9ABFFD007D43E818BD3BA7D7D5B2581F9D9237545C27D3ACFD0D93F45F67D27
            397AAE1D028C76363DC402F3E24AF3DC6BC3B131857F43657B7E10DDABD215AE
            621EDC3181FA564B9FC8E639B2E694BF42A31FEAF1717FDEAE92492AAE829249
            2494A4924925292492494A49249252931E13A4929E6FEB374DA33F0EEC5B80D9
            6B4B66276923DAF6FF00298BE7DC8A5F8F7D943FE954E731DF169DABE91EACC9
            612BE7AFAC351ABAE6733C2F791F02E25255EB4FFFD117D5CBBD7E9380FE4ED6
            B4FF0064ECFF00BEAF5A5E31F512CF53A554C267D3BCB7E44B5FFF007E5ECEAD
            7332BC784FF54FFDCB9DF0F870E7E6C7F5C7FDDA925C17D6AFADDD5BA77D6076
            361DC063502B3655B5A77123D4B1BBDCD73FDCC76D5A1F5C7EB4DD838587FB2E
            D0CBF300B83E03A2A8F078737DEE728BD89FA36F5EDFDAE8710D7C1EB525CAF4
            EEBD9F93F52AFEA6EB673A865A0DBB5BF4987D8ED9B7D3FA1B7F356063F5DFAE
            F7F4ABBAC5596C762E338B6D0595EED36CFB3D3F737DFF00BC88C1237A81C278
            75FDE5713E9292E670FEB064F51FAA391D50D9F64CAC6659BECADAD70DD50DFA
            32D0F6EDB7DAA7F50FA8F55EA9D10E7753BBD6B2DB5E2B3B5AC018D8669E9B5B
            FE13D4514A262483B84BD1A484CCBC5B1CF6D7756F757FCE06B812DFEBC1F6A9
            3AEA59B77D8D6EFD1924099FDDFDE414CD250B2DAAA8363DAC0741B8813F7A77
            D8CAD85F638318DD4B9C600F8929299248756451733D4A6C658C1F9CC7070FBD
            A9BED58C2A377AACF48686CDC3683FD79DA929ADD4993515F3F7D72A8B3AFE4B
            A347B891F22E6FF05F436580FA891A82342BC17EBDD51D49D67FC2DADFFA5B93
            E22E133DB84B0E49565C43F7B8E3F8717FDCBFFFD2E7FF00C5C5B365D44F16D4
            F03E2769FC8BDD57CFBFE2EEFD9D7DB49FF0C047C5AE6B97D04A6C92BC5887EE
            F10FC5AD861C3CC7307F7FDB97FCDE1FFB97CCA8E9ADFAC3F58FAD81EEDACB9D
            49FE5B5CDAB1FF00EA155FABBD32FEB57DC3289753D3B15ED60770D743C5157F
            66C73ECFEC2F48E9DD0FA574CB6CBB06814D9769638171275DDF9EE77E7145C4
            E998185EBFD9696D5F6A79B2F89F738F253CF33A1001D808FF0057F799F85E0F
            EADE417FD49EB58E7FC107387F6D83FF0049AADF577EAEF57EB3D2AC18F9FF00
            66C13696598E7710E700C76F2C6C35DF98BBCC6FAB7D17171F231B1F18329CB0
            1B90C0E790E027F79DFCAFCD563A774BC0E9941C7C1A853539C5E5A093EE2036
            7DE5DFBA91E600E2E11ACA4242C2B876B792FAD58957D5BFA8AFE9D43CBCE458
            DADF61D0B8BCFAB6BB6FF52AD8A87D66BF33A27D4CE8FD2719E6A765B2322C69
            83102EB2BDC3F7ECBBDEBBAEABD23A7F58C5FB2750A85D4EE0F024B4870D039A
            E616BBF3956C8FAAFD1327A7B3A764639B71AB76F607BDEE7B5D1B7736E73FD5
            FA3FCB55C92492772B9E33EB8F4AC2A1FD03EAFE054C6596B80B1EC0039C1C6B
            AF758E1EE77A8EF52CF72B5FE33B1F15CDE9787454C199936EC65A043DAC6815
            319BBF737DCBA5B3EA77D5DB1B487E26E763FF003567A967A83FAD77A9EABF6C
            7B773D657D65E9D6DDD4F031EDE8DFB43A3D0C8F5A97B85F5B8E8EDBB6DADCE6
            37655FF93414E6FD68ADB9FF005BFA0F44F53D6662B58EBB59320FA8FDFF00CB
            7558E9FAAE6E5E7FF8C0AFA7D949C9C7C066FA308BC318FB360B7D67FA9EC7FD
            3FFC0D687D5AFAB17D7D7723AF66638C3641AF030E439EC647A7EB5EE697FE95
            ECFE5BFF009CB16E753FAB5D1BAA64332B2E8FD6AA0032FADEEAEC0071FA4A5C
            C724A717A1FD5DA7A75FD5F2BA93E87BB2C7AD7F4EAB5AAAAE5F7377B5DB77FD
            1FA5E9AE73EA97D5467D61E819CE7DA715B764834103731BB06EB228DCC67BBD
            4F4F7AF43A7A374DA70EEC2AE90DA320117EAE2E7EE1B1DEADCE77ACFF006FFC
            22274EE9983D2F15B898150A31DA4B830127571DCED5E5CE494C71B05983D368
            C2638BD98F5B6A6B9DA921A36CB978AFD7BA817E4BA35664BBF1739ABDD1E25A
            578C7D71AB7BBA8B46BEFB08F938B958C02E1947F55A5CE4F872F2C7FD67E6FF
            00FFD3E17EA5DFE8FD68E9C7B3EE6D67FB7EC5F47AF97FA55FF66EA789904ED1
            55F5BCBBC035CD72FA7C10E01CD320EA08E0846F403B127ED5A235232EE00FF1
            78BFEF974924905CA4924925292492494A49249252945CF6B1A5CF21AD1A9713
            00055BAA752C6E97836E76498AEA13039713A318CFE53DCB8514756FAD35DDD5
            BAB5EEC2E8B8E1D60AD80996B0173FD2AFFC26D68FE7DFFF005B52431F103227
            8623AFF0412F66FF00AC9D018FD8EEA18FBBFE31A7F10AEE3E4E364D7EAE35AC
            BAB3C3EB7070FBDAB98E9DF537EA7676236EC32ECBA9E34B9B6927E7B36EC77F
            2762A5D47EA667F4627A8FD5BC9B43EBF73B1C9971039DBC36EFF8AB189DC18A
            5A46641FEB0F4AACF67B877057907D6401D999AC3F9D65A3EF2E5DD743FADD57
            55E9EE75A0559947B6FAC71FC9B193F98E5E65F58FA9305D977CE8EB1FB7CCB8
            9DAA5E5FD1EE0969435687C420667008EFC45FFFD4F2A5ED9F51BEBE61BBA462
            E17567FA36555B595E4192D735A3635B61FCC7B7F79789AD5E93D4054CFB3D87
            6899613E7F9AA4C4204D4F63B1EC506FA3F4633A974F7B4399954B9A7822C691
            F954BEDD85FF00722AFF003DBFDEBC17ED0DF04C725BE0A6FBB43F7FF04711EC
            FBD7DBF07FEE455FE7B7FBD31EA58039C8AFFCF6FF007AF0376501E0105F9D53
            797B47CD34E080FD3FC15C47B3F40FED4E9DFF00726AFF003DBFDEA0EEB3D29B
            CE5D5FE705F3D3FA9D00C6E9F80417754676613E698618C7E9FE09B3D9FA24F5
            DE8E39CCABFCE0A27EB17441FF006B2AFBD7CE4EEA7611ED601F1D50DD9D90EF
            CE03E0130887727E8AD5F63FAE9D46AEB1D47A6748C3B43E9BAC0E7B9A74DCE7
            0A9BFE633D45D575BA2AC7FAB39F452D0CAAAC3B58C68E0015B805E1DF54BA93
            B1FA85591638B9D8F6B2D83FBA0FB97B875CBEABBEAE750B2B70731F87739AE1
            C106B710427E4FE6F1D7CBAFF8CA1B97C63A6F55EA3D2EE191D3F21F8F677DA7
            DAEFF8CACFB2CFEDAF41E85FE33B16F68A3AD30635BC0C9AC1351FEBB357D5FF
            004D8B8AE85F563ABF5D7818554500C3F26CF6D43FB5FE11DFC8AD7A2749FA97
            D17A1562FB07DB335BAFAF68D1A7FE06AFA15FF5BF9C5125E27EB8E53FA275BC
            8CBC0815E5D3EA6D1A37DFA3F8FE5B7D55E7F979B7E5BF75A741F45A380BB0FF
            00187D49995D4EE0C32DA58299FE54973BFCDDCB88526491A88BE82D6F0C78B8
            AB51A07FFFD5F2A4924925256E56430435E607CFF2A4ECAC8708361F969F9109
            24EF5575A568B9739DF4893F1299249354A4924925292492494971B21F8D736D
            676E4788EE17A0FD5BFAF4DA70CF4FCD6FDA701ED2C2DE5CC6BB47D6E6FE7D4B
            CE51717F9D1F4FFB1CA9617C278AB82FAFEF7F550777DC69FAF9D059435955EC
            A98C10DAC34B600FCD0CDAB9DFAC5FE309B6D4EABA7932441BDC2037FA8D77D2
            72E1471F9DF359F9DF487D3FED7D1F920382F4BFF0BE556AB66E5BB26C264968
            24C9E493F9C5564924D95F11BDD21FFFD9FFED13C050686F746F73686F702033
            2E30003842494D04250000000000100000000000000000000000000000000038
            42494D03ED000000000010012C000000010002012C0000000100023842494D04
            2600000000000E000000000000000000003F8000003842494D040D0000000000
            040000001E3842494D04190000000000040000001E3842494D03F30000000000
            09000000000000000001003842494D040A00000000000100003842494D271000
            000000000A000100000000000000023842494D03F5000000000048002F666600
            01006C66660006000000000001002F6666000100A1999A000600000000000100
            3200000001005A00000006000000000001003500000001002D00000006000000
            0000013842494D03F80000000000700000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFF03E800000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFF03E800000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF03
            E800000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF03E8000038
            42494D040000000000000200013842494D040200000000000400000000384249
            4D0408000000000010000000010000024000000240000000003842494D041E00
            0000000004000000003842494D041A0000000003430000000600000000000000
            000000006A0000008000000007006D0070006C00610079006500720000000100
            0000000000000000000000000000000000000100000000000000000000008000
            00006A0000000000000000000000000000000001000000000000000000000000
            0000000000000010000000010000000000006E756C6C0000000200000006626F
            756E64734F626A6300000001000000000000526374310000000400000000546F
            70206C6F6E6700000000000000004C6566746C6F6E6700000000000000004274
            6F6D6C6F6E670000006A00000000526768746C6F6E670000008000000006736C
            69636573566C4C73000000014F626A6300000001000000000005736C69636500
            00001200000007736C69636549446C6F6E67000000000000000767726F757049
            446C6F6E6700000000000000066F726967696E656E756D0000000C45536C6963
            654F726967696E0000000D6175746F47656E6572617465640000000054797065
            656E756D0000000A45536C6963655479706500000000496D672000000006626F
            756E64734F626A6300000001000000000000526374310000000400000000546F
            70206C6F6E6700000000000000004C6566746C6F6E6700000000000000004274
            6F6D6C6F6E670000006A00000000526768746C6F6E6700000080000000037572
            6C54455854000000010000000000006E756C6C54455854000000010000000000
            004D7367655445585400000001000000000006616C7454616754455854000000
            0100000000000E63656C6C54657874497348544D4C626F6F6C01000000086365
            6C6C546578745445585400000001000000000009686F727A416C69676E656E75
            6D0000000F45536C696365486F727A416C69676E0000000764656661756C7400
            00000976657274416C69676E656E756D0000000F45536C69636556657274416C
            69676E0000000764656661756C740000000B6267436F6C6F7254797065656E75
            6D0000001145536C6963654247436F6C6F7254797065000000004E6F6E650000
            0009746F704F75747365746C6F6E67000000000000000A6C6566744F75747365
            746C6F6E67000000000000000C626F74746F6D4F75747365746C6F6E67000000
            000000000B72696768744F75747365746C6F6E6700000000003842494D041100
            000000000101003842494D0414000000000004000000033842494D040C000000
            000DFA00000001000000800000006A0000018000009F0000000DDE00180001FF
            D8FFE000104A46494600010201004800480000FFED000C41646F62655F434D00
            02FFEE000E41646F626500648000000001FFDB0084000C08080809080C09090C
            110B0A0B11150F0C0C0F1518131315131318110C0C0C0C0C0C110C0C0C0C0C0C
            0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C010D0B0B0D0E0D100E0E
            10140E0E0E14140E0E0E0E14110C0C0C0C0C11110C0C0C0C0C0C110C0C0C0C0C
            0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0CFFC0001108006A0080
            03012200021101031101FFDD00040008FFC4013F000001050101010101010000
            0000000000030001020405060708090A0B010001050101010101010000000000
            0000010002030405060708090A0B1000010401030204020507060805030C3301
            0002110304211231054151611322718132061491A1B14223241552C162333472
            82D14307259253F0E1F163733516A2B283264493546445C2A3743617D255E265
            F2B384C3D375E3F3462794A485B495C4D4E4F4A5B5C5D5E5F55666768696A6B6
            C6D6E6F637475767778797A7B7C7D7E7F7110002020102040403040506070706
            05350100021103213112044151617122130532819114A1B14223C152D1F03324
            62E1728292435315637334F1250616A2B283072635C2D2449354A31764455536
            7465E2F2B384C3D375E3F34694A485B495C4D4E4F4A5B5C5D5E5F55666768696
            A6B6C6D6E6F62737475767778797A7B7C7FFDA000C03010002110311003F00F2
            A493B5AE7B83580B9C74006A495D174EFF0017BF5B7A8C1A304B1A44EEB9CDAE
            07896BCEFF00FA295141206E7779C497A363FF00893EB8F00E46763553C86EF7
            91FF0042B5A547F892A1B1EBE7BAC3DF680C1F8B6C4692F93A4BDA71FF00C51F
            48A39636E3E36BDE7F066C6ABD47F8BEC5C6FE8F8D86C3E2585C7FCE7B1CE444
            47EF053E175517DC62AADD61F06B4BBFEA55FA3EADF5EC8FE6B06E20F7734B47
            DF66D5EDE3EABF52608AACA183C06E1F918A0FFAADD64F19147FD3FF00C82708
            43ACD167B3E474FD41FAC3646F655483DDF60FFD17BD6853FE2E2FD3ED19F5B3
            C431A5DFF546B5E8AFFAA1D71DFF006AA8FF00A7FF0090417FD49EBAEFFB578F
            FF004FFF00209E218BAC9167B3C753F507A1D5FD232AEB8FF276B07E47AB74FD
            5AFAA98C67ECDEB1F1B5EE77FD196B5742EFA85D75DFF6AF1FFE9FFE410CFF00
            8BCEB87FED5E3FFD3FFC82781807E9057A9CC60E878DFCC61D0C238218D9FF00
            3A152EA4DE9999596DD456E9FCEDA03BE4E1EE5BA7FC5C75A3FF006AF1FF00E9
            FF00E4145FFE2DFAD6D27ED58E4F87BFFF0020A40707EF047A9F2BEABD38615B
            3512EA5E7DA4F23F925505D87D68E89D47A6D56539D496CEB5BC1DCC716FEE3D
            AB8F55B3463197A7E53A85C0E9ABFFD007D43E818BD3BA7D7D5B2581F9D92375
            45C27D3ACFD0D93F45F67D27397AAE1D028C76363DC402F3E24AF3DC6BC3B131
            857F43657B7E10DDABD215AE621EDC3181FA564B9FC8E639B2E694BF42A31FEA
            F1717FDEAE92492AAE8292492494A4924925292492494A49249252931E13A492
            9E6FEB374DA33F0EEC5B80D96B4B66276923DAF6FF00298BE7DC8A5F8F7D943F
            E954E731DF169DABE91EACC9612BE7AFAC351ABAE6733C2F791F02E25255EB4F
            FFD117D5CBBD7E9380FE4ED6B4FF0064ECFF00BEAF5A5E31F512CF53A554C267
            D3BCB7E44B5FFF007E5ECEAD7332BC784FF54FFDCB9DF0F870E7E6C7F5C7FDDA
            925C17D6AFADDD5BA77D6076361DC063502B3655B5A77123D4B1BBDCD73FDCC7
            6D5A1F5C7EB4DD838587FB2ED0CBF300B83E03A2A8F078737DEE728BD89FA36F
            5EDFDAE8710D7C1EB525CAF4EEBD9F93F52AFEA6EB673A865A0DBB5BF4987D8E
            D9B7D3FA1B7F356063F5DFAEF7F4ABBAC5596C762E338B6D0595EED36CFB3D3F
            737DFF00BC88C1237A81C27875FDE5713E9292E670FEB064F51FAA391D50D9F6
            4CAC6659BECADAD70DD50DFA32D0F6EDB7DAA7F50FA8F55EA9D10E7753BBD6B2
            DB5E2B3B5AC018D8669E9B5BFE13D4514A262483B84BD1A484CCBC5B1CF6D775
            6F757FCE06B812DFEBC1F6A93AEA59B77D8D6EFD1924099FDDFDE414CD250B2D
            AAA8363DAC0741B8813F7A77D8CAD85F638318DD4B9C600F8929299248756451
            733D4A6C658C1F9CC7070FBDA9BED58C2A377AACF48686CDC3683FD79DA929AD
            D4993515F3F7D72A8B3AFE4BA347B891F22E6FF05F436580FA891A82342BC17E
            BDD51D49D67FC2DADFFA5B93E22E133DB84B0E49565C43F7B8E3F8717FDCBFFF
            D2E7FF00C5C5B365D44F16D4F03E2769FC8BDD57CFBFE2EEFD9D7DB49FF0C047
            C5AE6B97D04A6C92BC5887EEF10FC5AD861C3CC7307F7FDB97FCDE1FFB97CCA8
            E9ADFAC3F58FAD81EEDACB9D49FE5B5CDAB1FF00EA155FABBD32FEB57DC32897
            53D3B15ED60770D743C5157F66C73ECFEC2F48E9DD0FA574CB6CBB06814D9769
            638171275DDF9EE77E7145C4E998185EBFD9696D5F6A79B2F89F738F253CF33A
            1001D808FF0057F799F85E0FEADE417FD49EB58E7FC107387F6D83FF0049AADF
            577EAEF57EB3D2AC18F9FF0066C13696598E7710E700C76F2C6C35DF98BBCC6F
            AB7D17171F231B1F18329CB01B90C0E790E027F79DFCAFCD563A774BC0E9941C
            7C1A853539C5E5A093EE20367DE5DFBA91E600E2E11ACA4242C2B876B792FAD5
            8957D5BFA8AFE9D43CBCE458DADF61D0B8BCFAB6BB6FF52AD8A87D66BF33A27D
            4CE8FD2719E6A765B2322C6983102EB2BDC3F7ECBBDEBBAEABD23A7F58C5FB27
            50A85D4EE0F024B4870D039AE616BBF3956C8FAAFD1327A7B3A764639B71AB76
            F607BDEE7B5D1B7736E73FD5FA3FCB55C92492772B9E33EB8F4AC2A1FD03EAFE
            054C6596B80B1EC0039C1C6BAF758E1EE77A8EF52CF72B5FE33B1F15CDE97874
            54C199936EC65A043DAC6815319BBF737DCBA5B3EA77D5DB1B487E26E763FF00
            3567A967A83FAD77A9EABF6C7B773D657D65E9D6DDD4F031EDE8DFB43A3D0C8F
            5A97B85F5B8E8EDBB6DADCE637655FF93414E6FD68ADB9FF005BFA0F44F53D66
            62B58EBB59320FA8FDFF00CB7558E9FAAE6E5E7FF8C0AFA7D949C9C7C066FA30
            8BC318FB360B7D67FA9EC7FD3FFC0D687D5AFAB17D7D7723AF66638C3641AF03
            0E439EC647A7EB5EE697FE95ECFE5BFF009CB16E753FAB5D1BAA64332B2E8FD6
            AA0032FADEEAEC0071FA4A5CC724A717A1FD5DA7A75FD5F2BA93E87BB2C7AD7F
            4EAB5AAAAE5F7377B5DB77FD1FA5E9AE73EA97D5467D61E819CE7DA715B76483
            4103731BB06EB228DCC67BBD4F4F7AF43A7A374DA70EEC2AE90DA320117EAE2E
            7EE1B1DEADCE77ACFF006FFC22274EE9983D2F15B898150A31DA4B830127571D
            CED5E5CE494C71B05983D368C2638BD98F5B6A6B9DA921A36CB978AFD7BA817E
            4BA35664BBF1739ABDD1E25A578C7D71AB7BBA8B46BEFB08F938B958C02E1947
            F55A5CE4F872F2C7FD67E6FF00FFD3E17EA5DFE8FD68E9C7B3EE6D67FB7EC5F4
            7AF97FA55FF66EA789904ED155F5BCBBC035CD72FA7C10E01CD320EA08E0846F
            403B127ED5A235232EE00FF178BFEF974924905CA4924925292492494A492492
            52945CF6B1A5CF21AD1A971300055BAA752C6E97836E76498AEA13039713A318
            CFE53DCB8514756FAD35DDD5BAB5EEC2E8B8E1D60AD80996B0173FD2AFFC26D6
            8FE7DFFF005B52431F1032278623AFF0412F66FF00AC9D018FD8EEA18FBBFE31
            A7F10AEE3E4E364D7EAE35ACBAB3C3EB7070FBDAB98E9DF537EA7676236EC32E
            CBA9E34B9B6927E7B36EC77F2762A5D47EA667F4627A8FD5BC9B43EBF73B1C99
            71039DBC36EFF8AB189DC18A5A46641FEB0F4AACF67B877057907D6401D999AC
            3F9D65A3EF2E5DD743FADD5755E9EE75A0559947B6FAC71FC9B193F98E5E65F5
            8FA9305D977CE8EB1FB7CCB89DAA5E5FD1EE0969435687C420667008EFC45FFF
            D4F2A5ED9F51BEBE61BBA462E17567FA36555B595E4192D735A3635B61FCC7B7
            F79789AD5E93D4054CFB3D876899613E7F9AA4C4204D4F63B1EC506FA3F4633A
            974F7B4399954B9A7822C691F954BEDD85FF00722AFF003DBFDEBC17ED0DF04C
            725BE0A6FBB43F7FF04711ECFBD7DBF07FEE455FE7B7FBD31EA58039C8AFFCF6
            FF007AF0376501E0105F9D53797B47CD34E080FD3FC15C47B3F40FED4E9DFF00
            726AFF003DBFDEA0EEB3D29BCE5D5FE705F3D3FA9D00C6E9F80417754676613E
            698618C7E9FE09B3D9FA24F5DE8E39CCABFCE0A27EB17441FF006B2AFBD7CE4E
            EA7611ED601F1D50DD9D90EFCE03E0130887727E8AD5F63FAE9D46AEB1D47A67
            48C3B43E9BAC0E7B9A74DCE70A9BFE633D45D575BA2AC7FAB39F452D0CAAAC3B
            58C68E0015B805E1DF54BA93B1FA85591638B9D8F6B2D83FBA0FB97B875CBEAB
            BEAE750B2B70731F87739AE1C106B710427E4FE6F1D7CBAFF8CA1B97C63A6F55
            EA3D2EE191D3F21F8F677DA7DAEFF8CACFB2CFEDAF41E85FE33B16F68A3AD306
            35BC0C9AC1351FEBB357D5FF004D8B8AE85F563ABF5D7818554500C3F26CF6D4
            3FB5FE11DFC8AD7A2749FA97D17A1562FB07DB335BAFAF68D1A7FE06AFA15FF5
            BF9C5125E27EB8E53FA275BC8CBC0815E5D3EA6D1A37DFA3F8FE5B7D55E7F979
            B7E5BF75A741F45A380BB0FF00187D49995D4EE0C32DA58299FE54973BFCDDCB
            88526491A88BE82D6F0C78B8AB51A07FFFD5F2A4924925256E56430435E607CF
            F2A4ECAC8708361F969F910924EF5575A568B9739DF4893F1299249354A49249
            25292492494971B21F8D736D676E4788EE17A0FD5BFAF4DA70CF4FCD6FDA701E
            D2C2DE5CC6BB47D6E6FE7D4BCE51717F9D1F4FFB1CA9617C278AB82FAFEF7F55
            0777DC69FAF9D059435955ECA98C10DAC34B600FCD0CDAB9DFAC5FE309B6D4EA
            BA7932441BDC2037FA8D77D272E1471F9DF359F9DF487D3FED7D1F920382F4BF
            F0BE556AB66E5BB26C26496824C9E493F9C5564924D95F11BDD21FFFD9384249
            4D042100000000005500000001010000000F00410064006F0062006500200050
            0068006F0074006F00730068006F00700000001300410064006F006200650020
            00500068006F0074006F00730068006F007000200037002E0030000000010038
            42494D04060000000000070008000000010100FFE11248687474703A2F2F6E73
            2E61646F62652E636F6D2F7861702F312E302F003C3F787061636B6574206265
            67696E3D27EFBBBF272069643D2757354D304D7043656869487A7265537A4E54
            637A6B633964273F3E0A3C3F61646F62652D7861702D66696C74657273206573
            633D224352223F3E0A3C783A7861706D65746120786D6C6E733A783D2761646F
            62653A6E733A6D6574612F2720783A786170746B3D27584D5020746F6F6C6B69
            7420322E382E322D33332C206672616D65776F726B20312E35273E0A3C726466
            3A52444620786D6C6E733A7264663D27687474703A2F2F7777772E77332E6F72
            672F313939392F30322F32322D7264662D73796E7461782D6E73232720786D6C
            6E733A69583D27687474703A2F2F6E732E61646F62652E636F6D2F69582F312E
            302F273E0A0A203C7264663A4465736372697074696F6E2061626F75743D2775
            7569643A64313339643233332D366239362D313164652D383632612D66303135
            3834626162396363270A2020786D6C6E733A7861704D4D3D27687474703A2F2F
            6E732E61646F62652E636F6D2F7861702F312E302F6D6D2F273E0A20203C7861
            704D4D3A446F63756D656E7449443E61646F62653A646F6369643A70686F746F
            73686F703A66666133316232312D366239332D313164652D383632612D663031
            3538346261623963633C2F7861704D4D3A446F63756D656E7449443E0A203C2F
            7264663A4465736372697074696F6E3E0A0A3C2F7264663A5244463E0A3C2F78
            3A7861706D6574613E0A20202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            20202020202020202020202020200A2020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            202020202020202020202020202020202020200A202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020200A20202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            20202020202020202020202020202020202020202020202020202020200A2020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            20200A2020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            202020202020200A202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020200A20202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            20202020202020202020202020202020200A2020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            202020202020202020202020202020202020202020200A202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020200A20202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            0A20202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            20202020200A2020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            202020202020202020200A202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020200A20202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            20202020202020202020202020202020202020200A2020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            202020202020202020202020202020202020202020202020200A202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020200A20
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020200A20202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            20202020202020200A2020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            202020202020202020202020200A202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020200A20202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            20202020202020202020202020202020202020202020200A2020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            202020202020202020202020202020202020202020202020202020200A202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            200A202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020200A20202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            20202020202020202020200A2020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            202020202020202020202020202020200A202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020200A20202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            20202020202020202020202020202020202020202020202020200A2020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            202020202020202020202020202020202020202020202020202020202020200A
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            202020200A202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020200A20202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            20202020202020202020202020200A2020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            202020202020202020202020202020202020200A202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020200A20202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            20202020202020202020202020202020202020202020202020202020200A2020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            20200A2020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            202020202020200A202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020200A20202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            20202020202020202020202020202020200A2020202020202020202020202020
            2020202020202020202020202020202020202020202020202020202020202020
            2020202020202020200A3C3F787061636B657420656E643D2777273F3EFFEE00
            0E41646F626500644000000001FFDB0084000101010101010101010101010101
            0101010101010101010101010101010101010101010101010101010101020202
            0202020202020202030303030303030303030101010101010101010101020201
            0202030303030303030303030303030303030303030303030303030303030303
            03030303030303030303030303030303030303FFC0001108006A008003011100
            021101031101FFDD00040010FFC401A200000006020301000000000000000000
            00070806050409030A0201000B01000006030101010000000000000000000605
            04030702080109000A0B10000201030401030302030303020609750102030411
            05120621071322000831144132231509514216612433175271811862912543A1
            B1F02634720A19C1D13527E1533682F192A24454734546374763285556571AB2
            C2D2E2F2648374938465A3B3C3D3E3293866F3752A393A48494A58595A676869
            6A767778797A85868788898A9495969798999AA4A5A6A7A8A9AAB4B5B6B7B8B9
            BAC4C5C6C7C8C9CAD4D5D6D7D8D9DAE4E5E6E7E8E9EAF4F5F6F7F8F9FA110002
            010302040403050404040606056D010203110421120531060022134151073261
            147108428123911552A162163309B124C1D14372F017E18234259253186344F1
            A2B226351954364564270A7383934674C2D2E2F255657556378485A3B3C3D3E3
            F3291A94A4B4C4D4E4F495A5B5C5D5E5F52847576638768696A6B6C6D6E6F667
            778797A7B7C7D7E7F7485868788898A8B8C8D8E8F839495969798999A9B9C9D9
            E9F92A3A4A5A6A7A8A9AAABACADAEAFAFFDA000C03010002110311003F00F9FF
            00FBF75EEBDEFDD7BAF7BF75EEBDEFDD7BAF7BF75EEBDEFDD7BA566DBD8BBDB7
            9542526D0D9BBAB7555480F8E9B6DEDECB676A24B3142521C6525548C43A91C0
            FA8B7B7238DDC908858FC857AD120746B3627F2E2F9DDD90227DA5F14FBA27A7
            9C4663ADCCECFAEDA58E7130BA5F25BB860F1EA40FD579068FED5BDAF8766DD6
            E3FB2DBE63FED481FB4D075469625E320FDBD1CBDA3FC84BF9856E16A56CE6D5
            EB2EBEA69DA332D46EDED1DBD50F4D13F2D24949B44EE9AA2E89CE80BAAFC1B7
            36368793B7E969AAD1501FE265FF002127A64DE5B8FC75FCBA373B4FFE138DBD
            4785FB33E59F5AE035463EE29F65ECDDC3BA9A27BA16115566F21B416708030B
            1892E6DC8F6716FEDEEE5253C5BA45FB159BFC3A7A68EE110E0A4F469766FF00
            210F83DB457C9D97DEFDC7D83508885E3C2CBB4F62638CABFAC881713B9B2023
            9093E9FBAB8B0F57D6E7D6DED9A1A78D712BFD802FFD05D276DC8FE1503F9FF9
            BA311B3FF96C7F2A7EAA77A9FF00430DBFEB40402A7B1F7DEECDC71A98D8107F
            854395C6607D77F55E90DC71F4F67F69EDA582904DA339FE9313FC850749DB73
            90F0900E875C3527C21EB00BFE8FFE38F456DCA8822F1415F43D6FB4A4C8C512
            00AAA993ABC5D46415405161E5FC7B1359F205A424347B7443E7A013FB4827A4
            AFB839E321A7DBD168F9298FF8CDDE183C950EF2EA5EBCCB9A986554C9C7B6F1
            38ECED2929A564A2CEE369A972B4B2C6D665D335B528B836F67DFD40DA7704F0
            2FF6C898114A850AC3EC65A30FDBD31FBC268C929211F9E3F61C75AA67CABF8E
            B4DD1DBA56B36AD755E57AFB3F5B549829EBBC6D90C44D1A898E17253C650564
            A9196686711C62489791AD5BDC09EE27214DC957F0B432997699EBE1B1F89587
            C51BD283500410C000CB9A021803EDBAFC5EC6D51499788F23F31FEAC7452FDC
            71D1975FFFD0D03F1B8DC8E62BE8F1588A0ADCAE532151152506371D4B3D757D
            6D5CCC121A6A4A3A68E5A8A9A895CD95115998F007BD8058D00A9EB4CCA80B31
            0140C93E5D5CAFC74FF84F9FF365F937FC3E5D89F16333B6B1D90A582BD729DA
            5BA368F5C45498FA954682BB238CDC799A7DC3450CEAF7447A2F33D8E943C5CD
            2E364DCED2DA3BCBCB630DBB7C25C852DFE9549D67F25C79F41CB2E6DE5FDCF7
            0976BDAB705BABD8FE3108675415A55E403C35CE32E0938009C75747B03FE113
            9F38F2F163EA7B1FE55FC61D94B38864C8506DCA6ECDDED91A256556929D5AA3
            69ED5C6CD531DCA92B3B47A85C330FA96A08C9FD46603E401FF091D093A3C5B2
            FF00E1133B271AB036FDF96FB8376CC1156AD36E6268F65D2C8D7058C095BB7B
            7854C26C2C354B20E6F6FA58CA21B20FEDDEE9BFD2AC6BFE166E9B3E37E109FC
            FF00CC3A387B0FFE123BF1136220351B5F6AF62D5809FE59D8DD91DA55ACCC97
            21CD0EDAA1DB789F55CDC7DBE923EA0D858DA0BAE508BFB4DB6EA43FD261FF00
            3EB2F4C32DE1E12A0FCBFD8E8D7EC5FF0084FCF58F551D5D6FD2FF000E70350B
            20923AFABD9192CE652391428578F2D9FDA798C944C428B95945EC2F7B0F6716
            DBFF0027DB6576292BFE96363FB5989E9A6B7BB6E3703F9F43A41FCAFF00E476
            1E9CD1ED6DE3D03B7A92CA1697174DBAB194E02FD07828368451F03FC3D9D43C
            F5CB508A2ED97207C8463FE7EE939B0B93C655FE7FE6E92D95FE577F332B357D
            B76F746457BE9D753BF85AFF00F05DA6C7DAF4F71B95D295DA6F0FFCE3FF00A0
            BAA9DBAE8FFA2A7F3FF3741965BF943FCE3C816D1DE5D091024DAF53D8BF9FF5
            B68FB5D1FBA1CA89C763BC3F9C5FF4174D9DB2EFFDFE9FCFFCDD06D94FE499F3
            AB225BFE33FF00C7F40D7FAD4F650FAFFADB3CFB5F1FBBBCA91FFCB06F6BF6C5
            FF00417543B4DD9FF474FE7FE6E90190FE429F39EBAFABE437C7C173FF002B1D
            9BFF0011B3FDAD4F7A39513872FDED3ED8BFE82E9B6D96E9BFE2427F3FF3748E
            ABFF0084F2FCDCAB24C9F223E3D1BEAFACBD9A7EBFF927FB54BEF972B2F0E5EB
            DFDB17FD05D50EC57478DCA7F3FF00374C537FC271BE67CE4993E427C7824FFC
            DDECDFFEC3FDBDFEBF3CB23872F5EFED8BFE82EB5FB86E7FE5257F9FF9BA62CC
            FF00C2703E66458EA9962EF7F8EB5D2C713B4748F57D994CB33AA92B19A86D93
            388B51E2FA187B7A3F7EB966B43B1DF28F5FD234FCB58FF0F553B05CFF00BFD0
            9FCFFCDD6B3DFCD13E12FC86F8C1B53756CBEFAEBCABC2BCD4F3E4F6A6E4C555
            C5B8367EE4AAC0CD155BC980DC18D2627AA4A624B5254253D6AC6F778429F68F
            9D398363E76E4EDDE6DA2E84AF005974905648CAB0A92873F0971A8557273D5E
            CADE7B1BD844C940D515F2351EBF6D3AD6E7DE2FF428EBFFD10BBF9107C09EB0
            F8C5F1F36AFCC3ED0DB189DC3F227B970C9B8F6255E66923AD97AABAE328A5B6
            E43B720AEA54FE17BAB775015ADAEAD8C79D29278A9A3755F389723FDB0F6F3C
            4B2B6DEAEE106EEE06A4A8FECE33C08AF0671DDABF84802956AE06FDE1FDF316
            FBBEE3CA5B6DD94DB2C9BC39B49A19A71F1AB50E6388F604340640C581A2537F
            5E9DD8D4FB0B60E03146055CC5563E9325B92A99156A2AF39594F1CF5BE57E58
            C5492C861856F648900FADC98479AB78937ADEEF6E75D6D55D9621E4235242D3
            E6C3B98F9927ACB8F6E395A1E54E51DA36FF00080DC5E1492E1A9DCD3BA867A9
            F4427420F2551E75A8A9EC3DD0EBAF7BF75EEBDEFDD7BAF7BF75EEBDEFDD7BAF
            7BF75EEBDEFDD7BAF7BF75EEBDEFDD7BAF7BF75EEBDEFDD7BAC1529E48245FEA
            A7DFBAF754BFFCCBFE39ECAF913D39D8FD43BE68A9A5C2EFCDB598C2C55F351C
            75B3EDDCAD650D44387DD38C8A478F4E576EE4244AA80874D4D1E863A1981516
            F733DA3B496EE5599194D3CD5C15653EA082411D55955C00C2B9AFE63AF8EF76
            06CCCAF5CEFADE7B0339A7F8CEC8DD5B8369650A2B2C6F5FB7B2B5589AA96257
            F578659A90B21E6EA41F69FAB75FFFD2315D6DBEA9327D59D1F4DB75D63C04BB
            27AC23C1C5190B047889705825C6C68AB7558A3A3280017B016F7D3CE53DAECC
            72CEDB756E83E9DB6E8D969FC3E082BFCA9D7CF0FB97CC3BA3FB83CC1B75F4A7
            EB937CB88E4A9FF44174EAF5FF006D5F2EB76B8C5A341FD1147FBC0F7CC46F88
            FDBD7D0E28A2A8F975CFDEBAB75EF7EEBDD7BDFBAF75EF7EEBDD7BDFBAF75EF7
            EEBDD7BDFBAF75EF7EEBDD7BDFBAF75EF7EEBDD7BDFBAF75D372A41FE87FDEBD
            FBAF74423E58621E6C3D4CCABC8463F83F83CFFAF7F7EEBDD7C71BF9846DA976
            97CE0F957847130483BD7B1EA695E6560D35164373642BA9250480B22B41503D
            438241F6B2F6CDECAE4C0C3F0230FB244575FE4C3A2BD9B738F77B117B1914F1
            668CD3F8A19A485C7E4D1907E7D7FFD3427F2E9DD6FBFF00E287C49CCC928A99
            9B6B6CCDBF50509B09F6C66BFBAF240033332F8FF84841737B0F7D2CF6AF7017
            DED3F2FDD6AAB2EDAF193FF347C48BF968EBE7F3EF1FB21DA3EF35CF1B688884
            937E8E703D45DF83735FCCCC7AFA19FBE69F5F407D7BDFBAF75EF7EEBDD7BDFB
            AF75EF7EEBDD7BDFBAF75EF7EEBDD7BDFBAF75EF7EEBDD7BDFBAF75EF7EEBDD7
            BDFBAF75EF7EEBDD159F91B89FBCDB758745C889CFD3E9C1FA7F4F7EEBDD7C7E
            7F9C86DBA9C17CF7EEBAF921094DB8B7266EBE9E552B6964A1DC59AC3552D81B
            864931E2FC004116FCFB1DF3FD8359EE1B14C5682E367B1907CE96E911FE719E
            A1AF64B798F74D8F9C6D55EB2587356F1030F4D57D2DC28FF799C7F3EBFFD424
            9FC89F71BEE4F8B3B0B0B5152D3BED1EFBCA6DF891DF5BD351576676D6E18235
            0C4948C4B9B94A0FA0E40FA719D7EC06E0D3FB4DBCDB93536D3DDA81E81A1494
            7E459DBF9F5C6CFBED6CA967F799E54BD58F4AEE165B748C69C592E65B727E64
            24483EC03AFA69FBC14EBB27D6A47FCD43F9B6FCAEF8C9F3FF0033D5DD29D954
            B8FEA5EAFC675454EEFD86DB376365D372656BA869778EEEC5CBB872FB6B25B8
            E85B2DB7F2D4F464D3D54669DAED1857049C99F6E3DB3E5BE61E4A8B72DDB6F2
            DBA5C34C124F1245D0A09443A55C21D2C0B641AF9E3A0CEE5BA5CDBDEF870C9F
            A4A16A2833E6734AF0E8E1FF00387FE695BB7E3F749FC6B7F89FD834180EC2F9
            094B43DAD45B9930BB6F754941D331E0E1A8A69C63B71637358459374E6F394B
            0C72185E455A1A908548BFB0B7B59EDD5B6F7BBF300E65B167B2B126129A9D2B
            3EAA1CA956EC55248AD3B96BD2BDD7707861B7FA6928F266B83DB4F9E324F4AB
            F8F7F3B7BEBB47F92C76CFCA9C96F849FE4575B6D1EEAA39F7F26DADAB00FEF4
            ECDCE57546DFCA1DB1061536A16A6DBF5D42862345E194A6B74258929B7DE4DD
            9B6EF7676DE5B8ECE9B15C4B01F0F5BFC0EA350D7AB5E583675547007AB417B3
            49B4CB725FF5D436683883E94A70F975517D79F397F9DAEFFF008AFD8BF3536A
            FC80D9597E97E9FDC75B81DEF4D93D89D374BB9A29F150EDCA8C8D5C1B797ADA
            98E4B134D06E9A4690C55D14E57C8517D1CC9B7BC9FED259731D97295CEC92AE
            ED751868C8927299D4002DE29A31D0D4AA91C2BC7A2B8EF37792DE4BB5981850
            D0E16BE5E54F9F5733D3DF3FBB1BE4D7F28DEDFF0096B55BD64E82EE0E99DA3D
            AADB9F786C6DB9B5371E36A777F51E07FBC54B518DDAFD8588DCB87388DF5475
            14295146C0CD04B532474F51195471027B8BCAB0727F33DC6D567333D9346B2C
            7ABE20AF5ED63E654822B415143C7A106DB746F6D96575A3D483F68F3E947FC8
            87E44FCA6F967F09EB3E407CAEEC29BB03766F4EDDDED8ED9753FDD1DA1B3E87
            1BB1768D3E176EA414145B430181A5AD4A8DD9479566A8996591AC175596DEC0
            DD2F6A0341D5B4617B57ABF72D66E1C7EDDEC8D859FC86D10CDBAE8709BC36F6
            56B36C2A33A3B6E1A6A1C8D44D8508F1B026A562B1523F07DFBAAF4F193DE7B3
            F0A30CF99DD7B6B12BB8E682976F1C9E77174033D5154236A5A7C31AAAA88652
            6A95954C6906B670C2C0DC7BF75EEB2E7F766D6DAA94B2EE8DCDB7F6DC55D31A
            7A17CFE631D874ACA81A018295F23534E2A260645F4A5DBD438E47BF75EEA5E6
            F3B85DB58AADCEEE3CC62B6FE131B09A9C96673790A4C562B1F4EA4069EB7215
            F2C1494B0A922ED23AA8BFD7DFBAF74D1B5B7EEC6DF38993706C9DE9B4F78606
            09248A6CDED6DC587DC188865853C9345264B135957471C914643302E0AA9B9E
            3DFBAF750DFB3BADA2DB159BDA4EC2D8F1ECDC7D43D257EED937660536C5155C
            73253C94D579E6C80C5535424F22A14795583B0045C81EFDD7BA48F6CD2C197D
            AB3CF4D245554F5147E7A7A881D26867866883C33432C7AA392292360CACA486
            53707DFBAF75F246FE7B5B55A8FE48E5F7328B21ED0EE6DB92592F76A7DE32E4
            A9C349716D22A24B0B1BDCFD2DCCE3EEDD894D87DB3DC74FC7B4C7193FE92389
            C7FD5C34FCFAC3FF00BB1EF2B3739FDE13622FDD0F334D381FF3567B98D88FF9
            C2B5FCBAFFD5A85FF84E46EB3539DECDEBD79D7541DA3D31BBA8E0D7EA4390CA
            5460B213B272551FEC6956F6E74FF87BCACFBB9EE5A361F72F6B6381682603FE
            6D4E8FFF003E75CDCFBF6EC1E273AFDDFF0098A35EE6DC64B573FF0037AD258C
            7FD5D3FB7E7D7D5CBDE29F5D23EB467D93F1C68BF994FF0031AFE683053B4B93
            38DDA1F2133BD67905994AC1BFB6F6F3C06C8EA3952595B4241532605A265242
            FDAB4ABEF302F37E7E40E44F6F19BB754B6CB28F58DA36926FD9AABF6D3A07A5
            B8DC2FF71F90623ED0405E806FE5E3F1977D7CEBDEFD8F4DDB15198CDEC7F887
            F137B136D6DFC6E5E1965A5DBD9F970FBEA83AAF6152EA89A1A57C0EF0CD64F3
            5A1AF2F931A14FF6483BE79E60B3E4DB3B06DB5512F374DCE2662BC597546669
            0FAEA4548FD3BFA62C6D9AF5E45958948A2207CB8D07E4493F974733F96FEFE9
            F37FC947F99E75DD470FB1E8B746E48559AEF1C1D83D6D86578C2DCE88C57ED2
            9CFF008B16F613E7CB258BDDAF6F6F94FF006C514FFCDB95BFC8E3A5760EDFBA
            3708CF019FDA07F9BA043F976FF2ECF973F387E2A6F2A3EB3F96D07517C78C87
            6BE676CEF5E9FC8BEF4ADC36E4DC987C36CCCC566E2C86DFC15663F0B975A9A7
            AAA0558EA65E64A252C3D2A41B73CF3D72C7287325A36E1CB26EB7C5B6578E71
            E186446691428660596843701C1BA6AC6C6E6EED9C25CE983510573938CD07E5
            D58AFF00352EA8DB5FCAEFF918EE2F8D3B0371576E4C876D7626D8EBFDD1BBB2
            14F163B23BAB35BDF3336FAEC2C9D3E32964992828AAF6D6C69B1D052892668A
            80223C9238691B1879C79A6EB9C37DB9DEAEA158F52AA22035088A28AB53C4F1
            24D0549240031D0A6C2D16CE15855AB4A927D49E8A47F331DF5DC7F023F931FF
            002DEF875D67B9B21B0F21DF7B4D697B7776E02AEAF0D998A8A6C0E2BB1377ED
            1A7CBD04F4D2525167F7776594C8BA32BD4D15149092229A50433D2C5C963D35
            7F385F8A9D29D7F9BFE515FCB6FE3AEC0D8FB77736F9CE50E33776EADAF8AC7E
            1F756F2C1EE5CCEC2D935995DDD9DC724794CF526F1CD546633558F5D2CE92D5
            D1ABAFF9B36F75E53F113D0EBFF0A72D83D6590A0F82BD2FB0FAFF0065E3FBD3
            B7BB569B696DBDF74F8DA5A4DE1B7B62ED3A0C4EC6DB7B6A973B122D663F6B9D
            CFD8B473AC08EB1ACB41E4401D49F7E1D7909CE71D337F33DDBB8FF90DFCDDBF
            94AFC093BACEFDDBFD2184D8F9AECB492B57275A7274995A7DD5B9E5DC43CD51
            2C3B8331B07A6E9AA2613FEEAC591491AEAF73EEB4B8563D3AFCAAEEAED7F915
            FF000A04DA9F1BB71F5DE4FB9BAAFE2DED38F77F53FC63CAEFADBFD7BB1BB0BB
            223EACC76FB8BB1F7549BB436DECFBE3ABF73FDC53ACB4D5F3A52E153EDE16B5
            4AB7BAD8C25471E8E9FC1CFE5DDB3FE316F5FE635DBFF29774743EE3CC77EE26
            ABB6FB4BE1775854459CE9CE9BEB39F716EEECAC247BA3099CA1C41DC35B5B3E
            2A7A6A6AD970D8FA178682A161599246D1AEAA4D7481D52C7F29AFE54B87FE65
            1F013E575766B7C65FA5315D8BF2830557D4D558AC555EEAD93B5A3D8740B9CD
            D6B43D5F57B8701B72B24CA45BCE1C32E4B5C790A6A6C7082398446A22977D5D
            9A8475B9EF59F4961FA13E38F56F43E03319ADC585EA2EB4DA9D758CCEEE29C5
            566F3147B4B054985A7C964E451E315558947ACA25A388108802A81EF5D364D4
            D7AF9857F3D8DB51CD99EEBC99A7579B6F7C95DD7224A503B53C192DCFB9B1B3
            947E4C62595E25247D781F9F7953EEBD809BDA4E46BB09DF0C5666BE8AF6C54F
            E45B4FF2EB9B7F76ADE4DBFDE6FDE1DACCB48AEAE7751A7D5E1DC43AFE613C4A
            7CABD7FFD6D79BFE13C1BD8613E7A6276449ADA3EC2C360E18505B43576D7DF5
            B5F39116F50F5FD88A90BC1FD4791F99BBD8CDD3E8B7EE68B16F86EF63BB51FE
            9A341283FEF28FFB7AC44FBE2F2EFEF6E4DF6F37745FD5DB79BF6D73FF0034E7
            91AD987E6F2467F2EBEC2045C11CF22DC1B1FCFD08E41F708F5977D14DF8F5F0
            73E2C7C54DCFBD779F41F53E3F606E7EC6820A7DE999A6DC1BBB39579E860C9D
            666635A83B9B3F9A8E0FF727909A6630AC65DDFD448000126F9CE1CC5CC96F67
            69BD6E8D3DBC06B1A95450B50171A156B80066BD2682CEDAD99DE08B4B371C9F
            F29E977D4FF197A23A34F691EA7EB6C16C91DD3BC32DBF7B39314D9068F756E9
            CDC524592C85545595B551D143324D269A5A410524465731C4A5D8947B8F306F
            3BCFEEE3B96E0F30B4896386B4EC45E00500AF964D49A0A934EAF15BC30F89E1
            4606B353F33D02DD6FFCB8BE17F5175FF6FF0056F5D748E336D6C1EFBC3D1603
            B6F6DD3EE9DF7574BBBF138E8B2B0D152D44F92DD15B5B8DF0459AAA50F452D3
            4844B62C74AD8DAFF9F79B373BDDB371BEDDDA4BEB272D0B948C142695200400
            FC23E20463A663DBED22496348688E28C2A73FCFFC1D0C9F1DBE31745FC4FD91
            5FD73F1F760D275D6CBC9EE4AEDDD5D82A2CAEE0CCC551B8B27438CC6D6E48D4
            EE4CB666BD249E8B0F4D1945944604408504B1255BEF316F1CCB791DFEF77A67
            BB58C2062AAB45049028AAA3058F9573D3D05BC36C8638134A135F3E3F9F4CDF
            2ABE21FC7BF9ADD5FF00E877E49F5F53761EC48B3D41BA68281F2B9CC0D7E1F7
            2E329ABE8A833987CD6DCC8E2B2D415D051652A612526D12433BA48ACAC47B26
            E9F048E1D02BBF7F95F7C24ED2F8FD80F8C9D8BD4153BDFAAB6A671773ED7837
            5F61F656E3DE3B7370AE262C0FF15C2F6366F77D7EFCC716C353A52B53479014
            4D4E8B1184C6A147BAF6A35AF48CCE7F27AFE5DBB9A87ACE0CF7C7D194CB7511
            80EC7DED376776FC3D9542298D1351C593ECAA4DFD4DBEB3F498B38F87EC69EB
            B215106395345224084A9F75BD4739E883FF00327F8F5BAB7DFC98F89BD6FBBB
            F967A7CAEF823D5DB4A0A48BB33AAF7CEF5C77C89EA5DC590AA9687294D8B7C3
            F6AECECAE5B6DE2E9B0184AB9692B21AD9323FB92C55B155C7A4FBAD8E0D9CF5
            03F96A7F2C6DF1B7FE74F707F312EE9EA0C6FC79C2498FC8EC1F89FF001CE6CA
            E3B70EF8D8FB2E6C5516D597B13B473189CBEE0A03BEF716D7A2984E92E47259
            19AB32F5F355CE5FC45F7D78B6283AB4EF92FF00CB67E1CFCB4EC2DB1DBDDC3D
            593CBDC1B369A92836E76CEC3DEBBE3AB7B1E8282824A99A8689B76F5DEE2DB7
            95AD8289AB261019DE5929D657589915981D755048E07A13768FC34F8D9B17A8
            3B13A2F6BF5A52E3BAF7B77199AC4F6AC4F9FDD790DDDD934FB87112E033351B
            E3B27279DACEC7DCF93ACC2CCD482B2B32B2D5434D68A291235551EEBD535AF9
            F4AAF8E9F1ABA43E26757E33A63E3D6C2A0EB6EB4C3E4B3398C7ED8C7D7E6B29
            0C393DC15F264B3158F5FB832597CAD4CD59592962649DC28B2AD94003DD7892
            78F42FE6A21363EA108B831B0FF6E3DFBAD75F32EFE713B5BF8EE4BE6863E184
            4D326F9ED3CA5228D3713E1B7C6432A8CACDE943E3A3617B8E09E6D7F79C9CE5
            B7ADEFB27651B2559764B4907C8C51C5257F629FCBAE3AFB51BE9DA7EF77BA4E
            B2D23939BB72B73E845C4F73001FEF4EBF981D7FFFD7D513F92EEF45D91FCCFB
            E1C55486D06E2EE0DBBB22762FA1546F19CE0A9D8F04BDABAAE2B0E2C6C79B58
            8D3903711B673559CEC7B2486E213FF37EDA5887FC69C1EA27F7B7606E63F6E7
            75B245AC90DD58DD0F5FF14BEB6B96A7FB48987E7D7DACFD82FA963AF7BF75EE
            BDEFDD7BAF7BF75EEBDEFDD7BAF7BF75EEBDEFDD7BAF7BF75EEBDEFDD7BAF7BF
            75EE9BF2794C66131F5996CCE4683118AC753C95790C9E4EAE9E831F434B0A96
            9AA6B2B6AA48A9E969E251767765551F53EED1C724CE9143196918D0000924FA
            00324F5E24015271D137CAFF00322F80D85CAC985C8FCBFF008FB1646298C124
            50F666DAAD812656D0C8D5D435D53420AB0B1FDCB03F5F62A8F9079D25884A9C
            AD7DA08AFF0064E0FEC201FE5D2437F640D0DD257ED1D1A0D83D97D75DAB8087
            75758EFCD9DD89B6673A21CFEC8DCB86DD387793486310C9612B2BA904CA0FA9
            0B865FC81EC3D7BB7DF6DB3FD36E3652C1703F0C88C8DFB1803D284923917546
            E197D41AF4ACC81514936A200D0DF5FF005BDA4EAFD7CE1FF98E474994EE5F93
            18697434798EC4EE2C5B86E54AE43706E2A421B9FA7EFF00BE8ACD1C777EDB6C
            564F4A4DB1C287FDBDAAAFF97AE11DACF3ED9EFE7396EF15755AF385D4C29FF0
            ADC5DFFE7DEBFFD0D1EFE2BEFC4EAFF937F1DFB226C81C553EC3EEFEABDDD579
            2540FF006345B7B7C613295B55A3FB5E1A4A676E2C78E083CFB76195E09619A3
            F8D1811F6835E98BAB68EF2D6E2D26158A54643F63020FF87AFBB9D2D5D357D3
            535750D4D3D65156D3C35747594B347514B574B511ACD4F514F510B3C53D3CF1
            38647525594820907DB5D3FD49F7EEBDD7BDFBAF75EF7EEBDD7BDFBAF75EF7EE
            BDD7BDFBAF75EF7EEBDD7571FD47FB71EFDD7BA003E4EFC90EB8F89BD1FBEFBE
            7B4EBDA976AEC8C60A814148D1365F71E6EB664A2C0ED6C053CAE82AF359FCA4
            F1C10AFE940CD2C85628DD94E797B60BFE65DDECF66DB52B733352A7E1551967
            63E4AA2A4FEC1923A66E6E23B585E690F68FE7E807DBD6A990EC4F963FCDD36E
            F64FCCAF991DAFB97E38FF002F8EABC5EF0DEB8FD99B3A8B25988EBF686C2A3A
            FCB6E56D91B3942A6ECAEC5E231F34757BA7254B5C6A6B11E1C7D1BAA3430E43
            6E3BDF28FB3B6E367D8AC12F79B0A0324AFC56A2A0BB0A95078AC085485A176A
            90487A282F3796F16790A5A570079FD9EBF363F97564BF1EBF939FF277EFAEA7
            C66F8E95C8E73BD367E76962349D8986EF2DC191C8433CB4F1CAD4D5D4BB76A7
            0B4180CDD3A480CD43558EA7A8A773A64850F1EE3A97DECE7D92512A5E5BA2FF
            000AC29A7FE35A9BFE35D197EE4B151A4C6D5F9935E8B1FC85FE4D1DEDF08AA6
            B7E4CFF2B9EEDED0A5CEECF80E6B3BD3D95C9D3D7EE4CEE2B1CBF795F4F85ACA
            3A5A1C1763D349141EADBF99C74D355A02B0D449318E261A6C7EEA6CDCDAA9CB
            FEE2ED16E6194E959C021149C02C092D11FF008646C00F3502A7A433ED335A13
            71B74CD51C57CFF2F5FB08FCFA3C7F07FF009B76D8F97DF1FF003394DD9458DD
            9BDEDD6BF6985ED6DA348D2D3E3AA2A2A629C63778EDAA5AD924AE83019E7A39
            91E9A6679B1F5B0CB4F233011C92467EE2723BF266EC2382532ECF382D0B9E22
            9C51C8C165A8C8C3290C3CC032DBAF85EC44B0A4CB861FE51F23FCBAD19BF98D
            FC8DC3D1EF2F903BEFEF95E9F29BF7B08E0150F924C864B3DB872C31894CA84E
            B03CE266370A2342491F5F7917CCBCD6BB1FB7BB619A4D3729B6C30A2F9994C0
            AA00FF004B963F253D72CB907DB67E73F7C3983E9212FB7CBBFDDDDCCE3E15B6
            176F23313C3BC111A71AB3AE295EBFFFD1F9FF00FBF75EEBEA21FC8DFF009EF7
            4EE5FE24F41746FCC2DD11F5E6E7D8FD6DB5B66ECCEE0CAAD6566D1DD580DAF4
            306DBC4E177B6469A0A89F6E6EAC2D2D02531AFA941435F044B2CB34551A84B2
            BCFED9EE5BAF2E6CDCD1CB11FD4453C03C58411E2248954919013DEACC858A8E
            E5268015E052BB9C515CCD6B7474B2B61BC883915F422BF67E7D6D0389F91BF1
            F33F8FA6CAE13BD3A7B2F8CAD884D4990C6F656CDADA2A9899432C90D4D3E664
            8A442A4720FB8F25D8F7B81DA39768BA590710627047E457A3113C2722653F98
            E9D877874BB0BAF6EF58B0FA5D77EED5617FE975CA917F6DFEE9DD7FE8D971FF
            0038DFFCDD6FC68BFDFABFB47585FBDFA4E3BEBEDEEB216FFB3EF6B7FF005D7D
            EBF756E9FF0046DB8FF9C6FF00E6EB7E247FC63F68E9B25F91BD0F01B4DDC3D6
            6839B9FEFD6D836B7FAD943EF5FBAF73FF00A374FF00F38DFF00CDD7BC48FF00
            8C7ED1D46FF6673E3A8D61BBC7AA94C62EFAB7DEDB5B0FEBCE47DD4EDF7E38D9
            4DFEF0DFE6EBDE247FC63F6F49DADF98DF15F1E5854F7F755295201D1BCB0B2F
            37B7063AA606C47BD7D05F7FCA14BFEF0DFE6EBDE247FC63F6F4C753F3AFE1ED
            22EAA8F917D5482E4586EAA076E39BE94766B71FD3DD4D9DD8E36B27FBCB7F9B
            ADEB4FE21FB7A6497F9867C288582B7C92EAF662BA82479F8E43FE0A74464073
            6E05FDEBE92EBFE51A4FF793FE6EBDAD3F8C7EDEB5DEFE743F22B6BFCD6F90DF
            057E19F4A6FBC66E6D89D85BF3199ADD397DBD90796924DC1B9F74506C0C40AA
            54D2527DB3B7AA72D5284A9E6A432DF483EE79F67D23D8368E70E6ABA808B882
            02A81853B550C8D4AFF13041F97443BC169E6B3B453DACD9FCCD3F90AF57E9F3
            5B656D5EB8FE597F2BFAFF00636128B6EECED99F0B7BBF6C6D8C163A210D162B
            0986E9BDCB438EA28140B95869A15058DDDDAECC4B127DC0D7B77737F75737D7
            93992E66767763C4B312493F9F4208D163091A0A28A003AF9927C6FF0094DF21
            BE256F2A7EC4F8E5DB9BC3AA374114CD917DB990BE0B724300063A2DDFB52BD2
            B36CEEDC7FE04590A4A809F54D2D660C74F900F1EB705F837FF0A73EAEEC2A1C
            6F5E7CEADAB4BD2FBD6548E869BBAB63D1E4B2BD499CA9112430CBBA76F6BC96
            E9D835F5D3037921FE278DF23DDA4A48ECA3D4E9B287CBAA2FFE715D9998F821
            F363B83B8FE3AC98E876C77EF4F4BBF62C462EA64C7E02AA1DF667A3CFD6D2AE
            3D522F56E3C27F1CA5210AA4F5448FA9F736DB6F6376F6F6DA6DCEDFEAA6DB27
            140C69A821529A8D09D211F4B0142CAB4A8AD404379DB2E6E9770DBF6FDC0D9C
            D77114F155433461F0EC80900494AF86C6A11C862AC0693A7F76AF726F5EE0CB
            FF0013DD990069E9E499B1987A3F2458BC6ACCDEA30C0F248D2543A001E672D2
            3DB93C9F718F30732EEBCCB77F55B9CF5A57422E1101F255CFE6492C7CC9E93F
            24F2072D7B7FB69DBB97ACF497A1965721A6998568D23D0569534550A8B53A54
            54D7FFD2F9FF00FBF75EE8FF00FC4DF90549B5F132F596E5ADA7C7D1AD5C957B
            5EBAA25114266C8CCEF5D8B9E492D1C6D35538784EA019E4616BD8FB9BFDAEE7
            F8F67825E5DDCE6096ACE5E17268AACDF1231F20C68CA4E036A07E21424DD76F
            33B2DC46B5602847CBD7FCFF002A7A747CD7B071CAC7C94F4C5CF258C3116247
            1A8965B1D5EE7F5E67D18673FB7A0FFD379E9FF57EDEA1D4764E392FA20A7FF6
            11463FC7F0A38B7B625E6BA644A69F6F56FA4A797495C876752C4ACEE296141C
            1791628C0E7F2EFC0F65573CDE6352D24E157D49A0FE7D3AB640E02D7A0D733D
            E7B5A80DAB73F82A52756857ABA62CDA6C1822A33BB32EA17B5ED71EC3377EE2
            EDB16A0FBBC551E8DABFE3B5E9526DF29E111FD9FE7E82FCAFC9AD8B04AF12E4
            DEB19185DA871B51344DA9437A2668E38DED7E6C4D8F1EC3375EEA6D69A952E2
            693FD2A9A7FC68AF4A536A94F1503ED3FE6AF41AE4BE5261CBC894781CA54A82
            CA934E68E9D2400902411AC92481481700D8F3CDBD86EEBDD5624FD35948DF36
            70BFC806FF000F4A976BF5900FB0741EE47E4B6E3A989D6830189A291BF44D51
            2CF90D07502D78C25206BADC0FA58F3CDADEC82E7DC8DEE605618A28C7AF731F
            E640FE5D3EBB742BF1313FCBA4457F78761D7AE94C9D263FD418BE3F1D491484
            00C34EB9D67214937E2C6E073F5B92CFCE7CC737FCB45957FA2AABFCC0AFF3E9
            E5B3B65FF42AFDB53D5A8FF295F9295FD6FF00207617666E6CAD566321D47DB9
            D6DD9724354C58BED7C367E80E76087420451F691CA2CA355E4FF5BDCA9EDA6E
            175CD1B5F3872E6E37F2CB7735A9319762D40CAC86953801CC668319E8AB738D
            2D65B3B98E30115B3414F43FE0AF5F548F9C7BDB6D6F3FE5C5F303706DACC50E
            6B099FF873DE797C2E571F511D4D16571395E9EDCB5B8EC8514D11649E96B692
            7492375E191811F5F7034D0CB6F2CB0CF1959918AB29C10C0D0823D41C1E8FD4
            86D2CA6AA69D7CED3E0AFF002C3F977FCC132F4D0F46EC138FEBAA7AA147B87B
            C37DFDE6DFEA8C0BC0615ACA78336B495357BB7354CB3A938FC3C15950A48F37
            852F20A74F120713D6E6DF13BF92F7C2CFE5EDB768B7F6E5A3A7F907F2131917
            DF276BF63E3695B19B63271DDD1FADFAFDA7AFC06D36A47B786BA535B9752BA8
            55A06D035D36589FB3AD2BFF00E1435F23B07DB3F25BB1E9F0F3C75943D7DB47
            11D546A2091254A8DC15393AFCDE6E343A80FF007192E73EDA50395929A416B8
            F726C4A769F6EE7F1B12DECB551E742540FDAA8CDF611D151226DC4007E019FF
            0057DA475AB67B8CBA33EBFFD3F9FF00FBF75EEBDEFDD7BA10719DA5D8386A54
            A3C76E9C9474D1711C53FDBD768058B90AD5D054B85B9E05EC070381ECE6D798
            37AB18C436BB9CAB10E02B503EC0D5A7E5D32F6F0C86AF1827AE35FDA1D81928
            9E1ABDD59631BDB5253CA9457B306003D1253B817FE8791C7D3DEA6DFF007BB9
            044DBA4E57D03103F60A0EB6B0409F0C4BFB3A4855E4F255E00AEC8D75680DAC
            0ABAB9EA00600AEB02691C6BD2C79FAF247E7D95BC8EE6AEC49F99AF4E00070E
            9BFDB7D6FAF7BF75EEBDEFDD7BAF7BF75EEBDEFDD7BA103ACFB0733D63BC317B
            B70AE3C948E60AEA56178B238AA86415D41280C8489A34054DC699155BF1ECEB
            60DF2F797775B5DDAC1FF5A3390783A9C3237C987EC34232074CDC4097313C32
            0C1FE47C88EB70EFE5BFFCF4319B17A76B3E3977CE226EE6F8CB9FC1653664D8
            99556BB74EC8DB1B8296A283706CBCCE1EB27A63B9F6254D157491C74E1A39A0
            8256585A684A431CA3BE6D1B273FA1DFF97AE521DE1856689F1A9A832D4CAB79
            6B00A3F1C1A9E8AE09A6B022DE752611F091E9FE5FB388EB63AD99FCF7FE0760
            36262711B43B4F65ECBDBB82C5C14387DA14BB7331B523C1D0D326883198EDB1
            0E02916961A751658A9A131FFA9BFB8F24E4BE668DCC676A73F30C847ED0D4FD
            BD18FD6DB30AF8A3F9D7AA6BFE619FF0A12C7EE9DAB9DDA9F1CAAABBEE2B69AA
            69EB3B4F71D24B88C36DFA675759AA36FE1728916432996F0DCC3255430C10B0
            0DE39CFA40836CE4A8EC47EF0E67B88E2B44CF861812DF2661803FA2A4B37014
            E934B7A64FD3B6525CF9D3FC1FECE3AD1DFBA3B66BBB3B3F34DE7AAA8C6435D5
            75A2AEBD9A5AFCCE52AE5964ADCD57492EA9BCD5724AC40625C86D4FEA621487
            9A7984EFB748B0AE8DBE1148D787C8B11E5500003C801E75E945ADBF80A4B1AC
            8DC7FCDD027EC2BD2AEBFFD4F9FF00FBF75EEBDEFDD7BAF7BF75EEBDEFDD7BAF
            7BF75EEBDEFDD7BAF7BF75EEBDEFDD7BAF7BF75EEBDEFDD7BAF7BF75EE840EB3
            FF008FAE8FFE3EEFD2BFF1E67FC5D3FE0552FF00C09FFAB5FF00C76FF907D9AE
            CDFEE747FEE57FD43FF6BF97CBD7A6E5FECDBE1FF6DC3F3E8FDC5FF0107FC7D1
            FA17FE067FC09FA2FEAFF1FF0089F739C5FD88FF009287FB7F8FA236FED3FD0F
            F2E1D145EF4FF81B49FF001FB7EA4FF8BEFF00C587F4D57FC00FFA6EFEBFF36B
            DC49CD9FEE58FF0073BE23FEE470FF0069F2E8D6D3E13FD9FF00B5FF002FCFA2
            FDEC25D2BEBDEFDD7BAFFFD9}
        end
      end
    end
  end
  object ColorDialog1: TColorDialog
    Color = 147
    CustomColors.Strings = (
      'ColorA=5A5A5A'
      'ColorB=FFD304'
      'ColorC=060606'
      'ColorD=000093'
      'ColorE=FFFFFFFF'
      'ColorF=FFFFFFFF'
      'ColorG=FFFFFFFF'
      'ColorH=FFFFFFFF'
      'ColorI=FFAF80'
      'ColorJ=FFFFFF'
      'ColorK=7D3E1C'
      'ColorL=FFFFFFFF'
      'ColorM=FFFFFFFF'
      'ColorN=FFFFFFFF'
      'ColorO=FFFFFFFF'
      'ColorP=FFFFFFFF')
    Options = [cdFullOpen, cdAnyColor]
    Left = 218
    Top = 363
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [fdTrueTypeOnly, fdForceFontExist]
    Left = 179
    Top = 365
  end
end
