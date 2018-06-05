unit UnitOutLookUtil;

interface

uses Windows, ComObj, Variants, SysUtils, Dialogs, ActiveX, Vcl.ComCtrls, Outlook2010;

const
  olAppointmentItem = 1;
  olFolderCalendar =	9;//	The Calendar folder.
  olFolderConflicts	=19;//	The Conflicts folder (subfolder of Sync Issues folder). Only available for an Exchange account.
  olFolderContacts	=10;//	The Contacts folder.
  olFolderDeletedItems =	3;//	The Deleted Items folder.
  olFolderDrafts =	16;//	The Drafts folder.
  olFolderInbox	=6;//	The Inbox folder.
  olFolderJournal=	11;//	The Journal folder.
  olFolderJunk =	23;//	The Junk E-Mail folder.
  olFolderLocalFailures	=21;//	The Local Failures folder (subfolder of Sync Issues folder). Only available for an Exchange account.
  olFolderManagedEmail =	29;//	The top-level folder in the Managed Folders group. For more information on Managed Folders, see Help in Microsoft Outlook. Only available for an Exchange account.
  olFolderNotes=	12 ;//	The Notes folder.
  olFolderOutbox =	4;//	The Outbox folder.
  olFolderSentMail =	5;//	The Sent Mail folder.
  olFolderServerFailures =	22;//	The Server Failures folder (subfolder of Sync Issues folder). Only available for an Exchange account.
  olFolderSyncIssues =	20;//	The Sync Issues folder. Only available for an Exchange account.
  olFolderTasks=	13;//	The Tasks folder.
  olFolderToDo	=28;//	The To Do folder.
  olPublicFoldersAllPublicFolders=	18;//	The All Public Folders folder in the Exchange Public Folders store. Only available for an Exchange account.
  olFolderRssFeeds =	25;//	The RSS Feeds folder.
  olMailItem = $00000000;
  olContactItem = $00000002;
  olTaskItem = $00000003;
  olJournalItem = $00000004;
  olNoteItem = $00000005;
  olPostItem = $00000006;

  olImportanceLow = 0;
  olImportanceNormal = 1;
  olImportanceHigh = 2;

  olFree = 0;
  olTentative = 1;
  olBusy = 2;
  olOutOfOffice = 3;

  //User Property Type
  olCombination = 19;
  olCurrency = 14;
  olDateTime = 5;
  olDuration = 7;
  olFormula = 18;
  olKeywords = 11;
  olNumber = 3;
  olOutlookInternal = 0;
  olPercent = 12;
  olText = 1;
  olYesNo = 6;

  olFormatNumberRaw = 9;

  //olObjectClass
  olAppointment = 26;

function CreateNewAppointment(const ASubject, ABody, ALocation: string;
  AStartDate, AEndDate: TDateTime; ARemindMinute: integer = 0; AAllDay: integer = 0; AImportacne: integer = 1): String;
function CreateOrUpdateAppointment(const AID, ASubject, ABody, ALocation: string;
  AStartDate, AEndDate: TDateTime; ARemindMinute: integer = 0; AAllDay: integer = 0; AImportacne: integer = 1): String;
function UpdateAppointment(const AID, ASubject, ABody, ALocation: string;
  AStartDate, AEndDate: TDateTime; ARemindMinute: integer = 0; AAllDay: integer = 0; AImportacne: integer = 1): String;
procedure AssignAppointment(AAppointment: OLEVariant; const ASubject, ABody, ALocation: string;
  AStartDate, AEndDate: TDateTime; ARemindMinute: integer = 0; AAllDay: integer = 0; AImportacne: integer = 1);

procedure GetContactList;
procedure GetApplintmentBetweenDate(AStartDate, AEndDate: TDateTime);
//function SendMail(const Subject, Body, FileName,SenderName, SenderEMail,RecipientName, RecipientEMail: string): Integer;
function CheckOutLookInstalled: boolean;
procedure GetOutLook;
procedure SetAppointment2LV(ALV: TListView; AFolder: OLEVariant);
procedure SetContact2LV(ALV: TListView; AFolder: OLEVariant);
function GetOLHandle(const OutlookApp: TOutlookApplication): HWND;
function GetMailItemFromMsgFile(AFileName: string): OleVariant;

var
  g_OutLook: OLEVariant;

implementation

function CreateNewAppointment(const ASubject, ABody, ALocation: string;
  AStartDate, AEndDate: TDateTime; ARemindMinute: integer = 0; AAllDay: integer = 0; AImportacne: integer = 1): String;

  {to find a default Calendar folder}
  function GetCalendarFolder(folder: OLEVariant): OLEVariant;
  var
    i: Integer;
  begin
    for i := 1 to folder.Count do
    begin
      if (folder.Item[i].DefaultItemType = olAppointmentItem) then
        Result := folder.Item[i]
      else
        Result := GetCalendarFolder(folder.Item[i].Folders);

      if not VarIsNull(Result) and not VarIsEmpty(Result) then
        break
    end;
  end;

var
  outlook, ns, folder, appointment, Prop: OLEVariant;
begin
  Result := '';

  try
   Outlook := GetActiveOleObject('outlook.application');
  except
   Outlook := CreateOleObject('outlook.application');
  end;

  {get MAPI namespace}
  ns := outlook.GetNamespace('MAPI');
  {get a default Calendar folder}
  folder := GetCalendarFolder(ns.Folders);
  {if Calendar folder is found}
  if not VarIsNull(folder) and not VarIsEmpty(folder) then
  begin
//    Appointment := folder.Items.Find('[MyRecProperty] ='+IntToStr(1));

//    if VarIsNull(Appointment) or VarIsEmpty(Appointment) then
//    begin
      {create a new item}
      appointment := folder.Items.Add(olAppointmentItem);
//      Appointment:=Outlook.CreateItem(olAppointmentItem);
//      ShowMessage(IntToStr(Appointment.UserProperties.Count));
//      Prop:=Appointment.UserProperties.Add('MyRecProperty',olText);//,True,olFormatNumberRaw);
//      Prop.Value:=1;

      {define a subject and body of appointment}
      appointment.Subject := ASubject; //'new appointment';
//    end
//    else
//    begin
//      appointment.Subject := ASubject + '[MyRecProperty]'; //'new appointment';
//      showmessage('Not Null');
//    end;

    appointment.Body := ABody;// 'call me tomorrow';

    {location of appointment}
    appointment.Location := ALocation;//'room 3, level 2';

    {duration: 10 days starting from today}
    appointment.Start := AStartDate; //Now() + 0.05;
    appointment.End := AEndDate; //Now()+10; {10 days for execution}
    appointment.AllDayEvent := AAllDay; //1; {all day event}

    {set reminder in 20 minutes}
    appointment.ReminderMinutesBeforeStart := ARemindMinute; //20;
    appointment.ReminderSet := 1;

    {set a high priority}
    appointment.Importance := AImportacne; //olImportanceHigh;

    {add a few recipients}
//    appointment.Recipients.Add('person1@domain.com');
//    appointment.Recipients.Add('person2@domain.com');

    {change an organizer name}
//    appointment.Organizer := 'organizer@domain.com';

    Appointment.BusyStatus:=olBusy;

//    Prop.Display(true);
    {to save an appointment}
    appointment.Save;

    Result := VarToStr(Appointment.EntryID);
    {to display an appointment}
//    appointment.Display(True);

    {to print a form}
//    appointment.PrintOut;
  end;

  {to free all used resources}
  Prop := UnAssigned;
  appointment := UnAssigned;
  folder := UnAssigned;
  ns := UnAssigned;
  outlook := UnAssigned;
end;

function CreateOrUpdateAppointment(const AID, ASubject, ABody, ALocation: string;
  AStartDate, AEndDate: TDateTime; ARemindMinute: integer = 0; AAllDay: integer = 0; AImportacne: integer = 1): String;
begin
  Result := '';

  if AID = '' then
    Result := CreateNewAppointment(ASubject, ABody, ALocation, AStartDate, AEndDate,
                                          ARemindMinute, AAllDay, AImportacne)
  else
  begin
    UpdateAppointment(AID, ASubject, ABody, ALocation, AStartDate, AEndDate,
                                          ARemindMinute, AAllDay, AImportacne);
  end;

end;

function UpdateAppointment(const AID, ASubject, ABody, ALocation: string;
  AStartDate, AEndDate: TDateTime; ARemindMinute: integer = 0; AAllDay: integer = 0; AImportacne: integer = 1): String;
var
  outlook, NameSpace, CalendarFolder, Appointment: OleVariant;
begin
  try
   Outlook := GetActiveOleObject('outlook.application');
  except
   Outlook := CreateOleObject('outlook.application');
  end;

  NameSpace := outlook.GetNameSpace('MAPI');
//  CalendarFolder := NameSpace.GetDefaultFolder(olFolderCalendar);
  Appointment := NameSpace.GetItemFromID(AID);

  if VarIsNull(Appointment) or VarIsEmpty(Appointment) then
  begin
    Result := CreateNewAppointment(ASubject, ABody, ALocation, AStartDate, AEndDate,
                                          ARemindMinute, AAllDay, AImportacne);
    ShowMessage(AID + ' 없음');
  end
  else
  begin
    AssignAppointment(Appointment, '변경 되었음', ABody, ALocation, AStartDate, AEndDate,
                                          ARemindMinute, AAllDay, AImportacne);
    Appointment.Save;
//    ShowMessage(Appointment.subject);
  end;
end;

procedure AssignAppointment(AAppointment: OLEVariant; const ASubject, ABody, ALocation: string;
  AStartDate, AEndDate: TDateTime; ARemindMinute: integer = 0; AAllDay: integer = 0; AImportacne: integer = 1);
begin
  AAppointment.Subject := ASubject; //'new appointment';
  AAppointment.Body := ABody;// 'call me tomorrow';
  AAppointment.Location := ALocation;//'room 3, level 2';
  AAppointment.Start := AStartDate; //Now() + 0.05;
  AAppointment.End := AEndDate; //Now()+10; {10 days for execution}
  AAppointment.AllDayEvent := AAllDay; //1; {all day event}

  {set reminder in 20 minutes}
  AAppointment.ReminderMinutesBeforeStart := ARemindMinute; //20;
  AAppointment.ReminderSet := 1;

  {set a high priority}
  AAppointment.Importance := AImportacne; //olImportanceHigh;
end;

procedure GetContactList;
var
  outlook, NameSpace, Contacts, Contact: OleVariant;
  i, intFolderType: Integer;
begin
  try
   Outlook := GetActiveOleObject('outlook.application');
  except
   Outlook := CreateOleObject('outlook.application');
  end;

  NameSpace := outlook.GetNameSpace('MAPI');
  Contacts := NameSpace.GetDefaultFolder(olFolderContacts);//EntryID
//  intFolderType := Contacts.DefaultItemType;
//case intFolderType of
//  olMailItem: s := VarToStr(oiItem.SenderName) + oiItem.Subject + oiItem.ReceivedTime + oiItem.ReceivedByName;
//  olAppointmentItem: s := oiItem.Subject + oiItem.ReplyTime;
//  olContactItem: s := oiItem.FullName + oiItem.Email;
//  olTaskItem: s := oiItem.SenderName + oiItem.DueDate + oiItem.PercentComplete;
//  olJournalItem: s := oiItem.SenderName;
//  olNoteItem: s := oiItem.Subject + oiItem.CreationTime + oiItem.LastModificationTime;
//  olPostItem: s := VarToStr(oiItem.SenderName) + oiItem.Subject + oiItem.ReceivedTime;

  for i := 1 to Contacts.Items.Count do
  begin
    Contact := Contacts.Items.Item(i);
    {now you can read any property of contact. For example, full name and
     email address}
    ShowMessage(Contact.FullName + ' <' + Contact.Email1Address + '>');
  end;

  Outlook := UnAssigned;
end;

procedure GetApplintmentBetweenDate(AStartDate, AEndDate: TDateTime);
var
  i: Integer;
  Outlook, Namespace, Appointment, Calendar, CalendarFiltered: variant;
  Created: Boolean;
  Accept: Boolean;
  MyItems: Variant;
  startdate, enddate, filter: string;
begin
  Created := False;

  try
   Outlook := GetActiveOleObject('outlook.application');
  except
   Outlook := CreateOleObject('outlook.application');
   Created := True;
  end;

  Namespace := Outlook.GetNamespace('MAPI');
  Calendar := Namespace.GetDefaultFolder(olFolderCalendar);

  startdate := DateTimeToStr(AStartDate);// FormatDateTime('dd/mm/yy hh:nn am/pm', AStartDate);//yyyy-mm-dd hh:nn:ss
  enddate := DateTimeToStr(AEndDate); //FormatDateTime('dd/mm/yy hh:nn am/pm', AEndDate);
  filter:='([Start] >= "' + startdate + '") AND ([Start] <= "' + enddate + '")';

  CalendarFiltered := Calendar.Items.Restrict(filter);
  CalendarFiltered.Sort('[Start]');

//  try
//    Appointment := Calendar.Items.GetFirst;
//  except
////    Memo1.Lines.Add('No appointments found');
//  end;

//  while not VarIsEmpty(Appointment) and not VarIsNull(Appointment) do
  for i := 1 to CalendarFiltered.count do
  begin
//    Memo1.Lines.Add(Appointment.Subject);
    Appointment := CalendarFiltered.Item(i);
    ShowMessage(Appointment.Subject);

//    try
//      Appointment := Calendar.Items.GetNext;  // THIS LINE errors out when no more appts exists
//    except
//      on E: EOleSysError do
//      begin
//        if E.Errorcode > 0 then
//          ShowMessage(IntToStr(E.ErrorCode));
//      end;
//    end;
  end;

//  ShowMessage(IntToStr(CalendarFiltered.Count));

  Appointment := UnAssigned;
  Calendar := UnAssigned;
  Namespace := UnAssigned;
  Outlook := UnAssigned;
end;

//Usage:
//SendMail('Re: mailing from Delphi',
//           'Welcome to http://www.scalabium.com'#13#10'Mike Shkolnik',
//           'c:\autoexec.bat',
//           'your name', 'your@address.com',
//           'Mike Shkolnik', 'mshkolnik@scalabium.com');
//function SendMail(const Subject, Body, FileName,SenderName, SenderEMail,RecipientName, RecipientEMail: string): Integer;
//var
//  Msg: TMapiMessage;
//  lpSender, lpRecipient: TMapiRecipDesc;
//  FileAttach: TMapiFileDesc;
//
//  SM: TFNMapiSendMail;
//  MAPIModule: HModule;
//begin
//  FillChar(Msg, SizeOf(Msg), 0);
//
//  with Msg do
//  begin
//    if (Subject <> '') then
//      lpszSubject := PChar(Subject);
//
//    if (Body <> '') then
//      lpszNoteText := PChar(Body);
//
//    if (SenderEmail <> '') then
//    begin
//      lpSender.ulRecipClass := MAPI_ORIG;
//      if (SenderName = '') then
//        lpSender.lpszName := PChar(SenderEMail)
//      else
//        lpSender.lpszName := PChar(SenderName);
//      lpSender.lpszAddress := PChar(SenderEmail);
//      lpSender.ulReserved := 0;
//      lpSender.ulEIDSize := 0;
//      lpSender.lpEntryID := nil;
//      lpOriginator := @lpSender;
//    end;
//
//    if (RecipientEmail <> '') then
//    begin
//      lpRecipient.ulRecipClass := MAPI_TO;
//      if (RecipientName = '') then
//        lpRecipient.lpszName := PChar(RecipientEMail)
//      else
//        lpRecipient.lpszName := PChar(RecipientName);
//      lpRecipient.lpszAddress := PChar(RecipientEmail);
//      lpRecipient.ulReserved := 0;
//      lpRecipient.ulEIDSize := 0;
//      lpRecipient.lpEntryID := nil;
//      nRecipCount := 1;
//      lpRecips := @lpRecipient;
//    end
//    else
//      lpRecips := nil;
//
//    if (FileName = '') then
//    begin
//      nFileCount := 0;
//      lpFiles := nil;
//    end
//    else
//    begin
//      FillChar(FileAttach, SizeOf(FileAttach), 0);
//      FileAttach.nPosition := Cardinal($FFFFFFFF);
//      FileAttach.lpszPathName := PChar(FileName);
//
//      nFileCount := 1;
//      lpFiles := @FileAttach;
//    end;
//  end;//with
//
//  MAPIModule := LoadLibrary(PChar(MAPIDLL));
//
//  if MAPIModule = 0 then
//    Result := -1
//  else
//    try
//      @SM := GetProcAddress(MAPIModule, 'MAPISendMail');
//      if @SM <> nil then
//      begin
//        Result := SM(0, Application.Handle, Msg, MAPI_DIALOG or MAPI_LOGON_UI, 0);
//      end
//      else
//        Result := 1;
//    finally
//      FreeLibrary(MAPIModule);
//    end;
//
//  if Result <> 0 then
//    MessageDlg('Error sending mail (' + IntToStr(Result) + ').', mtError,
//                [mbOK], 0);
//end;

function CheckOutLookInstalled: boolean;
var
  ClassID: TCLSID;
  strOLEObject: string;
begin
  strOLEObject := 'Outlook.Application';
  Result := (CLSIDFromProgID(PWideChar(WideString(strOLEObject)), ClassID) = S_OK);
end;

procedure GetOutLook;
begin
  if VarIsNull(g_OutLook) then
  begin
    try
      g_OutLook := GetActiveOleObject('outlook.application');
    except
      try
        g_OutLook := CreateOleObject('outlook.application');
      except
        // Unable to access or start OUTLOOK
        MessageDlg(
          'Unable to start or access Outlook.  Possibilities include: permission problems, server down, or VPN not enabled.  Exiting...', mtError, [mbOK], 0);
        exit;
      end;
    end;
  end;
end;

//finalization
//  if not VarIsNull(g_OutLook) then
//    g_OutLook := UnAssigned;


procedure SetAppointment2LV(ALV: TListView; AFolder: OLEVariant);
var
  i: integer;
  Appointment: OLEVariant;
begin
  for I := 1 to AFolder.Items.count  do
  begin
    Appointment := AFolder.Items[i];

    try
      With ALV.Items.Add do
      begin
        Caption := Appointment.Subject;
        SubItems.Add(Appointment.Start);
        SubItems.Add(Appointment.End);
        SubItems.Add(Appointment.Duration);
        SubItems.Add(Appointment.Location);
        SubItems.Add(Appointment.Body);
      end;
    except
    end;
  end;
end;

procedure SetContact2LV(ALV: TListView; AFolder: OLEVariant);
var
  i: integer;
  Contact: OLEVariant;
begin
  for I := 1 to AFolder.Items.count  do
  begin
    Contact := AFolder.Items[i];

    try
      With ALV.Items.Add do
      begin
        Caption := Contact.FirstName;
        SubItems.Add(Contact.LastName);
        SubItems.Add(Contact.MiddleName);
        SubItems.Add(Contact.Gender);
        SubItems.Add(Contact.Birthday);
        SubItems.Add(Contact.Email1Address);
        SubItems.Add(Contact.Email1AddressType);
        SubItems.Add(Contact.HomeTelephoneNumber);
      end;
    except
    end;
  end;
end;

function GetOLHandle(const OutlookApp: TOutlookApplication): HWND;
var
  IWindow: IOleWindow;
begin
  Result := 0;
  //OutlookApp.ActiveInspector.QueryInterface(IOleWindow, IWindow);
  OutlookApp.ActiveExplorer.QueryInterface(IOleWindow, IWindow);
  if Assigned(IWindow) then begin
    IWindow.GetWindow(Result);
    IWindow := nil;
  end;
end;

function GetMailItemFromMsgFile(AFileName: string): OleVariant;
var
  Outlook, Namespace, Appointment, Calendar, CalendarFiltered: OleVariant;
begin
  try
   Outlook := GetActiveOleObject('outlook.application');
  except
   Outlook := CreateOleObject('outlook.application');
  end;

  Result := Outlook.CreateItemFromTemplate(AFileName);
  outlook := UnAssigned;
end;

end.
