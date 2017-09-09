object AddInModule: TAddInModule
  OldCreateOrder = True
  OnCreate = adxCOMAddInModuleCreate
  OnDestroy = adxCOMAddInModuleDestroy
  AddInName = 'Mail2WSAddIn'
  Description = #49688#49888' '#47700#51068#51012' '#50937#49548#53011#47196' '#49569#48512#54632
  SupportedApps = [ohaOutlook]
  OnAddInInitialize = adxCOMAddInModuleAddInInitialize
  TaskPanes = <>
  Height = 400
  Width = 380
  object adxContextMenu1: TadxContextMenu
    CommandBarName = 'ItemContextMenu'
    SupportedApp = ohaOutlook
    Left = 48
    Top = 24
    ButtonTypes = {0100000004000000}
    Buttons = <
      item
        Caption = 'DPMS'
        OfficeTag = '{8E13A718-16E8-4667-8888-31E3B319F76A}'
        olExplorerItemTypes = [adxOLAppointmentItem]
        olInspectorItemTypes = [adxOLAppointment]
        Temporary = True
        PropertyChanged = 2
        ButtonTypes = {0100000000000000}
        Buttons = <
          item
            Caption = 'Add To DPMS To-Do List'
            OfficeTag = '{E6A0D626-028E-45F9-A07C-EC036307CCE8}'
            olExplorerItemTypes = [adxOLMailItem]
            olInspectorItemTypes = [adxOLMail]
            Temporary = True
            OnClick = adxContextMenu1Controls0Controls0Click
            PropertyChanged = 1
          end>
      end>
    PropertyChanged = 0
  end
  object adxOutlookAppEvents1: TadxOutlookAppEvents
    OnNewMail = adxOutlookAppEvents1NewMail
    OnReminder = adxOutlookAppEvents1Reminder
    OnNewMailEx = adxOutlookAppEvents1NewMailEx
    OnReminderFire = adxOutlookAppEvents1ReminderFire
    Left = 112
    Top = 24
  end
end
