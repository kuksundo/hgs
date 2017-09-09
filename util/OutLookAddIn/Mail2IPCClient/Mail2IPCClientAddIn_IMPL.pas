unit Mail2IPCClientAddIn_IMPL;

interface

uses
  SysUtils, ComObj, ComServ, ActiveX, Variants, Outlook2010, Office2010, adxAddIn,
  System.Types, System.StrUtils, CalContextAddIn_TLB,
  System.Classes, Dialogs, adxHostAppEvents, adxolFormsManager;

const
  OLUSERID = 'A379042';
type
  TCoCalContextAddIn = class(TadxAddin, ICoCalContextAddIn)
  end;

  TAddInModule = class(TadxCOMAddInModule)
    adxContextMenu1: TadxContextMenu;
    adxOutlookAppEvents1: TadxOutlookAppEvents;
    procedure adxContextMenu1Controls0Controls0Click(Sender: TObject);
    procedure adxOutlookAppEvents1Reminder(ASender: TObject;
      const Item: IDispatch);
    procedure adxOutlookAppEvents1ReminderFire(ASender: TObject;
      const ReminderObject: IDispatch);
    procedure adxOutlookAppEvents1NewMail(Sender: TObject);
    procedure adxOutlookAppEvents1NewMailEx(ASender: TObject;
      const EntryIDCollection: WideString);
    procedure adxCOMAddInModuleAddInInitialize(Sender: TObject);
  private

  protected
    procedure DoItemAdd(ASender: TObject; const Item: IDispatch);
  public
    //Aflag = 'A'; //쪽지
    //      = 'B'; //SMS
    //AUser = 사번
    procedure Send_Message(AHead, ATitle, AContent, ASendUser, ARecvUser, AFlag: string);
  end;

implementation

uses HHI_WebService, UnitHHIMessage, CommonUtil_Unit;

{$R *.dfm}

procedure TAddInModule.adxCOMAddInModuleAddInInitialize(Sender: TObject);
//var
//  IFolderInbox: MAPIFolder;
begin
//  FItems := nil;
//  if Assigned(OutlookApp) then begin
//    IFolderInbox := OutlookApp.GetNamespace('MAPI').GetDefaultFolder(olFolderInbox);
//    if Assigned(IFolderInbox) then
//      try
//        FItems := TItems.Create(nil);
//        FItems.ConnectTo(IFolderInbox.Items);
//        FItems.OnItemAdd := DoItemAdd;
//      finally
//        IFolderInbox := nil;
//      end;
//  end;
end;

procedure TAddInModule.adxContextMenu1Controls0Controls0Click(Sender: TObject);
begin
  ShowMessage('Add To DPMS To-Do List');
end;

procedure TAddInModule.adxOutlookAppEvents1NewMail(Sender: TObject);
begin
//  ShowMessage('OnNewMail');
end;

procedure TAddInModule.adxOutlookAppEvents1NewMailEx(ASender: TObject;
  const EntryIDCollection: WideString);
var
  LNameSpace: _NameSpace;
  LMailItem: MailItem;//IDispatch;
  LStrArr: TStringDynArray;
  i: integer;
  LStr: string;
begin
//  ShowMessage(EntryIDCollection);
  LNameSpace := OutlookApp.GetNamespace('MAPI') as _NameSpace;//.GetDefaultFolder();
  LStrArr := SplitString(EntryIDCollection, ',');

  for i := Low(LStrArr) to High(LStrArr) do
  begin
    LMailItem := nil;
    LMailItem := LNameSpace.GetItemFromID(LStrArr[i],OutlookApp.GetNamespace('MAPI').GetDefaultFolder(olFolderInbox).StoreID) as MailItem;

    if Assigned(LMailItem) then
    begin
      LStr := LMailItem.SenderName;
      LStr := StrToken(LStr,'(');
      Send_Message('[메일알림]', 'adxOutlookAppEvents1NewMailEx', '[메일]' + LMailItem.Subject + ' [from:' + LStr + ']', OLUSERID, OLUSERID, 'B'); //+ ', at ' + FormatDateTime('m월dd일 hh시nn분', LMailItem.ReceivedTime)
//      ShowMessage(LMailItem.Subject + ' : ' + LMailItem.SenderName);
    end;
  end;
end;

procedure TAddInModule.adxOutlookAppEvents1Reminder(ASender: TObject;
  const Item: IDispatch);
begin
//  ShowMessage(DateTimeToStr(AppointmentItem(Item).Start));
end;

procedure TAddInModule.adxOutlookAppEvents1ReminderFire(ASender: TObject;
  const ReminderObject: IDispatch);
var
  LAppointmentItem: AppointmentItem;
begin
  LAppointmentItem := Reminder(ReminderObject).Item as AppointmentItem;

  if LAppointmentItem.Start >= now then
  begin
    Send_Message('[알림]', 'LAppointmentItem.Subject', '[일정]' + LAppointmentItem.Subject + ' => ' + FormatDateTime('hh시mm분', LAppointmentItem.Start),OLUSERID, OLUSERID, 'B');
//    ShowMessage(LAppointmentItem.Subject + ':' + DateTimeToStr(LAppointmentItem.Start));
  end;
//    ShowMessage(LAppointmentItem.Subject + ':' + DateTimeToStr(LAppointmentItem.Start));
//    ShowMessage(Reminder(ReminderObject).Caption + ': ' + DateTimeToStr(Reminder(ReminderObject).NextReminderDate));
end;

procedure TAddInModule.DoItemAdd(ASender: TObject; const Item: IDispatch);
begin

end;

procedure TAddInModule.Send_Message(AHead, ATitle, AContent, ASendUser, ARecvUser, AFlag: string);
var
  lstr,
  lcontent : String;
begin
//  헤더의 길이가 21byte를 넘지 않아야 함.
//  lhead := 'HiTEMS-문제점보고서';
//  ltitle   := '업무변경건';
  lcontent := AContent;

  if Aflag = 'B' then
  begin
    while True do
    begin
      if lcontent = '' then
        Break;

      if Length(lcontent) > 90 then
      begin
        lstr := Copy(lcontent,1,90);
        lcontent := Copy(lcontent,91,Length(lcontent)-90);
      end else
      begin
        lstr := Copy(lcontent,1,Length(lcontent));
        lcontent := '';
      end;

      //문자 메세지는 title(lstr)만 보낸다.
      Send_Message_Main_CODE(AFlag,ASendUser,ARecvUser,AHead,lstr,ATitle);
    end;
  end
  else
  begin
    lstr := lcontent;
    Send_Message_Main_CODE(AFlag,ASendUser,ARecvUser,AHead,lstr,ATitle);
  end;
end;

initialization
  TadxFactory.Create(ComServer, TCoCalContextAddIn, CLASS_CoCalContextAddIn, TAddInModule);

end.
