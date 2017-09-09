object TaskRecoveryF: TTaskRecoveryF
  Left = 0
  Top = 0
  Caption = #50629#47924#44288#47532#49884#49828#53596' '#49325#51228#46108' Task '#48373#44396' '#54868#47732
  ClientHeight = 614
  ClientWidth = 822
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 369
    Width = 822
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ExplicitLeft = 8
    ExplicitTop = 354
  end
  object RecoveryStep: TAdvSmoothStepControl
    Left = 0
    Top = 41
    Width = 822
    Height = 65
    Fill.Color = clWhite
    Fill.ColorMirror = clNone
    Fill.ColorMirrorTo = clNone
    Fill.GradientType = gtSolid
    Fill.GradientMirrorType = gtSolid
    Fill.BorderColor = clGray
    Fill.Rounding = 0
    Fill.ShadowOffset = 0
    Fill.Glow = gmNone
    Transparent = False
    StepActions = <
      item
        ActiveContent.Caption = 'Table '#48373#44396' From Backup'
        ActiveContent.Description.Text = #50724#46972#53364' '#48177#50629#54028#51068'(.dmp)'#47196' '#48512#53552' '#53580#51060#48660' '#48373#44396'(1'#51452#51068#44036' '#51200#51109#46120')'
        ActiveContent.Description.Font.Charset = DEFAULT_CHARSET
        ActiveContent.Description.Font.Color = clWindowText
        ActiveContent.Description.Font.Height = -11
        ActiveContent.Description.Font.Name = 'Tahoma'
        ActiveContent.Description.Font.Style = []
        ActiveContent.ImageName = '6'
        ActiveContent.Hint = 'Hint for Step 1'
        InActiveContent.Caption = 'Table '#48373#44396' From Backup'
        InActiveContent.Description.Text = 'Description for Step 1'
        InActiveContent.Description.Font.Charset = DEFAULT_CHARSET
        InActiveContent.Description.Font.Color = clWindowText
        InActiveContent.Description.Font.Height = -11
        InActiveContent.Description.Font.Name = 'Tahoma'
        InActiveContent.Description.Font.Style = []
        InActiveContent.ImageName = '6'
        InActiveContent.Hint = 'Hint for Step 1'
        DisabledContent.Description.Font.Charset = DEFAULT_CHARSET
        DisabledContent.Description.Font.Color = clWindowText
        DisabledContent.Description.Font.Height = -11
        DisabledContent.Description.Font.Name = 'Tahoma'
        DisabledContent.Description.Font.Style = []
        ProcessedContent.Caption = 'Step 1'
        ProcessedContent.Description.Text = 
          '1) decompress full_3.dmp.Z 2) imp system/manager0 file=/backup/d' +
          'ump/full_3.dmp log=imp.log fromuser=HITEMS touser=CLONE_HITEMS t' +
          'ables=TMS_TASK,TMS_ATTFILES  buffer=8192000 STATISTICS=none  3) ' +
          'imp system/manager0 file=/backup/dump/full_3.dmp log=imp.log fro' +
          'muser=HITEMS touser=CLONE_HITEMS tables=TMS_TASK_SHARE  buffer=8' +
          '192000 STATISTICS=none  4) imp system/manager0 file=/backup/dump' +
          '/full_3.dmp log=imp.log fromuser=HITEMS touser=CLONE_HITEMS tabl' +
          'es=TMS_PLAN,  TMS_PLAN_INCHARGE buffer=8192000 STATISTICS=none  ' +
          '5) imp system/manager0 file=/backup/dump/full_3.dmp log=imp.log ' +
          'fromuser=HITEMS touser=CLONE_HITEMS tables=TMS_ATTFILES, TMS_RES' +
          'ULT,  TMS_RESULT_MH buffer=8192000 STATISTICS=none 6) rm full_3.' +
          'dmp'
        ProcessedContent.Description.Font.Charset = DEFAULT_CHARSET
        ProcessedContent.Description.Font.Color = clWindowText
        ProcessedContent.Description.Font.Height = -11
        ProcessedContent.Description.Font.Name = 'Tahoma'
        ProcessedContent.Description.Font.Style = []
        ProcessedContent.ImageName = '6'
        ProcessedContent.Hint = 'Hint for Step 1'
        Tag = 0
      end
      item
        ActiveContent.Caption = 'Table Data '#48373#49324' From CLONE'
        ActiveContent.Description.Text = 
          'insert into tms_task select * from clone_hitems.tms_task where t' +
          'ask_prt = :taskno'
        ActiveContent.Description.Font.Charset = DEFAULT_CHARSET
        ActiveContent.Description.Font.Color = clWindowText
        ActiveContent.Description.Font.Height = -11
        ActiveContent.Description.Font.Name = 'Tahoma'
        ActiveContent.Description.Font.Style = []
        ActiveContent.ImageName = '7'
        ActiveContent.Hint = 'Table Data '#48373#49324' From CLONE'
        InActiveContent.Caption = 'Table Data '#48373#49324' From CLONE'
        InActiveContent.Description.Text = 
          'insert into tms_task select * from clone_hitems.tms_task where t' +
          'ask_prt = :taskno'
        InActiveContent.Description.Font.Charset = DEFAULT_CHARSET
        InActiveContent.Description.Font.Color = clWindowText
        InActiveContent.Description.Font.Height = -11
        InActiveContent.Description.Font.Name = 'Tahoma'
        InActiveContent.Description.Font.Style = []
        InActiveContent.ImageName = '7'
        InActiveContent.Hint = 'Table Data '#48373#49324' From CLONE'
        DisabledContent.Description.Font.Charset = DEFAULT_CHARSET
        DisabledContent.Description.Font.Color = clWindowText
        DisabledContent.Description.Font.Height = -11
        DisabledContent.Description.Font.Name = 'Tahoma'
        DisabledContent.Description.Font.Style = []
        ProcessedContent.Caption = 'Step 2'
        ProcessedContent.Description.Text = 'Description for Step 2'
        ProcessedContent.Description.Font.Charset = DEFAULT_CHARSET
        ProcessedContent.Description.Font.Color = clWindowText
        ProcessedContent.Description.Font.Height = -11
        ProcessedContent.Description.Font.Name = 'Tahoma'
        ProcessedContent.Description.Font.Style = []
        ProcessedContent.ImageName = '7'
        ProcessedContent.Hint = 'Hint for Step 2'
        Tag = 0
      end
      item
        ActiveContent.Caption = 'Step 3'
        ActiveContent.Description.Text = 'Description for Step 3'
        ActiveContent.Description.Font.Charset = DEFAULT_CHARSET
        ActiveContent.Description.Font.Color = clWindowText
        ActiveContent.Description.Font.Height = -11
        ActiveContent.Description.Font.Name = 'Tahoma'
        ActiveContent.Description.Font.Style = []
        ActiveContent.ImageName = '8'
        ActiveContent.Hint = 'Hint for Step 3'
        InActiveContent.Caption = 'Step 3'
        InActiveContent.Description.Text = 'Description for Step 3'
        InActiveContent.Description.Font.Charset = DEFAULT_CHARSET
        InActiveContent.Description.Font.Color = clWindowText
        InActiveContent.Description.Font.Height = -11
        InActiveContent.Description.Font.Name = 'Tahoma'
        InActiveContent.Description.Font.Style = []
        InActiveContent.ImageName = '8'
        InActiveContent.Hint = 'Hint for Step 3'
        DisabledContent.Description.Font.Charset = DEFAULT_CHARSET
        DisabledContent.Description.Font.Color = clWindowText
        DisabledContent.Description.Font.Height = -11
        DisabledContent.Description.Font.Name = 'Tahoma'
        DisabledContent.Description.Font.Style = []
        ProcessedContent.Caption = 'Step 3'
        ProcessedContent.Description.Text = 'Description for Step 3'
        ProcessedContent.Description.Font.Charset = DEFAULT_CHARSET
        ProcessedContent.Description.Font.Color = clWindowText
        ProcessedContent.Description.Font.Height = -11
        ProcessedContent.Description.Font.Name = 'Tahoma'
        ProcessedContent.Description.Font.Style = []
        ProcessedContent.ImageName = '8'
        ProcessedContent.Hint = 'Hint for Step 3'
        Tag = 0
      end
      item
        ActiveContent.Caption = 'Step 4'
        ActiveContent.Description.Text = 'Description for Step 4'
        ActiveContent.Description.Font.Charset = DEFAULT_CHARSET
        ActiveContent.Description.Font.Color = clWindowText
        ActiveContent.Description.Font.Height = -11
        ActiveContent.Description.Font.Name = 'Tahoma'
        ActiveContent.Description.Font.Style = []
        ActiveContent.ImageName = '9'
        ActiveContent.Hint = 'Hint for Step 4'
        InActiveContent.Caption = 'Step 4'
        InActiveContent.Description.Text = 'Description for Step 4'
        InActiveContent.Description.Font.Charset = DEFAULT_CHARSET
        InActiveContent.Description.Font.Color = clWindowText
        InActiveContent.Description.Font.Height = -11
        InActiveContent.Description.Font.Name = 'Tahoma'
        InActiveContent.Description.Font.Style = []
        InActiveContent.ImageName = '9'
        InActiveContent.Hint = 'Hint for Step 4'
        DisabledContent.Description.Font.Charset = DEFAULT_CHARSET
        DisabledContent.Description.Font.Color = clWindowText
        DisabledContent.Description.Font.Height = -11
        DisabledContent.Description.Font.Name = 'Tahoma'
        DisabledContent.Description.Font.Style = []
        ProcessedContent.Caption = 'Step 4'
        ProcessedContent.Description.Text = 'Description for Step 4'
        ProcessedContent.Description.Font.Charset = DEFAULT_CHARSET
        ProcessedContent.Description.Font.Color = clWindowText
        ProcessedContent.Description.Font.Height = -11
        ProcessedContent.Description.Font.Name = 'Tahoma'
        ProcessedContent.Description.Font.Style = []
        ProcessedContent.ImageName = '9'
        ProcessedContent.Hint = 'Hint for Step 4'
        Tag = 0
      end
      item
        ActiveContent.Caption = 'Step 5'
        ActiveContent.Description.Text = 'Description for Step 5'
        ActiveContent.Description.Font.Charset = DEFAULT_CHARSET
        ActiveContent.Description.Font.Color = clWindowText
        ActiveContent.Description.Font.Height = -11
        ActiveContent.Description.Font.Name = 'Tahoma'
        ActiveContent.Description.Font.Style = []
        ActiveContent.ImageName = '10'
        ActiveContent.Hint = 'Hint for Step 5'
        InActiveContent.Caption = 'Step 5'
        InActiveContent.Description.Text = 'Description for Step 5'
        InActiveContent.Description.Font.Charset = DEFAULT_CHARSET
        InActiveContent.Description.Font.Color = clWindowText
        InActiveContent.Description.Font.Height = -11
        InActiveContent.Description.Font.Name = 'Tahoma'
        InActiveContent.Description.Font.Style = []
        InActiveContent.ImageName = '10'
        InActiveContent.Hint = 'Hint for Step 5'
        DisabledContent.Description.Font.Charset = DEFAULT_CHARSET
        DisabledContent.Description.Font.Color = clWindowText
        DisabledContent.Description.Font.Height = -11
        DisabledContent.Description.Font.Name = 'Tahoma'
        DisabledContent.Description.Font.Style = []
        ProcessedContent.Caption = 'Step 5'
        ProcessedContent.Description.Text = 'Description for Step 5'
        ProcessedContent.Description.Font.Charset = DEFAULT_CHARSET
        ProcessedContent.Description.Font.Color = clWindowText
        ProcessedContent.Description.Font.Height = -11
        ProcessedContent.Description.Font.Name = 'Tahoma'
        ProcessedContent.Description.Font.Style = []
        ProcessedContent.ImageName = '10'
        ProcessedContent.Hint = 'Hint for Step 5'
        Tag = 0
      end>
    Appearance.InActiveCaptionFont.Charset = DEFAULT_CHARSET
    Appearance.InActiveCaptionFont.Color = clWindowText
    Appearance.InActiveCaptionFont.Height = -11
    Appearance.InActiveCaptionFont.Name = 'Tahoma'
    Appearance.InActiveCaptionFont.Style = []
    Appearance.DisabledCaptionFont.Charset = DEFAULT_CHARSET
    Appearance.DisabledCaptionFont.Color = clWindowText
    Appearance.DisabledCaptionFont.Height = -11
    Appearance.DisabledCaptionFont.Name = 'Tahoma'
    Appearance.DisabledCaptionFont.Style = []
    Appearance.ActiveCaptionFont.Charset = DEFAULT_CHARSET
    Appearance.ActiveCaptionFont.Color = clWindowText
    Appearance.ActiveCaptionFont.Height = -11
    Appearance.ActiveCaptionFont.Name = 'Tahoma'
    Appearance.ActiveCaptionFont.Style = []
    Appearance.ProcessedCaptionFont.Charset = DEFAULT_CHARSET
    Appearance.ProcessedCaptionFont.Color = clWindowText
    Appearance.ProcessedCaptionFont.Height = -11
    Appearance.ProcessedCaptionFont.Name = 'Tahoma'
    Appearance.ProcessedCaptionFont.Style = []
    Appearance.InActiveDescriptionFont.Charset = DEFAULT_CHARSET
    Appearance.InActiveDescriptionFont.Color = clWindowText
    Appearance.InActiveDescriptionFont.Height = -9
    Appearance.InActiveDescriptionFont.Name = 'Tahoma'
    Appearance.InActiveDescriptionFont.Style = []
    Appearance.DisabledDescriptionFont.Charset = DEFAULT_CHARSET
    Appearance.DisabledDescriptionFont.Color = clWindowText
    Appearance.DisabledDescriptionFont.Height = -11
    Appearance.DisabledDescriptionFont.Name = 'Tahoma'
    Appearance.DisabledDescriptionFont.Style = []
    Appearance.ActiveDescriptionFont.Charset = DEFAULT_CHARSET
    Appearance.ActiveDescriptionFont.Color = clWindowText
    Appearance.ActiveDescriptionFont.Height = -9
    Appearance.ActiveDescriptionFont.Name = 'Tahoma'
    Appearance.ActiveDescriptionFont.Style = []
    Appearance.ProcessedDescriptionFont.Charset = DEFAULT_CHARSET
    Appearance.ProcessedDescriptionFont.Color = clWindowText
    Appearance.ProcessedDescriptionFont.Height = -9
    Appearance.ProcessedDescriptionFont.Name = 'Tahoma'
    Appearance.ProcessedDescriptionFont.Style = []
    Appearance.ActiveAppearance.ShapeColor = 16053492
    Appearance.ActiveAppearance.CaptionColor = 4210752
    Appearance.ActiveAppearance.DescriptionColor = 4210752
    Appearance.ActiveAppearance.BackGroundFill.Color = 5294077
    Appearance.ActiveAppearance.BackGroundFill.ColorTo = clNone
    Appearance.ActiveAppearance.BackGroundFill.ColorMirror = 3314943
    Appearance.ActiveAppearance.BackGroundFill.ColorMirrorTo = 749567
    Appearance.ActiveAppearance.BackGroundFill.GradientType = gtSolid
    Appearance.ActiveAppearance.BackGroundFill.GradientMirrorType = gtVertical
    Appearance.ActiveAppearance.BackGroundFill.BorderColor = clBlack
    Appearance.ActiveAppearance.BackGroundFill.Rounding = 0
    Appearance.ActiveAppearance.BackGroundFill.ShadowOffset = 0
    Appearance.ActiveAppearance.BackGroundFill.Glow = gmNone
    Appearance.InActiveAppearance.ShapeColor = 5294077
    Appearance.InActiveAppearance.CaptionColor = 4210752
    Appearance.InActiveAppearance.DescriptionColor = 4210752
    Appearance.InActiveAppearance.BackGroundFill.Color = 16053492
    Appearance.InActiveAppearance.BackGroundFill.ColorTo = clNone
    Appearance.InActiveAppearance.BackGroundFill.ColorMirror = 14540253
    Appearance.InActiveAppearance.BackGroundFill.ColorMirrorTo = 13158600
    Appearance.InActiveAppearance.BackGroundFill.GradientType = gtSolid
    Appearance.InActiveAppearance.BackGroundFill.GradientMirrorType = gtVertical
    Appearance.InActiveAppearance.BackGroundFill.BorderColor = clGray
    Appearance.InActiveAppearance.BackGroundFill.Rounding = 0
    Appearance.InActiveAppearance.BackGroundFill.ShadowOffset = 0
    Appearance.InActiveAppearance.BackGroundFill.Glow = gmNone
    Appearance.DisabledAppearance.ShapeColor = 16053492
    Appearance.DisabledAppearance.CaptionColor = 10526880
    Appearance.DisabledAppearance.DescriptionColor = 10526880
    Appearance.DisabledAppearance.BackGroundFill.ColorMirror = clNone
    Appearance.DisabledAppearance.BackGroundFill.ColorMirrorTo = clNone
    Appearance.DisabledAppearance.BackGroundFill.GradientType = gtVertical
    Appearance.DisabledAppearance.BackGroundFill.GradientMirrorType = gtSolid
    Appearance.DisabledAppearance.BackGroundFill.BorderColor = clNone
    Appearance.DisabledAppearance.BackGroundFill.Rounding = 0
    Appearance.DisabledAppearance.BackGroundFill.ShadowOffset = 0
    Appearance.DisabledAppearance.BackGroundFill.Glow = gmNone
    Appearance.ProcessedAppearance.ShapeColor = 5294077
    Appearance.ProcessedAppearance.CaptionColor = 10526880
    Appearance.ProcessedAppearance.DescriptionColor = 10526880
    Appearance.ProcessedAppearance.BackGroundFill.Color = 16053492
    Appearance.ProcessedAppearance.BackGroundFill.ColorTo = clNone
    Appearance.ProcessedAppearance.BackGroundFill.ColorMirror = 14540253
    Appearance.ProcessedAppearance.BackGroundFill.ColorMirrorTo = 13158600
    Appearance.ProcessedAppearance.BackGroundFill.GradientType = gtSolid
    Appearance.ProcessedAppearance.BackGroundFill.GradientMirrorType = gtVertical
    Appearance.ProcessedAppearance.BackGroundFill.BorderColor = clGray
    Appearance.ProcessedAppearance.BackGroundFill.Rounding = 0
    Appearance.ProcessedAppearance.BackGroundFill.ShadowOffset = 0
    Appearance.ProcessedAppearance.BackGroundFill.Glow = gmNone
    Appearance.ShapeSize = 45
    Appearance.ProgressSize = 30
    Appearance.ProgressBackGround.Color = 16053492
    Appearance.ProgressBackGround.ColorTo = clNone
    Appearance.ProgressBackGround.ColorMirror = 14540253
    Appearance.ProgressBackGround.ColorMirrorTo = 13158600
    Appearance.ProgressBackGround.GradientType = gtSolid
    Appearance.ProgressBackGround.GradientMirrorType = gtVertical
    Appearance.ProgressBackGround.BorderColor = clGray
    Appearance.ProgressBackGround.Rounding = 0
    Appearance.ProgressBackGround.ShadowOffset = 0
    Appearance.ProgressBackGround.Glow = gmNone
    Appearance.Progress.Color = 5294077
    Appearance.Progress.ColorTo = clNone
    Appearance.Progress.ColorMirror = 3314943
    Appearance.Progress.ColorMirrorTo = 749567
    Appearance.Progress.GradientType = gtSolid
    Appearance.Progress.GradientMirrorType = gtVertical
    Appearance.Progress.BorderColor = clBlack
    Appearance.Progress.Rounding = 0
    Appearance.Progress.ShadowOffset = 0
    Appearance.Progress.Glow = gmNone
    Appearance.SeparatorFill.Color = 5294077
    Appearance.SeparatorFill.ColorTo = clNone
    Appearance.SeparatorFill.ColorMirror = 3314943
    Appearance.SeparatorFill.ColorMirrorTo = 749567
    Appearance.SeparatorFill.GradientType = gtVertical
    Appearance.SeparatorFill.GradientMirrorType = gtVertical
    Appearance.SeparatorFill.BorderColor = 5294077
    Appearance.SeparatorFill.Rounding = 0
    Appearance.SeparatorFill.ShadowOffset = 0
    Appearance.SeparatorFill.Glow = gmNone
    Appearance.DescriptionFill.Color = 5294077
    Appearance.DescriptionFill.ColorTo = clNone
    Appearance.DescriptionFill.ColorMirror = 3314943
    Appearance.DescriptionFill.ColorMirrorTo = 749567
    Appearance.DescriptionFill.GradientType = gtSolid
    Appearance.DescriptionFill.GradientMirrorType = gtVertical
    Appearance.DescriptionFill.BorderColor = clBlack
    Appearance.DescriptionFill.Rounding = 0
    Appearance.DescriptionFill.ShadowOffset = 0
    Appearance.DescriptionFill.Glow = gmNone
    PictureContainer = GDIPPictureContainer1
    VisibleSteps = 3
    OnStepClick = RecoveryStepStepClick
    OnStepChanged = RecoveryStepStepChanged
    Align = alTop
    TabOrder = 0
  end
  object TodoList1: TTodoList
    Left = 0
    Top = 106
    Width = 822
    Height = 263
    ActiveColumnColor = clWhite
    ActiveItemColor = clNone
    ActiveItemColorTo = clNone
    Align = alTop
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
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ImageIndex = -1
        Tag = False
        TodoData = tdHandle
        Width = 22
        MaxLength = 0
      end
      item
        Alignment = taLeftJustify
        Color = clWindow
        Editable = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ImageIndex = 2
        Tag = False
        TodoData = tdComplete
        Width = 22
        MaxLength = 0
      end
      item
        Alignment = taLeftJustify
        Caption = 'Subject'
        Color = clWindow
        Editable = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ImageIndex = -1
        Tag = False
        TodoData = tdSubject
        Width = 300
        MaxLength = 0
      end
      item
        Alignment = taLeftJustify
        Caption = 'Notes'
        Color = clWindow
        Editable = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ImageIndex = 3
        Tag = False
        TodoData = tdNotes
        Width = 400
        MaxLength = 0
      end
      item
        Alignment = taLeftJustify
        Caption = 'Compl.'
        Color = clWindow
        Editable = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ImageIndex = -1
        Tag = False
        TodoData = tdCompletion
        Width = 100
        MaxLength = 0
      end>
    CompleteCheck.CheckType = ctCheckBox
    CompletionFont.Charset = DEFAULT_CHARSET
    CompletionFont.Color = clGray
    CompletionFont.Height = -11
    CompletionFont.Name = 'MS Sans Serif'
    CompletionFont.Style = [fsStrikeOut]
    DateFormat = 'd/MM/yyyy'
    DragCursor = crDrag
    DragMode = dmManual
    DragKind = dkDrag
    Editable = True
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
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    GridLineColor = clSilver
    HeaderActiveColor = 9758459
    HeaderActiveColorTo = 1414638
    HeaderColor = 16572875
    HeaderColorTo = 14722429
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -11
    HeaderFont.Name = 'MS Sans Serif'
    HeaderFont.Style = []
    HeaderHeight = 22
    ItemHeight = 18
    Items = <
      item
        Complete = False
        Completion = 0
        ImageIndex = 0
        Notes.Strings = (
          
            'select * from clone_hitems.tms_task where task_no = :taskno or t' +
            'ask_prt = :taskno')
        Priority = tpNormal
        Resource = 'Dale'
        Status = tsNotStarted
        Subject = 'CLONE'#51032' TMS_TASK'#50640' Task No'#51316#51116' '#54869#51064
        Tag = 0
      end
      item
        Complete = False
        Completion = 0
        ImageIndex = 0
        Notes.Strings = (
          
            'insert into tms_task select * from clone_hitems.tms_task where t' +
            'ask_no = :taskno or task_prt = :taskno')
        Priority = tpNormal
        Resource = 'Bill'
        Status = tsNotStarted
        Subject = 'Insert TMS_TASK from CLONE(task_no or task_prt)'
        Tag = 0
      end
      item
        Complete = False
        Completion = 0
        ImageIndex = -1
        Notes.Strings = (
          
            'select * from clone_hitems.tms_task_share where task_no = :taskn' +
            'o')
        Priority = tpLowest
        Status = tsNotStarted
        Subject = 'CLONE'#51032' TMS_TASK_SHARE'#50640' Task No '#51316#51116' '#54869#51064
        Tag = 0
      end
      item
        Complete = False
        Completion = 0
        ImageIndex = 1
        Notes.Strings = (
          
            'insert into tms_task_share select * from clone_hitems.tms_task_s' +
            'hare where task_no = :taskno')
        Priority = tpNormal
        Resource = 'Jack'
        Status = tsNotStarted
        Subject = 'Insert TMS_TASK_SHARE'
        Tag = 0
      end
      item
        Complete = False
        Completion = 0
        ImageIndex = -1
        Notes.Strings = (
          'select * from clone_hitems.tms_plan where task_no = :taskno')
        Priority = tpLowest
        Status = tsNotStarted
        Subject = 'CLONE'#51032' TMS_PLAN'#50640' Task No '#51316#51116' '#54869#51064'('#48373#49688#44060' Plan No '#44032#51256#50740')'
        Tag = 0
      end
      item
        Complete = False
        Completion = 0
        ImageIndex = -1
        Notes.Strings = (
          
            'insert into tms_plan select * from clone_hitems.tms_plan where t' +
            'ask_no = :taskno')
        Priority = tpLowest
        Status = tsNotStarted
        Subject = 'Insert TMS_PLAN'
        Tag = 0
      end
      item
        Complete = False
        Completion = 0
        ImageIndex = -1
        Notes.Strings = (
          
            'insert into tms_plan_incharge select * from clone_hitems.tms_pla' +
            'n_incharge where plan_no = :planno')
        Priority = tpLowest
        Status = tsNotStarted
        Subject = 'Insert TMS_PLAN_INCHARGE'
        Tag = 0
      end
      item
        Complete = False
        Completion = 0
        ImageIndex = -1
        Notes.Strings = (
          'select * from clone_hitems.tms_attfiles where owner = :planno')
        Priority = tpLowest
        Status = tsNotStarted
        Subject = 'CLONE'#51032' TMS_ATTFILES'#50640' Plan No '#51316#51116' '#54869#51064
        Tag = 0
      end
      item
        Complete = False
        Completion = 0
        ImageIndex = -1
        Notes.Strings = (
          
            'insert into tms_attfiles select * from clone_hitems.tms_attfiles' +
            ' where owner = :planno')
        Priority = tpLowest
        Status = tsNotStarted
        Subject = 'Insert TMS_ATTFILES'
        Tag = 0
      end
      item
        Complete = False
        Completion = 0
        ImageIndex = -1
        Notes.Strings = (
          'select * from CLONE_HITEMS.TMS_RESULT where plan_no = :planno')
        Priority = tpLowest
        Status = tsNotStarted
        Subject = 
          '6'#48264#50640#49436' '#44032#51256#50728' Plan No'#47196' CLONE'#51032' TMS_RESULT'#50640' Plan No '#51316#51116' '#54869#51064'('#48373#49688#44060' Result No' +
          ' '#44032#51256#50740')'
        Tag = 0
      end
      item
        Complete = False
        Completion = 0
        ImageIndex = -1
        Notes.Strings = (
          
            'insert into tms_result select * from CLONE_HITEMS.TMS_RESULT whe' +
            're plan_no =:planno')
        Priority = tpLowest
        Status = tsNotStarted
        Subject = 'Insert TMS_RESULT'
        Tag = 0
      end
      item
        Complete = False
        Completion = 0
        ImageIndex = -1
        Notes.Strings = (
          'select * from CLONE_HITEMS.TMS_RESULT_MH where rst_no = :rstno')
        Priority = tpLowest
        Status = tsNotStarted
        Subject = 'CLONE'#51032' TMS_RESULT_MH'#50640' Result No '#51316#51116' '#54869#51064
        Tag = 0
      end
      item
        Complete = False
        Completion = 0
        ImageIndex = -1
        Notes.Strings = (
          
            'insert into tms_result_mh select * from CLONE_HITEMS.TMS_RESULT_' +
            'MH where rst_no = :rstno')
        Priority = tpLowest
        Status = tsNotStarted
        Subject = 'Insert TMS_RESULT_MH'
        Tag = 0
      end>
    NullDate = 'None'
    MultiSelect = False
    Preview = False
    PreviewFont.Charset = DEFAULT_CHARSET
    PreviewFont.Color = clBlue
    PreviewFont.Height = -11
    PreviewFont.Name = 'MS Sans Serif'
    PreviewFont.Style = []
    PreviewColor = clWhite
    PreviewColorTo = 14548991
    PreviewHeight = 32
    PriorityFont.Charset = DEFAULT_CHARSET
    PriorityFont.Color = clRed
    PriorityFont.Height = -11
    PriorityFont.Name = 'MS Sans Serif'
    PriorityFont.Style = []
    PriorityStrings.Lowest = 'Lowest'
    PriorityStrings.Low = 'Low'
    PriorityStrings.Normal = 'Normal'
    PriorityStrings.High = 'High'
    PriorityStrings.Highest = 'Highest'
    PriorityListWidth = -1
    ProgressLook.CompleteColor = 2741875
    ProgressLook.CompleteFontColor = 8404992
    ProgressLook.UnCompleteColor = clWindow
    ProgressLook.UnCompleteFontColor = clBlue
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
    SelectionColor = 15908738
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
    Version = '1.5.1.0'
    TotalTimeSuffix = 'h'
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 822
    Height = 41
    Align = alTop
    TabOrder = 2
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 81
      Height = 13
      Caption = #48373#44396#54624' Task No:'
    end
    object Label2: TLabel
      Left = 240
      Top = 16
      Width = 44
      Height = 13
      Caption = #54016' Code:'
    end
    object TaskNoEdit: TEdit
      Left = 104
      Top = 11
      Width = 121
      Height = 21
      ImeName = 'Microsoft IME 2010'
      TabOrder = 0
      Text = '20140407180923294'
    end
    object Button1: TButton
      Left = 488
      Top = 2
      Width = 113
      Height = 33
      Caption = #48373#44396' '#49884#51089
      TabOrder = 1
      OnClick = Button1Click
    end
    object TeamCodeEdit: TEdit
      Left = 290
      Top = 14
      Width = 121
      Height = 21
      ImeName = 'Microsoft IME 2010'
      TabOrder = 2
      Text = 'K1G2'
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 573
    Width = 822
    Height = 41
    Align = alBottom
    TabOrder = 3
    ExplicitTop = 458
    DesignSize = (
      822
      41)
    object BitBtn1: TBitBtn
      Left = 699
      Top = 3
      Width = 89
      Height = 35
      Anchors = [akRight, akBottom]
      Kind = bkClose
      NumGlyphs = 2
      TabOrder = 0
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 372
    Width = 822
    Height = 201
    Align = alClient
    ImeName = 'Microsoft IME 2010'
    TabOrder = 4
    ExplicitTop = 400
    ExplicitHeight = 173
  end
  object GDIPPictureContainer1: TGDIPPictureContainer
    Items = <
      item
        Picture.Data = {
          89504E470D0A1A0A0000000D494844520000001E0000001E08060000003B30AE
          A20000000467414D410000B18E7CFB5193000000206348524D0000870F00008C
          0F0000FD520000814000007D790000E98B00003CE5000019CC733C857700000A
          396943435050686F746F73686F70204943432070726F66696C65000048C79D96
          775454D71687CFBD777AA1CD30025286DEBBC000D27B935E456198196028030E
          3334B121A2021145449A224850C480D150245644B1101454B007240828311845
          542C6F46D68BAEACBCF7F2F2FBE3AC6FEDB3F7B9FBECBDCF5A170092A72F9797
          064B0190CA13F0833C9CE911915174EC0080011E608029004C5646BA5FB07B08
          10C9CBCD859E2172025F0401F07A58BC0270D3D033804E07FF9FA459E97C81E8
          9800119BB339192C11178838254B902EB6CF8A981A972C66182566BE284111CB
          893961910D3EFB2CB2A398D9A93CB688C539A7B353D962EE15F1B64C2147C488
          AF880B33B99C2C11DF12B1468A30952BE237E2D8540E33030014496C17705889
          22361131891F12E422E2E500E048095F71DC572CE0640BC49772494BCFE17313
          1205741D962EDDD4DA9A41F7E464A5700402C300262B99C967D35DD252D399BC
          1C0016EFFC5932E2DAD24545B634B5B6B434343332FDAA50FF75F36F4ADCDB45
          7A19F8B96710ADFF8BEDAFFCD21A0060CC896AB3F38B2DAE0A80CE2D00C8DDFB
          62D3380080A4A86F1DD7BFBA0F4D3C2F890241BA8DB1715656961197C3321217
          F40FFD4F87BFA1AFBE67243EEE8FF2D05D39F14C618A802EAE1B2B2D254DC8A7
          67A433591CBAE19F87F81F07FE751E06419C780E9FC313458489A68CCB4B10B5
          9BC7E60AB8693C3A97F79F9AF80FC3FEA4C5B91689D2F81150638C80D4752A40
          7EED07280A1120D1FBC55DFFA36FBEF830207E79E12A938B73FFEF37FD67C1A5
          E225839BF039CE252884CE12F23317F7C4CF12A0010148022A9007CA401DE800
          436006AC802D70046EC01BF8831010095603164804A9800FB2401ED8040A4131
          D809F6806A50071A41336805C741273805CE834BE01AB8016E83FB60144C8067
          6016BC060B10046121324481E421154813D287CC2006640FB941BE50101409C5
          4209100F124279D066A8182A83AAA17AA819FA1E3A099D87AE4083D05D680C9A
          867E87DEC1084C82A9B012AC051BC30CD809F68143E0557002BC06CE850BE01D
          7025DC001F853BE0F3F035F8363C0A3F83E7108010111AA28A18220CC405F147
          A29078848FAC478A900AA4016945BA913EE426328ACC206F51181405454719A2
          6C519EA850140BB506B51E5582AA461D4675A07A51375163A859D4473419AD88
          D647DBA0BDD011E8047416BA105D816E42B7A32FA26FA327D0AF31180C0DA38D
          B1C2786222314998B59812CC3E4C1BE61C6610338E99C362B1F2587DAC1DD61F
          CBC40AB085D82AEC51EC59EC107602FB0647C4A9E0CC70EEB8281C0F978FABC0
          1DC19DC10DE126710B7829BC26DE06EF8F67E373F0A5F8467C37FE3A7E02BF40
          90266813EC08218424C2264225A1957091F080F0924824AA11AD8981442E7123
          B192788C789938467C4B9221E9915C48D124216907E910E91CE92EE925994CD6
          223B92A3C802F20E7233F902F911F98D0445C248C24B822DB141A246A2436248
          E2B9245E5253D24972B564AE6485E409C9EB92335278292D291729A6D47AA91A
          A99352235273D2146953697FE954E912E923D257A4A764B0325A326E326C9902
          9983321764C62908459DE242615136531A29172913540C559BEA454DA21653BF
          A30E506765656497C986C966CBD6C89E961DA521342D9A172D85564A3B4E1BA6
          BD5BA2B4C4690967C9F625AD4B8696CCCB2D957394E3C815C9B5C9DD967B274F
          9777934F96DF25DF29FF5001A5A0A710A890A5B05FE1A2C2CC52EA52DBA5ACA5
          454B8F2FBDA7082BEA290629AE553CA8D8AF38A7A4ACE4A194AE54A574416946
          99A6ECA89CA45CAE7C46795A85A262AFC255295739ABF2942E4B77A2A7D02BE9
          BDF4595545554F55A16ABDEA80EA829AB65AA85ABE5A9BDA4375823A433D5EBD
          5CBD477D564345C34F234FA345E39E265E93A199A8B957B34F735E4B5B2B5C6B
          AB56A7D694B69CB69776AE768BF6031DB28E83CE1A9D069D5BBA185D866EB2EE
          3EDD1B7AB09E855EA25E8DDE757D58DF529FABBF4F7FD0006D606DC033683018
          3124193A19661AB6188E19D18C7C8DF28D3A8D9E1B6B184719EF32EE33FE6862
          619262D26872DF54C6D4DB34DFB4DBF477333D3396598DD92D73B2B9BBF906F3
          2EF317CBF4977196ED5F76C78262E167B1D5A2C7E283A59525DFB2D572DA4AC3
          2AD6AAD66A84416504304A1897ADD1D6CED61BAC4F59BFB5B1B411D81CB7F9CD
          D6D036D9F688EDD472EDE59CE58DCBC7EDD4EC9876F576A3F674FB58FB03F6A3
          0EAA0E4C870687C78EEA8E6CC726C749275DA724A7A34ECF9D4D9CF9CEEDCEF3
          2E362EEB5CCEB922AE1EAE45AE036E326EA16ED56E8FDCD5DC13DC5BDC673D2C
          3CD67A9CF3447BFA78EEF21CF152F26279357BCD7A5B79AFF3EEF521F904FB54
          FB3CF6D5F3E5FB76FBC17EDE7EBBFD1EACD05CC15BD1E90FFCBDFC77FB3F0CD0
          0E5813F06320263020B026F0499069505E505F30253826F848F0EB10E790D290
          FBA13AA1C2D09E30C9B0E8B0E6B0F970D7F0B2F0D108E3887511D7221522B991
          5D51D8A8B0A8A6A8B9956E2BF7AC9C88B6882E8C1E5EA5BD2A7BD595D50AAB53
          569F8E918C61C69C8845C786C71E897DCFF4673630E7E2BCE26AE366592EACBD
          AC676C4776397B9A63C729E34CC6DBC597C54F25D825EC4E984E7448AC489CE1
          BA70ABB92F923C93EA92E693FD930F257F4A094F694BC5A5C6A69EE4C9F09279
          BD69CA69D96983E9FAE985E9A36B6CD6EC5933CBF7E137654019AB32BA0454D1
          CF54BF5047B8453896699F5993F9262B2CEB44B674362FBB3F472F677BCE64AE
          7BEEB76B516B596B7BF254F336E58DAD735A57BF1E5A1FB7BE6783FA86820D13
          1B3D361EDE44D894BCE9A77C93FCB2FC579BC337771728156C2C18DFE2B1A5A5
          50A2905F38B2D5766BDD36D436EEB681EDE6DBABB67F2C62175D2D3629AE287E
          5FC22AB9FA8DE93795DF7CDA11BF63A0D4B274FF4ECC4EDECEE15D0EBB0E9749
          97E5968DEFF6DBDD514E2F2F2A7FB52766CF958A6515757B097B857B472B7D2B
          BBAA34AA7656BDAF4EACBE5DE35CD356AB58BBBD767E1F7BDFD07EC7FDAD754A
          75C575EF0E700FDCA9F7A8EF68D06AA83888399879F049635863DFB78C6F9B9B
          149A8A9B3E1CE21D1A3D1C74B8B7D9AAB9F988E291D216B845D8327D34FAE88D
          EF5CBFEB6A356CAD6FA3B5151F03C784C79E7E1FFBFDF0719FE33D2718275A7F
          D0FCA1B69DD25ED40175E474CC7626768E7645760D9EF43ED9D36DDBDDFEA3D1
          8F874EA99EAA392D7BBAF40CE14CC1994F6773CFCE9D4B3F37733EE1FC784F4C
          CFFD0B11176EF506F60E5CF4B978F992FBA50B7D4E7D672FDB5D3E75C5E6CAC9
          AB8CAB9DD72CAF75F45BF4B7FF64F153FB80E540C775ABEB5D37AC6F740F2E1F
          3C33E43074FEA6EBCD4BB7BC6E5DBBBDE2F6E070E8F09D91E891D13BEC3B5377
          53EEBEB897796FE1FEC607E807450FA51E563C527CD4F0B3EECF6DA396A3A7C7
          5CC7FA1F073FBE3FCE1A7FF64BC62FEF270A9E909F544CAA4C364F994D9D9A76
          9FBEF174E5D38967E9CF16660A7F95FEB5F6B9CEF31F7E73FCAD7F366276E205
          FFC5A7DF4B5ECABF3CF46AD9AB9EB980B947AF535F2FCC17BD917F73F82DE36D
          DFBBF077930B59EFB1EF2B3FE87EE8FEE8F3F1C1A7D44F9FFE050398F3FCBAC4
          E8D3000000097048597300000EC300000EC301C76FA864000000197445587453
          6F667477617265005061696E742E4E45542076332E352E36D083AD5A0000094C
          49444154484B959669705BD515C78D5906DA0F2530D3943085322599E90614DA
          CEB4FDD0D24E32858021294C3A6D03CC24348469A149A1490349531A92408289
          F126C996AD7D7FCFDA65E9599BB558D6BE5AB6BCC9F26ECB4BEC90C5B1FDEF7D
          8278A02484DC99337A7A7A7ABF7BCFF99FA5ACEC2B2E46D6707B26E4FB61C861
          78C167D3FED7C3986AFD6EA636D8E13D168FC55E8AC5E20F350B84777CC5D75D
          FFB17447EB860146F0AF3E736332A5E72E452D2284ED34A2EDAD4876B6A32B11
          466F771786F2834BA32323E9C1C1C1C3ED1EEFB7AFFFE66B3CC1781577A432B2
          D70BC1DAB1A2A31A13560EFA2C8D48D9248896C016A408B83B1D437EA00F5393
          13585C388B0B17CE93CF85897C7EE84D8D86FAFA0D6D80495936B8C624C6D424
          6F75B49F8762673D26EDF5186C6D44C62646CC4E21C682831EF46412280C0D60
          A6388D8F3F3E87E5E5CB6017FB592C16AD2E77FB7D5F09AE8BFAEEA7868D31FB
          390DC20B52F48E37613CCDC5A4A71E434C03B2362112760DE21E0BD2612F7AB3
          298C8E143037378B8B172F607565A50466D7EAEA2AB93F976A6FF73CF8A570CA
          11BBAB319C0928472330CE33702FD288CD4A3190E7632CCC45C1C9430F2340D2
          AE46828033113FFA735D98181FC50271F3E5A52516B706BE029F999989E8F486
          6F5E157EE03D5B79ADB6C0AF75CD40901E827A240AF30C03EF1C8DD48404F92C
          1F435E1E72F666A41D2A24BD1664631D18ECEBC1F4D464C9CD2B2BCB9F835EF9
          B242BC303C322C3E72E4DFB77C012ED1C47E77463ABA54A39F03C75584303908
          4D2102EB34838EE91674E5251808F3D1EB2260BB1C319701E9888F08AB17B3B3
          455C62DD4C5C7BAD75E9D2A5CBE148E499CF81CF7CC0BD5520F6789BE45DE0AA
          F2E068C7D1601F8338D6077A300C669C4170B40589783382966A78E97AB49B64
          08B86D48C6A3281486709E9CF87A6B6C6C2C70FCF889DBD7E02D6ADD2F5512CB
          B25AE9815411864095015FDB8726A61FB25016BA5C278CDD5A58838D6833D52E
          1914BC698D5232D04253030CC34CF774772F4D4DB2EEFEF82AEC55E2899592CA
          171717961D4EE7E36B60A5585169A2CC30505668D50EA8551EC8D54188B50948
          AC69881C7E483C3A486DC2A2522DB1DBACAD12AFCF2FF4760485666B9B58A6D4
          D843E1487176761617CE9F5F53F4CAF23211DCA592DA590DB0028C46233525F0
          CF7EFAD8CD94828EB41A6CB0E8AC306BAD30D20C74940314453640F9C0915950
          2FA767859A1685A3C35D1D8F050F9232B9271A4FEC89C493075C1EFF4752855A
          114F2466D942C2822E5E20B0738B58383B5F4A3536CFA7A726904C26E25B9F7A
          FAB6B237DE7CF36E83CE34C5581DB059ECB099EDB01ADBD06A6883596F874A61
          46B350BB5ACB15992993B3D2E10FBCECEFF4EFF47B5DDBBD7EDF767F47E7CE76
          AF7FB7C1C29C1649E4E67C7E70757C6C143333D3982220F69ACDF3C2D020F283
          FD4427D1E9D75EFFFBFAB27F1E3878BFB5D576D9E574C3E9707D62F64FADCD05
          2DA58754AC9C174AE455B4CE74B0D5E6785EA5D73D7A254E5A9DFE5193C5BA4D
          A1D1EEABE33557FA7CDED94C2A5982F4F7E5D0DB93454F36836C570A997412E1
          606079D7AE971F28DBB7FF1F1BDD2E273AFC3E043AFC25EB24160C7420D4D901
          1250B4D0F4B848A63A2A53517B3554CBD653C78F7DE30AF8F47B27EE148AA55B
          784DA297AAEB1BDF36E875A3DE7627517B04F16818B14810D1702722A1000B85
          CFEBC6CE175EFC5ED9AE5DBB1FE80CF89613E4C164228A74325EDA59B62B8D1C
          E93A11F227B7DB39C9E18B8F3489E57BC532F9E63A0E67ADFE9EA9E37EB75920
          DEDCD024FC4B0DA7F128A5528C5B4D3A74789CF0AF990B3ECF27E6686B5DD9B6
          FDF70F96553CF3ECB7A291D06C5FAEBBE49AFC407F291E6C5C26C6C788CB0690
          CB752F8B64EA0F0572CDDB2299E249854ABD59A5513EA251891E15AB645B7822
          C513757CE5A1EA3AFE874A997AD940EBE0B45AE1665AE16EB3A2DD4ECC6123C6
          C0A86F99DBBC79CBBD65EBD7AFBF3DD819488D8F8D6072621CC5E929CCCE1471
          767E0EE71617D81687B1D151245399285FAC3824D3E80E2AD4F4362939B95422
          DAAC528B9F6DA25507CE3429DFE2887511BE584F424384A96360D35BD06634C1
          6E36C1613191CD9821170BD39B366D2AB5CB9B18C6C69F279267F38C4D818BA4
          A72E91FC5B2149CF26FFE2E222516911D178AA4D20531F96AAB587D53AD32195
          863E24978A0E0BE4FCC3228B8269329956F93A0F64862854748008D34D52D386
          56AD19369D016D7A3DAA4E9F12B0CC92462A2B2B2B08749585B11586857DB6CB
          B03598854F136FF4F5F5E7DD5E1FA5339AAB294A5D6DA604549BB561D0E01340
          1DD043158E42E8EC41932107119586421D428BBA1D46CA06BDB265F56FAFECDD
          B656B9366EDCB4AE3797CB10E297965BD6F585A12164527104BD6DF09815706B
          B9F0596AD01911C0D3AF87B1B71DF244068DEE21708CA3E069F21028B3902B42
          A8FD489EF9D10F1EBEFBB38DE2A67A0E67CFD2D2D235C96C6B3B4F6A31DB0273
          D934227E07420E1DA23629520C0F5D412E2239115CC37A6807BD90A4BBC1F58C
          A3C634831ACD346A44FDABBBF6BCF3EA9A9BAFD0EFB967C39DE170D87EADD646
          0639C4A21130B656706B2AF1E1B10308D975A0ABDF82F0D076986BFF0CA37617
          389617611956832E7821EACAA1DE3F8D33A605EC3BE974DCFB9D47D65D7518D8
          BAF5A91F0F0F0F17AEE6EF4838544AAD6E92DF8DF55510732AC13FF5361A8EBE
          02FAE41E78B87FC540A00ACDF22D7015B8A48FEBA019F542D093C33B74ACF0D8
          AFB63DF665E34F3929285B49DF9CFC2C9CED3224E5E0F7796027B9998804E030
          695075741FE9CF72288FED81F9DD3FC153B71319FF3BC88E35C14F4626F38C16
          F5117AE2377FF8E3D3045A7EBDA1EF961D3B763CD193EBE965E3CA2E165C24DD
          A5A73B8B80AF1D36230D4ADC00C147EF42C3390673DD11041A0FA3BFE5382643
          F5280CF090986A8438F47EEFAF9F7BFC4902FCE2C8738D5DDC4C92FC218AA2D5
          67CFCE5F9C27C5843DB1C9A887B8B9018DB595A0250D90D49FC2C9FD3B51F5DA
          7648F655C0F19F1D18A08FA0AFA3F2421DEF55CDC6EFDFF73079FFCDD73BE9FF
          FF7E537979F9BA8A8A8AE7288A32F7F5E6E6478687C8709743361941D4EF42C0
          69422743216A9523A56F4054767A4E76EC554BC56F7FF2FC6DB796DFF90505DF
          E00ED8D8AC23AAFFF9EEDDBBF7BF7FF284985B57ED6CE2D48479D51F84AB4E1C
          711E7D63AFF8C5ED4FEE7F60C3FA5F9092C42AF7BAF1BCC13D94DCF635627711
          5BFFA9B1D7ECBD1B72E9FF0024C26AA387C53B360000000049454E44AE426082}
        Name = '4'
        Tag = 0
      end
      item
        Picture.Data = {
          89504E470D0A1A0A0000000D494844520000001E0000001E08060000003B30AE
          A20000000467414D410000B18E7CFB5193000000206348524D0000870F00008C
          0F0000FD520000814000007D790000E98B00003CE5000019CC733C857700000A
          396943435050686F746F73686F70204943432070726F66696C65000048C79D96
          775454D71687CFBD777AA1CD30025286DEBBC000D27B935E456198196028030E
          3334B121A2021145449A224850C480D150245644B1101454B007240828311845
          542C6F46D68BAEACBCF7F2F2FBE3AC6FEDB3F7B9FBECBDCF5A170092A72F9797
          064B0190CA13F0833C9CE911915174EC0080011E608029004C5646BA5FB07B08
          10C9CBCD859E2172025F0401F07A58BC0270D3D033804E07FF9FA459E97C81E8
          9800119BB339192C11178838254B902EB6CF8A981A972C66182566BE284111CB
          893961910D3EFB2CB2A398D9A93CB688C539A7B353D962EE15F1B64C2147C488
          AF880B33B99C2C11DF12B1468A30952BE237E2D8540E33030014496C17705889
          22361131891F12E422E2E500E048095F71DC572CE0640BC49772494BCFE17313
          1205741D962EDDD4DA9A41F7E464A5700402C300262B99C967D35DD252D399BC
          1C0016EFFC5932E2DAD24545B634B5B6B434343332FDAA50FF75F36F4ADCDB45
          7A19F8B96710ADFF8BEDAFFCD21A0060CC896AB3F38B2DAE0A80CE2D00C8DDFB
          62D3380080A4A86F1DD7BFBA0F4D3C2F890241BA8DB1715656961197C3321217
          F40FFD4F87BFA1AFBE67243EEE8FF2D05D39F14C618A802EAE1B2B2D254DC8A7
          67A433591CBAE19F87F81F07FE751E06419C780E9FC313458489A68CCB4B10B5
          9BC7E60AB8693C3A97F79F9AF80FC3FEA4C5B91689D2F81150638C80D4752A40
          7EED07280A1120D1FBC55DFFA36FBEF830207E79E12A938B73FFEF37FD67C1A5
          E225839BF039CE252884CE12F23317F7C4CF12A0010148022A9007CA401DE800
          436006AC802D70046EC01BF8831010095603164804A9800FB2401ED8040A4131
          D809F6806A50071A41336805C741273805CE834BE01AB8016E83FB60144C8067
          6016BC060B10046121324481E421154813D287CC2006640FB941BE50101409C5
          4209100F124279D066A8182A83AAA17AA819FA1E3A099D87AE4083D05D680C9A
          867E87DEC1084C82A9B012AC051BC30CD809F68143E0557002BC06CE850BE01D
          7025DC001F853BE0F3F035F8363C0A3F83E7108010111AA28A18220CC405F147
          A29078848FAC478A900AA4016945BA913EE426328ACC206F51181405454719A2
          6C519EA850140BB506B51E5582AA461D4675A07A51375163A859D4473419AD88
          D647DBA0BDD011E8047416BA105D816E42B7A32FA26FA327D0AF31180C0DA38D
          B1C2786222314998B59812CC3E4C1BE61C6610338E99C362B1F2587DAC1DD61F
          CBC40AB085D82AEC51EC59EC107602FB0647C4A9E0CC70EEB8281C0F978FABC0
          1DC19DC10DE126710B7829BC26DE06EF8F67E373F0A5F8467C37FE3A7E02BF40
          90266813EC08218424C2264225A1957091F080F0924824AA11AD8981442E7123
          B192788C789938467C4B9221E9915C48D124216907E910E91CE92EE925994CD6
          223B92A3C802F20E7233F902F911F98D0445C248C24B822DB141A246A2436248
          E2B9245E5253D24972B564AE6485E409C9EB92335278292D291729A6D47AA91A
          A99352235273D2146953697FE954E912E923D257A4A764B0325A326E326C9902
          9983321764C62908459DE242615136531A29172913540C559BEA454DA21653BF
          A30E506765656497C986C966CBD6C89E961DA521342D9A172D85564A3B4E1BA6
          BD5BA2B4C4690967C9F625AD4B8696CCCB2D957394E3C815C9B5C9DD967B274F
          9777934F96DF25DF29FF5001A5A0A710A890A5B05FE1A2C2CC52EA52DBA5ACA5
          454B8F2FBDA7082BEA290629AE553CA8D8AF38A7A4ACE4A194AE54A574416946
          99A6ECA89CA45CAE7C46795A85A262AFC255295739ABF2942E4B77A2A7D02BE9
          BDF4595545554F55A16ABDEA80EA829AB65AA85ABE5A9BDA4375823A433D5EBD
          5CBD477D564345C34F234FA345E39E265E93A199A8B957B34F735E4B5B2B5C6B
          AB56A7D694B69CB69776AE768BF6031DB28E83CE1A9D069D5BBA185D866EB2EE
          3EDD1B7AB09E855EA25E8DDE757D58DF529FABBF4F7FD0006D606DC033683018
          3124193A19661AB6188E19D18C7C8DF28D3A8D9E1B6B184719EF32EE33FE6862
          619262D26872DF54C6D4DB34DFB4DBF477333D3396598DD92D73B2B9BBF906F3
          2EF317CBF4977196ED5F76C78262E167B1D5A2C7E283A59525DFB2D572DA4AC3
          2AD6AAD66A84416504304A1897ADD1D6CED61BAC4F59BFB5B1B411D81CB7F9CD
          D6D036D9F688EDD472EDE59CE58DCBC7EDD4EC9876F576A3F674FB58FB03F6A3
          0EAA0E4C870687C78EEA8E6CC726C749275DA724A7A34ECF9D4D9CF9CEEDCEF3
          2E362EEB5CCEB922AE1EAE45AE036E326EA16ED56E8FDCD5DC13DC5BDC673D2C
          3CD67A9CF3447BFA78EEF21CF152F26279357BCD7A5B79AFF3EEF521F904FB54
          FB3CF6D5F3E5FB76FBC17EDE7EBBFD1EACD05CC15BD1E90FFCBDFC77FB3F0CD0
          0E5813F06320263020B026F0499069505E505F30253826F848F0EB10E790D290
          FBA13AA1C2D09E30C9B0E8B0E6B0F970D7F0B2F0D108E3887511D7221522B991
          5D51D8A8B0A8A6A8B9956E2BF7AC9C88B6882E8C1E5EA5BD2A7BD595D50AAB53
          569F8E918C61C69C8845C786C71E897DCFF4673630E7E2BCE26AE366592EACBD
          AC676C4776397B9A63C729E34CC6DBC597C54F25D825EC4E984E7448AC489CE1
          BA70ABB92F923C93EA92E693FD930F257F4A094F694BC5A5C6A69EE4C9F09279
          BD69CA69D96983E9FAE985E9A36B6CD6EC5933CBF7E137654019AB32BA0454D1
          CF54BF5047B8453896699F5993F9262B2CEB44B674362FBB3F472F677BCE64AE
          7BEEB76B516B596B7BF254F336E58DAD735A57BF1E5A1FB7BE6783FA86820D13
          1B3D361EDE44D894BCE9A77C93FCB2FC579BC337771728156C2C18DFE2B1A5A5
          50A2905F38B2D5766BDD36D436EEB681EDE6DBABB67F2C62175D2D3629AE287E
          5FC22AB9FA8DE93795DF7CDA11BF63A0D4B274FF4ECC4EDECEE15D0EBB0E9749
          97E5968DEFF6DBDD514E2F2F2A7FB52766CF958A6515757B097B857B472B7D2B
          BBAA34AA7656BDAF4EACBE5DE35CD356AB58BBBD767E1F7BDFD07EC7FDAD754A
          75C575EF0E700FDCA9F7A8EF68D06AA83888399879F049635863DFB78C6F9B9B
          149A8A9B3E1CE21D1A3D1C74B8B7D9AAB9F988E291D216B845D8327D34FAE88D
          EF5CBFEB6A356CAD6FA3B5151F03C784C79E7E1FFBFDF0719FE33D2718275A7F
          D0FCA1B69DD25ED40175E474CC7626768E7645760D9EF43ED9D36DDBDDFEA3D1
          8F874EA99EAA392D7BBAF40CE14CC1994F6773CFCE9D4B3F37733EE1FC784F4C
          CFFD0B11176EF506F60E5CF4B978F992FBA50B7D4E7D672FDB5D3E75C5E6CAC9
          AB8CAB9DD72CAF75F45BF4B7FF64F153FB80E540C775ABEB5D37AC6F740F2E1F
          3C33E43074FEA6EBCD4BB7BC6E5DBBBDE2F6E070E8F09D91E891D13BEC3B5377
          53EEBEB897796FE1FEC607E807450FA51E563C527CD4F0B3EECF6DA396A3A7C7
          5CC7FA1F073FBE3FCE1A7FF64BC62FEF270A9E909F544CAA4C364F994D9D9A76
          9FBEF174E5D38967E9CF16660A7F95FEB5F6B9CEF31F7E73FCAD7F366276E205
          FFC5A7DF4B5ECABF3CF46AD9AB9EB980B947AF535F2FCC17BD917F73F82DE36D
          DFBBF077930B59EFB1EF2B3FE87EE8FEE8F3F1C1A7D44F9FFE050398F3FCBAC4
          E8D3000000097048597300000EC300000EC301C76FA864000000197445587453
          6F667477617265005061696E742E4E45542076332E352E36D083AD5A000005F2
          49444154484BED56594F5B5710BE3CB4FD01F905959AED297D8A9444ADD4A72C
          7DCA63A53AAAD28688B42104C2164880607687CD60309B8D6DBC8131C66131DE
          B08D77C0408090A4ED1F69ABE937E7FA1092E7A852D55AFA3433E79C3BDF9939
          E7CC5851FEFFFDA73230BCBA5B6F0CEE45C6432F19E1C9F0FE870819D7F6341F
          35295A67F8B381E59D3F46D75E9231C8D8A73146689FC68189F081902381BDDF
          3F2AB16E71AB7A7079878656766968F51DF4455BCC611CF2AFBE17DB95034B05
          0DA37F695B035BD3EBDF1252B7B8A9E9F66D6A3ABD394D9B27ABD1CE65352DEE
          B4A6D191D43C75A6AE1F6F7A299329E998CF7CD3E9DD24AD2747CF66B3D4ECCE
          D213679A1A1D6921A5DE28759E2BCE4BD9E048D1637B8AEA6692546DD9A0CAE9
          04559862F4602A460FCD71AA825D63DBA01A6BFCBA6D2D52A2D81347C6F9ECAF
          E4CDFD460B804FCA3C7480C7E49C17EB78ED5CE62DCDA6DF922BF5861C1BAF05
          6612AFC9127B2530BDAEC2143DA4A9C8813826093E2E4360D7A8E0A3023BF164
          54A7ECDC9B55C98404789CE71992D49138227BE29520B503B6F81159E3202C12
          ABA487340952BE274CCC3A4BDC93823293380A32F15C91DC83685412352A1E97
          988EECD1902F493A579474EE75EA7246A807B27F2145E3C15D11AD79FD50443A
          8948D568DF5D5079510D81BDA0628DBD723A936FC88DB4A9782B2493BA0191D2
          E46B10A604A129B42B30BA9C271B888C2B5B204E53973B46BDDE349904E1E17B
          A9952F447D2D2F09CFD6A998A207064E951D67C49237C1E96329F53E4F9C4697
          7234028C070A0256A4761AD1E9FD39322342AD3D4A03BE2C75CF258F9F1E47C8
          44F289F2F3647B6865C7A0A048B4B3133E2306525F847A6EFAC50C0D2295E6C8
          3EF42C1996F2C797676C6D9746560B34E0CF93CE838CCCA7A9C39DA05E5F4ED4
          00261C29829F22CE566070B9D0AEA052D5F2B9F0AEE5C59037D31C3DA0565B88
          865FE471867BD4E95C17E7C69784D3C9845DB31BD4B790219D37433D8001042D
          F6186EEE9EC0F0AA2A0D905C23D8C67BAF55F4CB3B65F2C6F185605D380706E1
          B875264C43206E7744A9C912A4EE6264CF719E1C619B6B03A459114997272D9C
          6B5DB8800B792E36025C84A4CEB2CD932B53B8FA703ADE954AF502B0DD89687A
          40D485F475B812A475C444D9E439DEB96E214775A610A74E38EF9ACFD2F3C52D
          6A75A5483B9B46640581FEA502F51675B6BBBCF9EF1594B89B7257A23C022C19
          AD8E3875CCA544A97C620953FD5480DADC49424DA77E38D0426F712448E7DB14
          8E3BE773D4E141E57326811436B14DDDBE2DD241327AA03FF76F23E2EC4DA5DD
          93BDCABBE0019E94BBECF517E0344E4D337826986FB6C7A907E97B6A8D8AF1C7
          D3117A3816A0465B8CEACC116A766C50AD390A44A8DA14A116179ED8C2E67BE0
          B2CC63CDAED455A5C995FEBA532CD81283BC4306DB9CAE87C615A13758D689D7
          31110ABF88A8C11AE3B4D13390D482AC06A8B7C4A87C2C482DEE8CA8FD27D136
          9F17361AC6574A833D71911B030FB4CEE590067552E2C1E80A35D8E2701A16F3
          AD585B351154A382DEE4CA50C3CC86B02B40F8682A4A5500CF31B8E130789DB4
          EBACF18B4AA53976E12906B9039D94BC90ED4638BD3BB0088711AA4534A253D9
          937467C04FF5E836F598AF9C088BF1FB20BE3B848D629E3B1B77AC46C6079DAE
          7C6AFD82523E113E5F8F762630A34A6E6DDCE28EDB9C799D7EEAF3D1DDC117EA
          1ACC971BD7A8623C48770697A87A3A4E1593112A0569AD2551F49514EBA44FD5
          BF6AFF3C1E3AAF941983A7ABAD4815F0087D947BA9B4D5B1843A371DA35210DF
          EEF3D33D434010DE1F0BD18FB07FE8F553D9C81ABE55D70A14FD549D1CC3780D
          503A12F842B93D1CF89C1BF5497013675B4AA9B3934A34F75F40780F448CFB63
          613479FE3E26D673C33FF9FD491FD2CF2DFDEAE7CAAD5ECF29E4FC4FFEA7F000
          4EE5062AE18C89386219B58C8677CDBA949C290693324E065181002A4C71E19B
          C15CDF75BB4F292525259F7CF9EDADD233576E0C9CB97C6D08D033CE16E5B92B
          D7F4EFE1F255FDB90F701636E3CC258065F1DBD397AEE94F17753176E5463F73
          81F453F9DFAB04CA3F898FFA47F5DFE1EC6F83F540FD5EC4EA92000000004945
          4E44AE426082}
        Name = '1'
        Tag = 0
      end
      item
        Picture.Data = {
          89504E470D0A1A0A0000000D494844520000001E0000001E08060000003B30AE
          A20000000467414D410000B18E7CFB5193000000206348524D0000870F00008C
          0F0000FD520000814000007D790000E98B00003CE5000019CC733C857700000A
          396943435050686F746F73686F70204943432070726F66696C65000048C79D96
          775454D71687CFBD777AA1CD30025286DEBBC000D27B935E456198196028030E
          3334B121A2021145449A224850C480D150245644B1101454B007240828311845
          542C6F46D68BAEACBCF7F2F2FBE3AC6FEDB3F7B9FBECBDCF5A170092A72F9797
          064B0190CA13F0833C9CE911915174EC0080011E608029004C5646BA5FB07B08
          10C9CBCD859E2172025F0401F07A58BC0270D3D033804E07FF9FA459E97C81E8
          9800119BB339192C11178838254B902EB6CF8A981A972C66182566BE284111CB
          893961910D3EFB2CB2A398D9A93CB688C539A7B353D962EE15F1B64C2147C488
          AF880B33B99C2C11DF12B1468A30952BE237E2D8540E33030014496C17705889
          22361131891F12E422E2E500E048095F71DC572CE0640BC49772494BCFE17313
          1205741D962EDDD4DA9A41F7E464A5700402C300262B99C967D35DD252D399BC
          1C0016EFFC5932E2DAD24545B634B5B6B434343332FDAA50FF75F36F4ADCDB45
          7A19F8B96710ADFF8BEDAFFCD21A0060CC896AB3F38B2DAE0A80CE2D00C8DDFB
          62D3380080A4A86F1DD7BFBA0F4D3C2F890241BA8DB1715656961197C3321217
          F40FFD4F87BFA1AFBE67243EEE8FF2D05D39F14C618A802EAE1B2B2D254DC8A7
          67A433591CBAE19F87F81F07FE751E06419C780E9FC313458489A68CCB4B10B5
          9BC7E60AB8693C3A97F79F9AF80FC3FEA4C5B91689D2F81150638C80D4752A40
          7EED07280A1120D1FBC55DFFA36FBEF830207E79E12A938B73FFEF37FD67C1A5
          E225839BF039CE252884CE12F23317F7C4CF12A0010148022A9007CA401DE800
          436006AC802D70046EC01BF8831010095603164804A9800FB2401ED8040A4131
          D809F6806A50071A41336805C741273805CE834BE01AB8016E83FB60144C8067
          6016BC060B10046121324481E421154813D287CC2006640FB941BE50101409C5
          4209100F124279D066A8182A83AAA17AA819FA1E3A099D87AE4083D05D680C9A
          867E87DEC1084C82A9B012AC051BC30CD809F68143E0557002BC06CE850BE01D
          7025DC001F853BE0F3F035F8363C0A3F83E7108010111AA28A18220CC405F147
          A29078848FAC478A900AA4016945BA913EE426328ACC206F51181405454719A2
          6C519EA850140BB506B51E5582AA461D4675A07A51375163A859D4473419AD88
          D647DBA0BDD011E8047416BA105D816E42B7A32FA26FA327D0AF31180C0DA38D
          B1C2786222314998B59812CC3E4C1BE61C6610338E99C362B1F2587DAC1DD61F
          CBC40AB085D82AEC51EC59EC107602FB0647C4A9E0CC70EEB8281C0F978FABC0
          1DC19DC10DE126710B7829BC26DE06EF8F67E373F0A5F8467C37FE3A7E02BF40
          90266813EC08218424C2264225A1957091F080F0924824AA11AD8981442E7123
          B192788C789938467C4B9221E9915C48D124216907E910E91CE92EE925994CD6
          223B92A3C802F20E7233F902F911F98D0445C248C24B822DB141A246A2436248
          E2B9245E5253D24972B564AE6485E409C9EB92335278292D291729A6D47AA91A
          A99352235273D2146953697FE954E912E923D257A4A764B0325A326E326C9902
          9983321764C62908459DE242615136531A29172913540C559BEA454DA21653BF
          A30E506765656497C986C966CBD6C89E961DA521342D9A172D85564A3B4E1BA6
          BD5BA2B4C4690967C9F625AD4B8696CCCB2D957394E3C815C9B5C9DD967B274F
          9777934F96DF25DF29FF5001A5A0A710A890A5B05FE1A2C2CC52EA52DBA5ACA5
          454B8F2FBDA7082BEA290629AE553CA8D8AF38A7A4ACE4A194AE54A574416946
          99A6ECA89CA45CAE7C46795A85A262AFC255295739ABF2942E4B77A2A7D02BE9
          BDF4595545554F55A16ABDEA80EA829AB65AA85ABE5A9BDA4375823A433D5EBD
          5CBD477D564345C34F234FA345E39E265E93A199A8B957B34F735E4B5B2B5C6B
          AB56A7D694B69CB69776AE768BF6031DB28E83CE1A9D069D5BBA185D866EB2EE
          3EDD1B7AB09E855EA25E8DDE757D58DF529FABBF4F7FD0006D606DC033683018
          3124193A19661AB6188E19D18C7C8DF28D3A8D9E1B6B184719EF32EE33FE6862
          619262D26872DF54C6D4DB34DFB4DBF477333D3396598DD92D73B2B9BBF906F3
          2EF317CBF4977196ED5F76C78262E167B1D5A2C7E283A59525DFB2D572DA4AC3
          2AD6AAD66A84416504304A1897ADD1D6CED61BAC4F59BFB5B1B411D81CB7F9CD
          D6D036D9F688EDD472EDE59CE58DCBC7EDD4EC9876F576A3F674FB58FB03F6A3
          0EAA0E4C870687C78EEA8E6CC726C749275DA724A7A34ECF9D4D9CF9CEEDCEF3
          2E362EEB5CCEB922AE1EAE45AE036E326EA16ED56E8FDCD5DC13DC5BDC673D2C
          3CD67A9CF3447BFA78EEF21CF152F26279357BCD7A5B79AFF3EEF521F904FB54
          FB3CF6D5F3E5FB76FBC17EDE7EBBFD1EACD05CC15BD1E90FFCBDFC77FB3F0CD0
          0E5813F06320263020B026F0499069505E505F30253826F848F0EB10E790D290
          FBA13AA1C2D09E30C9B0E8B0E6B0F970D7F0B2F0D108E3887511D7221522B991
          5D51D8A8B0A8A6A8B9956E2BF7AC9C88B6882E8C1E5EA5BD2A7BD595D50AAB53
          569F8E918C61C69C8845C786C71E897DCFF4673630E7E2BCE26AE366592EACBD
          AC676C4776397B9A63C729E34CC6DBC597C54F25D825EC4E984E7448AC489CE1
          BA70ABB92F923C93EA92E693FD930F257F4A094F694BC5A5C6A69EE4C9F09279
          BD69CA69D96983E9FAE985E9A36B6CD6EC5933CBF7E137654019AB32BA0454D1
          CF54BF5047B8453896699F5993F9262B2CEB44B674362FBB3F472F677BCE64AE
          7BEEB76B516B596B7BF254F336E58DAD735A57BF1E5A1FB7BE6783FA86820D13
          1B3D361EDE44D894BCE9A77C93FCB2FC579BC337771728156C2C18DFE2B1A5A5
          50A2905F38B2D5766BDD36D436EEB681EDE6DBABB67F2C62175D2D3629AE287E
          5FC22AB9FA8DE93795DF7CDA11BF63A0D4B274FF4ECC4EDECEE15D0EBB0E9749
          97E5968DEFF6DBDD514E2F2F2A7FB52766CF958A6515757B097B857B472B7D2B
          BBAA34AA7656BDAF4EACBE5DE35CD356AB58BBBD767E1F7BDFD07EC7FDAD754A
          75C575EF0E700FDCA9F7A8EF68D06AA83888399879F049635863DFB78C6F9B9B
          149A8A9B3E1CE21D1A3D1C74B8B7D9AAB9F988E291D216B845D8327D34FAE88D
          EF5CBFEB6A356CAD6FA3B5151F03C784C79E7E1FFBFDF0719FE33D2718275A7F
          D0FCA1B69DD25ED40175E474CC7626768E7645760D9EF43ED9D36DDBDDFEA3D1
          8F874EA99EAA392D7BBAF40CE14CC1994F6773CFCE9D4B3F37733EE1FC784F4C
          CFFD0B11176EF506F60E5CF4B978F992FBA50B7D4E7D672FDB5D3E75C5E6CAC9
          AB8CAB9DD72CAF75F45BF4B7FF64F153FB80E540C775ABEB5D37AC6F740F2E1F
          3C33E43074FEA6EBCD4BB7BC6E5DBBBDE2F6E070E8F09D91E891D13BEC3B5377
          53EEBEB897796FE1FEC607E807450FA51E563C527CD4F0B3EECF6DA396A3A7C7
          5CC7FA1F073FBE3FCE1A7FF64BC62FEF270A9E909F544CAA4C364F994D9D9A76
          9FBEF174E5D38967E9CF16660A7F95FEB5F6B9CEF31F7E73FCAD7F366276E205
          FFC5A7DF4B5ECABF3CF46AD9AB9EB980B947AF535F2FCC17BD917F73F82DE36D
          DFBBF077930B59EFB1EF2B3FE87EE8FEE8F3F1C1A7D44F9FFE050398F3FCBAC4
          E8D3000000097048597300000EC300000EC301C76FA864000000197445587453
          6F667477617265005061696E742E4E45542076332E352E36D083AD5A0000085F
          49444154484BED9679588EF91AC789504498A36330C6324623A1A2458D8A5296
          1CA30D994879EBADB4493583B6B714A3450BADD2629990DED24298D2A690B46A
          A35545BB76BDDF733FAECE5CE79A663473CEF9F33CD7F5BD9EDFF3BCF7737FEE
          FBFBFC7EBFF79930E1FFC7A71CE05F357D02FF2AA509FC62EC49026B5DF805D7
          B94C159264CF1691579A2EBC61FAFFDC3CC15952F25385D6C74ACA1BF6195905
          C2CD3F15D1DC425C4F2E414054362C4F46619F01A74F42462F76E21471F9FFBA
          808953C53F9F242011272E7D182CDB6838FADC8793EF4344724BE0199C037BCF
          14FC702605A7BCEE22F85A1E7E0ABA8F65AB0F4040582E8E4F60DDE7FF51017C
          D324E4F804E55AC4648FC2F4C40D58B924C0C62D19C1B18530754C82815D020E
          DBA7C2C821114EE7D361E99A045BF724B807A461BDB20D26CFD8D8C2374D52EE
          2FC127094ACB4D1652EE9932770FF69B85E1A04D2C0CED93E077A510DF1FBB03
          2DB378EC31E54293A4639986E36733E93E1562C7853339723BB510D3E76B63B2
          D0B73D4CAE3F059F2CA4B0807FE6E69669225A98B198057DDB5BD87EF8063861
          55D0B3CFC60E763AD4D999506367D3F91134AD3260E8948FDD66A9D0344FC08F
          DE19B8965882B92BCC21F0775D4C11566EE19FA9B0605CF854E1CD5C41AA76E6
          523644D69C8206EB0634D80930762FC066A3746C66E54099950725563E944C9E
          42DFB51C1AB64550B7AD84814B018E3867C0CCF90162130BA1B8C7078BD79840
          689E1AF7936081392A8AB3166963F65766F86CF5292CDDE40735E324989E7D0E
          09FD1CC81A3E81824921BE6517619329A36218785643C5B208C65ED53878FA25
          3619E7C029B8143189955820E58A395F5B90ED9A98364755F10FE13344346E2F
          5C6B8925B21C2C94F38694D6CFF08CAEC456EB0288EA1740FCD073481ABD80B4
          493164092A6F5E82D0A4569CBBD10C55DB526C39568AFD6E6558B62B05EA1619
          58FB8FAB982FC5C1672BCD3163BEE6EDDF05CF5AA83B73DE0A83C105522721AB
          150E9DE3777127B301FD8323D0742C83987131561374835931341C2B61E8FB1A
          2CFF5AD885376097630514AC4AA17FAE0662264558A9978D35FA0FA175EC2E96
          2A076391F469CC5DCE1E9C498C31F0394BF4B77E21610B498D40ACDC168675FB
          B9C87CD186E10F3C78C7378315DC802381753874BE16DB9D2B2165518AB56625
          50B42FC789A84658530112E6C558675102098B224898E6E1202717A23B22F095
          4A30164AFB80618C018B889A5A2D5770878C4E24B4ECD2B0E1C803D847D4E07A
          4E07944E966323752963570EE98F2AFB28E6DAF3D61B0C8FF0E019D7FCF15A86
          EE6F74AA809CC30B1879154262EF4D88EFBA8C155B0220226A663506BC48D2C1
          6DF5F640ACD7BD0A25760AAC43CA9156D405ABE8067CE7F30ACA676BB0C9A572
          8C7EB8DE84D2C601B0C3EB7FFD4DC9B70E8A64BB49401914582990F9FE36D6EC
          0AC517C418035E2EEFE6BE41270ADF1AC643E9E87DEC747E86B4926E843C6A43
          56652F3443EAA1E6550335EF1AA833A262B6914EC4B7604FE06B98C63462EBB9
          6AA892D402EBA11EF01AE6211550B3A12548F9A4F7C6E06B450FF7316051156F
          1B8543B1503D7A0FEAC733A1E15A00676E130E5CAA437C710FDC1FB68193F60E
          F689AD3874A511ECD826DC7CDE0DFF47EDD0A26E6DB92DD0A6F3AEA05AEC0EA9
          C5778155F088AB05CBEB19F4DCF3A043DBAB989AAFCD18B0F8CE8BDB9458F1D0
          707884DDA71E43E74C21DC92DE4037A21626716FC0F9A50D2604B5497D0BAFC7
          9DC8A8EB070FC0AB8E6178D33CE0A4B7C32FB71376C9ADF89174EE5E0BDADF0F
          A3B2B117F6E1B4D468135AA311B46D0C584AEBB2F0669384216D973CECA55DEA
          A04F09CEA4BCC1E1AB7560273623A8B01BAE8FBB7032A7134E795D08287E8FAA
          EE0FB856D9070E5DBB53316748FEF99DE44A13CCA36A905ED281D8CC66B0FD8A
          B0CD2279487A6FB4F0EFAEE52D664977F67B14E090773158175EC2EF7E0B2C6F
          D6C3E17E2B3C9E7681DB3008DF977DF0AF1A4054DD20AED60FC2AFB21FDE657D
          F028EC812375EE99D586A0CCB7F04C6C04F7491B4EC65443CFB3005BCC92EFFC
          E1CEA56A7177EB3E8FA730BE5801F34BD508CB7A871364F7E9EC76F85287B104
          4E681D46D49B61A4758CE04AF30744360D23BC7E0817A8002F7AE77E791D78DE
          486372CB87641254817DA79F41D5F2DED835FCEF956871F2EF998555E318591C
          FDA413A77F7987F305DD08ABEA470C41D2BB4690D2C943CE7B1EE23A78B8D936
          82EBAD1F1045F0E8EA7E4495F4D0246C852FB954D532006BDA0BB45CF3EF8DFB
          EF44E0254617CA3B1C6E362192ECF5CBEF4250692F593B841B6F47104FD09A41
          A0F30390DAC343421715D0CEC32D82731BA9F317EFE199D10EB7D4565CCE6E83
          5948458716E7C99271C11430499BF37087F595DA81B33453AF123488DE61F4BF
          C0D465493F0F8334A5737B79E052210C388D3A8F7C358840029FCDEA44405607
          8E5FAB1DD07279B083C9391E980960BE16FFB6D32642DF3EAEA127ACA007178B
          7A115E3588988661FCDCF20171EF4690D3CD432ABDE7ACEE113C26FB6F350E23
          F4653FCE3F7B0F2F027B2437F5ECB0BE749072CD23CD180FCE4F01B348CC17C3
          37DF6CD23C60195950E697D74D9DF452E20144D4D0BBA4EEEFD0C48AAE1B4674
          ED10CA3A4790DA3084EB15FD087EDA032F6E7199948AF601CAB18AB490C42CA3
          299FEAFAD78E2968194966E2443E1D85BD56A1D691B935E772BB78FECF7B71A1
          A80F97A9888BC5FD1FC7A154D44FD99D3CABCBB9350ABA56A1F48C2E3D2B4B5A
          FE673B668A62E002A4D9A4C52409921A496FDE972BEDB6183884ED778948669D
          E7661EF1E566EAD15885EECDFB52F43813331A2B39FA2C9343703C9B7FEB04DF
          A83D8CF5CC373253BD188949CA74C37CB83362C652A4D5A3314C2CF3CC541293
          63E26F13FF956B26C1E4D1644C07CC64111A153366EE31202686891DF7F82748
          31917CB137AFD00000000049454E44AE426082}
        Name = '5'
        Tag = 0
      end
      item
        Picture.Data = {
          89504E470D0A1A0A0000000D494844520000001E0000001E08060000003B30AE
          A20000000467414D410000B18E7CFB5193000000206348524D0000870F00008C
          0F0000FD520000814000007D790000E98B00003CE5000019CC733C857700000A
          396943435050686F746F73686F70204943432070726F66696C65000048C79D96
          775454D71687CFBD777AA1CD30025286DEBBC000D27B935E456198196028030E
          3334B121A2021145449A224850C480D150245644B1101454B007240828311845
          542C6F46D68BAEACBCF7F2F2FBE3AC6FEDB3F7B9FBECBDCF5A170092A72F9797
          064B0190CA13F0833C9CE911915174EC0080011E608029004C5646BA5FB07B08
          10C9CBCD859E2172025F0401F07A58BC0270D3D033804E07FF9FA459E97C81E8
          9800119BB339192C11178838254B902EB6CF8A981A972C66182566BE284111CB
          893961910D3EFB2CB2A398D9A93CB688C539A7B353D962EE15F1B64C2147C488
          AF880B33B99C2C11DF12B1468A30952BE237E2D8540E33030014496C17705889
          22361131891F12E422E2E500E048095F71DC572CE0640BC49772494BCFE17313
          1205741D962EDDD4DA9A41F7E464A5700402C300262B99C967D35DD252D399BC
          1C0016EFFC5932E2DAD24545B634B5B6B434343332FDAA50FF75F36F4ADCDB45
          7A19F8B96710ADFF8BEDAFFCD21A0060CC896AB3F38B2DAE0A80CE2D00C8DDFB
          62D3380080A4A86F1DD7BFBA0F4D3C2F890241BA8DB1715656961197C3321217
          F40FFD4F87BFA1AFBE67243EEE8FF2D05D39F14C618A802EAE1B2B2D254DC8A7
          67A433591CBAE19F87F81F07FE751E06419C780E9FC313458489A68CCB4B10B5
          9BC7E60AB8693C3A97F79F9AF80FC3FEA4C5B91689D2F81150638C80D4752A40
          7EED07280A1120D1FBC55DFFA36FBEF830207E79E12A938B73FFEF37FD67C1A5
          E225839BF039CE252884CE12F23317F7C4CF12A0010148022A9007CA401DE800
          436006AC802D70046EC01BF8831010095603164804A9800FB2401ED8040A4131
          D809F6806A50071A41336805C741273805CE834BE01AB8016E83FB60144C8067
          6016BC060B10046121324481E421154813D287CC2006640FB941BE50101409C5
          4209100F124279D066A8182A83AAA17AA819FA1E3A099D87AE4083D05D680C9A
          867E87DEC1084C82A9B012AC051BC30CD809F68143E0557002BC06CE850BE01D
          7025DC001F853BE0F3F035F8363C0A3F83E7108010111AA28A18220CC405F147
          A29078848FAC478A900AA4016945BA913EE426328ACC206F51181405454719A2
          6C519EA850140BB506B51E5582AA461D4675A07A51375163A859D4473419AD88
          D647DBA0BDD011E8047416BA105D816E42B7A32FA26FA327D0AF31180C0DA38D
          B1C2786222314998B59812CC3E4C1BE61C6610338E99C362B1F2587DAC1DD61F
          CBC40AB085D82AEC51EC59EC107602FB0647C4A9E0CC70EEB8281C0F978FABC0
          1DC19DC10DE126710B7829BC26DE06EF8F67E373F0A5F8467C37FE3A7E02BF40
          90266813EC08218424C2264225A1957091F080F0924824AA11AD8981442E7123
          B192788C789938467C4B9221E9915C48D124216907E910E91CE92EE925994CD6
          223B92A3C802F20E7233F902F911F98D0445C248C24B822DB141A246A2436248
          E2B9245E5253D24972B564AE6485E409C9EB92335278292D291729A6D47AA91A
          A99352235273D2146953697FE954E912E923D257A4A764B0325A326E326C9902
          9983321764C62908459DE242615136531A29172913540C559BEA454DA21653BF
          A30E506765656497C986C966CBD6C89E961DA521342D9A172D85564A3B4E1BA6
          BD5BA2B4C4690967C9F625AD4B8696CCCB2D957394E3C815C9B5C9DD967B274F
          9777934F96DF25DF29FF5001A5A0A710A890A5B05FE1A2C2CC52EA52DBA5ACA5
          454B8F2FBDA7082BEA290629AE553CA8D8AF38A7A4ACE4A194AE54A574416946
          99A6ECA89CA45CAE7C46795A85A262AFC255295739ABF2942E4B77A2A7D02BE9
          BDF4595545554F55A16ABDEA80EA829AB65AA85ABE5A9BDA4375823A433D5EBD
          5CBD477D564345C34F234FA345E39E265E93A199A8B957B34F735E4B5B2B5C6B
          AB56A7D694B69CB69776AE768BF6031DB28E83CE1A9D069D5BBA185D866EB2EE
          3EDD1B7AB09E855EA25E8DDE757D58DF529FABBF4F7FD0006D606DC033683018
          3124193A19661AB6188E19D18C7C8DF28D3A8D9E1B6B184719EF32EE33FE6862
          619262D26872DF54C6D4DB34DFB4DBF477333D3396598DD92D73B2B9BBF906F3
          2EF317CBF4977196ED5F76C78262E167B1D5A2C7E283A59525DFB2D572DA4AC3
          2AD6AAD66A84416504304A1897ADD1D6CED61BAC4F59BFB5B1B411D81CB7F9CD
          D6D036D9F688EDD472EDE59CE58DCBC7EDD4EC9876F576A3F674FB58FB03F6A3
          0EAA0E4C870687C78EEA8E6CC726C749275DA724A7A34ECF9D4D9CF9CEEDCEF3
          2E362EEB5CCEB922AE1EAE45AE036E326EA16ED56E8FDCD5DC13DC5BDC673D2C
          3CD67A9CF3447BFA78EEF21CF152F26279357BCD7A5B79AFF3EEF521F904FB54
          FB3CF6D5F3E5FB76FBC17EDE7EBBFD1EACD05CC15BD1E90FFCBDFC77FB3F0CD0
          0E5813F06320263020B026F0499069505E505F30253826F848F0EB10E790D290
          FBA13AA1C2D09E30C9B0E8B0E6B0F970D7F0B2F0D108E3887511D7221522B991
          5D51D8A8B0A8A6A8B9956E2BF7AC9C88B6882E8C1E5EA5BD2A7BD595D50AAB53
          569F8E918C61C69C8845C786C71E897DCFF4673630E7E2BCE26AE366592EACBD
          AC676C4776397B9A63C729E34CC6DBC597C54F25D825EC4E984E7448AC489CE1
          BA70ABB92F923C93EA92E693FD930F257F4A094F694BC5A5C6A69EE4C9F09279
          BD69CA69D96983E9FAE985E9A36B6CD6EC5933CBF7E137654019AB32BA0454D1
          CF54BF5047B8453896699F5993F9262B2CEB44B674362FBB3F472F677BCE64AE
          7BEEB76B516B596B7BF254F336E58DAD735A57BF1E5A1FB7BE6783FA86820D13
          1B3D361EDE44D894BCE9A77C93FCB2FC579BC337771728156C2C18DFE2B1A5A5
          50A2905F38B2D5766BDD36D436EEB681EDE6DBABB67F2C62175D2D3629AE287E
          5FC22AB9FA8DE93795DF7CDA11BF63A0D4B274FF4ECC4EDECEE15D0EBB0E9749
          97E5968DEFF6DBDD514E2F2F2A7FB52766CF958A6515757B097B857B472B7D2B
          BBAA34AA7656BDAF4EACBE5DE35CD356AB58BBBD767E1F7BDFD07EC7FDAD754A
          75C575EF0E700FDCA9F7A8EF68D06AA83888399879F049635863DFB78C6F9B9B
          149A8A9B3E1CE21D1A3D1C74B8B7D9AAB9F988E291D216B845D8327D34FAE88D
          EF5CBFEB6A356CAD6FA3B5151F03C784C79E7E1FFBFDF0719FE33D2718275A7F
          D0FCA1B69DD25ED40175E474CC7626768E7645760D9EF43ED9D36DDBDDFEA3D1
          8F874EA99EAA392D7BBAF40CE14CC1994F6773CFCE9D4B3F37733EE1FC784F4C
          CFFD0B11176EF506F60E5CF4B978F992FBA50B7D4E7D672FDB5D3E75C5E6CAC9
          AB8CAB9DD72CAF75F45BF4B7FF64F153FB80E540C775ABEB5D37AC6F740F2E1F
          3C33E43074FEA6EBCD4BB7BC6E5DBBBDE2F6E070E8F09D91E891D13BEC3B5377
          53EEBEB897796FE1FEC607E807450FA51E563C527CD4F0B3EECF6DA396A3A7C7
          5CC7FA1F073FBE3FCE1A7FF64BC62FEF270A9E909F544CAA4C364F994D9D9A76
          9FBEF174E5D38967E9CF16660A7F95FEB5F6B9CEF31F7E73FCAD7F366276E205
          FFC5A7DF4B5ECABF3CF46AD9AB9EB980B947AF535F2FCC17BD917F73F82DE36D
          DFBBF077930B59EFB1EF2B3FE87EE8FEE8F3F1C1A7D44F9FFE050398F3FCBAC4
          E8D3000000097048597300000EC300000EC301C76FA864000000197445587453
          6F667477617265005061696E742E4E45542076332E352E36D083AD5A00000A5A
          49444154484BB5970750955716C703D895F200E9BD83B1615D8D618D1A156CD8
          414004EC8AA109561403820D7B54ACA84411EC5204E9D2E1C17B3C105004D4C4
          943565574DD6F2DBFB9C98519CD999DDD9FD66CEDCF9DEFDBEF3FBDF73CF77CE
          7D1F7DF4FFBB5484EB4E7EFEFE9AAB567DD1F97F8D513A57B3B3B3EB7E3EF982
          7D5979E5E43A45434853F3DDC32DF7DB72EA9BDBDB9BDB1EBFBC702175D47F03
          563A57EDD6AD5B975DBBE28D8B6E178F96CB158B1B9BEEEE6C6969BDDADAF6B0
          41D6F4F85966C5B724DE7A48E0F17A3E8DBC8DE1B26C54BCD3599B24E3564EDE
          C27F077E139A80808592ACEC5B836B6A649E771A9B36DD6B694D12CE2BA48DDF
          FCED6AD923F6DC68E3CBE4FB449F6B2328E13E33E39A18B64686D9D222D43CD2
          51F3CC44C52B13559F1CD47CF3F03820A3BCBC324EF856FA7FEF5293D72936B7
          B63DC86D69FBE681B4F1BB97D78A1FB1EF6A2B21C79A99B655C1C7C1B55805D6
          D23F4CCEF0357246282D4286C3AA72347DB2E9254012BF5C34FD0BC57365D88B
          E7751695D149CC0D5D9F8F4CAE48556E494770E7FAFA3B59F117DBF188ABC725
          A28ABE8125982F2A40D737172DAF2CB4E66588310363FF6CEC96E561B3240B6D
          AF2BD82FC96440502ECE21F94CDC5C8AC78E5A5C3694302054FC1696C7A0883C
          3E8FCAA7B656DE989171D3F5DAB51B56EFC2552B2AAB0E79C49572E2462DB2A6
          BB5428EA2991CB2853C8A96C5420BD5B8FACA581BA5605F56DB534B4578BB10A
          456B05B2FBE554351753D2904F9E3C9B9B55195C2FBDCEA5C2CB9CBD99CCC9B4
          144E655E24B7BA5419F24DEF865CE5564E6E48F0E17292B3E5A41425E0B16E3A
          C3564DE0B34DB39912BF108F8440FC4E07B1F2DC52D6A4FAF2E5350FB6A7CD65
          479A27D1573C597D6E16CB4E4CC3F7D06466C5BB3179AB2B9F6F1CCBD0C0BF32
          60C55446ACF62626F92825A565D1EFEDF599B34993CF65DFE3466123071237B3
          34623643968C6164D814DCB7F9E17724882527C3587C7C310147E7B0F2943B21
          67A612913485A0C4492C4A70C3EF901BF3F6BB3173971BD3B64D6442D4E77C12
          3E9E61AB3D18B329906D97CE0A70F9D6F7C03E3EF3ED2A158FB855DA4CD2D903
          C864720AF3F329292BA35A2645DEA4A0AA414A5E753EA9052924661D25213D9E
          BD57B688EC0E23FCC412961FF2C27BCF34A66F77656A9C007F399191EB26317C
          9D3713B786B3E34A32A5A515DBDE03ABAAAA6A2AEEDCFFE9726E3D17521349D8
          16C90C6713EC8C75B130D6C7CCC800277B1B860F7566FCB831CC993D93C58B02
          88DAB086B8AD311C3C7890A4A424D2D2D229282AA2A4B294325905F9D262AE16
          E772A12087ECCA0AE475F54535B5B2F9CABAF036C9BAC9EB1A6AD20A145CCB4E
          A3687F285113ADF01969C3F2F103899C60CD94C1960CB431A6BFB51136267A18
          F4D6A6B78E045D1D2D74B5B5D0F9C324122D245ACA7B091FDB8A77FAF561EEE4
          F1F879CC246A4D28A22ED4086897B7E04EE5E555A995358D14961553B8FB0BD2
          02FA71DAC7998480CF38B36010BB3C86E0EBE2C066F7FEB80EB41042AC7032D7
          C7CE540F137D6D01D21622B4D19648DE8095A614E66861C83C977ECC1DD59730
          AF29DCB9D39C2BA07FD66ED59C9CFCD8FA86266A1575D4C5CF276BD527A4057E
          4A4EE828AAD60DA1246C00E7160D222B780427BCFAB07796235B27DB11F4990D
          6606BAF4B532C6DAC4006D21E08D090146FA3A78BB38B2DB7B24B173877120D8
          4B196E6531E9F4E7F79C9272C9AFBEBE91E67B77C98F9A8362B533D5E143B913
          3990FBD17D79B2C39EC7714E7C17DB8796CDFD91AD71A67CF55076CF1D20C0BD
          D1EFAD83ADA9FE1BA872F5A6428C99BE04C3DE9AB8897CD93EDD9A6BD101544B
          6B13DEDDE38F62626247D5D535D0DAD64EC1BA09E4050DA369C3009EEE72E4E9
          7E5B9E1FB2E59F87AD7975DC9E675F39702FDA91A5A38D196AA34BD8786BD6BB
          DA316980294E66FA6F4404BA98112AE69D2DB430D051C7485783758101949655
          C4BE97D9D6D636C6D552D98BF6070F695FDF97C71B1CF87EB3033F6FB5E1C521
          6B487184B48F799DEEC4A53073865A6B30C85C9D10176D32575A5016EC80D710
          03E2DD0CC52AB549F1B2202FD081F5E30C196DA72342AF49707008F90545611D
          1B867A5E5EE1C387ADF779B4C6822791E6FCBEDB8ED74704F0842D9CB7E7C7E3
          962C1C236188794FC63BF424C6559D274956FCFD941D093374192C567774863E
          639D74899961CDCFDB067269BE3501C38D7034D565576C0C1919597E1D9B45B7
          4B97AF167FDB2CE7FB703D9E46E9F3224E8FD7FB0DE1A425F91B4D19DF578305
          C3D5D9324E9D7B3162FEAA13D40CE659453FE60DD160948D3A1717EA89AFC080
          C1D6DABCFACA99A7312242DE566C1863CCCDB347389F9C32AD23B8D3A953A72F
          FCA8B8CD935075FEB1BE27FF8CE90E7B7AC1216D2EF969B0CB5D83C2105D5E9F
          31877322FCC97662B4A77D8B3ECB87F42478442F764FD0E049AC1903CC35290D
          B5E0B748631A16E871D1AD37A597BF66DFFE831F9C46D4124F9F3DF6A8F83AAD
          BE5D79BCB40BCF233AC3CE1E022CE1FBC89E7CB7B63BBFEDD6842403386D0C67
          CC20D182871B75B8E1AF4DFA123DA40B35F965536F82C6E810EEA2C9EF6B34F8
          255893667F0D5A0AD358B67C8563C715AB26259D3F28BF91C495891A54B8F7E0
          A177679EAE54E3F750359EAE52E545B82AAF23D520BAAB10A40E0775E1B801AF
          0FEB52B74E87977B0D447E88ED893522CB5F57945C2D7E09E9C1AF2BBAD0E2D3
          85B6EAA257262626061DC12AE7CFA7ECB976FA18AB465A1037DA84A4097AE44D
          95209DA1CE9D593D78E0D9959F1674E6F9924EBC0C13F038B10D27B5205DC2AB
          4C31A6E8C057FAB0559F67613AD81889EC9ED89D6F7D3A53EBAEC6DDDAEA5F55
          5454241F804511D97174FF6EA60DB367C1A7F6848FB365A79B25E7669A71D3D3
          98325F436A030CA80FD0A36591360F1669F2C332757E5E2BC219D75BE4860677
          032454CDD5A6C85DC21C476DFCFA68903EB63BA9A3BBD3A0B8F35040D53F00A7
          A5656E39B6331A1F973EAC1CE744C40407F6BADB7262A625A91E66DCF03223D7
          D794C205A6DC5E6044558021D5FE064885980A3F23323C4C499A65C9D1E936EC
          9B6A83EF5053F444BD9EFF176B3C46F543A168940968F70FC065E555D1B1EB42
          9835C24134044722263AB265921D7BA75971CEC382644F7352E7999236DF94CA
          6586D42C3744BA4C9F5A61C5FE46A47B9BF1F51C4BF60BB15B5C6D59E1628586
          860693079AE33FE953E4F286F71AC45B01AA52A9FC406E663A27F7C77364DB66
          0E6E0AE6E45A3F0EAF9AC1F1C5A339E3E7CC89B9369C9E63CE054F53CECE3616
          9130E6FA3C432E8BF198BB193B275912E76A49D4780BC2C758A229C0236C0D08
          F57445F87FBF41FC4156090D5DEDB46367FCECE3C74F2D4D4EBEB8F6FAF58C1D
          D9B7F28E1516955C2C2FAFCE914AEBAA84EABB8A9A9A1F1495A5CFEB8A735F37
          E45EA6E4D229AE24C4736CFB26F66E082272A51F110B66B072C6581C1D1CE863
          6542E0FC39E2B0277DBF417488F99B7F0EC294E76065FB5236ED6EC27A0AD310
          A6CC4A3D716A3135333377F0F4F41AB161E3A649FBF61DF4494C4CFA22F5E295
          A8B4F49BFB72720ACE1415955D17B022694D5D9D10DC7E2BA76063C73ADD71BF
          FFD37BA5D877052B1B7DD73F12A997183585E908EBF1D6F1BF006AB26D1E2879
          37430000000049454E44AE426082}
        Name = '2'
        Tag = 0
      end
      item
        Picture.Data = {
          89504E470D0A1A0A0000000D494844520000001E0000001E08060000003B30AE
          A20000000467414D410000B18E7CFB5193000000206348524D0000870F00008C
          0F0000FD520000814000007D790000E98B00003CE5000019CC733C857700000A
          396943435050686F746F73686F70204943432070726F66696C65000048C79D96
          775454D71687CFBD777AA1CD30025286DEBBC000D27B935E456198196028030E
          3334B121A2021145449A224850C480D150245644B1101454B007240828311845
          542C6F46D68BAEACBCF7F2F2FBE3AC6FEDB3F7B9FBECBDCF5A170092A72F9797
          064B0190CA13F0833C9CE911915174EC0080011E608029004C5646BA5FB07B08
          10C9CBCD859E2172025F0401F07A58BC0270D3D033804E07FF9FA459E97C81E8
          9800119BB339192C11178838254B902EB6CF8A981A972C66182566BE284111CB
          893961910D3EFB2CB2A398D9A93CB688C539A7B353D962EE15F1B64C2147C488
          AF880B33B99C2C11DF12B1468A30952BE237E2D8540E33030014496C17705889
          22361131891F12E422E2E500E048095F71DC572CE0640BC49772494BCFE17313
          1205741D962EDDD4DA9A41F7E464A5700402C300262B99C967D35DD252D399BC
          1C0016EFFC5932E2DAD24545B634B5B6B434343332FDAA50FF75F36F4ADCDB45
          7A19F8B96710ADFF8BEDAFFCD21A0060CC896AB3F38B2DAE0A80CE2D00C8DDFB
          62D3380080A4A86F1DD7BFBA0F4D3C2F890241BA8DB1715656961197C3321217
          F40FFD4F87BFA1AFBE67243EEE8FF2D05D39F14C618A802EAE1B2B2D254DC8A7
          67A433591CBAE19F87F81F07FE751E06419C780E9FC313458489A68CCB4B10B5
          9BC7E60AB8693C3A97F79F9AF80FC3FEA4C5B91689D2F81150638C80D4752A40
          7EED07280A1120D1FBC55DFFA36FBEF830207E79E12A938B73FFEF37FD67C1A5
          E225839BF039CE252884CE12F23317F7C4CF12A0010148022A9007CA401DE800
          436006AC802D70046EC01BF8831010095603164804A9800FB2401ED8040A4131
          D809F6806A50071A41336805C741273805CE834BE01AB8016E83FB60144C8067
          6016BC060B10046121324481E421154813D287CC2006640FB941BE50101409C5
          4209100F124279D066A8182A83AAA17AA819FA1E3A099D87AE4083D05D680C9A
          867E87DEC1084C82A9B012AC051BC30CD809F68143E0557002BC06CE850BE01D
          7025DC001F853BE0F3F035F8363C0A3F83E7108010111AA28A18220CC405F147
          A29078848FAC478A900AA4016945BA913EE426328ACC206F51181405454719A2
          6C519EA850140BB506B51E5582AA461D4675A07A51375163A859D4473419AD88
          D647DBA0BDD011E8047416BA105D816E42B7A32FA26FA327D0AF31180C0DA38D
          B1C2786222314998B59812CC3E4C1BE61C6610338E99C362B1F2587DAC1DD61F
          CBC40AB085D82AEC51EC59EC107602FB0647C4A9E0CC70EEB8281C0F978FABC0
          1DC19DC10DE126710B7829BC26DE06EF8F67E373F0A5F8467C37FE3A7E02BF40
          90266813EC08218424C2264225A1957091F080F0924824AA11AD8981442E7123
          B192788C789938467C4B9221E9915C48D124216907E910E91CE92EE925994CD6
          223B92A3C802F20E7233F902F911F98D0445C248C24B822DB141A246A2436248
          E2B9245E5253D24972B564AE6485E409C9EB92335278292D291729A6D47AA91A
          A99352235273D2146953697FE954E912E923D257A4A764B0325A326E326C9902
          9983321764C62908459DE242615136531A29172913540C559BEA454DA21653BF
          A30E506765656497C986C966CBD6C89E961DA521342D9A172D85564A3B4E1BA6
          BD5BA2B4C4690967C9F625AD4B8696CCCB2D957394E3C815C9B5C9DD967B274F
          9777934F96DF25DF29FF5001A5A0A710A890A5B05FE1A2C2CC52EA52DBA5ACA5
          454B8F2FBDA7082BEA290629AE553CA8D8AF38A7A4ACE4A194AE54A574416946
          99A6ECA89CA45CAE7C46795A85A262AFC255295739ABF2942E4B77A2A7D02BE9
          BDF4595545554F55A16ABDEA80EA829AB65AA85ABE5A9BDA4375823A433D5EBD
          5CBD477D564345C34F234FA345E39E265E93A199A8B957B34F735E4B5B2B5C6B
          AB56A7D694B69CB69776AE768BF6031DB28E83CE1A9D069D5BBA185D866EB2EE
          3EDD1B7AB09E855EA25E8DDE757D58DF529FABBF4F7FD0006D606DC033683018
          3124193A19661AB6188E19D18C7C8DF28D3A8D9E1B6B184719EF32EE33FE6862
          619262D26872DF54C6D4DB34DFB4DBF477333D3396598DD92D73B2B9BBF906F3
          2EF317CBF4977196ED5F76C78262E167B1D5A2C7E283A59525DFB2D572DA4AC3
          2AD6AAD66A84416504304A1897ADD1D6CED61BAC4F59BFB5B1B411D81CB7F9CD
          D6D036D9F688EDD472EDE59CE58DCBC7EDD4EC9876F576A3F674FB58FB03F6A3
          0EAA0E4C870687C78EEA8E6CC726C749275DA724A7A34ECF9D4D9CF9CEEDCEF3
          2E362EEB5CCEB922AE1EAE45AE036E326EA16ED56E8FDCD5DC13DC5BDC673D2C
          3CD67A9CF3447BFA78EEF21CF152F26279357BCD7A5B79AFF3EEF521F904FB54
          FB3CF6D5F3E5FB76FBC17EDE7EBBFD1EACD05CC15BD1E90FFCBDFC77FB3F0CD0
          0E5813F06320263020B026F0499069505E505F30253826F848F0EB10E790D290
          FBA13AA1C2D09E30C9B0E8B0E6B0F970D7F0B2F0D108E3887511D7221522B991
          5D51D8A8B0A8A6A8B9956E2BF7AC9C88B6882E8C1E5EA5BD2A7BD595D50AAB53
          569F8E918C61C69C8845C786C71E897DCFF4673630E7E2BCE26AE366592EACBD
          AC676C4776397B9A63C729E34CC6DBC597C54F25D825EC4E984E7448AC489CE1
          BA70ABB92F923C93EA92E693FD930F257F4A094F694BC5A5C6A69EE4C9F09279
          BD69CA69D96983E9FAE985E9A36B6CD6EC5933CBF7E137654019AB32BA0454D1
          CF54BF5047B8453896699F5993F9262B2CEB44B674362FBB3F472F677BCE64AE
          7BEEB76B516B596B7BF254F336E58DAD735A57BF1E5A1FB7BE6783FA86820D13
          1B3D361EDE44D894BCE9A77C93FCB2FC579BC337771728156C2C18DFE2B1A5A5
          50A2905F38B2D5766BDD36D436EEB681EDE6DBABB67F2C62175D2D3629AE287E
          5FC22AB9FA8DE93795DF7CDA11BF63A0D4B274FF4ECC4EDECEE15D0EBB0E9749
          97E5968DEFF6DBDD514E2F2F2A7FB52766CF958A6515757B097B857B472B7D2B
          BBAA34AA7656BDAF4EACBE5DE35CD356AB58BBBD767E1F7BDFD07EC7FDAD754A
          75C575EF0E700FDCA9F7A8EF68D06AA83888399879F049635863DFB78C6F9B9B
          149A8A9B3E1CE21D1A3D1C74B8B7D9AAB9F988E291D216B845D8327D34FAE88D
          EF5CBFEB6A356CAD6FA3B5151F03C784C79E7E1FFBFDF0719FE33D2718275A7F
          D0FCA1B69DD25ED40175E474CC7626768E7645760D9EF43ED9D36DDBDDFEA3D1
          8F874EA99EAA392D7BBAF40CE14CC1994F6773CFCE9D4B3F37733EE1FC784F4C
          CFFD0B11176EF506F60E5CF4B978F992FBA50B7D4E7D672FDB5D3E75C5E6CAC9
          AB8CAB9DD72CAF75F45BF4B7FF64F153FB80E540C775ABEB5D37AC6F740F2E1F
          3C33E43074FEA6EBCD4BB7BC6E5DBBBDE2F6E070E8F09D91E891D13BEC3B5377
          53EEBEB897796FE1FEC607E807450FA51E563C527CD4F0B3EECF6DA396A3A7C7
          5CC7FA1F073FBE3FCE1A7FF64BC62FEF270A9E909F544CAA4C364F994D9D9A76
          9FBEF174E5D38967E9CF16660A7F95FEB5F6B9CEF31F7E73FCAD7F366276E205
          FFC5A7DF4B5ECABF3CF46AD9AB9EB980B947AF535F2FCC17BD917F73F82DE36D
          DFBBF077930B59EFB1EF2B3FE87EE8FEE8F3F1C1A7D44F9FFE050398F3FCBAC4
          E8D3000000097048597300000EC300000EC301C76FA864000000197445587453
          6F667477617265005061696E742E4E45542076332E352E36D083AD5A0000076F
          49444154484BAD57696C54D71965F082EBA4D88904AD1AD24A5122A42CAAD448
          54112A55905282145A83841B926611383F5C9A8E6D40A020A2162581625C5257
          35158E8404423638890D4E206012ECF11ADBE3F1EC339ED533E359DEECAB67FF
          7AEE1D8FC1516A13254F3A7AEFDEB9EF9E73BEEFBBEFDE59B5EA87B944E7CF9F
          7FD0E5723D170A85DE2C292959FDC34CBB7416D1D56BD7AADD6ECF6F23916863
          22317F31954AA9F2F97C9A16AE0189E4A9EF455C5A5A2ABA73E7CE3A8FC7F342
          2412391C8F272E2793A9996C369FCDE5F2C491CF134839583B93C990C9647E07
          C4A2FB225FB76EDDEAF1F1894704C1FB52381C7937168F772793496B369BCBE7
          72394CBA14E8A7542AB304E97486D2992C095EEF2048CB56246E3EDD52353F9F
          74643239CA604206367111194C964AA5BF058C78697F3A9DA5442299128B1B7E
          B6223106AC89446236F61273313F9F2A2059B827313907DAF78239646D88A668
          34465EAF6F51C8D494ECF5FB0977A9DDE1BC9E008956AB23B3D94A72B982DF59
          1F4312828ACFE17014E1F4915AAD21B3C54A5A9D8E66660C343B6B23A48A5210
          64B73B3A415CB292EBD51A8DEE643C912438878B340B17C5E3498AC51270E227
          87C349184316CB2C198D6614900564464EACD71B785B2A9DC2EF568AC5136C1E
          61C386471FBC97184BEE527B7BFBE7E8FBD1627F7FBFA436169B27B75B203508
          4C660B9CCCD08CC1483ADC0D8C0C1160245AAD9E934A2443FC37994CCEDB4A95
          9AFFEEF6787974FA6E7FF97C535353894C26DBBE6FDFBE970D0643FED4A953DE
          F2F2F2BB82DE7FEFF0D3D12873172085428530CFD2D4D4348742A986001377CD
          044C4E4E915CA1E4E32C56DB426A94A4C438239C33040261763F3D3A3AFAD6AD
          5BB7A8AFAF8F46464668D3A64DE7E076EDAAEAAA35A280E52F3541EBDB269FD7
          46A1708C3B76BA3C342D572E3AD4C3915E6F8433134D4F2B40A2418EB5648020
          9B7D0EEF68B97B2692F5BB5C02399D1EED850B174EB4B6B6FAE3F138E199366F
          DEFC6F56CCABC2B6BFBE4BC18394169AC8E518A670244E2A9596F42050AB753C
          DC1A8D9E4F6AB1D8905F0B9F580EB70CAC9F89602EC7272639310B7D3014E511
          3879F21FADF80051BF4442B5B5B5A18A8A8AE778B57F7E65D73359FF8154CE7F
          805CD62E388E238706B833D1AC6D8E0B60D0C1AD4C864A07B952A54131596962
          42CAC3CE84CCCDB949853B132995CAF8BBDDDD3D34303090157C3E6A6E394D1B
          376E6C07E92F8A8555AE1BDFFB513E7090DCE60FE13801F556924EC939A142A1
          C6244E1A1C1CA1AFBF9E8443237E9F25BBC34D5370C6A2A3D319F838BBC3C585
          47A3F33C459D9D97C90B52C9F0306DDBB6CD5F5959F93C48CB8BC4A25D3B9E78
          3CE16CF07B4D8711A258615210AB543AB8D17397ACCD26974886B973138ACFED
          F643E83CDE89F3F78AF078FCC40AEAC68D1BE474BBE9EFC78F33B7FF01E123DF
          5CD765FD9FBD7C34EA1093DB6583CA104234441393324E6C305850CD16924D2B
          69746C02B95523C43254B38D02C12885C3090A0663782E6006E3DBDACE92DFEF
          A7DEEBD769EBD6AD0272BBE5DBBEDFA287AA2BD63B75F53AC7EC30F9FC1190A8
          104A2C19A5960BD020EF6E38710B014EE60F44968085B8D8EF740A343E3E4E36
          87830E1E3A44BFD9B2E5364837FCBFAF58C9B90F7FF78ADDD495F7F92234E7F4
          417114EB3146ACCDC414E1872B867BFBD8330B75201045714D130E0474B5B797
          5E7C713B5DBCD831872DF6C7CB7D3EABEEDC6CF9CAEB0B631DFA791199CC769A
          94CAC9857C0ADE3010422AC22065AEB131E0D90BD202C258D32E1A1B1B2383D9
          4CE286066A686842A51BE8F2954F362D47BC7AEFDE57FF2060328B758E131A8C
          B308BB1AB99DA4A1A1314E5C1000424482932FB459DFD0D008C9E4726AFE670B
          EDD8F17BEABEFA19173DADD0FC6DD9DDAAACACEC2776871062A11E1818416E8D
          C8B50A2F07E008BB12447938F95D017E3F238FA0FA1D201EA21E84B8BEBE9EC4
          E246AC6D031769363BC6563A1CAC01D970D195DB1344510142018C98A1D82EDE
          59C82583586A707BAAA58576EEDC495D1FF770C10244618ECC9123471F5D36DC
          9352651B23F378982BFED2127804E499F78716FB592DB04DE0CAA79FD2FEFDFB
          A9B1F1005684AE20168E11EEE41737BFAA598E5874FBCBC13A973B88C1053072
          26E2DE3E26A620AAD0DFD1D9856234D1FB274E504D4D0D9D6B3F1FBCD6FB85F4
          5FAD6D1DAFBCFADAD1B56BD7B2AF56D5B207030C7E9685A800461E80F2107904
          A6FCAE20D6CFDC5B675DE98E8ECBE963C78EC1696366FDFAF5FF05C14EE097C0
          CF8187810A60F9F376557575957DCE177682C4E90ADCC502A95A2D27497F1775
          75BC177FFD4F2F7D8C8DFD8D3367CE98C46271AAAEAEEE0310FC6AE19451BA50
          C9F777D4651F728DD63CEA42188D66477274A42F7BEBC659EAB972903EB9F847
          BADDB33B77B6E5859B1B9F78783BC6FE1457557373B374CF9E3D87D07E72A5EA
          5DB6C0DACE7EB4A3B676CF5BF83BB2FBF83B9BBB0DD23AF2CCFC99B093E98E34
          FEFAB585F0B1C39CE8D2A54BBB0FE0C2F3630073F9BD2E364125F0C0E38F3DF4
          945B5FAFEAEDDCF5C1039565EC9BBBE4F488DC3E833EB6CFAE7C88FF8E92605C
          C42A72712FFDC6FB2C87DFC9E9FF005D1FC15068121B4C0000000049454E44AE
          426082}
        Name = '3'
        Tag = 0
      end
      item
        Picture.Data = {
          89504E470D0A1A0A0000000D49484452000000160000001308060000009479FD
          880000000467414D410000B18F0BFC6105000000097048597300000EC100000E
          C101B8916BED0000001974455874536F667477617265005061696E742E4E4554
          2076332E352E36D083AD5A0000039D49444154384F8594594854611886BFB232
          A3C9CCCA6DB27119C719E7CC8C4E535190142545A4A815B4D082D8A2B6884B65
          E5562EB954964BB96B6966E59AA6D555375D48B7751144D055104194152E7DBD
          FF1907272775601886C379BEF73CFFFB1DA2993EB5E6C5541F1A39A7C990EADE
          A22FD3B5E9EAB6B46BEEEEED08B874B46B7574628FD267C6FB1D2E5658F45465
          69A61AF330C06300B3DB7D3D6B1FE878F3230DEFE9086080C74FF5FA8C9CEF5F
          F9226760E98E99075C0F73A632731E955B7E52D55AA69A354CF5614C4D4656DC
          973808E04DED1A8E7912C887BB5673428F0FA7F77970F680DB48E1F3C55DA52F
          172A1D0714872EA2D2B04EBA691EA7DB00565998AAF15B0770A3895DEE49AC6A
          D5F1FA87C11CF958CD073AFDF858F72A4E7EEAC5179F2DE7AB834BB8E8C5A277
          C52F5D54FFC28B4C055412F6876E98590657027C17DF5AFC6F30F1BC66037BB5
          84B0A94DCB118F82786F87BFD0C189489DFAD4832F3F73E72B83AE9CFF5C3184
          212E56789ED18F0A4DBFA8249465F02D802B00BD2374E07F7D28CF810E577816
          3A3642471452EFEFF0E3B82E5F4E92E19E9CD1BF823307DC396B60D9711B3885
          0A8C4CC5005FC7A39701562E74006CA76341B3C4DE486D446AB483631E07F281
          0978428F92CFF67A730A06A4F579BCB282AF186A291FE02213C333C3B3A38E89
          D40AB8F66B0D61735B306F831201DF07F8116889EFF6E5131870B247F9CD0ACE
          951AA183A1634A6AE8B04F0DD77327AAE78F831470917C17B4EC79120035FE7C
          B053C5873A55A356708E5482D42CEB28828EA9A9EF6080AD7A6888130E52F45A
          85E40668D900F856A4DF8901517802D4F1BD159CAD8F406A96535F436A7188F6
          AEED1B0225D46894E10AC08573350E540CB0A08A624878BBA6D20ACED2CF47EA
          370EA9ED1B62EBB5A89F0C37C94D5900E7A22D9E18E08B270868D5FDD0B769A5
          C92E674B66A4FEFC8F6B9B125BFD64B8D002B8589C86C901A2E70BEF49A31872
          CE71FB72A470A4FE25374428B1D54FB4C406B76911CE457A31403C41836918AB
          9F4BCD06A7FFBF3772A48FB292E9E0A2DF022ED28BCDAC5E3386016F312072FA
          17D1C5102565EA87E19BE9AADC922F48FE09C9BFE3307F632B47B03C2358F961
          6CE6570C18C476C6418FC2117A4AED446735CE9416ACA30BBA21BA14C2384C86
          EF3124DF0DB0332A28E13DB21DF0582C4F2CB4AC03DC6DFA84E24A923A95CE04
          BDA614CD28A56B1970067C1CF0C2996F9CED6A927A1E9D56C753725037E01FE8
          9CB69B3274D1B3DD36DBF5BF32762B34361C9B210000000049454E44AE426082}
        Name = '6'
        Tag = 0
      end
      item
        Picture.Data = {
          89504E470D0A1A0A0000000D49484452000000140000001408060000008D891D
          0D0000000467414D410000B18F0BFC6105000000097048597300000EC100000E
          C101B8916BED0000001974455874536F667477617265005061696E742E4E4554
          2076332E352E36D083AD5A0000026249444154384FA5954D4F135114860F3AD3
          42A15044E3B7D6563B6D628CD18D8971E74217BA217E408CBA5216045C286AA2
          F68240B180DC2A141591E9309D422BED9E154B7EC5FC95E37B2754494C66316D
          F266DA34F3F4BDE7399312F9BC2C8A8DDAB18BEE4666C0AD19636E3D39EB36E2
          C57EBF7B7CBF2B514CD8DD19AE18F7B866BCE47A32CF8DF8D2D316803DD9F5CE
          243BC9BB5C354678EBFC348085E04093BA85153AC9CEE99BBC997EC6BF2F08AE
          27E65A014645E9401FDB87AFF246E6115753636839151CF88BBA045AF27A24C1
          4EFC365A3EE75AEA4D70E02A45B26BD4C5966AD977852BE9070AFAC457CA24E9
          C339D2E42CF21929902E17715D465628BC0B289B14652B7482CBC7AEC3F8FDED
          CDF490ACA5DE4A4892F5C4BC6C9C2B48D8478A83F491B49D69D2384F3ACFE32A
          91AF4811F94E215EA176C6D101C5D1DBCF70F9F80DAE641EA2E9108EFF1AA2C6
          31D71C6F61A520CCA409D2772671F30C82968C968C96BC882C230AFA933AFE41
          C3A73C494EE20E443DF6C055E305F6F495FA0193041AA225EF6FB980CF5F9025
          44417F5018D0C85FA875F008DB5183CB47AFB173F6165752FD683DA036C1A40F
          008EE346CC92314BAF65F3E8FF433B78953A790D332DB5C55881D518D4D364F7
          5E62FBD06593DE418A8008B49468293FE1FD1CA204619EBBFBA17B33DD862809
          A8C45C65897A64A9AD57621354067D370050A1242928CC7BA2BE91167C0FD154
          28490AAA4429FB90151C88E38BE64C1700DC03070762A642AD531E415B4F161A
          07074254760A901C6068EB6D00C0FE8F9E9F15D8176AA5D49E36C133ADCCF03D
          69A359D25D40DD0904BBEA02ECFB17F0075D4448AEF11D2E730000000049454E
          44AE426082}
        Name = '7'
        Tag = 0
      end
      item
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000014000000130806000000908C2D
          B50000000467414D410000B18F0BFC6105000000097048597300000EC100000E
          C101B8916BED0000001974455874536F667477617265005061696E742E4E4554
          2076332E352E36D083AD5A0000027849444154384FA593DF4B537118C65FD7D2
          082C47EBECC739679B63BF0E84810A410951E10C8C100AEAC26ECCBB10A228B1
          92C256B939CD5ACDB255AEFD3A6EF3ACBFA088AEBA098220102F2428A89BA8C8
          5894DF9EB3E98521DBA11D78381BBCE7739EF779BE8748C325ED935BA503B247
          C3A8B611694F2626F9E57E6DD355A63863D2EC6C49BFF3F9E5396F4F56573394
          DB9CE8B608A9A2B45F5EF41D9A75D60ED4C5635C5392797765FEF80ECEF6D604
          B4D023839966DE720D092638D34CDA2BE7E1F4FFD7B6D2C34E407F98EAE28CDB
          9A64CD3BD28B5287ECA8E8D24A570778BA3EC7534811691C9A546C1481A2F83D
          FD1A5006978CD33F61DCB6D42F14F4DCD7252B9E6339C57532AF384F294AF369
          45719C2D64ED834FFD64A58001C0519E82DF450A33916E321BDD6676BA8BFB3D
          FC7FC054A849856E04D49862AED60CF375CACC7B24CBDC2772CCD59FFFE81C50
          FA1C670A0D25F73CDDD003D823D0D8BC4813CB700958048A42F7990028562F43
          55A7284974A5996F77A9A8679EE3B9F6756300D02D50B8006851A45B80DD5903
          B502AAAE6FD221D34D896FDCF654D0DD9E3156CC14C04664398CD57FFE0B5D5D
          DF428F3F9B287E94D327F49A8E119C7600FAD5863CD742D54CA7D508E6058A19
          34C1CA9906030285F0F078A9A43234B252D4945AD612B2EDD604B4D2483D4FD7
          DE08340A2721288C92261650D407B57D35D7F209884E69045E69E369E40BA00C
          ED17713E6700B562FD36405FC0ED6FB1048E2CE0055BAA422D343C64A1CBCB70
          FA89A7401FA0F5AB0FC16913C063D012E0AABA2A02393A5F67A60BAFCC74E925
          A03BD71B46AE1BA0C3D07BBC20540578AEC54483174D34D4586D159C043B3489
          48CA5FC7CAF51753F405DF5E4D065C0000000049454E44AE426082}
        Name = '8'
        Tag = 0
      end
      item
        Picture.Data = {
          89504E470D0A1A0A0000000D49484452000000140000001408060000008D891D
          0D0000000467414D410000B18F0BFC6105000000097048597300000EC200000E
          C20115284A800000001974455874536F667477617265005061696E742E4E4554
          2076332E352E36D083AD5A0000036549444154384F75D4D94B54711407F03B73
          E73A9B39AEA5B955D3A2041111F410F44754104544BD243D14D85B1111E54BF4
          56101884A3B9A499E5BE64A5A6953AE332D98BC4D04B51441B39E36CBF397DCF
          CF3BE375132E82E067BEE79CEF1D4559E74778359BF05A8F0A9FA35A4C658C8B
          E9CC8098C99D17B3F98362B6B04AF84B0EAEF77F6BFE167F6752C584E9A498B4
          CC031400494C6D22800490C4EC163C8524FCA51131B7B35BCC95EDDF108E8D98
          EDF13153757CDC1416932A096F1A099F9DE2BE2498A3835B019690F8E026803F
          C4C7BD27D6A09141558D0D996B63A366117F6F22316906A801B4014C474A1752
          6603CCC35380A708E0763CBB8096FF057A7C051A19502BA2AFD468EC8D993036
          616CA0168056804E801900B30C6373CA62803B74B4EC9B98DBE39668B847CB8A
          F45BBE445FAA141B0638066C5C0731F6A8C74597CF16D0D58A02FADC873DCE70
          CA7C7D9740FD9CD49DC04E1B96C02EED62B8D79288BC003864268C4DC6B16BAB
          B2A8B0681B95ED2E255F3383BCCBCD3A8AA43C3EEFD45F1AC4EF5265B15D1B08
          776B1419B010C6261C87E26F97C70E74D9A9E36E26F5DCCFA69F23B8B6BC3850
          9994AFCE3B65B83081E7BCB2F83CED175252A4CF4238CECA9413666AB9934107
          F695D09143C5E46F0526F7C9308E24AB948419CFAF56424FD368B14323EC7265
          4AEC121522CFAD8CE5919B5CFAD581CACBE35012E6C4BC8EDC3E25F4C44A4849
          9C32CC29B1CBE86B24E58B6374CFCD245842BE26544876D3B9D44F4E2B617D15
          D399009BAD7F64CA76A0BCCB7EEC32393A50CF0D03D888374716DE6680D3755C
          7EC00325D8641B9429DB0CA333CA35C2D56BAE1B4140DC4F2EBD84AD291CAF69
          42F89C179485067B65F0B12D116A05FA0C68A7BE4F1DADB9E6D2778891EB01C8
          D2E34DE2D7D3887BAD417C805B59A8B76701FD1A6AB651A81520F6694487EF39
          A9F2541E5D39974381364DEE957BCA075B8537A65EBF85478E4BC1467B4CA2BC
          CF55A83C1477948B8F9ECAF2730BF09AEAF877E0E5CB609D43055A0F54A492F2
          F85C271C4A5E1FC5E79EA660BCA6DC04E0FF80AFFDC659A873D8813E041A5E42
          F543F1F5B952DCD324CC897134E0BF91FACC86DF894039E969ECF4130E25F8FA
          A915705A863971AF258A7A0DE25B6AE32F58E3A7E0504EA0C7807A422DD669C0
          01D42A80DD8E843BB4DBE14EED306075BD64FF01C0BC75F5E206896600000000
          49454E44AE426082}
        Name = '9'
        Tag = 0
      end
      item
        Picture.Data = {
          89504E470D0A1A0A0000000D49484452000000140000001408060000008D891D
          0D0000000467414D410000B18F0BFC6105000000097048597300000EC200000E
          C20115284A800000001974455874536F667477617265005061696E742E4E4554
          2076332E352E36D083AD5A0000022949444154384F9DD4BF6B13611807F047C8
          D8CD21FE01CEE2E6247470D04128E2E8E82A04A7BABBB8095670B8FC30866A34
          24B59626FD212A05BB8869632009E2D2CBAFCBDDE52EBD9F99BE3EEF9503C54B
          7AF1E01D0E8ECF3DEFFB7E9F87E8CFA7A02CD3BA2A5151FB4CEFB41295F57BB4
          A127FEFA26F64B7E98A2820206416F343008AAE8A0F77A9DB6C697623BC187B9
          7EEA724545EE9787ABDB63061915603900C1608BB6E3A299EE3283B8FFD58478
          56EB366E7D32F0AC6DE169C7C6B52FA600C1608B6A468C4A33DD35CAF690C80F
          70F3A381D56F265CCF83E7F9BC3C38FE140F1A9600C1608B76CF43D3724E80A2
          CADBFB1A1CC785EBBAB06C1B8D463340A753467F305A6574C76825E6A292BC46
          996E003E6F1AB01D0793C9293A9D9F30CCC9BF68CDC0855D46F766552AC93702
          90AB7C521FC364A4DD66CC30A3D126572A50AE74F6F6D3F207015EA928302C1B
          FAD8988F86DB1767BA1355695A5EE22A0F04BAB2AFC647C54555F9F6AB5191CA
          74CF503ECBD8A8B87D112991D3C8F00B34DB5B0C3D667493C3BFA9B7B8092272
          9AED2D8CDE399C9CB569597F11DDA231D17E7F08DFF7F1E8F81454E2562D69B5
          D93D7F0EAA28A3A0A38E5417C90DAEAEC86051BB3B7F88CC40074325E8A8A391
          8D648907899850EB6A2ADE440A2F4A446A6F14444A74D3F7A185E45B1E77AF78
          15949858F8CB30528C5EDF52F0F050C3C5D703D04B5EF9C18258888AF0A7E583
          B04D838192EDFD2716A2D2C91249278F19CEF15A893AB3DFD898D3E83DE730FB
          0000000049454E44AE426082}
        Name = '10'
        Tag = 0
      end>
    Version = '1.0.0.0'
    Left = 41
    Top = 80
  end
  object PopupMenu1: TPopupMenu
    Left = 8
    Top = 80
    object FTaskNoList1: TMenuItem
      Caption = 'FTaskNoList '#51200#51109
      OnClick = FTaskNoList1Click
    end
    object FPlanNoList1: TMenuItem
      Caption = 'FPlanNoList '#51200#51109
      OnClick = FPlanNoList1Click
    end
    object FResultNoList1: TMenuItem
      Caption = 'FResultNoList '#51200#51109
      OnClick = FResultNoList1Click
    end
  end
  object OpenTextFileDialog1: TOpenTextFileDialog
    Left = 80
    Top = 80
  end
end
